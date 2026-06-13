import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/models/employe_model.dart';
import 'package:pedidos/models/employee_role_simple_model.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';
import 'package:pedidos/widgets/custom_text_field.dart';
import 'package:pedidos/widgets/custom_dropdown_field.dart';
import 'package:pedidos/core/network/http_client.dart';
import 'package:pedidos/core/network/api_client.dart';
import 'package:pedidos/core/network/exceptions/network_exceptions.dart';

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

  String _selectedRoleId = '';
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
      _selectedRoleId = widget.employee!.userRole;
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
      _selectedRoleId = '';
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

        // Si es un empleado existente y tiene un rol, seleccionarlo
        if (widget.employee != null && _selectedRoleId.isNotEmpty) {
          _selectedRoleId = widget.employee!.userRole;
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

  String _getSelectedRoleName() {
    if (_selectedRoleId.isEmpty) return '';
    final role = _availableRoles.firstWhere(
          (r) => r.id.toString() == _selectedRoleId,
      orElse: () => EmployeeRoleSimple(id: 0, name: ''),
    );
    return role.name;
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

  Future<void> _saveEmployee() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.employee == null) {
        // Crear nuevo empleado
        final request = CreateEmployeeRequest(
          firstName: _firstNameController.text.trim(),
          middleName: _middleNameController.text.trim().isEmpty ? null : _middleNameController.text.trim(),
          paternalSurname: _paternalSurnameController.text.trim(),
          maternalSurname: _maternalSurnameController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          roleId: int.tryParse(_selectedRoleId ?? '') ?? 0,
          salary: double.parse(_salaryController.text.trim()),
          parentUserId: _selectedParentUserId,
        );

        await _apiClient.createEmployee(request.toJson());
        _showSuccess('Empleado creado exitosamente');
        Navigator.pop(context, true);
      } else {
        // Actualizar empleado existente
        final request = UpdateEmployeeRequest(
          firstName: _firstNameController.text.trim(),
          middleName: _middleNameController.text.trim().isEmpty ? null : _middleNameController.text.trim(),
          paternalSurname: _paternalSurnameController.text.trim(),
          maternalSurname: _maternalSurnameController.text.trim(),
          phone: _phoneController.text.trim(),
          salary: double.parse(_salaryController.text.trim()),
          parentUserId: _selectedParentUserId,
        );

        await _apiClient.updateEmployee(widget.employee!.id.toString(), request.toJson());
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
                value: _selectedRoleId.isNotEmpty ? _selectedRoleId : null,
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
                      _selectedRoleId = value;
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