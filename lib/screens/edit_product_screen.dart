import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/screens/modals/confirmation_modal.dart';
import 'package:pedidos/models/size_item_model.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';
import 'package:pedidos/widgets/custom_text_field.dart';
import 'package:pedidos/widgets/custom_dropdown_field.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController(text: 'Zapatilla Runner Pro');
  final TextEditingController _skuController = TextEditingController(text: 'SNK-990-R');
  final TextEditingController _priceController = TextEditingController(text: '89.99');
  final TextEditingController _stockController = TextEditingController(text: '24');
  final TextEditingController _descriptionController = TextEditingController(
    text: 'Zapatilla de alto rendimiento con amortiguación mejorada y suela antideslizante. Ideal para corredores urbanos.',
  );

  String _selectedCategory = 'Calzado';
  bool _isLoading = false;

  final List<String> _categories = ['Calzado', 'Ropa', 'Accesorios'];

  // Lista de tallas/tamaños
  List<SizeItem> _sizes = [
    SizeItem(size: 'XS', stock: 5, isEnabled: true),
    SizeItem(size: 'S', stock: 12, isEnabled: true),
    SizeItem(size: 'M', stock: 24, isEnabled: true),
    SizeItem(size: 'L', stock: 18, isEnabled: true),
    SizeItem(size: 'XL', stock: 8, isEnabled: true),
    SizeItem(size: 'XXL', stock: 3, isEnabled: true),
  ];

  final TextEditingController _newSizeController = TextEditingController();
  final TextEditingController _newSizeStockController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _descriptionController.dispose();
    _newSizeController.dispose();
    _newSizeStockController.dispose();
    super.dispose();
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Producto actualizado exitosamente'),
            backgroundColor: AppTheme.primary,
          ),
        );
        Navigator.pop(context);
      });
    }
  }

  void _deleteProduct() {
    ConfirmationModal.show(
      context,
      title: 'Eliminar Artículo',
      message: '¿Estás seguro de que deseas eliminar este producto?\n\nEsta acción no se puede deshacer.',
      confirmText: 'Eliminar',
      cancelText: 'Cancelar',
      type: ConfirmationType.warning,
      customIcon: FontAwesomeIcons.trashCan,
      onConfirm: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Producto eliminado'),
            backgroundColor: AppTheme.error,
          ),
        );
        Navigator.pop(context);
      },
    );
  }

  void _addNewSize() {
    if (_newSizeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingresa una talla'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }

    int stock = int.tryParse(_newSizeStockController.text) ?? 0;

    setState(() {
      _sizes.add(SizeItem(
        size: _newSizeController.text.toUpperCase(),
        stock: stock,
        isEnabled: true,
      ));
      _newSizeController.clear();
      _newSizeStockController.clear();
    });
  }

  void _updateSizeStock(int index, int newStock) {
    setState(() {
      _sizes[index].stock = newStock;
    });
  }

  void _toggleSizeEnabled(int index) {
    setState(() {
      _sizes[index].isEnabled = !_sizes[index].isEnabled;
    });
  }

  void _deleteSize(int index) {
    ConfirmationModal.show(
      context,
      title: 'Eliminar Talla',
      message: '¿Estás seguro de que deseas eliminar la talla ${_sizes[index].size}?',
      confirmText: 'Eliminar',
      cancelText: 'Cancelar',
      type: ConfirmationType.warning,
      customIcon: FontAwesomeIcons.trashCan,
      onConfirm: () {
        setState(() {
          _sizes.removeAt(index);
        });
      },
    );
  }

  int get _totalStock {
    return _sizes.fold(0, (sum, size) => sum + (size.isEnabled ? size.stock : 0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: CustomTopAppBar(
          title: 'Artículos',
          showBackButton: true,
          actions:[
            AppBarButton(
                icon: FontAwesomeIcons.trashCan,
                color: AppTheme.error,
                onPressed: _deleteProduct
            ),
            AppBarButton(
              icon: FontAwesomeIcons.solidFloppyDisk,
              onPressed: _saveProduct,
            )
          ]
      ),
      body: Column(
        children: [
          // Contenido principal
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingXl),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Product Image Preview Section
                    _buildImageSection(),
                    const SizedBox(height: AppTheme.spacingXl),
                    // Form Section
                    _buildFormSection(),
                    const SizedBox(height: AppTheme.spacingXl),
                    // Sizes Section
                    _buildSizesSection(),
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

  Widget _buildImageSection() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
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
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuDN0YaWJEXaGOUXGPg9_g8eOXuF1FaEWhIl2HcCUiH_w3kmLpCOVB2GdcvrWp8CvSBNaS4k7tGiBAgZZ7fJcZE229wIwFin4HLUmV16rekm3JA2p0Lknex24ByzVjCZEFrdagi4CxfjjkM27Hcl0yTa0gs33zLaDtTsNGpaHi38mxCY_RSMNsU6Q5lo10KnmU1_xH7Tg8YSMyvWh6lbJmfylp06qqlgHV9XhHP7XCNNK8WJo8viVOgLSBh1UA_Jj_2_c0B7t-V1grh-',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppTheme.surfaceContainer,
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.image,
                            size: 48,
                            color: AppTheme.outline,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: AppTheme.spacingLg,
                right: AppTheme.spacingLg,
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Funcionalidad: Cambiar imagen'),
                        backgroundColor: AppTheme.primary,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(AppTheme.spacingMd),
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
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),
        Text(
          'Toca para cambiar la imagen',
          style: TextStyle(
            fontSize: AppTheme.fontSizeSmall,
            fontWeight: FontWeight.w500,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Nombre del Producto
        CustomTextField(
          controller: _nameController,
          label: 'Nombre del Producto',
          hint: 'Ej. Zapatilla Runner Pro',
          icon: FontAwesomeIcons.box,
          textInputAction: TextInputAction.next,
          borderRadius: AppTheme.borderRadiusXXl,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa el nombre del producto';
            }
            return null;
          },
        ),
        const SizedBox(height: AppTheme.spacingLg),

        // SKU y Categoría
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomTextField(
                controller: _skuController,
                label: 'SKU/ID',
                hint: 'Ej. SNK-990-R',
                icon: FontAwesomeIcons.barcode,
                textInputAction: TextInputAction.next,
                borderRadius: AppTheme.borderRadiusXXl,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Requerido';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: AppTheme.spacingLg),
            Expanded(
              child: CustomDropdownField(
                label: 'Categoría',
                hint: 'Seleccione una categoría',
                icon: FontAwesomeIcons.list,
                borderRadius: AppTheme.borderRadiusXXl,
                value: _selectedCategory,
                items: const [
                  'Electrónica',
                  'Ropa',
                  'Hogar',
                  'Papelería',
                  'Calzado'
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value ?? '';
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingLg),

        // Precio y Stock General
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _priceController,
                label: 'Precio de Venta',
                hint: '0.00',
                icon: FontAwesomeIcons.dollarSign,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                borderRadius: AppTheme.borderRadiusXXl,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Requerido';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: AppTheme.spacingLg),
            Expanded(
              child: _buildStockSummaryCard(),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingLg),

        // Descripción
        CustomTextField(
          controller: _descriptionController,
          label: 'Descripción',
          hint: 'Descripción del producto...',
          icon: FontAwesomeIcons.alignLeft,
          maxLines: 4,
          textInputAction: TextInputAction.done,
          borderRadius: AppTheme.borderRadiusXXl,
        ),
      ],
    );
  }

// Método auxiliar para el campo de precio
  Widget _buildPriceField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required FaIconData icon,
    String? Function(String?)? validator,
  }) {
    return CustomTextField(
      controller: controller,
      label: label,
      hint: hint,
      icon: icon,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.next,
      borderRadius: AppTheme.borderRadiusXXl,
      validator: validator,
    );
  }

// Método auxiliar para el dropdown (necesitas crear este widget)
  Widget _buildDropdownField({
    required String? value,
    required String label,
    required List<String> items,
    required FaIconData icon,
    required Function(String?) onChanged,
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
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusXXl),
            border: Border.all(color: AppTheme.outlineVariant),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppTheme.spacingLg,
                vertical: AppTheme.spacingLg,
              ),
            ),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Selecciona una categoría';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStockSummaryCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FaIcon(
              FontAwesomeIcons.cubes,
              size: 14,
              color: AppTheme.primary,
            ),
            const SizedBox(width: AppTheme.spacingSm),
            Text(
              'Stock Total',
              style: TextStyle(
                fontSize: AppTheme.fontSizeLabel,
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingSm),
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
          decoration: BoxDecoration(
            color: AppTheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
            border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total unidades:',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeBody,
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
              Text(
                '$_totalStock',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeTitle,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSizesSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: AppTheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.ruler,
                  size: 20,
                  color: AppTheme.primary,
                ),
                const SizedBox(width: AppTheme.spacingSm),
                Text(
                  'Tallas / Tamaños',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeTitle,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                ),
                const Spacer(),
                Text(
                  'Total: $_totalStock',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeLabel,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0, color: AppTheme.outlineVariant),

          // Lista de tallas
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _sizes.length,
            separatorBuilder: (context, index) => const Divider(height: 0, color: AppTheme.outlineVariant),
            itemBuilder: (context, index) {
              final size = _sizes[index];
              return _buildSizeItem(size, index);
            },
          ),

          // Agregar nueva talla
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _newSizeController,
                        decoration: InputDecoration(
                          hintText: 'Talla (Ej. M, L, XL, 42)',
                          hintStyle: TextStyle(
                            color: AppTheme.outlineVariant,
                            fontSize: AppTheme.fontSizeSmall,
                          ),
                          border: _buildInputBorder(),
                          enabledBorder: _buildInputBorder(),
                          focusedBorder: _buildFocusedBorder(),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacingLg,
                            vertical: AppTheme.spacingLg,
                          ),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingMd),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: _newSizeStockController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Stock',
                          hintStyle: TextStyle(
                            color: AppTheme.outlineVariant,
                            fontSize: AppTheme.fontSizeSmall,
                          ),
                          border: _buildInputBorder(),
                          enabledBorder: _buildInputBorder(),
                          focusedBorder: _buildFocusedBorder(),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacingLg,
                            vertical: AppTheme.spacingLg,
                          ),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingMd),
                    GestureDetector(
                      onTap: _addNewSize,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
                        ),
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.plus,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingSm),
                Text(
                  'Agrega nuevas tallas según sea necesario',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeSmall,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeItem(SizeItem size, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg, vertical: AppTheme.spacingMd),
      child: Row(
        children: [
          // Switch para habilitar/deshabilitar
          Switch(
            value: size.isEnabled,
            onChanged: (_) => _toggleSizeEnabled(index),
            activeColor: AppTheme.primary,
          ),
          const SizedBox(width: AppTheme.spacingMd),
          // Talla
          Container(
            width: 60,
            child: Text(
              size.size,
              style: TextStyle(
                fontSize: AppTheme.fontSizeBody,
                fontWeight: FontWeight.w600,
                color: size.isEnabled ? AppTheme.onSurface : AppTheme.outline,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingLg),
          // Stock
          Expanded(
            child: Container(
              height: 44,
              child: TextFormField(
                initialValue: size.stock.toString(),
                keyboardType: TextInputType.number,
                enabled: size.isEnabled,
                onChanged: (value) {
                  int newStock = int.tryParse(value) ?? 0;
                  _updateSizeStock(index, newStock);
                },
                decoration: InputDecoration(
                  hintText: 'Stock',
                  border: _buildInputBorder(),
                  enabledBorder: _buildInputBorder(),
                  focusedBorder: _buildFocusedBorder(),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingLg,
                    vertical: AppTheme.spacingLg,
                  ),
                  isDense: true,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingMd),
          // Botón eliminar
          GestureDetector(
            onTap: () => _deleteSize(index),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppTheme.errorContainer.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.trashCan,
                  size: 16,
                  color: AppTheme.error,
                ),
              ),
            ),
          ),
        ],
      ),
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