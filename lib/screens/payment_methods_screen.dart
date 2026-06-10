// Reemplaza la parte donde se usaba PaymentMethodStatus
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/screens/add_payment_method_screen.dart';
import 'package:pedidos/screens/modals/confirmation_modal.dart';
import 'package:pedidos/models/payment_method_model.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';
import 'package:pedidos/widgets/custom_text_field.dart';
import 'package:pedidos/core/network/http_client.dart';
import 'package:pedidos/core/network/api_client.dart';
import 'package:pedidos/core/network/exceptions/network_exceptions.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<PaymentMethod> _paymentMethods = [];
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
      await _loadPaymentMethods();
    } catch (e) {
      print('Error en inicialización: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al cargar los métodos de pago';
      });
    }
  }

  Future<void> _loadPaymentMethods() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _apiClient.getPaymentMethods();
      print('Respuesta completa: $response');

      List<PaymentMethod> methods = [];

      if (response is List) {
        methods = response.map((item) => PaymentMethod.fromJson(item)).toList();
      } else if (response is Map<String, dynamic>) {
        if (response.containsKey('data')) {
          final data = response['data'];
          if (data is List) {
            methods = data.map((item) => PaymentMethod.fromJson(item)).toList();
          }
        } else {
          methods = [PaymentMethod.fromJson(response)];
        }
      }

      print('Métodos procesados: ${methods.length}');

      setState(() {
        _paymentMethods = methods;
        _isLoading = false;
      });
    } catch (e) {
      print('Error cargando métodos de pago: $e');
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
    return 'Error al cargar los métodos de pago';
  }

  List<PaymentMethod> get _filteredMethods {
    if (_searchQuery.isEmpty) return _paymentMethods;
    return _paymentMethods.where((method) =>
        method.name.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  Future<void> _addPaymentMethod() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPaymentMethodScreen()),
    );

    if (result == true) {
      await _loadPaymentMethods();
    }
  }

  Future<void> _editPaymentMethod(PaymentMethod method) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPaymentMethodScreen(paymentMethod: method),
      ),
    );

    if (result == true) {
      await _loadPaymentMethods();
    }
  }

  Future<void> _deletePaymentMethod(PaymentMethod method) async {
    await ConfirmationModal.show(
      context,
      title: 'Eliminar método',
      message: '¿Estás seguro de que deseas eliminar "${method.name}"?\n\nEsta acción no se puede deshacer.',
      confirmText: 'Eliminar',
      cancelText: 'Cancelar',
      type: ConfirmationType.warning,
      customIcon: FontAwesomeIcons.trashCan,
      onConfirm: () async {
        await _executeDeleteMethod(method);
      },
    );
  }

  Future<void> _executeDeleteMethod(PaymentMethod method) async {
    try {
      setState(() {
        _isLoading = true;
      });

      await _apiClient.deletePaymentMethod(method.id.toString());

      setState(() {
        _paymentMethods.removeWhere((m) => m.id == method.id);
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${method.name} eliminado correctamente'),
          backgroundColor: AppTheme.error,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showError('Error al eliminar el método de pago');
    }
  }

  Future<void> _seedDefaultMethods() async {
    await ConfirmationModal.show(
      context,
      title: 'Restaurar métodos por defecto',
      message: '¿Estás seguro de que deseas restaurar los métodos de pago por defecto? Esto agregará los métodos estándar.',
      confirmText: 'Restaurar',
      cancelText: 'Cancelar',
      type: ConfirmationType.info,
      customIcon: FontAwesomeIcons.rotateLeft,
      onConfirm: () async {
        try {
          setState(() {
            _isLoading = true;
          });

          final response = await _apiClient.seedDefaultPaymentMethods();

          List<PaymentMethod> methods = [];

          if (response is List) {
            methods = response.map((item) => PaymentMethod.fromJson(item)).toList();
          } else if (response is Map<String, dynamic>) {
            if (response.containsKey('data')) {
              final data = response['data'];
              if (data is List) {
                methods = data.map((item) => PaymentMethod.fromJson(item)).toList();
              }
            }
          }

          setState(() {
            _paymentMethods = methods;
            _isLoading = false;
          });

          _showSuccess('Métodos de pago por defecto restaurados');
        } catch (e) {
          setState(() {
            _isLoading = false;
          });
          _showError('Error al restaurar métodos por defecto');
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

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: CustomTopAppBar(
        title: 'Métodos de pago',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
        actions: [
          AppBarButton(
            icon: FontAwesomeIcons.rotateLeft,
            onPressed: _seedDefaultMethods,
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPaymentMethod,
        backgroundColor: AppTheme.loginButtonColor,
        elevation: 4,
        heroTag: 'payment_methods_fab',
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
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadPaymentMethods,
              child: const Text('Reintentar'),
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
                _buildPaymentMethodsList(),
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
      hint: 'Buscar métodos de pago...',
      icon: FontAwesomeIcons.magnifyingGlass,
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      borderRadius: AppTheme.borderRadiusXXl,
    );
  }

  Widget _buildPaymentMethodsList() {
    if (_filteredMethods.isEmpty) {
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
              FontAwesomeIcons.creditCard,
              size: 64,
              color: AppTheme.outline.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppTheme.spacingLg),
            Text(
              _searchQuery.isEmpty
                  ? 'No hay métodos de pago configurados'
                  : 'No se encontraron métodos de pago',
              style: TextStyle(
                fontSize: AppTheme.fontSizeBody,
                color: AppTheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingLg),
            ElevatedButton.icon(
              onPressed: _addPaymentMethod,
              icon: const FaIcon(FontAwesomeIcons.plus, size: 16),
              label: const Text('Agregar método manualmente'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            TextButton.icon(
              onPressed: _seedDefaultMethods,
              icon: const FaIcon(FontAwesomeIcons.rotateLeft, size: 16),
              label: const Text('Restaurar métodos por defecto'),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primary,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: _filteredMethods.map((method) => Padding(
        padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
        child: _buildPaymentMethodCard(method),
      )).toList(),
    );
  }

  Widget _buildPaymentMethodCard(PaymentMethod method) {
    return GestureDetector(
      onTap: () => _editPaymentMethod(method),
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
            // Icono - SIEMPRE con el color seleccionado por el usuario
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: method.colorValue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: FaIcon(
                  method.faIcon,
                  size: 20,
                  color: method.colorValue,
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
                    method.name,
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeBody,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
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
              onPressed: () => _deletePaymentMethod(method),
              tooltip: 'Eliminar método',
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