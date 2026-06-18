import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/screens/edit_product_screen.dart';
import 'package:pedidos/enums/view_model_enum.dart';
import 'package:pedidos/models/product_item_model.dart';
import 'package:pedidos/enums/stock_status_enum.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';
import 'package:pedidos/widgets/custom_chips.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  String _selectedCategory = 'Todos';

  ViewMode _currentViewMode = ViewMode.mediumIcons;
  final List<String> _categories = [
    'Todos',
    'Fertilizantes',
    'Semillas',
    'Herramientas',
  ];

  List<Product> get _filteredProducts {
    if (_selectedCategory == 'Todos') {
      return products;
    }
    return products.where((product) => product.category == _selectedCategory).toList();
  }

  // Lista de productos (la misma de antes)
  final List<Product> products = [
    Product(
      id: 'SHO-0021',
      name: 'UltraBoost Pro X',
      price: 149.99,
      category: 'Calzado',
      stock: 4,
      stockStatus: StockStatus.lowStock,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDqmlHh7LKWdjhfzNvxRbePX66p0ofPsDklPk1jWv7JB2ZI_3bldN46ewYvjufEvd3rg9s9K_sDqxlw6-9NBfpDZ-n5pHEt0XzopQUbBvbsM17o0btLdw6gMX352Dp-Pl6c3pfEsuBVvB3JpRL_XBWy66u3ViaIfhEBEB7PoalusJ6TuOuPmaWGhjlBUDl7d3xUQl-eWwYZl0Ntf2OhfJCoul3b1sDNJgkYsFsiOE6637uqS1u1GIdSkadjCHKCNyJUYU8xnk6RIKwd',
    ),
    Product(
      id: 'WAT-8842',
      name: 'Classic Minimalist',
      price: 210.00,
      category: 'Accesorios',
      stock: 42,
      stockStatus: StockStatus.inStock,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuC_Mcf8RJhjhrC2FuBpInEuF41WSWSOEmGEQ1U_o5Y4ppD64qRnfPeMh8AkyIHR-35FI_gH0zcvo8dyVyepGj5jkkxjnbpTb7IGvTEyVqzeqHk4Eb4Z5_aLwc9YLsws2SvXNxqeTXX9HpRlxlw5ots4NeiAwsjTD-ozmksaHZIA85ZD-WvSAPM54ZlkL50Dcb_gt3V_lHP_HIO0rcMbFUvwM-oYJGCzVQIDBalEr9ge77fc5wWfefb72vNLAATNGpX6WHjcz0cYzbg5',
    ),
    Product(
      id: 'AUD-1190',
      name: 'Elite Sound X1',
      price: 299.00,
      category: 'Electrónica',
      stock: 15,
      stockStatus: StockStatus.inStock,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAr84JXf-DkbN2goXF2c_pvEf_xk1PR98fAQQwTBKbJRk_z2jS94jI6tKCU0AaFTT5VhLBmLxWN1ZODlnS_jyCFil0lev0-WmeMP_47aLO79OAtciChdQ4VSDNjufrNfZwDSPXfwP9ifBug9ju8quF0rBwvh4P5AChcBMJgTLOZCx7j5hHHlpAnNDIvrE0PJUivIpzsJ3_IZC7VXj1-odXozjltLXsa6gVaewlFRci-q3i4scTrxQI5K1N4KuQwS81eYCDTOJsVQZsD',
    ),
    Product(
      id: 'HOM-4421',
      name: 'Eco Flask 500ml',
      price: 35.00,
      category: 'Hogar',
      stock: 1,
      stockStatus: StockStatus.critical,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCNu7GxmS8o-8z1yly4d5xF1ECk7-dq3axGOXSftpsLL38adnVNV-P7EdKR1iVTduU0T04w1iB7B66JlI_xxjhrbXRfVKaqmYDLQBbOVqIrmx74GG8dWC3BLHUdXvuyE8jUME1ktPpuKYlmTrilnSTc6xzGicoR3GFdJoLmkOStxkD8fj_pUQupJaZryyr3eVonO8FhiFYh-eaCRQg6u6fyWpyNfbxuWLdxesk0bjZay-_xrcCYStMOtsbdyipaUCtwujssruOhxXBe',
    ),
    Product(
      id: 'FUR-9902',
      name: 'Aero Chair v2',
      price: 450.00,
      category: 'Muebles',
      stock: 8,
      stockStatus: StockStatus.inStock,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBp8eCTQhRBL6AsodvBFOqfA9p-gQ6g_VUPqMQq9M81mEZV2fvjZuM3Xy1clmeRPCR5hYxswlSkdZtsS2L1n59B3yZOUvcFo8ffBofopRrtkR2Mp8jJHjxETbVtkATqGApiEL3cOgdel1w6_pP9R6bjPZB16x6hY-QEmB23PkhfKQczE_RoY1LdkJQBSA0UtSKnmQ4W3UW2Bxxq-Py5UM1IQobx3mEqH8NGqdjF_9CuirsLfSVYw_X7n8Girn5MUKeQX1IVkqOWuFNa',
    ),
    Product(
      id: 'HOM-1102',
      name: 'Soft Knit Blanket',
      price: 79.99,
      category: 'Hogar',
      stock: 24,
      stockStatus: StockStatus.inStock,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCULMJVSWKONsnOp09DYyNbVBPQaczkNJT0d3o_WgrIn1_qhzzamYWv1G4CjZaRnqbE4ppdlYqPSqMOfUaNUeoik1wEGVUIRVbRi_ztxBq75n3Rrd8VJafzr5Nit24IyWmH6EWhVklAo97z4nvQjF-PrrPaM9LcFA2GM3saQk8ihL2iQ03I6EIS7Ucm5yi6BL7AHlVWUXr7EmMdR9O2JlM7-8OkLquwAlLUNa5mRZHTnkBVeOHAR98YpEW1eIXjLy3HqrlcGVb-K7gM',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingXl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategoryFilter(),
                  const SizedBox(height: AppTheme.spacingSm),
                  _buildSearchInfoBar(),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return _buildContent(constraints.maxWidth);
                    },
                  ),
                  const SizedBox(height: AppTheme.spacingXl),
                  _buildPagination(),
                  const SizedBox(height: AppTheme.spacingXl * 2),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditProductScreen()),
          );
        },
        backgroundColor: AppTheme.primaryContainer,
        elevation: 4,
        heroTag: 'inventory_fab',
        shape: const CircleBorder(),
        child: const FaIcon(
          FontAwesomeIcons.cartPlus,
          size: 24,
          color: AppTheme.onPrimaryContainer,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
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

  Widget _buildContent(double maxWidth) {
    switch (_currentViewMode) {
      case ViewMode.list:
        return _buildListMode();
      case ViewMode.largeIcons:
        return _buildGridMode(maxWidth, crossAxisCount: 2, imageHeight: 180);
      case ViewMode.mediumIcons:
        return _buildGridMode(maxWidth, crossAxisCount: 3, imageHeight: 140);
      case ViewMode.smallIcons:
        return _buildGridMode(maxWidth, crossAxisCount: 4, imageHeight: 120);
    }
  }

  Widget _buildListMode() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
          child: _buildListCard(products[index]),
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
                          color: AppTheme.surfaceVariant,
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditProductScreen(),
                                ),
                              );
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
    required double imageHeight,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppTheme.spacingMd,
        mainAxisSpacing: AppTheme.spacingMd,
        childAspectRatio:
            (maxWidth / crossAxisCount - AppTheme.spacingLg) / 334,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return _buildProductCard(products[index]);
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
                          color: AppTheme.surfaceVariant,
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditProductScreen(),
                              ),
                            );
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

  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.outlineVariant),
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
          ),
          child: IconButton(
            icon: FaIcon(
              FontAwesomeIcons.chevronLeft,
              size: 16,
              color: AppTheme.onSurfaceVariant,
            ),
            onPressed: () {},
          ),
        ),
        const SizedBox(width: AppTheme.spacingLg),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.primary,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
          ),
          child: const Center(
            child: Text(
              '1',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppTheme.spacingSm),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.outlineVariant),
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
          ),
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            child: const Text('2'),
          ),
        ),
        const SizedBox(width: AppTheme.spacingSm),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.outlineVariant),
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
          ),
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            child: const Text('3'),
          ),
        ),
        const SizedBox(width: AppTheme.spacingLg),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.outlineVariant),
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
          ),
          child: IconButton(
            icon: FaIcon(
              FontAwesomeIcons.chevronRight,
              size: 16,
              color: AppTheme.onSurfaceVariant,
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}