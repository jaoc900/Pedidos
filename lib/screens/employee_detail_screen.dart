import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/models/employe_model.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';
import 'package:pedidos/widgets/custom_text_field.dart';
import 'package:pedidos/widgets/custom_dropdown_field.dart';

// Pantalla de detalle de empleado
class EmployeeDetailScreen extends StatefulWidget {
  final Employee? employee;
  const EmployeeDetailScreen({super.key, this.employee});

  @override
  State<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _departmentController;
  late TextEditingController _passwordController;
  String _selectedRole = 'Vendedor';
  bool _isLoading = false;

  final List<String> _roles = ['Administrador', 'Vendedor', 'Almacenista', 'Contador', 'Supervisor'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee?.name ?? '');
    _emailController = TextEditingController(text: widget.employee?.email ?? '');
    _phoneController = TextEditingController(text: widget.employee?.phone ?? '');
    _departmentController = TextEditingController(text: widget.employee?.department ?? '');
    _passwordController = TextEditingController();
    _selectedRole = widget.employee?.role ?? 'Vendedor';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _departmentController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _saveEmployee() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Simular llamada a API
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.employee == null ? 'Empleado creado exitosamente' : 'Empleado actualizado'),
          backgroundColor: AppTheme.primary,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          _buildTopAppBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingXl),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Nombre completo
                    CustomTextField(
                      controller: _nameController,
                      label: 'Nombre completo',
                      hint: 'Ej. Ana García',
                      icon: FontAwesomeIcons.user,
                      textInputAction: TextInputAction.next,
                      borderRadius: AppTheme.borderRadiusXXl,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Requerido';
                        return null;
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingLg),

                    // Correo electrónico
                    CustomTextField(
                      controller: _emailController,
                      label: 'Correo electrónico',
                      hint: 'ana@ejemplo.com',
                      icon: FontAwesomeIcons.envelope,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      borderRadius: AppTheme.borderRadiusXXl,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Correo inválido';
                          }
                        }
                        return null;
                      },
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

                    // Rol - Usando CustomDropdownField
                    CustomDropdownField(
                      value: _selectedRole,
                      label: 'Rol',
                      hint: 'Selecciona un rol',
                      items: _roles,
                      icon: FontAwesomeIcons.userGear,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedRole = value;
                          });
                        }
                      },
                      borderRadius: AppTheme.borderRadiusXXl,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Selecciona un rol';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingLg),

                    // Departamento
                    CustomTextField(
                      controller: _departmentController,
                      label: 'Departamento',
                      hint: 'Ej. Ventas',
                      icon: FontAwesomeIcons.building,
                      textInputAction: TextInputAction.next,
                      borderRadius: AppTheme.borderRadiusXXl,
                    ),
                    const SizedBox(height: AppTheme.spacingLg),

                    // Contraseña temporal (solo para nuevo empleado)
                    if (widget.employee == null)
                      CustomTextField(
                        controller: _passwordController,
                        label: 'Contraseña temporal',
                        hint: '********',
                        icon: FontAwesomeIcons.lock,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        borderRadius: AppTheme.borderRadiusXXl,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Requerido';
                          if (value.length < 6) return 'Mínimo 6 caracteres';
                          return null;
                        },
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

  Widget _buildTopAppBar() {
    return CustomTopAppBar(
      title: widget.employee == null ? 'Nuevo Empleado' : 'Editar Empleado',
      showBackButton: true,
      onBackPressed: () => Navigator.pop(context),
      actions: [
         AppBarButton(
           icon: FontAwesomeIcons.save,
           onPressed: _saveEmployee,
           color: AppTheme.primary,
         ),
       ],
    );
  }
}