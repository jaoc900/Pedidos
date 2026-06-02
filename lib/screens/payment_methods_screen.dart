import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/screens/modals/confirmation_modal.dart';
import 'package:pedidos/screens/add_payment_method_screen.dart';
import 'package:pedidos/enums/payment_method_enum.dart';
import 'package:pedidos/models/payment_method_model.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';
import 'package:pedidos/widgets/custom_text_field.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<PaymentMethod> _paymentMethods = [
    PaymentMethod(
      id: '1',
      name: 'Efectivo',
      description: 'Cobro directo en tienda',
      icon: FontAwesomeIcons.moneyBill,
      status: PaymentMethodStatus.active,
      details: 'Pago en efectivo',
    ),
    PaymentMethod(
      id: '2',
      name: 'Transferencia Bancaria',
      description: 'Banco Nacional - Cta. *4567',
      icon: FontAwesomeIcons.buildingColumns,
      status: PaymentMethodStatus.active,
      details: 'Banco: Nacional, Cuenta: 1234****4567',
    ),
    PaymentMethod(
      id: '3',
      name: 'Pago QR',
      description: 'Stripe Terminal',
      icon: FontAwesomeIcons.qrcode,
      status: PaymentMethodStatus.configured,
      details: 'Terminal configurada',
    ),
    PaymentMethod(
      id: '4',
      name: 'Tarjeta de Crédito',
      description: 'Visa, Mastercard, Amex',
      icon: FontAwesomeIcons.creditCard,
      status: PaymentMethodStatus.active,
      details: 'Aceptamos todas las tarjetas',
    ),
    PaymentMethod(
      id: '5',
      name: 'PayPal',
      description: 'Cuenta empresarial',
      icon: FontAwesomeIcons.paypal,
      status: PaymentMethodStatus.inactive,
      details: 'pendiente@empresa.com',
    ),
  ];

  List<PaymentMethod> get _filteredMethods {
    if (_searchQuery.isEmpty) return _paymentMethods;
    return _paymentMethods.where((method) =>
    method.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        method.description.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  void _addPaymentMethod() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPaymentMethodScreen()),
    );
  }

  void _editPaymentMethod(PaymentMethod method) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPaymentMethodScreen()),
    );
  }

  void _toggleMethodStatus(PaymentMethod method) {
    ConfirmationModal.show(
      context,
      title: method.status == PaymentMethodStatus.active ? 'Desactivar método' : 'Activar método',
      message: '¿Estás seguro de que deseas ${method.status == PaymentMethodStatus.active ? 'desactivar' : 'activar'} "${method.name}"?',
      confirmText: method.status == PaymentMethodStatus.active ? 'Desactivar' : 'Activar',
      cancelText: 'Cancelar',
      type: ConfirmationType.warning,
      customIcon: method.status == PaymentMethodStatus.active ? FontAwesomeIcons.ban : FontAwesomeIcons.checkCircle,
      onConfirm: () {
        setState(() {
          if (method.status == PaymentMethodStatus.active) {
            method.status = PaymentMethodStatus.inactive;
          } else {
            method.status = PaymentMethodStatus.active;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${method.name} ${method.status == PaymentMethodStatus.active ? "activado" : "desactivado"}'),
            backgroundColor: method.status == PaymentMethodStatus.active ? AppTheme.secondary : AppTheme.error,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          _buildTopAppBar(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingXl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Search Bar
                  _buildSearchBar(),
                  const SizedBox(height: AppTheme.spacingLg),
                  // Payment Methods List
                  _buildPaymentMethodsList(),
                  const SizedBox(height: AppTheme.spacingXl),
                ],
              ),
            ),
          ),
        ],
      ),
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

  Widget _buildTopAppBar(BuildContext context) {
    return CustomTopAppBar(
      title: 'Métodos de pago ',
      showBackButton: true,
      onBackPressed: () => Navigator.pop(context),
      actions: [
        AppBarButton(
            icon: FontAwesomeIcons.save,
            onPressed: () => {})
      ],
    );
  }

  Widget _buildSearchBar() {
    return CustomTextField(
      controller: _searchController, // Necesitas crear este controller
      label: '', // Si no quieres label, puedes pasar una cadena vacía
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
              'No se encontraron métodos de pago',
              style: TextStyle(
                fontSize: AppTheme.fontSizeBody,
                color: AppTheme.onSurfaceVariant,
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
    Color statusColor;
    String statusText;
    Color statusBgColor;
    FaIconData? statusIcon;

    switch (method.status) {
      case PaymentMethodStatus.active:
        statusColor = AppTheme.secondary;
        statusText = 'Activo';
        statusBgColor = AppTheme.secondaryContainer;
        break;
      case PaymentMethodStatus.inactive:
        statusColor = AppTheme.error;
        statusText = 'Inactivo';
        statusBgColor = AppTheme.errorContainer;
        break;
      case PaymentMethodStatus.configured:
        statusColor = AppTheme.primary;
        statusText = 'Configurado';
        statusBgColor = AppTheme.primaryContainer;
        break;
    }

    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icono
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: method.status == PaymentMethodStatus.active
                  ? AppTheme.secondaryContainer
                  : AppTheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
            ),
            child: Center(
              child: FaIcon(
                method.icon,
                size: 24,
                color: method.status == PaymentMethodStatus.active
                    ? AppTheme.onSecondaryContainer
                    : AppTheme.onSurfaceVariant,
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
                    fontSize: AppTheme.fontSizeLabel,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  method.description,
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeSmall,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingSm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: statusBgColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Botón de acción
          PopupMenuButton<String>(
            icon: FaIcon(
              FontAwesomeIcons.ellipsisVertical,
              size: 20,
              color: AppTheme.outline,
            ),
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  _editPaymentMethod(method);
                  break;
                case 'toggle':
                  _toggleMethodStatus(method);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    FaIcon(FontAwesomeIcons.pen, size: 16),
                    SizedBox(width: 12),
                    Text('Editar'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'toggle',
                child: Row(
                  children: [
                    FaIcon(
                      method.status == PaymentMethodStatus.active
                          ? FontAwesomeIcons.ban
                          : FontAwesomeIcons.checkCircle,
                      size: 16,
                      color: method.status == PaymentMethodStatus.active
                          ? AppTheme.error
                          : AppTheme.secondary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      method.status == PaymentMethodStatus.active
                          ? 'Desactivar'
                          : 'Activar',
                      style: TextStyle(
                        color: method.status == PaymentMethodStatus.active
                            ? AppTheme.error
                            : AppTheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

