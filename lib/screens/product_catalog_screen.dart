import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/enums/stock_status_enum.dart';
import 'package:pedidos/models/product_item_model.dart';

class ProductCatalogScreen extends StatefulWidget {
  const ProductCatalogScreen({super.key});

  @override
  State<ProductCatalogScreen> createState() => _ProductCatalogScreenState();
}

class _ProductCatalogScreenState extends State<ProductCatalogScreen> {
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
      body: Stack(
        children: [
          // Contenido principal
          Column(
            children: [
              // TopAppBar
              _buildTopAppBar(),
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
                      const SizedBox(height: AppTheme.spacingLg),
                      // Product Grid - CORREGIDO: Usar LayoutBuilder para ancho
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: AppTheme.spacingLg,
                              mainAxisSpacing: AppTheme.spacingLg,
                              childAspectRatio: 0.75,
                              // Forzar un ancho máximo
                            ),
                            itemCount: _filteredProducts.length,
                            itemBuilder: (context, index) {
                              final product = _filteredProducts[index];
                              return SizedBox(
                                width: constraints.maxWidth / 2 - AppTheme.spacingLg,
                                child: _buildProductCard(product),
                              );
                            },
                          );
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

  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXl, vertical: AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.background,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Avatar
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.arrowLeft,
                        size: 20,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingLg),
                Text(
                  'Catálogo de productos',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeTitle,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.loginButtonColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
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
                    ? AppTheme.primaryContainer
                    : AppTheme.secondaryContainer.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                border: isSelected
                    ? null
                    : Border.all(color: AppTheme.secondaryContainer.withValues(alpha: 0.3)),
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeLabel,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? AppTheme.onPrimaryContainer
                        : AppTheme.onSecondaryContainer,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchInfoBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${_filteredProducts.length} Artículos encontrados',
          style: TextStyle(
            fontSize: AppTheme.fontSizeLabel,
            fontWeight: FontWeight.w500,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              FaIcon(
                FontAwesomeIcons.filter,
                size: 14,
                color: AppTheme.primary,
              ),
              const SizedBox(width: AppTheme.spacingSm),
              Text(
                'Filtrar',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeLabel,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        // Aquí iría la navegación a detalles del producto
      },
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppTheme.borderRadiusXl),
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppTheme.surfaceContainer,
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.image,
                          size: 32,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  const SizedBox(height: AppTheme.spacingSm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: AppTheme.fontSizeTitle,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.onPrimaryFixedVariant,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Stock: ${product.stock} ${product.stockStatus == StockStatus.inStock ? 'kg' : 'unid'}',
                            style: TextStyle(
                              fontSize: AppTheme.fontSizeSmall,
                              fontWeight: FontWeight.w500,
                              color: product.stockStatus == StockStatus.lowStock
                                  ? AppTheme.error
                                  : AppTheme.secondary,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => _addToCart(product),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppTheme.loginButtonColor,
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
                ],
              ),
            ),
          ],
        ),
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

  Widget _buildNavItem({
    required FaIconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              icon,
              size: 22,
              color: isSelected ? AppTheme.loginButtonColor : Colors.grey.shade500,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppTheme.loginButtonColor : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}