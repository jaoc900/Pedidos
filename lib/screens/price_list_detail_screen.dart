import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/utils/icon_helper.dart';
import 'package:pedidos/models/price_list_model.dart';
import 'package:pedidos/models/product_price_model.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';
import 'package:pedidos/widgets/custom_text_field.dart';
import 'package:pedidos/widgets/custom_chips.dart';

class PriceListDetailScreen extends StatefulWidget {
  final String? listName;

  const PriceListDetailScreen({super.key, this.listName});

  @override
  State<PriceListDetailScreen> createState() => _PriceListDetailScreenState();
}

class _PriceListDetailScreenState extends State<PriceListDetailScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'Todas';
  String _selectedCategory = '';
  bool _isEditing = false;
  String? _editingProductId;

  final List<String> _categories = ['Todos', 'Semillas', 'Fertilizantes', 'Herramientas'];

  final List<ProductPrice> _products = [
    ProductPrice(
      id: '1',
      name: 'Semillas de Maíz Híbrido',
      sku: 'SKU-2024-01',
      price: 112.50,
      stock: 450,
      stockUnit: 'kg',
      category: 'Semillas',
      icon: FontAwesomeIcons.seedling,
      iconColor: AppTheme.primary,
    ),
    ProductPrice(
      id: '2',
      name: 'Fertilizante Orgánico NPK',
      sku: 'SKU-FERT-88',
      price: 45.00,
      stock: 120,
      stockUnit: 'ud',
      category: 'Fertilizantes',
      icon: FontAwesomeIcons.leaf,
      iconColor: AppTheme.secondary,
    ),
    ProductPrice(
      id: '3',
      name: 'Sustrato Premium 50L',
      sku: 'SKU-SUS-012',
      price: 28.75,
      stock: 85,
      stockUnit: 'ud',
      category: 'Fertilizantes',
      icon: FontAwesomeIcons.pagelines,
      iconColor: AppTheme.tertiary,
    ),
    ProductPrice(
      id: '4',
      name: 'Sistema Micro-Riego',
      sku: 'SKU-IRR-901',
      price: 340.00,
      stock: 5,
      stockUnit: 'ud',
      category: 'Herramientas',
      icon: FontAwesomeIcons.water,
      iconColor: AppTheme.primary,
    ),
    ProductPrice(
      id: '5',
      name: 'Humus de Lombriz',
      sku: 'SKU-ORG-334',
      price: 18.20,
      stock: 500,
      stockUnit: 'kg',
      category: 'Fertilizantes',
      icon: FontAwesomeIcons.tree,
      iconColor: AppTheme.secondary,
    ),
    ProductPrice(
      id: '6',
      name: 'Consultoría Técnica',
      sku: 'SKU-SERV-01',
      price: 75.00,
      stock: 0,
      stockUnit: 'hora',
      category: 'Servicios',
      icon: FontAwesomeIcons.chalkboardUser,
      iconColor: AppTheme.tertiary,
    ),
  ];

  List<ProductPrice> get _filteredProducts {
    List<ProductPrice> filtered = _products;

    if (_selectedCategory != 'Todos') {
      filtered = filtered.where((p) => p.category == _selectedCategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((p) =>
      p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.sku.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    return filtered;
  }

  void _startEditing(String productId, double currentPrice) {
    setState(() {
      _editingProductId = productId;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar Precio'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _products.firstWhere((p) => p.id == productId).name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppTheme.spacingLg),
            TextFormField(
              initialValue: currentPrice.toString(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Precio',
                prefixText: '\$ ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
                ),
              ),
              onFieldSubmitted: (value) {
                final newPrice = double.tryParse(value);
                if (newPrice != null) {
                  setState(() {
                    final index = _products.indexWhere((p) => p.id == productId);
                    if (index != -1) {
                      _products[index].price = newPrice;
                    }
                  });
                }
                Navigator.pop(context);
                setState(() {
                  _editingProductId = null;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _editingProductId = null;
              });
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // El guardado se maneja en onFieldSubmitted
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          _buildTopAppBar(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingXl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: AppTheme.spacingLg),
                  // Filtros
                  _buildFilters(),
                  const SizedBox(height: AppTheme.spacingLg),
                  _buildProductsList(),
                  const SizedBox(height: AppTheme.spacingXl),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Agregar nuevo producto'),
              backgroundColor: AppTheme.primary,
            ),
          );
        },
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.onTertiary,
        elevation: 4,
        heroTag: 'add_product_fab',
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        ),
        child: const FaIcon(FontAwesomeIcons.plus, size: 24),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildTopAppBar(BuildContext context) {
    return CustomTopAppBar(
      title: 'Lista: ',
      showBackButton: true,
      onBackPressed: () => Navigator.pop(context),
      actions: [
        AppBarButton(
            icon: FontAwesomeIcons.save,
            onPressed: () => {})
      ],
    );
  }

  Widget _buildSearchBar() {
    return CustomTextField(
      controller: _searchController, // Necesitas crear este controller
      label: '', // Si no quieres label, puedes pasar una cadena vacía
      hint: 'Buscar por número o cliente...',
      icon: FontAwesomeIcons.magnifyingGlass,
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      borderRadius: AppTheme.borderRadiusXXl,
    );
  }

  Widget _buildFilters() {
    final filters = [
      const FilterChipData(label: 'Todos', value: 'todos', icon: FontAwesomeIcons.list),
      const FilterChipData(label: 'Pendientes', value: 'pendientes', icon: FontAwesomeIcons.clock),
      const FilterChipData(label: 'Completados', value: 'completados', icon: FontAwesomeIcons.check),
      const FilterChipData(label: 'Cancelados', value: 'cancelados', icon: FontAwesomeIcons.times),
    ];

    return CustomFilterChipWithIcon(
      filters: filters,
      selectedFilter: _selectedFilter,
      onFilterSelected: (filter) {
        setState(() {
          _selectedFilter = filter;
        });
      },
    );
  }

  Widget _buildSearchSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: AppTheme.outlineVariant),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o SKU...',
                hintStyle: TextStyle(
                  color: AppTheme.onSurfaceVariant,
                  fontSize: AppTheme.fontSizeBody,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingMd),
                  child: FaIcon(
                    FontAwesomeIcons.magnifyingGlass,
                    size: 20,
                    color: AppTheme.outline,
                  ),
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.times,
                    size: 16,
                    color: AppTheme.outline,
                  ),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingLg,
                  vertical: AppTheme.spacingLg,
                ),
              ),
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
            ),
            child: IconButton(
              icon: FaIcon(
                FontAwesomeIcons.filter,
                size: 20,
                color: AppTheme.primary,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: AppTheme.spacingMd),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingXl,
                vertical: AppTheme.spacingSm,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.secondaryContainer
                    : AppTheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeLabel,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? AppTheme.onSecondaryContainer
                        : AppTheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductsList() {
    if (_filteredProducts.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
          border: Border.all(color: AppTheme.outlineVariant),
        ),
        child: Column(
          children: [
            FaIcon(
              FontAwesomeIcons.boxOpen,
              size: 64,
              color: AppTheme.outline.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppTheme.spacingLg),
            Text(
              'No se encontraron productos',
              style: TextStyle(
                fontSize: AppTheme.fontSizeBody,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredProducts.length,
      separatorBuilder: (context, index) => const SizedBox(height: AppTheme.spacingMd),
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        return _buildProductItem(product);
      },
    );
  }

  Widget _buildProductItem(ProductPrice product) {
    final isLowStock = product.stock < 10 && product.stock > 0;
    final isOutOfStock = product.stock == 0;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: AppTheme.surfaceContainerHigh),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Row(
          children: [
            // Icono del producto
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: product.iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
              ),
              child: Center(
                child: FaIcon(
                  product.icon,
                  size: 24,
                  color: product.iconColor,
                ),
              ),
            ),
            const SizedBox(width: AppTheme.spacingLg),
            // Información del producto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeLabel,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.sku,
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeSmall,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                      color: AppTheme.outline,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.cubes,
                        size: 12,
                        color: isOutOfStock ? AppTheme.error : AppTheme.outline,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Stock: ${product.stock} ${product.stockUnit}',
                        style: TextStyle(
                          fontSize: AppTheme.fontSizeSmall,
                          fontWeight: FontWeight.w500,
                          color: isLowStock
                              ? AppTheme.warning
                              : (isOutOfStock ? AppTheme.error : AppTheme.tertiary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Precio y botón de editar
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeTitle,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () => _startEditing(product.id, product.price),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingMd,
                      vertical: AppTheme.spacingSm,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
                    ),
                    child: Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.pen,
                          size: 12,
                          color: AppTheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Editar',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

