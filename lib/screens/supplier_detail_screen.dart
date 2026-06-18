import 'package:flutter/material.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/models/supplier_model.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';
import 'package:pedidos/widgets/custom_text_field.dart';

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
      appBar: CustomTopAppBar(
        title: widget.supplier == null ? 'Nuevo Proveedor' : 'Editar Proveedor',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveSupplier,
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.primary,
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
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
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Formulario
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingXl),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Nombre del Proveedor
                    CustomTextField(
                      controller: _nameController,
                      label: 'Nombre del Proveedor',
                      hint: 'Ej. Agroinsumos S.A.',
                      icon: FontAwesomeIcons.building,
                      textInputAction: TextInputAction.next,
                      borderRadius: AppTheme.borderRadiusXXl,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa el nombre';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingLg),

                    // Persona de Contacto
                    CustomTextField(
                      controller: _contactController,
                      label: 'Persona de Contacto',
                      hint: 'Ej. Juan Pérez',
                      icon: FontAwesomeIcons.user,
                      textInputAction: TextInputAction.next,
                      borderRadius: AppTheme.borderRadiusXXl,
                    ),
                    const SizedBox(height: AppTheme.spacingLg),

                    // Teléfono
                    CustomTextField(
                      controller: _phoneController,
                      label: 'Teléfono',
                      hint: '+52 555 123 4567',
                      icon: FontAwesomeIcons.phone,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      borderRadius: AppTheme.borderRadiusXXl,
                    ),
                    const SizedBox(height: AppTheme.spacingLg),

                    // Correo Electrónico
                    CustomTextField(
                      controller: _emailController,
                      label: 'Correo Electrónico',
                      hint: 'ventas@proveedor.com',
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

                    // Dirección
                    CustomTextField(
                      controller: _addressController,
                      label: 'Dirección',
                      hint: 'Calle, Número, Ciudad...',
                      icon: FontAwesomeIcons.locationDot,
                      maxLines: 2,
                      textInputAction: TextInputAction.next,
                      borderRadius: AppTheme.borderRadiusXXl,
                    ),
                    const SizedBox(height: AppTheme.spacingLg),

                    // Categoría
                    CustomTextField(
                      controller: _categoryController,
                      label: 'Categoría',
                      hint: 'Ej. Insumos, Herramientas, Semillas',
                      icon: FontAwesomeIcons.tag,
                      textInputAction: TextInputAction.next,
                      borderRadius: AppTheme.borderRadiusXXl,
                    ),
                    const SizedBox(height: AppTheme.spacingLg),

                    // Días de Pago
                    CustomTextField(
                      controller: _paymentDaysController,
                      label: 'Días de Pago',
                      hint: '30',
                      icon: FontAwesomeIcons.calendar,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      borderRadius: AppTheme.borderRadiusXXl,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Requerido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingLg),

                    // Switch Activo
                    SwitchListTile(
                      title: const Text('Proveedor Activo'),
                      subtitle: const Text('Permite realizar compras a este proveedor'),
                      value: _isActive,
                      onChanged: (value) {
                        setState(() {
                          _isActive = value;
                        });
                      },
                      activeThumbColor: AppTheme.primary,
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: AppTheme.spacingXl),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}