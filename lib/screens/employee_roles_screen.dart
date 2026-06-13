import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/screens/modals/confirmation_modal.dart';
import 'package:pedidos/screens/add_employee_role_screen.dart';
import 'package:pedidos/models/employee_role_model.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';
import 'package:pedidos/widgets/custom_text_field.dart';
import 'package:pedidos/widgets/primary_button.dart';
import 'package:pedidos/core/network/http_client.dart';
import 'package:pedidos/core/network/api_client.dart';
import 'package:pedidos/core/network/exceptions/network_exceptions.dart';

class EmployeeRolesScreen extends StatefulWidget {
  const EmployeeRolesScreen({super.key});

  @override
  State<EmployeeRolesScreen> createState() => _EmployeeRolesScreenState();
}

class _EmployeeRolesScreenState extends State<EmployeeRolesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<EmployeeRole> _roles = [];
  bool _isLoading = true;
  String? _errorMessage;

  late ApiClient _apiClient;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final httpClient = HttpClient();
      _apiClient = ApiClient(httpClient);
      await _loadRoles();
    } catch (e) {
      print('Error en inicialización: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al cargar los roles';
      });
    }
  }

  Future<void> _loadRoles() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _apiClient.getEmployeeRoles();
      print('Respuesta completa: $response');

      List<EmployeeRole> roles = [];

      if (response is List) {
        roles = response.map((item) => EmployeeRole.fromJson(item)).toList();
      } else if (response is Map<String, dynamic>) {
        if (response.containsKey('data')) {
          final data = response['data'];
          if (data is List) {
            roles = data.map((item) => EmployeeRole.fromJson(item)).toList();
          }
        }
      }

      print('Roles procesados: ${roles.length}');

      setState(() {
        _roles = roles;
        _isLoading = false;
      });
    } catch (e) {
      print('Error cargando roles: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = _getErrorMessage(e);
      });
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error is NetworkExceptions) {
      return error.message;
    }
    return 'Error al cargar los roles';
  }

  List<EmployeeRole> get _filteredRoles {
    if (_searchQuery.isEmpty) return _roles;
    return _roles.where((role) =>
    role.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        role.description.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  Future<void> _addRole() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEmployeeRoleScreen()),
    );

    if (result == true) {
      await _loadRoles();
    }
  }

  Future<void> _editRole(EmployeeRole role) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEmployeeRoleScreen(role: role),
      ),
    );

    if (result == true) {
      await _loadRoles();
    }
  }

  Future<void> _deleteRole(EmployeeRole role) async {
    await ConfirmationModal.show(
      context,
      title: 'Eliminar Rol',
      message: '¿Estás seguro de que deseas eliminar el rol "${role.name}"?\n\nEsta acción no se puede deshacer.',
      confirmText: 'Eliminar',
      cancelText: 'Cancelar',
      type: ConfirmationType.warning,
      customIcon: FontAwesomeIcons.trashCan,
      onConfirm: () async {
        try {
          setState(() {
            _isLoading = true;
          });

          await _apiClient.deleteEmployeeRole(role.id.toString());

          setState(() {
            _roles.removeWhere((r) => r.id == role.id);
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Rol "${role.name}" eliminado'),
              backgroundColor: AppTheme.error,
              duration: const Duration(seconds: 2),
            ),
          );
        } catch (e) {
          setState(() {
            _isLoading = false;
          });
          _showError('Error al eliminar el rol');
        }
      },
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: CustomTopAppBar(
        title: 'Roles de Empleados',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
        actions: [
          AppBarButton(
            icon: FontAwesomeIcons.rotateLeft,
            onPressed: _loadRoles,
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addRole,
        backgroundColor: AppTheme.loginButtonColor,
        elevation: 4,
        heroTag: 'employee_roles_fab',
        shape: const CircleBorder(),
        child: const FaIcon(
          FontAwesomeIcons.plus,
          size: 24,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.circleExclamation,
              size: 48,
              color: AppTheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Reintentar',
              icon: FontAwesomeIcons.rotateLeft,
              onPressed: _loadRoles,
              borderRadius: AppTheme.borderRadiusXXl,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingXl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSearchBar(),
                const SizedBox(height: AppTheme.spacingLg),
                _buildRolesList(),
                const SizedBox(height: AppTheme.spacingXl),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return CustomTextField(
      controller: _searchController,
      label: '',
      hint: 'Buscar roles...',
      icon: FontAwesomeIcons.magnifyingGlass,
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      borderRadius: AppTheme.borderRadiusXXl,
    );
  }

  Widget _buildRolesList() {
    if (_filteredRoles.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
          border: Border.all(color: AppTheme.outlineVariant),
        ),
        child: Column(
          children: [
            FaIcon(
              FontAwesomeIcons.userShield,
              size: 64,
              color: AppTheme.outline.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppTheme.spacingLg),
            Text(
              _searchQuery.isEmpty
                  ? 'No hay roles configurados'
                  : 'No se encontraron roles',
              style: TextStyle(
                fontSize: AppTheme.fontSizeBody,
                color: AppTheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingLg),
            PrimaryButton(
              text: 'Agregar rol',
              icon: FontAwesomeIcons.plus,
              onPressed: _addRole,
              borderRadius: AppTheme.borderRadiusXXl,
            ),
          ],
        ),
      );
    }

    return Column(
      children: _filteredRoles.map((role) => Padding(
        padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
        child: _buildRoleCard(role),
      )).toList(),
    );
  }

  Widget _buildRoleCard(EmployeeRole role) {
    return GestureDetector(
      onTap: () => _editRole(role),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
          border: Border.all(color: AppTheme.surfaceContainerHighest),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icono
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: role.colorValue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: FaIcon(
                  role.faIcon,
                  size: 20,
                  color: role.colorValue,
                ),
              ),
            ),
            const SizedBox(width: AppTheme.spacingLg),
            // Información
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role.name,
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeBody,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    role.description,
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeSmall,
                      color: AppTheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Botón de eliminar
            IconButton(
              icon: FaIcon(
                FontAwesomeIcons.trashCan,
                size: 20,
                color: AppTheme.error,
              ),
              onPressed: () => _deleteRole(role),
              tooltip: 'Eliminar rol',
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}