import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/screens/modals/confirmation_modal.dart';
import 'package:pedidos/models/customer_model.dart';
import 'package:pedidos/enums/customer_type_enum.dart';
import 'package:pedidos/screens/customer_orders_screen.dart';
import 'package:pedidos/screens/customer_payments_screen.dart';
import 'package:pedidos/widgets/custom_text_field.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';

class CustomerDetailScreen extends StatefulWidget {
  final Customer? customer;

  const CustomerDetailScreen({super.key, this.customer});

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;

  bool _isLoading = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.customer?.name ?? '');
    _phoneController = TextEditingController(text: widget.customer?.phone ?? '');
    _emailController = TextEditingController(text: widget.customer?.email ?? '');
    _addressController = TextEditingController(text: widget.customer?.address ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _saveCustomer() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.customer == null
                ? 'Cliente creado exitosamente'
                : 'Cliente actualizado exitosamente',
          ),
          backgroundColor: AppTheme.primary,
        ),
      );
      Navigator.pop(context, true);
    }
  }

  void _confirmCancel() {
    if (_hasChanges()) {
      ConfirmationModal.show(
        context,
        title: 'Descartar cambios',
        message: 'Tienes cambios sin guardar. ¿Deseas salir sin guardar?',
        confirmText: 'Descartar',
        cancelText: 'Seguir editando',
        type: ConfirmationType.warning,
        customIcon: FontAwesomeIcons.penToSquare,
        onConfirm: () {
          Navigator.pop(context);
        },
      );
    } else {
      Navigator.pop(context);
    }
  }

  bool _hasChanges() {
    final hasChanges = _nameController.text != (widget.customer?.name ?? '') ||
        _phoneController.text != (widget.customer?.phone ?? '') ||
        _emailController.text != (widget.customer?.email ?? '') ||
        _addressController.text != (widget.customer?.address ?? '');
    return hasChanges;
  }

  void _navigateToOrders() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CustomerOrdersScreen(),
      ),
    );
  }

  void _navigateToPayments() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CustomerPaymentsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // TopAppBar
          _buildTopAppBar(),
          // Contenido principal
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingXl),
              child: Column(
                children: [
                  // Profile Picture Section
                  _buildProfileSection(),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Form Section
                  _buildForm(),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Sección de Botones (Órdenes y Pagos)
                  _buildActionButtonsSection(),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Mapa preview
                  _buildMapPreview(),
                  const SizedBox(height: AppTheme.spacingXl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopAppBar() {
    return CustomTopAppBar(
      title: 'Detalle de cliente',
      showBackButton: true,
      onBackPressed: _confirmCancel,
      actions: [
        AppBarButton(
          icon: FontAwesomeIcons.solidFloppyDisk,
          onPressed: _saveCustomer,
        ),
      ],
    );
  }

  Widget _buildProfileSection() {
    return Column(
      children: [
        Stack(
          children: [
            // Avatar
            Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuA6Vg-ueFpmn3sRsYmOHnutFNDoUXehFMzsjPzOmjXL4kJnZu7v7gDEF0D1VlP7uDsZM9JuayNMB_YgTUH9Ahs_WfIzj6DPixMOFhdcGK0QIb_C6qFzbrejjp0h-9L2iPoe299j1Fg74un5huUmys1iwnDqIxhg5bVrTiSYR5TKJlkNEBmyZ8Ltb2n9VnXW4rbucDQjK2vxz7uEsygAeTpWedoP8Y6o1_KH-77TKrZt4H2rR3vZOxjn7M8kqxLdmGjqk0HuwpjGYoDi',
                  width: 128,
                  height: 128,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppTheme.primaryContainer,
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.user,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Botón de cámara
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Funcionalidad: Cambiar foto de perfil'),
                      backgroundColor: AppTheme.primary,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(AppTheme.spacingSm),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const FaIcon(
                    FontAwesomeIcons.camera,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingLg),
        Text(
          widget.customer?.name ?? 'Información del Cliente',
          style: TextStyle(
            fontSize: AppTheme.fontSizeTitle,
            fontWeight: FontWeight.w600,
            color: AppTheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.customer?.type == CustomerType.vip ? 'Cliente VIP' :
          widget.customer?.type == CustomerType.newLead ? 'Nuevo Cliente' :
          'Complete los datos para continuar',
          style: TextStyle(
            fontSize: AppTheme.fontSizeBody,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Nombre completo
          CustomTextField(
            controller: _nameController,
            label: 'Nombre',
            hint: 'Ej. Juan Pérez',
            icon: FontAwesomeIcons.user,
            textInputAction: TextInputAction.next,
            borderRadius: AppTheme.borderRadiusXXl,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa el nombre';
              }
              if (value.length < 3) {
                return 'El nombre debe tener al menos 3 caracteres';
              }
              return null;
            },
          ),
          const SizedBox(height: AppTheme.spacingLg),

          // Teléfono
          CustomTextField(
            controller: _phoneController,
            label: 'Teléfono',
            hint: '+34 600 000 000',
            icon: FontAwesomeIcons.phone,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            borderRadius: AppTheme.borderRadiusXXl,
          ),
          const SizedBox(height: AppTheme.spacingLg),

          // Correo electrónico
          CustomTextField(
            controller: _emailController,
            label: 'Correo',
            hint: 'nombre@ejemplo.com',
            icon: FontAwesomeIcons.envelope,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            borderRadius: AppTheme.borderRadiusXXl,
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                final emailRegex = RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                );
                if (!emailRegex.hasMatch(value)) {
                  return 'Ingresa un correo válido';
                }
              }
              return null;
            },
          ),
          const SizedBox(height: AppTheme.spacingLg),

          // Dirección (multilínea)
          CustomTextField(
            controller: _addressController,
            label: 'Dirección',
            hint: 'Calle, Número, Ciudad...',
            icon: FontAwesomeIcons.locationDot,
            maxLines: 3,
            textInputAction: TextInputAction.done,
            borderRadius: AppTheme.borderRadiusXXl,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtonsSection() {
    return Row(
      children: [
        // Botón Ver Órdenes
        Expanded(
          child: GestureDetector(
            onTap: _navigateToOrders,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingXl),
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
                border: Border.all(color: AppTheme.outlineVariant),
              ),
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.receipt,
                        size: 24,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  Text(
                    'Ver Órdenes',
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeLabel,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Historial de compras',
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeSmall,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: AppTheme.spacingLg),
        // Botón Ver Pagos
        Expanded(
          child: GestureDetector(
            onTap: _navigateToPayments,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingXl),
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
                border: Border.all(color: AppTheme.outlineVariant),
              ),
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.secondary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.moneyBill,
                        size: 24,
                        color: AppTheme.secondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  Text(
                    'Ver Pagos',
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeLabel,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Registro de pagos',
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeSmall,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapPreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
      child: Container(
        height: 128,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.outlineVariant),
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        ),
        child: Image.network(
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDB1GvJeJEqr29Qt4vMz8UDds-qQkbN5h9ESRg9Sd2bLoxjBPaMgZnd6AUhZjmC9Gv25K9kCqCEGyLBYPuTmc6EHzZD4nAnRkcG5zzS_ccLOacXGU5qwQ0IZYClnv5EZ_77_hRDlZgUpP7oaJQfWT7_wzaHgM5PRg68EnPOD2AxwdMjiomBODnKIEvIxcOnBOvqN_VXcaUUqFbLSsvjNWQIsydeImmunyeE6S3xcL7LCGAkctL6yvID9JvToO46jzKgCuFcqPaIqgNU',
          width: double.infinity,
          height: 128,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: double.infinity,
              height: 128,
              color: AppTheme.surfaceContainer,
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.map,
                  size: 32,
                  color: AppTheme.outline,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMultilineTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required FaIconData icon,
    int maxLines = 3,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FaIcon(
              icon,
              size: 14,
              color: AppTheme.primary,
            ),
            const SizedBox(width: AppTheme.spacingSm),
            Text(
              label,
              style: TextStyle(
                fontSize: AppTheme.fontSizeLabel,
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingSm),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          minLines: 2,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppTheme.outlineVariant,
              fontSize: AppTheme.fontSizeBody,
            ),
            filled: true,
            fillColor: Colors.white,
            isDense: true,
            alignLabelWithHint: true,
            border: _buildInputBorder(),
            enabledBorder: _buildInputBorder(),
            focusedBorder: _buildFocusedBorder(),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingLg,
              vertical: AppTheme.spacingLg,
            ),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _buildInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
      borderSide: BorderSide(color: AppTheme.outlineVariant, width: 1),
    );
  }

  OutlineInputBorder _buildFocusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
      borderSide: const BorderSide(color: AppTheme.primary, width: 2),
    );
  }
}