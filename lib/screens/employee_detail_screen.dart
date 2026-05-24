import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/enums/user_role_enum.dart';
import 'package:pedidos/models/employe_model.dart';

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
  late TextEditingController _roleController;
  late TextEditingController _departmentController;
  late TextEditingController _passwordController;
  String _selectedRole = 'Vendedor';
  final List<String> _roles = ['Administrador', 'Vendedor', 'Almacenista', 'Contador', 'Supervisor'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee?.name ?? '');
    _emailController = TextEditingController(text: widget.employee?.email ?? '');
    _phoneController = TextEditingController(text: widget.employee?.phone ?? '');
    _roleController = TextEditingController(text: widget.employee?.role ?? 'Vendedor');
    _departmentController = TextEditingController(text: widget.employee?.department ?? '');
    _passwordController = TextEditingController();
    _selectedRole = widget.employee?.role ?? 'Vendedor';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _roleController.dispose();
    _departmentController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _saveEmployee() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.employee == null ? 'Empleado creado exitosamente' : 'Empleado actualizado'), backgroundColor: AppTheme.primary),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const FaIcon(FontAwesomeIcons.arrowLeft, color: AppTheme.primary), onPressed: () => Navigator.pop(context)),
        title: Text(widget.employee == null ? 'Nuevo Empleado' : 'Editar Empleado', style: const TextStyle(color: AppTheme.primary)),
        actions: [TextButton(onPressed: _saveEmployee, child: const Text('Guardar', style: TextStyle(color: AppTheme.primary)))],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_nameController, 'Nombre completo', 'Ej. Ana García', FontAwesomeIcons.user, validator: (v) => v == null || v.isEmpty ? 'Requerido' : null),
              const SizedBox(height: AppTheme.spacingLg),
              _buildTextField(_emailController, 'Correo electrónico', 'ana@ejemplo.com', FontAwesomeIcons.envelope, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: AppTheme.spacingLg),
              _buildTextField(_phoneController, 'Teléfono', '+52 555 123 4567', FontAwesomeIcons.phone, keyboardType: TextInputType.phone),
              const SizedBox(height: AppTheme.spacingLg),
              _buildDropdownField('Rol', _selectedRole, _roles, FontAwesomeIcons.userGear, (v) => setState(() => _selectedRole = v!)),
              const SizedBox(height: AppTheme.spacingLg),
              _buildTextField(_departmentController, 'Departamento', 'Ej. Ventas', FontAwesomeIcons.building),
              const SizedBox(height: AppTheme.spacingLg),
              if (widget.employee == null) _buildTextField(_passwordController, 'Contraseña temporal', '********', FontAwesomeIcons.lock, obscureText: true, validator: (v) => v == null || v.isEmpty ? 'Requerido' : null),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController c, String label, String hint, FaIconData icon, {TextInputType keyboardType = TextInputType.text, bool obscureText = false, String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [FaIcon(icon, size: 14, color: AppTheme.primary), const SizedBox(width: 8), Text(label, style: TextStyle(fontSize: AppTheme.fontSizeLabel, fontWeight: FontWeight.w600, color: AppTheme.onSurfaceVariant))]),
        const SizedBox(height: 8),
        TextFormField(controller: c, keyboardType: keyboardType, obscureText: obscureText, validator: validator, decoration: InputDecoration(hintText: hint, filled: true, fillColor: Colors.white, border: _border(), enabledBorder: _border(), focusedBorder: _focusedBorder(), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16))),
      ],
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> items, FaIconData icon, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [FaIcon(icon, size: 14, color: AppTheme.primary), const SizedBox(width: 8), Text(label, style: TextStyle(fontSize: AppTheme.fontSizeLabel, fontWeight: FontWeight.w600, color: AppTheme.onSurfaceVariant))]),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.outlineVariant)),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 16)),
            icon: FaIcon(FontAwesomeIcons.chevronDown, size: 16, color: AppTheme.onSurfaceVariant),
            items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border() => OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppTheme.outlineVariant, width: 1));
  OutlineInputBorder _focusedBorder() => OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.primary, width: 2));
}