// lib/screens/add_employee_role_screen.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/models/employee_role_model.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';
import 'package:pedidos/widgets/custom_text_field.dart';
import 'package:pedidos/widgets/primary_button.dart';
import 'package:pedidos/core/network/http_client.dart';
import 'package:pedidos/core/network/api_client.dart';

class AddEmployeeRoleScreen extends StatefulWidget {
  final EmployeeRole? role;

  const AddEmployeeRoleScreen({super.key, this.role});

  @override
  State<AddEmployeeRoleScreen> createState() => _AddEmployeeRoleScreenState();
}

class _AddEmployeeRoleScreenState extends State<AddEmployeeRoleScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _selectedIcon = 'user';
  Color _selectedColor = AppTheme.primary;
  bool _isLoading = false;

  late ApiClient _apiClient;

  final List<Map<String, dynamic>> _icons = [
    {'value': 'admin', 'icon': FontAwesomeIcons.userShield, 'label': 'Administrador'},
    {'value': 'seller', 'icon': FontAwesomeIcons.userTie, 'label': 'Vendedor'},
    {'value': 'supervisor', 'icon': FontAwesomeIcons.userCheck, 'label': 'Supervisor'},
    {'value': 'warehouse', 'icon': FontAwesomeIcons.box, 'label': 'Almacén'},
    {'value': 'accountant', 'icon': FontAwesomeIcons.calculator, 'label': 'Contador'},
    {'value': 'manager', 'icon': FontAwesomeIcons.userGear, 'label': 'Gerente'},
    {'value': 'cashier', 'icon': FontAwesomeIcons.moneyBill, 'label': 'Cajero'},
    {'value': 'delivery', 'icon': FontAwesomeIcons.truck, 'label': 'Repartidor'},
  ];

  final List<Map<String, dynamic>> _colorOptions = [
    {'value': '#4CAF50', 'color': Colors.green, 'label': 'Verde'},
    {'value': '#2196F3', 'color': Colors.blue, 'label': 'Azul'},
    {'value': '#FF9800', 'color': Colors.orange, 'label': 'Naranja'},
    {'value': '#9C27B0', 'color': Colors.purple, 'label': 'Morado'},
    {'value': '#F44336', 'color': Colors.red, 'label': 'Rojo'},
    {'value': '#00BCD4', 'color': Colors.cyan, 'label': 'Cian'},
    {'value': '#009688', 'color': Colors.teal, 'label': 'Teal'},
    {'value': '#795548', 'color': Colors.brown, 'label': 'Marrón'},
  ];

  @override
  void initState() {
    super.initState();
    _initialize();
    if (widget.role != null) {
      _loadRoleData();
    }
  }

  Future<void> _initialize() async {
    final httpClient = HttpClient();
    _apiClient = ApiClient(httpClient);
  }

  void _loadRoleData() {
    _nameController.text = widget.role!.name;
    _descriptionController.text = widget.role!.description;
    _selectedIcon = widget.role!.icon;
    _selectedColor = widget.role!.colorValue;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2)}';
  }

  Future<void> _saveRole() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final request = CreateEmployeeRoleRequest(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          icon: _selectedIcon,
          color: _colorToHex(_selectedColor),
        );

        if (widget.role == null) {
          await _apiClient.createEmployeeRole(request.toJson());
          _showSuccess('Rol creado exitosamente');
        } else {
          await _apiClient.updateEmployeeRole(widget.role!.id.toString(), request.toJson());
          _showSuccess('Rol actualizado exitosamente');
        }

        Navigator.pop(context, true);
      } catch (e) {
        _showError('Error al guardar el rol: ${e.toString()}');
        setState(() {
          _isLoading = false;
        });
      }
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
        title: widget.role == null ? 'Agregar Rol' : 'Editar Rol',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
        actions: [
          AppBarButton(
            icon: FontAwesomeIcons.save,
            onPressed: _saveRole,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            const SizedBox(height: AppTheme.spacingLg),
            _buildBentoGrid(),
            const SizedBox(height: AppTheme.spacingXl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppTheme.spacingSm),
        Text(
          'Define un rol personalizado para tus empleados con nombre, descripción, icono y color único.',
          style: TextStyle(
            fontSize: AppTheme.fontSizeBody,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildBentoGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 700;

        if (isDesktop) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 7,
                child: _buildFormArea(),
              ),
              const SizedBox(width: AppTheme.spacingLg),
              Expanded(
                flex: 5,
                child: _buildVisualCard(),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              _buildFormArea(),
              const SizedBox(height: AppTheme.spacingLg),
              _buildVisualCard(),
            ],
          );
        }
      },
    );
  }

  Widget _buildFormArea() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: AppTheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Nombre del Rol
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.tag,
                      size: 14,
                      color: AppTheme.primary,
                    ),
                    const SizedBox(width: AppTheme.spacingSm),
                    Text(
                      'Nombre del Rol',
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
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa el nombre';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Ej. Supervisor, Cajero...',
                    hintStyle: TextStyle(
                      color: AppTheme.outlineVariant,
                      fontSize: AppTheme.fontSizeBody,
                    ),
                    filled: true,
                    fillColor: AppTheme.surface,
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
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Descripción
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.alignLeft,
                      size: 14,
                      color: AppTheme.primary,
                    ),
                    const SizedBox(width: AppTheme.spacingSm),
                    Text(
                      'Descripción',
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
                  controller: _descriptionController,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa una descripción';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Describe las responsabilidades de este rol...',
                    hintStyle: TextStyle(
                      color: AppTheme.outlineVariant,
                      fontSize: AppTheme.fontSizeBody,
                    ),
                    filled: true,
                    fillColor: AppTheme.surface,
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
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Icon Selector
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.icons,
                      size: 14,
                      color: AppTheme.primary,
                    ),
                    const SizedBox(width: AppTheme.spacingSm),
                    Text(
                      'Seleccionar Icono',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeLabel,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingSm),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: AppTheme.spacingMd,
                    mainAxisSpacing: AppTheme.spacingMd,
                    childAspectRatio: 1,
                  ),
                  itemCount: _icons.length,
                  itemBuilder: (context, index) {
                    final isSelected = _selectedIcon == _icons[index]['value'];
                    final iconData = _icons[index]['icon'] as FaIconData;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIcon = _icons[index]['value'];
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _selectedColor
                              : AppTheme.surface,
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
                          border: Border.all(
                            color: isSelected
                                ? _selectedColor
                                : AppTheme.outlineVariant,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Center(
                          child: FaIcon(
                            iconData,
                            size: 24,
                            color: isSelected
                                ? Colors.white
                                : AppTheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Color Selector
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.palette,
                      size: 14,
                      color: AppTheme.primary,
                    ),
                    const SizedBox(width: AppTheme.spacingSm),
                    Text(
                      'Seleccionar Color',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeLabel,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingSm),
                Wrap(
                  spacing: AppTheme.spacingMd,
                  runSpacing: AppTheme.spacingMd,
                  children: _colorOptions.map((colorOption) {
                    final color = colorOption['color'] as Color;
                    final isSelected = _selectedColor == color;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColor = color;
                        });
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? Colors.white : Colors.transparent,
                            width: 3,
                          ),
                          boxShadow: isSelected
                              ? [
                            BoxShadow(
                              color: color.withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                              : null,
                        ),
                        child: isSelected
                            ? const Center(
                          child: FaIcon(
                            FontAwesomeIcons.check,
                            size: 16,
                            color: Colors.white,
                          ),
                        )
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualCard() {
    final selectedIconData = _icons.firstWhere(
          (i) => i['value'] == _selectedIcon,
      orElse: () => _icons[0],
    )['icon'] as FaIconData;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: _selectedColor.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        image: DecorationImage(
          image: const NetworkImage(
            'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=800',
          ),
          fit: BoxFit.cover,
          opacity: 0.15,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icono de vista previa
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
            ),
            child: Center(
              child: FaIcon(
                selectedIconData,
                size: 32,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Text(
            _nameController.text.isEmpty ? 'Nuevo Rol' : _nameController.text,
            style: TextStyle(
              fontSize: AppTheme.fontSizeTitle,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            _descriptionController.text.isEmpty
                ? 'Descripción del rol'
                : _descriptionController.text,
            style: TextStyle(
              fontSize: AppTheme.fontSizeSmall,
              color: Colors.white.withValues(alpha: 0.9),
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _selectedColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
              const SizedBox(width: AppTheme.spacingSm),
              Text(
                'Color del rol',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeSmall,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ],
      ),
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