import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/models/employe_model.dart';
import 'package:pedidos/models/employee_role_simple_model.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';
import 'package:pedidos/widgets/custom_text_field.dart';
import 'package:pedidos/widgets/custom_dropdown_field.dart';
import 'package:pedidos/widgets/primary_button.dart';
import 'package:pedidos/widgets/custom_outlined_button.dart';
import 'package:pedidos/core/network/http_client.dart';
import 'package:pedidos/core/network/api_client.dart';
import 'package:pedidos/screens/modals/confirmation_modal.dart';

class EmployeeDetailScreen extends StatefulWidget {
  final Employee? employee;
  const EmployeeDetailScreen({super.key, this.employee});

  @override
  State<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos del empleado
  late TextEditingController _firstNameController;
  late TextEditingController _middleNameController;
  late TextEditingController _paternalSurnameController;
  late TextEditingController _maternalSurnameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _salaryController;
  late TextEditingController _passwordController;

  int _selectedRoleId = 0;
  int? _selectedParentUserId;
  bool _isLoading = false;

  late ApiClient _apiClient;

  // Lista de roles disponibles
  List<EmployeeRoleSimple> _availableRoles = [];
  bool _isLoadingRoles = true;

  @override
  void initState() {
    super.initState();
    _initialize();
    _initControllers();
    _loadAvailableRoles();
  }

  Future<void> _initialize() async {
    final httpClient = HttpClient();
    _apiClient = ApiClient(httpClient);
  }

  void _initControllers() {
    if (widget.employee != null) {
      // Edición: cargar datos existentes
      _firstNameController = TextEditingController(text: widget.employee!.firstName);
      _middleNameController = TextEditingController(text: widget.employee!.middleName ?? '');
      _paternalSurnameController = TextEditingController(text: widget.employee!.paternalSurname);
      _maternalSurnameController = TextEditingController(text: widget.employee!.maternalSurname);
      _emailController = TextEditingController(text: widget.employee!.userEmail);
      _phoneController = TextEditingController(text: widget.employee!.phone);
      _salaryController = TextEditingController(text: widget.employee!.salary.toString());
      _selectedRoleId = widget.employee!.roleId;
      _selectedParentUserId = widget.employee!.parentUserId;
      _passwordController = TextEditingController();
    } else {
      // Nuevo empleado
      _firstNameController = TextEditingController();
      _middleNameController = TextEditingController();
      _paternalSurnameController = TextEditingController();
      _maternalSurnameController = TextEditingController();
      _emailController = TextEditingController();
      _phoneController = TextEditingController();
      _salaryController = TextEditingController();
      _passwordController = TextEditingController();
      _selectedRoleId = 0;
      _selectedParentUserId = null;
    }
  }

