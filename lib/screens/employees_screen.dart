import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/screens/modals/confirmation_modal.dart';
import 'package:pedidos/models/employe_model.dart';
import 'package:pedidos/enums/employee_status_enum.dart';
import 'package:pedidos/screens/employee_detail_screen.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';
import 'package:pedidos/widgets/custom_chips.dart';
import 'package:pedidos/widgets/custom_text_field.dart';
import 'package:pedidos/widgets/primary_button.dart';
import 'package:pedidos/core/network/http_client.dart';
import 'package:pedidos/core/network/api_client.dart';
import 'package:pedidos/core/network/exceptions/network_exceptions.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'Todos';
  final List<String> _filters = ['Todos', 'Activos', 'Inactivos', 'Administradores'];

  List<Employee> _employees = [];
  bool _isLoading = true;
  String? _errorMessage;

  // Estadísticas
  int _activeCount = 0;
  int _inactiveCount = 0;
  int _adminCount = 0;
  double _totalSales = 0;

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
      await _loadEmployees();
      await _loadStats();
    } catch (e) {
      print('Error en inicialización: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al cargar los empleados';
      });
    }
  }

  Future<void> _loadEmployees() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _apiClient.getEmployees();
      print('Respuesta completa: $response');

      List<Employee> employees = [];

      if (response is List) {
        employees = response.map((item) => Employee.fromJson(item)).toList();
      } else if (response is Map<String, dynamic>) {
        if (response.containsKey('data')) {
          final data = response['data'];
          if (data is List) {
            employees = data.map((item) => Employee.fromJson(item)).toList();
          }
        }
      }

      print('Empleados procesados: ${employees.length}');

      setState(() {
        _employees = employees;
        _isLoading = false;
      });
    } catch (e) {
      print('Error cargando empleados: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = _getErrorMessage(e);
      });
    }
  }

  Future<void> _loadStats() async {
    try {
      final response = await _apiClient.getEmployeeStats();

      if (response is Map<String, dynamic>) {
        final data = response['data'] ?? response;
        setState(() {
          _activeCount = data['activeCount'] ?? 0;
          _inactiveCount = data['inactiveCount'] ?? 0;
          _adminCount = data['adminCount'] ?? 0;
          _totalSales = (data['totalSales'] ?? 0).toDouble();
        });
      }
    } catch (e) {
      print('Error cargando estadísticas: $e');
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error is NetworkExceptions) {
      return error.message;
    }
    return 'Error al cargar los empleados';
  }

  List<Employee> get _filteredEmployees {
    List<Employee> filtered = _employees;

    switch (_selectedFilter) {
      case 'Activos':
        filtered = filtered.where((e) => e.status == EmployeeStatus.active).toList();
        break;
      case 'Inactivos':
        filtered = filtered.where((e) => e.status == EmployeeStatus.inactive).toList();
        break;
      case 'Administradores':
        filtered = filtered.where((e) => e.userRole == '4' || e.userRole == 'Administrador').toList();
        break;
      default:
        break;
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((e) =>
      e.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          e.userEmail.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          e.userRole.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          e.department.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    return filtered;
  }

  Future<void> _addEmployee() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EmployeeDetailScreen()),
    );

    if (result == true) {
      await _loadEmployees();
      await _loadStats();
    }
  }

  Future<void> _editEmployee(Employee employee) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EmployeeDetailScreen(employee: employee)),
    );

    if (result == true) {
      await _loadEmployees();
      await _loadStats();
    }
  }

  Future<void> _resetPassword(Employee employee) async {
    await ConfirmationModal.show(
      context,
      title: 'Restablecer contraseña',
      message: '¿Estás seguro de que deseas restablecer la contraseña de "${employee.fullName}"?\n\nRecibirá un correo para crear una nueva contraseña.',
      confirmText: 'Restablecer',
      cancelText: 'Cancelar',
      type: ConfirmationType.info,
      customIcon: FontAwesomeIcons.key,
      onConfirm: () async {
        try {
          setState(() {
            _isLoading = true;
          });

          await _apiClient.resetEmployeePassword(employee.id.toString());

          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Contraseña restablecida para ${employee.fullName}'),
              backgroundColor: AppTheme.primary,
              duration: const Duration(seconds: 2),
            ),
          );
        } catch (e) {
          setState(() {
            _isLoading = false;
          });
          _showError('Error al restablecer la contraseña');
        }
      },
    );
  }

  Future<void> _deactivateEmployee(Employee employee) async {
    await ConfirmationModal.show(
      context,
      title: 'Desactivar empleado',
      message: '¿Estás seguro de que deseas desactivar a "${employee.fullName}"?\n\nNo podrá acceder a la plataforma.',
      confirmText: 'Desactivar',
      cancelText: 'Cancelar',
      type: ConfirmationType.warning,
      customIcon: FontAwesomeIcons.userSlash,
      onConfirm: () async {
        try {
          setState(() {
            _isLoading = true;
          });

          // Llamar al API para desactivar empleado
          final response = await _apiClient.toggleEmployeeStatus(employee.id.toString(), false);

          setState(() {
            final index = _employees.indexWhere((e) => e.id == employee.id);
            if (index != -1) {
              _employees[index] = Employee.fromJson(response['data'] ?? response);
            }
            _isLoading = false;
          });

          await _loadStats();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${employee.fullName} ha sido desactivado'),
              backgroundColor: AppTheme.warning,
            ),
          );
        } catch (e) {
          setState(() {
            _isLoading = false;
          });
          _showError('Error al desactivar el empleado');
        }
      },
    );
  }

  Future<void> _activateEmployee(Employee employee) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Llamar al API para activar empleado
      final response = await _apiClient.toggleEmployeeStatus(employee.id.toString(), true);

      setState(() {
        final index = _employees.indexWhere((e) => e.id == employee.id);
        if (index != -1) {
          _employees[index] = Employee.fromJson(response['data'] ?? response);
        }
        _isLoading = false;
      });

      await _loadStats();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${employee.fullName} ha sido activado'),
          backgroundColor: AppTheme.primary,
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showError('Error al activar el empleado');
    }
  }

  Future<void> _deleteEmployee(Employee employee) async {
    await ConfirmationModal.show(
      context,
      title: 'Eliminar empleado',
      message: '¿Estás seguro de que deseas eliminar a "${employee.fullName}"?\n\nEsta acción no se puede deshacer.',
      confirmText: 'Eliminar',
      cancelText: 'Cancelar',
      type: ConfirmationType.warning,
      customIcon: FontAwesomeIcons.trashCan,
      onConfirm: () async {
        try {
          setState(() {
            _isLoading = true;
          });

          await _apiClient.deleteEmployee(employee.id.toString());

          setState(() {
            _employees.removeWhere((e) => e.id == employee.id);
            _isLoading = false;
          });

          await _loadStats();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${employee.fullName} ha sido eliminado'),
              backgroundColor: AppTheme.error,
            ),
          );
        } catch (e) {
          setState(() {
            _isLoading = false;
          });
          _showError('Error al eliminar el empleado');
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
        title: 'Empleados',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
        actions: [
          AppBarButton(
            icon: FontAwesomeIcons.rotateLeft,
            onPressed: _loadEmployees,
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEmployee,
        backgroundColor: AppTheme.loginButtonColor,
        heroTag: 'employees_fab',
        shape: const CircleBorder(),
        child: const FaIcon(FontAwesomeIcons.plus, size: 24, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(FontAwesomeIcons.circleExclamation, size: 48, color: AppTheme.error),
            const SizedBox(height: 16),
            Text(_errorMessage!, style: TextStyle(fontSize: 16, color: AppTheme.error), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            PrimaryButton(text: 'Reintentar', icon: FontAwesomeIcons.rotateLeft, onPressed: _loadEmployees, borderRadius: AppTheme.borderRadiusXXl),
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
                _buildSummaryCards(),
                const SizedBox(height: AppTheme.spacingLg),
                _buildSearchBar(),
                const SizedBox(height: AppTheme.spacingLg),
                _buildFilters(),
                const SizedBox(height: AppTheme.spacingLg),
                _buildEmployeesList(),
                const SizedBox(height: AppTheme.spacingXl),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(child: _buildSummaryCard(title: 'Activos', value: _activeCount.toString(), color: AppTheme.secondary, icon: FontAwesomeIcons.userCheck)),
        const SizedBox(width: AppTheme.spacingLg),
        Expanded(child: _buildSummaryCard(title: 'Inactivos', value: _inactiveCount.toString(), color: AppTheme.warning, icon: FontAwesomeIcons.userSlash)),
        const SizedBox(width: AppTheme.spacingLg),
        Expanded(child: _buildSummaryCard(title: 'Administradores', value: _adminCount.toString(), color: AppTheme.primary, icon: FontAwesomeIcons.userGear)),
      ],
    );
  }

  Widget _buildSummaryCard({required String title, required String value, required Color color, required FaIconData icon}) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          FaIcon(icon, size: 20, color: color),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppTheme.onSurface)),
          Text(title, style: TextStyle(fontSize: 10, color: AppTheme.onSurfaceVariant), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return CustomTextField(
      controller: _searchController,
      label: '',
      hint: 'Buscar por nombre, email o rol...',
      icon: FontAwesomeIcons.magnifyingGlass,
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      borderRadius: AppTheme.borderRadiusXXl,
    );
  }

  Widget _buildFilters() {
    final filters = [
      const FilterChipData(label: 'Todos', value: 'Todos', icon: FontAwesomeIcons.users),
      const FilterChipData(label: 'Activos', value: 'Activos', icon: FontAwesomeIcons.userCheck),
      const FilterChipData(label: 'Inactivos', value: 'Inactivos', icon: FontAwesomeIcons.userSlash),
      const FilterChipData(label: 'Administradores', value: 'Administradores', icon: FontAwesomeIcons.userShield),
    ];

    return CustomFilterChipWithIcon(
      filters: filters,
      selectedFilter: _selectedFilter,
      onFilterSelected: (filter) {
        setState(() {
          _selectedFilter = filter;
        });
      },
    );
  }

  Widget _buildEmployeesList() {
    if (_filteredEmployees.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
          border: Border.all(color: AppTheme.outlineVariant),
        ),
        child: Column(children: [
          FaIcon(FontAwesomeIcons.users, size: 64, color: AppTheme.outline.withValues(alpha: 0.5)),
          const SizedBox(height: AppTheme.spacingLg),
          Text('No se encontraron empleados', style: TextStyle(fontSize: AppTheme.fontSizeBody, color: AppTheme.onSurfaceVariant)),
          const SizedBox(height: AppTheme.spacingLg),
          PrimaryButton(text: 'Agregar empleado', icon: FontAwesomeIcons.plus, onPressed: _addEmployee, borderRadius: AppTheme.borderRadiusXXl),
        ]),
      );
    }

    return Column(children: _filteredEmployees.map((e) => Padding(padding: const EdgeInsets.only(bottom: AppTheme.spacingLg), child: _buildEmployeeCard(e))).toList());
  }

  Widget _buildEmployeeCard(Employee employee) {
    final isActive = employee.status == EmployeeStatus.active;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: isActive ? AppTheme.outlineVariant : AppTheme.errorContainer),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppTheme.primary, width: 2)),
                  child: ClipOval(
                    child: Image.network(
                      employee.avatarUrl,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppTheme.primaryContainer,
                        child: Center(child: FaIcon(FontAwesomeIcons.user, size: 28, color: Colors.white)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingLg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(child: Text(employee.fullName, style: TextStyle(fontSize: AppTheme.fontSizeTitle, fontWeight: FontWeight.w700, color: AppTheme.onSurface))),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingSm, vertical: 4),
                          decoration: BoxDecoration(color: isActive ? AppTheme.secondaryContainer : AppTheme.errorContainer, borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull)),
                          child: Text(isActive ? 'Activo' : 'Inactivo', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: isActive ? AppTheme.secondary : AppTheme.error)),
                        ),
                      ]),
                      const SizedBox(height: 4),
                      Text(employee.userRole, style: TextStyle(fontSize: AppTheme.fontSizeSmall, color: AppTheme.primary, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                PopupMenuButton(
                  icon: FaIcon(FontAwesomeIcons.ellipsisVertical, size: 20, color: AppTheme.outline),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: ListTile(leading: FaIcon(FontAwesomeIcons.pen, size: 16), title: const Text('Editar'), onTap: () => _editEmployee(employee)),
                    ),
                    PopupMenuItem(
                      child: ListTile(leading: FaIcon(FontAwesomeIcons.key, size: 16, color: AppTheme.primary), title: Text('Restablecer contraseña', style: TextStyle(color: AppTheme.primary)), onTap: () => _resetPassword(employee)),
                    ),
                    if (isActive)
                      PopupMenuItem(
                        child: ListTile(leading: FaIcon(FontAwesomeIcons.userSlash, size: 16, color: AppTheme.warning), title: Text('Desactivar', style: TextStyle(color: AppTheme.warning)), onTap: () => _deactivateEmployee(employee)),
                      ),
                    if (!isActive)
                      PopupMenuItem(
                        child: ListTile(leading: FaIcon(FontAwesomeIcons.userCheck, size: 16, color: AppTheme.secondary), title: Text('Activar', style: TextStyle(color: AppTheme.secondary)), onTap: () => _activateEmployee(employee)),
                      ),
                    PopupMenuItem(
                      child: ListTile(leading: FaIcon(FontAwesomeIcons.trashCan, size: 16, color: AppTheme.error), title: Text('Eliminar', style: TextStyle(color: AppTheme.error)), onTap: () => _deleteEmployee(employee)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            const Divider(),
            const SizedBox(height: AppTheme.spacingMd),
            Row(children: [
              FaIcon(FontAwesomeIcons.envelope, size: 14, color: AppTheme.outline), const SizedBox(width: 8), Expanded(child: Text(employee.userEmail, style: TextStyle(fontSize: AppTheme.fontSizeSmall, color: AppTheme.onSurfaceVariant))),
            ]),
            const SizedBox(height: AppTheme.spacingSm),
            Row(children: [
              FaIcon(FontAwesomeIcons.phone, size: 14, color: AppTheme.outline), const SizedBox(width: 8), Expanded(child: Text(employee.phone, style: TextStyle(fontSize: AppTheme.fontSizeSmall, color: AppTheme.onSurfaceVariant))),
            ]),
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