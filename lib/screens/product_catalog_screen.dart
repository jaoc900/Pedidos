import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/enums/stock_status_enum.dart';
import 'package:pedidos/enums/view_model_enum.dart';
import 'package:pedidos/models/product_item_model.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';
import 'package:pedidos/widgets/custom_chips.dart';

class ProductCatalogScreen extends StatefulWidget {
  const ProductCatalogScreen({super.key});

  @override
  State<ProductCatalogScreen> createState() => _ProductCatalogScreenState();
}

class _ProductCatalogScreenState extends State<ProductCatalogScreen> {
  ViewMode _currentViewMode = ViewMode.mediumIcons;
  String _selectedCategory = 'Todos';
  int _cartItemsCount = 0;
  double _cartTotal = 0.00;

  final List<String> _categories = [
    'Todos',
    'Fertilizantes',
    'Semillas',
    'Herramientas',
  ];

  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Fertilizante Orgánico A1',
      price: 45.00,
      stock: 124,
      stockStatus: StockStatus.inStock,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDOGDZ5MwC5WBi4nK9r4tyMgiqkFY5o7yiJ2fWpZN9kb1k2P1aNFLexio9_F1oIOw4J6AOCPcHP8h907PWMB4bCKWmcm3rWPkDt4kmnpMzs_xGzYlhD2jqiuF8D2XRrjQSaT1z298YvHdiBakdLmXjFy95h6FfB2uEocn1Lo_U3yil93SyWFzkIgl5Evbbec8XiWNDmyKPyhWQ8z7EUGqze6pNI0VcxMseDIqRM_MW42882ywJ_JGwtVenViBMxfb4E3uU-bWAkuST0',
      category: 'Fertilizantes',
    ),
    Product(
      id: '2',
      name: 'Semillas Premium Mix',
      price: 28.50,
      stock: 12,
      stockStatus: StockStatus.lowStock,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCuTfLijgdv3y_ASh_ny-oqq0US1GtMSJ-zKJFzFlCLNBQgDfc7Al23Uz7jkounjYEs4fGq-a8KzukkhwYEGF506dmaH6QxMxcJYseBRgPb0R5gGE3oD3yD8iQXmuQXKkjpbj8eN-XpepJELzGQk-DnMtofcq8MWbQa9RzJAwQI8hPIHLafRNyCBCNTeSpMB8OGKQf2XoDBDxqsfoz-mG_tKLanjktsaMpFqq-P8hVbLvjUh2Qt3rLBmHy-CUfKtgRbKhfnBoHpvptR',
      category: 'Semillas',
    ),
    Product(
      id: '3',
      name: 'Herramienta Manual Pro',
      price: 15.90,
      stock: 45,
      stockStatus: StockStatus.inStock,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBp0vlIEHMm9Tkorsk2-u2h8yeMETVPBJ8OKG2kNiKvoawlO3tUjZju75p9tk1WQTfC4sh0xotY9eefecLa2qHA3pISjCPIlcjBBIAVgjstN2ckL3tYZeeROVSkOjzO-7xALy2qraODHMlgJ7j_RmdzCSYirJK631A7GkZsyggCK1DE0T5oYI9xZCQu0bsp0DZPngVOcaYUtXHLozaf-uB1wLaGFT5K1Zl8WEJMbC0Y9pjLTjeamcReI9zQ5n8eT4cN8RFxSKZKgJw7',
      category: 'Herramientas',
    ),
    Product(
      id: '4',
      name: 'Suplemento Foliar',
      price: 62.00,
      stock: 88,
      stockStatus: StockStatus.inStock,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDJCbzVRx73FimkDNZ5tQriG9lyRhdKlVEB4KCrUInb3DOIKf9o81qagM4hxMCD6WPUwAvWGk9iAsPkV8tYWu0s6nfA5Z4mOi_ZOb9tkzUOl7QjS2AhkiqLRPv9B39cDFLrr7LiW1tjj0AO4QQuInvh0jaQSF78jH12Yg_yEeroKI9wJ0p1jPf1TRwRyFxm3uyBv7ln1-05hgFOri2u4HTyUhUdOFgZeTvFLSlsKIIRuW0vsE1xeOf-SvlnKwQBCluXO7AQxI-rJFi8',
      category: 'Fertilizantes',
    ),
  ];

  List<Product> get _filteredProducts {
    if (_selectedCategory == 'Todos') {
      return _products;
    }
    return _products.where((product) => product.category == _selectedCategory).toList();
  }

  void _addToCart(Product product) {
    setState(() {
      _cartItemsCount++;
      _cartTotal += product.price;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} agregado al carrito'),
        backgroundColor: AppTheme.primary,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: CustomTopAppBar(
        title: 'Catálogo de productos',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Stack(
        children: [
          // Contenido principal
          Column(
            children: [
              // Contenido con scroll
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppTheme.spacingLg),
                      // Category Filter
                      _buildCategoryFilter(),
                      const SizedBox(height: AppTheme.spacingLg),
                      // Search & Info Bar
                      _buildSearchInfoBar(),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return _buildContent(constraints.maxWidth);
                        },
                      ),
                      const SizedBox(height: AppTheme.spacingXxl * 2),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Floating Cart
          if (_cartItemsCount > 0) _buildFloatingCart(),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return CustomFilterChips(
      filters: _categories,
      selectedFilter: _selectedCategory,
      onFilterSelected: (category) {
        setState(() {
          _selectedCategory = category;
        });
      },
      height: 44,
      itemPadding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingXl,
        vertical: AppTheme.spacingSm,
      ),
    );
  }

  Widget _buildContent(double maxWidth) {
    switch (_currentViewMode) {
      case ViewMode.list:
        return _buildListMode();
      case ViewMode.largeIcons:
        return _buildGridMode(maxWidth, crossAxisCount: 2);
      case ViewMode.mediumIcons:
        return _buildGridMode(maxWidth, crossAxisCount: 3);
      case ViewMode.smallIcons:
        return _buildGridMode(maxWidth, crossAxisCount: 4);
    }
  }

  Widget _buildViewModeButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Modo Lista
          _buildViewModeButton(
            icon: FontAwesomeIcons.bars,
            mode: ViewMode.list,
            isSelected: _currentViewMode == ViewMode.list,
          ),
          // Modo Iconos Grandes
          _buildViewModeButton(
            icon: FontAwesomeIcons.tableCellsLarge,
            mode: ViewMode.largeIcons,
            isSelected: _currentViewMode == ViewMode.largeIcons,
          ),
          // Modo Iconos Medianos
          _buildViewModeButton(
            icon: FontAwesomeIcons.tableCells,
            mode: ViewMode.mediumIcons,
            isSelected: _currentViewMode == ViewMode.mediumIcons,
          ),
          // Modo Iconos Pequeños
          _buildViewModeButton(
            icon: FontAwesomeIcons.grip,
            mode: ViewMode.smallIcons,
            isSelected: _currentViewMode == ViewMode.smallIcons,
          ),

          // Separador vertical
          Container(
            width: 1,
            height: 24,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            color: AppTheme.outlineVariant,
          ),

          // Botón de filtrar
          _buildFilterButton(),
        ],
      ),
    );
  }

  Widget _buildFilterButton() {
    return GestureDetector(
      onTap: () {
        _showFilterDialog();
      },
      child: Container(
        width: 36,
        height: 36,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
        ),
        child: Center(
          child: FaIcon(
            FontAwesomeIcons.filter,
            size: 16,
            color: AppTheme.primary,
          ),
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.borderRadiusXl),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(AppTheme.spacingXl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filtrar productos',
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeTitle,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingLg),

                  // Rango de precios
                  Text(
                    'Rango de precio',
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeLabel,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.outlineVariant),
                            borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
                          ),
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: 'Mín',
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingMd),
                      const Text('-'),
                      const SizedBox(width: AppTheme.spacingMd),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.outlineVariant),
                            borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
                          ),
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: 'Máx',
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppTheme.spacingLg),

                  // Stock
                  Text(
                    'Disponibilidad',
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeLabel,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFilterChip('En stock', true),
                      ),
                      const SizedBox(width: AppTheme.spacingMd),
                      Expanded(
                        child: _buildFilterChip('Stock bajo', false),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppTheme.spacingXl),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.onSurfaceVariant,
                            side: BorderSide(color: AppTheme.outlineVariant),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
                            ),
                          ),
                          child: const Text('Limpiar'),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingMd),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Aplicar filtros
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
                            ),
                          ),
                          child: const Text('Aplicar'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        // Lógica para seleccionar/deseleccionar
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMd,
          vertical: AppTheme.spacingSm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryContainer : AppTheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
          border: isSelected ? null : Border.all(color: AppTheme.outlineVariant),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: AppTheme.fontSizeSmall,
              fontWeight: FontWeight.w600,
              color: isSelected ? AppTheme.onPrimaryContainer : AppTheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildViewModeButton({
    required FaIconData icon,
    required ViewMode mode,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentViewMode = mode;
        });
      },
      child: Container(
        width: 36,
        height: 36,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
        ),
        child: Center(
          child: FaIcon(
            icon,
            size: 16,
            color: isSelected ? Colors.white : AppTheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchInfoBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Cantidad de artículos (izquierda)
        Text(
          '${_filteredProducts.length} Artículos',
          style: TextStyle(
            fontSize: AppTheme.fontSizeLabel,
            fontWeight: FontWeight.w500,
            color: AppTheme.onSurfaceVariant,
          ),
        ),

        // Botones de cambio de vista + filtro (derecha)
        _buildViewModeButtons(),
      ],
    );
  }

  Widget _buildListMode() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredProducts.length, // ← Cambiado
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
          child: _buildListCard(_filteredProducts[index]), // ← Cambiado
        );
      },
    );
  }

  Widget _buildListCard(Product product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
        border: Border.all(color: AppTheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Imagen
          ClipRRect(
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(AppTheme.borderRadiusLg),
            ),
            child: Image.network(
              product.imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 100,
                  height: 100,
                  color: AppTheme.surfaceContainer,
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.image,
                      size: 32,
                      color: AppTheme.outline,
                    ),
                  ),
                );
              },
            ),
          ),
          // Información
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.id,
                              style: TextStyle(
                                fontSize: AppTheme.fontSizeSmall,
                                color: AppTheme.outline,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              product.name,
                              style: TextStyle(
                                fontSize: AppTheme.fontSizeLabel,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: AppTheme.fontSizeLabel,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingXs),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingSm,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(
                            AppTheme.borderRadiusSm,
                          ),
                        ),
                        child: Text(
                          product.category,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'Stock: ${product.stock}',
                            style: TextStyle(
                              fontSize: AppTheme.fontSizeSmall,
                              fontWeight: FontWeight.w600,
                              color: product.stockStatus == StockStatus.inStock
                                  ? AppTheme.secondary
                                  : AppTheme.error,
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingMd),
                          // En tu widget de inventario, dentro del Card del producto:
                          IconButton(
                            icon: const FaIcon(
                              FontAwesomeIcons.penToSquare,
                              size: 20,
                              color: AppTheme.primary,
                            ),
                            onPressed: () {

                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridMode(
      double maxWidth, {
        required int crossAxisCount,
      }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppTheme.spacingMd,
        mainAxisSpacing: AppTheme.spacingMd,
        childAspectRatio: (maxWidth / crossAxisCount - AppTheme.spacingLg) / 334,
      ),
      itemCount: _filteredProducts.length, // ← Cambiado
      itemBuilder: (context, index) {
        return _buildProductCard(_filteredProducts[index]); // ← Cambiado
      },
    );
  }

  Widget _buildProductCard(Product product) {
    return Container(
      height: 440, // Altura fija de 400px
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen - altura reducida
          SizedBox(
            height: 180, // Reducido de 200 a 180
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppTheme.borderRadiusXl),
                  ),
                  child: Image.network(
                    product.imageUrl,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 180,
                        color: AppTheme.surfaceContainer,
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.image,
                            size: 32,
                            color: AppTheme.outline,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Badge de stock
                Positioned(
                  top: AppTheme.spacingSm,
                  right: AppTheme.spacingSm,
                  child: _buildStockBadge(product),
                ),
              ],
            ),
          ),
          // Información del producto
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Contenido superior
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.id,
                                  style: TextStyle(
                                    fontSize: AppTheme.fontSizeSmall,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.outline,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  product.name,
                                  style: TextStyle(
                                    fontSize: AppTheme.fontSizeLabel,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.onSurface,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: AppTheme.fontSizeLabel,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingSm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingSm,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(
                            AppTheme.borderRadiusSm,
                          ),
                        ),
                        child: Text(
                          product.category,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingMd),
                      const Divider(color: AppTheme.outlineVariant),
                      //const SizedBox(height: AppTheme.spacingXs),
                    ],
                  ),
                  // Stock y edición - parte inferior
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Stock Actual',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppTheme.outline,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${product.stock} ${product.stock == 1 ? 'unidad' : 'unidades'}',
                            style: TextStyle(
                              fontSize: AppTheme.fontSizeSmall,
                              fontWeight: FontWeight.w700,
                              color: product.stockStatus == StockStatus.inStock
                                  ? AppTheme.secondary
                                  : AppTheme.error,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: IconButton(
                          icon: FaIcon(
                            FontAwesomeIcons.pen,
                            size: 14,
                            color: AppTheme.secondary,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {

                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockBadge(Product product) {
    String label;
    Color bgColor;
    Color textColor;
    FaIconData? icon;

    switch (product.stockStatus) {
      case StockStatus.lowStock:
        label = 'Low Stock';
        bgColor = AppTheme.errorContainer;
        textColor = AppTheme.onErrorContainer;
        icon = FontAwesomeIcons.triangleExclamation;
        break;
      case StockStatus.critical:
        label = 'Critical';
        bgColor = AppTheme.errorContainer;
        textColor = AppTheme.error;
        icon = FontAwesomeIcons.circleExclamation;
        break;
      default:
        label = 'In Stock';
        bgColor = AppTheme.secondaryContainer;
        textColor = AppTheme.onSecondaryContainer;
        icon = null;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            FaIcon(icon, size: 10, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingCart() {
    return Positioned(
      bottom: 80,
      left: AppTheme.spacingLg,
      right: AppTheme.spacingLg,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.inverseSurface,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.basketShopping,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingMd),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Items en pedido: $_cartItemsCount',
                        style: TextStyle(
                          fontSize: AppTheme.fontSizeLabel,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.onInverseSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Total est. \$${_cartTotal.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.onInverseSurface.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  // Navegar al carrito
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
                  ),
                ),
                child: const Text('Ver Pedido'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}