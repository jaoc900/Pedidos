import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/models/expense_category_model.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';
import 'package:pedidos/core/network/http_client.dart';
import 'package:pedidos/core/network/api_client.dart';

class AddExpenseCategoryScreen extends StatefulWidget {
  final ExpenseCategory? category;

  const AddExpenseCategoryScreen({super.key, this.category});

  @override
  State<AddExpenseCategoryScreen> createState() => _AddExpenseCategoryScreenState();
}

class _AddExpenseCategoryScreenState extends State<AddExpenseCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  int _selectedIconIndex = 0;
  Color _selectedColor = AppTheme.primary;
  bool _isLoading = false;

  late ApiClient _apiClient;

  final List<Map<String, dynamic>> _icons = [
    {'icon': FontAwesomeIcons.tags, 'name': 'category', 'label': 'General'},
    {'icon': FontAwesomeIcons.cartShopping, 'name': 'shopping', 'label': 'Compras'},
    {'icon': FontAwesomeIcons.house, 'name': 'home', 'label': 'Hogar'},
    {'icon': FontAwesomeIcons.utensils, 'name': 'food', 'label': 'Alimentos'},
    {'icon': FontAwesomeIcons.car, 'name': 'transport', 'label': 'Transporte'},
    {'icon': FontAwesomeIcons.bolt, 'name': 'utilities', 'label': 'Servicios'},
    {'icon': FontAwesomeIcons.heart, 'name': 'health', 'label': 'Salud'},
    {'icon': FontAwesomeIcons.graduationCap, 'name': 'education', 'label': 'Educación'},
    {'icon': FontAwesomeIcons.gamepad, 'name': 'entertainment', 'label': 'Entretenimiento'},
    {'icon': FontAwesomeIcons.plane, 'name': 'travel', 'label': 'Viajes'},
  ];

  final List<Color> _colorOptions = [
    AppTheme.primary,
    AppTheme.secondary,
    AppTheme.tertiary,
    AppTheme.error,
    const Color(0xFF9C27B0), // Morado
    const Color(0xFF2196F3), // Azul
    const Color(0xFF009688), // Teal
    const Color(0xFFFF9800), // Naranja
    const Color(0xFF795548), // Marrón
    const Color(0xFF607D8B), // Gris azulado
    const Color(0xFFE91E63), // Rosa
  ];

  @override
  void initState() {
    super.initState();
    _initialize();
    if (widget.category != null) {
      _loadCategoryData();
    }
  }

  Future<void> _initialize() async {
    final httpClient = HttpClient();
    _apiClient = ApiClient(httpClient);
  }

  void _loadCategoryData() {
    _nameController.text = widget.category!.name;
    _descriptionController.text = widget.category!.description;

    // Buscar el índice del icono existente
    final index = _icons.indexWhere((i) => i['name'] == widget.category!.iconName);
    if (index != -1) _selectedIconIndex = index;
    _selectedColor = widget.category!.color;
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

  Future<void> _saveCategory() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final selectedIcon = _icons[_selectedIconIndex];
        final request = CreateExpenseCategoryRequest(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          color: _colorToHex(_selectedColor),
          iconName: selectedIcon['name'],
        );

        if (widget.category == null) {
          // Crear nueva categoría
          await _apiClient.createExpenseCategory(request.toJson());
          _showSuccess('Categoría creada exitosamente');
        } else {
          // Actualizar categoría existente
          await _apiClient.updateExpenseCategory(widget.category!.id.toString(), request.toJson());
          _showSuccess('Categoría actualizada exitosamente');
        }
        if (!mounted) return;

        Navigator.pop(context, true);
      } catch (e) {
        _showError('Error al guardar la categoría: ${e.toString()}');
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
        title: widget.category == null ? 'Agregar categoría' : 'Editar categoría',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
        actions: [
          AppBarButton(
            icon: FontAwesomeIcons.floppyDisk,
            onPressed: _saveCategory,
          )
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
          'Organiza tus gastos creando una categoría personalizada con un nombre, descripción, icono y color único.',
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
            // Category Name
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
                      'Nombre de la Categoría',
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
                    hintText: 'Ej. Renta mensual, Compras...',
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

            // Description
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
                    hintText: 'Describe el propósito de esta categoría...',
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
                    crossAxisCount: 5,
                    crossAxisSpacing: AppTheme.spacingMd,
                    mainAxisSpacing: AppTheme.spacingMd,
                    childAspectRatio: 1,
                  ),
                  itemCount: _icons.length,
                  itemBuilder: (context, index) {
                    final isSelected = _selectedIconIndex == index;
                    final iconData = _icons[index]['icon'] as FaIconData;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIconIndex = index;
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
                            size: 22,
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
                  children: _colorOptions.map((color) {
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
    final selectedIcon = _icons[_selectedIconIndex]['icon'] as FaIconData;
    final Color visualCardColor = _selectedColor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: visualCardColor.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        image: DecorationImage(
          image: const NetworkImage(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCibnU-a4dNd5b16ENMmnq72FKxbUpwIgDsE9Mh27pr5-_UQlUgKTnGd15xBebiLxnka4nDjTClHtK4jB9ZhNavicG6MQPee6a6xrtpGgdYjiresiHqp1jdFO26Ux005nIbMDbEUTxBzhqusvFc_jWC07Hi9DpCDAm1WNUdB3cR5r7QDjwQmX6PM-LFgTRoSK0DCuVc-niJKSeNyOVj5wjodH_dmcWGU6CX_lMejbfNUbbF9kxO4t5djRPVN3nwdarijfuOy-JCFmkG',
          ),
          fit: BoxFit.cover,
          opacity: 0.15,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
            ),
            child: Center(
              child: FaIcon(
                selectedIcon,
                size: 32,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Text(
            _nameController.text.isEmpty ? 'Nueva Categoría' : _nameController.text,
            style: TextStyle(
              fontSize: AppTheme.fontSizeTitle,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            _descriptionController.text.isEmpty
                ? 'Descripción de la categoría'
                : _descriptionController.text,
            style: TextStyle(
              fontSize: AppTheme.fontSizeSmall,
              color: Colors.white.withValues(alpha: 0.9),
            ),
            maxLines: 2,
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
                'Color seleccionado',
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