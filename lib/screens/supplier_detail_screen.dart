import 'package:flutter/material.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/models/supplier_model.dart';

class SupplierDetailScreen extends StatefulWidget {
  final Supplier? supplier;

  const SupplierDetailScreen({super.key, this.supplier});

  @override
  State<SupplierDetailScreen> createState() => _SupplierDetailScreenState();
}

class _SupplierDetailScreenState extends State<SupplierDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _contactController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _categoryController;
  late TextEditingController _paymentDaysController;

  bool _isActive = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.supplier?.name ?? '');
    _contactController = TextEditingController(text: widget.supplier?.contact ?? '');
    _phoneController = TextEditingController(text: widget.supplier?.phone ?? '');
    _emailController = TextEditingController(text: widget.supplier?.email ?? '');
    _addressController = TextEditingController(text: widget.supplier?.address ?? '');
    _categoryController = TextEditingController(text: widget.supplier?.category ?? '');
    _paymentDaysController = TextEditingController(
      text: widget.supplier?.paymentDays.toString() ?? '30',
    );
    _isActive = widget.supplier?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _categoryController.dispose();
    _paymentDaysController.dispose();
    super.dispose();
  }

  void _saveSupplier() async {
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
            widget.supplier == null
                ? 'Proveedor creado exitosamente'
                : 'Proveedor actualizado exitosamente',
          ),
          backgroundColor: AppTheme.primary,
        ),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft, color: AppTheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.supplier == null ? 'Nuevo Proveedor' : 'Editar Proveedor',
          style: const TextStyle(
            fontSize: AppTheme.fontSizeTitle,
            fontWeight: FontWeight.w700,
            color: AppTheme.primary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveSupplier,
            child: _isLoading
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
              ),
            )
                : const Text(
              'Guardar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.primary,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                controller: _nameController,
                label: 'Nombre del Proveedor',
                hint: 'Ej. Agroinsumos S.A.',
                icon: FontAwesomeIcons.building,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppTheme.spacingLg),
              _buildTextField(
                controller: _contactController,
                label: 'Persona de Contacto',
                hint: 'Ej. Juan Pérez',
                icon: FontAwesomeIcons.user,
              ),
              const SizedBox(height: AppTheme.spacingLg),
              _buildTextField(
                controller: _phoneController,
                label: 'Teléfono',
                hint: '+52 555 123 4567',
                icon: FontAwesomeIcons.phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: AppTheme.spacingLg),
              _buildTextField(
                controller: _emailController,
                label: 'Correo Electrónico',
                hint: 'ventas@proveedor.com',
                icon: FontAwesomeIcons.envelope,
                keyboardType: TextInputType.emailAddress,
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
              _buildTextField(
                controller: _addressController,
                label: 'Dirección',
                hint: 'Calle, Número, Ciudad...',
                icon: FontAwesomeIcons.locationDot,
                maxLines: 2,
              ),
              const SizedBox(height: AppTheme.spacingLg),
              _buildTextField(
                controller: _categoryController,
                label: 'Categoría',
                hint: 'Ej. Insumos, Herramientas, Semillas',
                icon: FontAwesomeIcons.tag,
              ),
              const SizedBox(height: AppTheme.spacingLg),
              _buildTextField(
                controller: _paymentDaysController,
                label: 'Días de Pago',
                hint: '30',
                icon: FontAwesomeIcons.calendar,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppTheme.spacingLg),
              SwitchListTile(
                title: const Text('Proveedor Activo'),
                subtitle: const Text('Permite realizar compras a este proveedor'),
                value: _isActive,
                onChanged: (value) {
                  setState(() {
                    _isActive = value;
                  });
                },
                activeColor: AppTheme.primary,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: AppTheme.spacingXl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required FaIconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
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
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppTheme.outlineVariant,
              fontSize: AppTheme.fontSizeBody,
            ),
            filled: true,
            fillColor: Colors.white,
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
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
      borderSide: BorderSide(color: AppTheme.outlineVariant, width: 1),
    );
  }

  OutlineInputBorder _buildFocusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
      borderSide: const BorderSide(color: AppTheme.primary, width: 2),
    );
  }
}