  Future<void> _loadAvailableRoles() async {
    setState(() {
      _isLoadingRoles = true;
    });

    try {
      final response = await _apiClient.getEmployeeRolesSimpleList();
      // La respuesta es una lista, no un objeto único
      List<EmployeeRoleSimple> roles = [];

      if (response is List) {
        roles = response.map((item) => EmployeeRoleSimple.fromJson(item)).toList();
      } else if (response is Map<String, dynamic>) {
        // Si la respuesta tiene estructura anidada
        if (response.containsKey('data')) {
          final data = response['data'];
          if (data is List) {
            roles = data.map((item) => EmployeeRoleSimple.fromJson(item)).toList();
          }
        }
      }

      setState(() {
        _availableRoles = roles;
        _isLoadingRoles = false;
        debugPrint("Roles: ${_availableRoles.length}");

        // Si es un empleado existente y tiene un rol, seleccionarlo
        if (widget.employee != null && _selectedRoleId > 0) {
          _selectedRoleId = widget.employee!.roleId;
        }
      });
    } catch (e) {
      print('Error cargando roles: $e');
      setState(() {
        _isLoadingRoles = false;
      });
      _showError('Error al cargar los roles disponibles');
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _paternalSurnameController.dispose();
    _maternalSurnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _salaryController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword(Employee employee) async {
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool obscureNewPassword = true;
    bool obscureConfirmPassword = true;

    // Mostrar diálogo para ingresar nueva contraseña
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateModal) {
          return AlertDialog(
            title: const Text('Restablecer Contraseña'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Ingresa la nueva contraseña para "${employee.fullName}"',
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeBody,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingLg),
                  // Nueva contraseña
                  CustomTextField(
                    controller: newPasswordController,
                    label: 'Nueva contraseña',
                    hint: 'Mínimo 6 caracteres',
                    icon: FontAwesomeIcons.lock,
                    obscureText: obscureNewPassword,
                    suffixIcon: IconButton(
                      icon: FaIcon(
                        obscureNewPassword ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                        size: 18,
                        color: AppTheme.outline,
                      ),
                      onPressed: () {
                        setStateModal(() {
                          obscureNewPassword = !obscureNewPassword;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa la nueva contraseña';
                      }
                      if (value.length < 6) {
                        return 'La contraseña debe tener al menos 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  // Confirmar contraseña
                  CustomTextField(
                    controller: confirmPasswordController,
                    label: 'Confirmar contraseña',
                    hint: 'Repite la nueva contraseña',
                    icon: FontAwesomeIcons.lock,
                    obscureText: obscureConfirmPassword,
                    suffixIcon: IconButton(
                      icon: FaIcon(
                        obscureConfirmPassword ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                        size: 18,
                        color: AppTheme.outline,
                      ),
                      onPressed: () {
                        setStateModal(() {
                          obscureConfirmPassword = !obscureConfirmPassword;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirma la contraseña';
                      }
                      if (value != newPasswordController.text) {
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Botón Cancelar (Outlined)
                    CustomOutlinedButton(
                      text: 'Cancelar',
                      onPressed: () => Navigator.pop(context, false),
                      icon: FontAwesomeIcons.times,
                      height: 45,
                      fontSize: 14,
                      borderRadius: AppTheme.borderRadiusXXl,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      fullWidth: false,
                    ),
                    const SizedBox(width: AppTheme.spacingMd),
                    // Botón Restablecer (Primary)
                    PrimaryButton(
                      text: 'Restablecer',
                      icon: FontAwesomeIcons.key,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          Navigator.pop(context, true);
                        }
                      },
                      borderRadius: AppTheme.borderRadiusXXl,
                      height: 45,
                      fontSize: 14,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      fullWidth: false,
                    ),
                  ],
                ),
              ],
            actionsPadding: const EdgeInsets.all(AppTheme.spacingMd),
            contentPadding: const EdgeInsets.all(AppTheme.spacingLg),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
            ),
          );
        },
      ),
    );

    if (shouldReset != true) return;

    try {
      setState(() {
        _isLoading = true;
      });

      // Llamar al API con la nueva contraseña
      await _apiClient.resetEmployeePassword(
        employee.id.toString(),
        newPasswordController.text.trim(),
      );

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Contraseña actualizada para ${employee.fullName}'),
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
  }

  Future<void> _saveEmployee() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final employee = Employee(
        id: widget.employee?.id ?? 0,
        firstName: _firstNameController.text.trim(),
        middleName: _middleNameController.text.trim().isEmpty ? null : _middleNameController.text.trim(),
        paternalSurname: _paternalSurnameController.text.trim(),
        maternalSurname: _maternalSurnameController.text.trim(),
        phone: _phoneController.text.trim(),
        userId: widget.employee?.userId ?? 0,  // Si es null, usar 0
        userEmail: _emailController.text.trim(),
        userRole: widget.employee?.userRole ?? '',  // Si es null, usar string vacío
        salary: double.parse(_salaryController.text.trim()),
        createdAt: widget.employee?.createdAt ?? DateTime.now(),  // Si es null, usar fecha actual
        roleId: _selectedRoleId,
        parentUserId: _selectedParentUserId,
        password: _passwordController.text.trim()
      );
      jsonEncode(employee.toJson());
      if (widget.employee == null) {
        await _apiClient.createEmployee(employee.toJson());
        _showSuccess('Empleado creado exitosamente');
        Navigator.pop(context, true);
      } else {
        await _apiClient.updateEmployee(widget.employee!.id.toString(), employee.toJson());
        _showSuccess('Empleado actualizado exitosamente');
        Navigator.pop(context, true);
      }
    } catch (e) {
      _showError('Error al guardar el empleado: ${e.toString()}');
      setState(() {
        _isLoading = false;
      });
    }
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
        title: widget.employee == null ? 'Nuevo Empleado' : 'Editar Empleado',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
        actions: [
          if (widget.employee != null)
          AppBarButton(
            icon: FontAwesomeIcons.key,
            onPressed: () {
              if (widget.employee != null) {
                _resetPassword(widget.employee!);
              }
            },
          ),
          AppBarButton(
            icon: FontAwesomeIcons.save,
            onPressed: _saveEmployee,
          ),
        ],
      ),
      body: _isLoading || _isLoadingRoles
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Nombre
              CustomTextField(
                controller: _firstNameController,
                label: 'Nombre',
                hint: 'Ej. Ana',
                icon: FontAwesomeIcons.user,
                textInputAction: TextInputAction.next,
                borderRadius: AppTheme.borderRadiusXXl,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'El nombre es requerido';
                  return null;
                },
              ),
              const SizedBox(height: AppTheme.spacingLg),

              // Segundo Nombre (opcional)
              CustomTextField(
                controller: _middleNameController,
                label: 'Segundo nombre (opcional)',
                hint: 'Ej. María',
                icon: FontAwesomeIcons.user,
                textInputAction: TextInputAction.next,
                borderRadius: AppTheme.borderRadiusXXl,
              ),
              const SizedBox(height: AppTheme.spacingLg),

              // Apellido Paterno
              CustomTextField(
                controller: _paternalSurnameController,
                label: 'Apellido paterno',
                hint: 'Ej. García',
                icon: FontAwesomeIcons.user,
                textInputAction: TextInputAction.next,
                borderRadius: AppTheme.borderRadiusXXl,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'El apellido paterno es requerido';
                  return null;
                },
              ),
              const SizedBox(height: AppTheme.spacingLg),

              // Apellido Materno
              CustomTextField(
                controller: _maternalSurnameController,
                label: 'Apellido materno',
                hint: 'Ej. Pérez',
                icon: FontAwesomeIcons.user,
                textInputAction: TextInputAction.next,
                borderRadius: AppTheme.borderRadiusXXl,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'El apellido materno es requerido';
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
                  if (value == null || value.isEmpty) return 'El correo es requerido';
                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Correo inválido';
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
                validator: (value) {
                  if (value == null || value.isEmpty) return 'El teléfono es requerido';
                  return null;
                },
              ),
              const SizedBox(height: AppTheme.spacingLg),

              // Salario
              CustomTextField(
                controller: _salaryController,
                label: 'Salario',
                hint: '0.00',
                icon: FontAwesomeIcons.dollarSign,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                borderRadius: AppTheme.borderRadiusXXl,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'El salario es requerido';
                  if (double.tryParse(value) == null) return 'Salario inválido';
                  return null;
                },
              ),
              const SizedBox(height: AppTheme.spacingLg),

              // Rol - Cargado desde API
              CustomDropdownField(
                value: _selectedRoleId > 0 ? _selectedRoleId.toString() : null,
                label: 'Rol',
                hint: 'Selecciona un rol',
                items: _availableRoles.map((role) => DropdownItem(
                  value: role.id.toString(),
                  label: role.name,
                )).toList(),
                icon: FontAwesomeIcons.userGear,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedRoleId = int.parse(value);
                    });
                  }
                },
                borderRadius: AppTheme.borderRadiusXXl,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Selecciona un rol';
                  return null;
                },
              ),
              const SizedBox(height: AppTheme.spacingLg),

              // Contraseña temporal (solo para nuevo empleado)
              if (widget.employee == null)
                CustomTextField(
                  controller: _passwordController,
                  label: 'Contraseña temporal',
                  hint: 'Mínimo 6 caracteres',
                  icon: FontAwesomeIcons.lock,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  borderRadius: AppTheme.borderRadiusXXl,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'La contraseña es requerida';
                    if (value.length < 6) return 'Mínimo 6 caracteres';
                    return null;
                  },
                ),

              const SizedBox(height: AppTheme.spacingXl),
            ],
          ),
        ),
      ),
    );
  }
}