import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';
import 'package:pedidos/widgets/custom_text_field.dart';
import 'package:pedidos/widgets/custom_chips.dart';
import 'package:pedidos/screens/pos_checkout_screen.dart';
import 'package:pedidos/screens/modals/confirmation_modal.dart';
import 'package:pedidos/screens/pos_quick_scanner_screen.dart';

class PointOfSaleScreen extends StatefulWidget {
  const PointOfSaleScreen({super.key});

  @override
  State<PointOfSaleScreen> createState() => _PointOfSaleScreenState();
}

class _PointOfSaleScreenState extends State<PointOfSaleScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All Items';
  int _cartItemCount = 0;
  double _cartTotal = 0.0;

  final List<String> _categories = [
    'All Items',
    'Fertilizers',
    'Seeds',
    'Tools',
    'Irrigation',
    'Pest Control',
  ];

  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Pro-Grow Organic Nitr...',
      description: '25kg Bag',
      price: 45.99,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCxowoAAgvnKEOe727Pmwf5Y_T7NvzJayilmPMgrsK6QN3BKY8lhs_1dC9waf5dnHdlBnymykwRyNSaptQMyGf3bE8F7l83W2So0asMefyvpDWDoiV2tHzh9QStBHPoNa3cbziOQufcmpnafV_NKrJTgLx6N_bL2O70CFpbBIQTjEWGz5-Z3lhwCrmiOsGXX3AgDb8wEEPtvzuIvjlLHWfa8stVpppyTZmgJaL9YRzoKfQxoH1-I53pywIypnFNxWdXRaK1fF3r7GpG',
      stockStatus: StockStatus.inStock,
      isOnSale: false,
    ),
    Product(
      id: '2',
      name: 'Premium Steel Trowel',
      description: 'Ash Wood Handle',
      price: 24.50,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAQ2dPTLLCD-tBKaKHvloYvGmwfnIwrsD0xQyEzJwIhKuklgh4ojEVzJyp9taFR4DRjHfuRB6oUI5ibO-ALa0V12azpjp6irVbIxvHFuFh0wuQ2gd3j1Iv_AkywSxRKvcNVNMRqN5rFuABLzYu7vXDfw_IV3hhWw54PJkNLsEiigLgN95JjUyVmti4gF05SGll1Q3W0s5wOgrZ8mEm0RyNTMS7Q0_bXewss5AMn-gxGKV6xSeSiLkzY9p4Opafqt4SmTgQOmyb_cWtr',
      stockStatus: StockStatus.inStock,
      isOnSale: false,
    ),
    Product(
      id: '3',
      name: 'Heirloom Tomato Mix',
      description: '50 Count Packet',
      price: 12.99,
      originalPrice: 14.43,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCUjHMg3GOqwbKkX4JrEAt7EQXCsxGWnhYoQejpQ_priZ0D9GYzQnk6G2G9f6z0QD9NJmfY6JEh7aNEjFlzdn4WjHeKT0yQpPi5djHaQaCN8ZPrEHVITrsuBnYupZuoh98M-CneahXchPiJZPbfuEKkc5mwv8fqiEjJEP9_YkBeSIG4i9xcznAEil4VTBqvJgJ_V8jTdT-QCamFlR1NkuovK6qEmb8d6cd16puUn-AXlJSqeH8OAkbxBRFGUTV9rJ3P2od7MqEnrRNj',
      stockStatus: StockStatus.inStock,
      isOnSale: true,
    ),
    Product(
      id: '4',
      name: 'Smart Water Timer',
      description: 'WiFi Enabled',
      price: 89.00,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuABdCGQ3QgppfB3-gnrChraXslciXb5ipJ6mfGNimlmLJe0yvccOZmTTmDszWr55XKj68FcZWf3xuGgwNMpUWl6WIPLjjG7V8mwFFxTXni3j0bbyXtSXqDTw3BlmnEa68V7eHXukKoE7k4eleL8VhSsY2BEG-VyqT2QQ7bV4skJIZlSWiAJFnNjK00XxKfPwgoZ-RJJHK3KHcWdmaXNQhaWMesnSHEIyBL2hBO-gsD8dfDjw9gbt6Kd-QWF7wAY1EeOGVvusEPMnekK',
      stockStatus: StockStatus.lowStock,
      isOnSale: false,
    ),
    Product(
      id: '5',
      name: 'Modern Metal Can',
      description: '5L Forest Green',
      price: 32.00,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDiovJj3BOt-MrwAp7G1s6nUKL_0-folpZs921wAbvDXGpu5Hwb36HlBDLt40GF9LqhhMXzSjonAYBzh8K2Z4VbyuYA_7ZtoFyQRwQKUcl2QCSlHw4gT5Zg2yKdJWQ5jnTcH8RlfXK-LCH3jFwv9zWOMM3krrF3TDkeaiGro7Wfnu-8ZpuI5LWA0yY2t98KWMqeqV9-qvn0y2lZYywi2RG2UouvC3a0zifAJ5VXHScEGJ2tkWzG0w1PdtVxWyMwlaQFqkfu2ZwVfYkL',
      stockStatus: StockStatus.inStock,
      isOnSale: false,
    ),
    Product(
      id: '6',
      name: 'Heavy-Duty Gloves',
      description: 'Puncture Resistant',
      price: 18.75,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBWC4Qr8lkIMobzE-FWsuxjhRfakOddFMK2CLQf4NSrE7YTY2-4LXuwPjP4tGSXCStk9kn6Y5Xjyz42Lmhx_jRssZaTA6sRPLkNGHuHwMxxFPVWMjJMC5iaAqjSycyVdkqsS35X-riIinULLI9m7navgpaImrQvSAZ4x6J2kdD9vzjOZKyI90I9TIKqdy9y6XSzslBt1KBzbySDl_JpbbxjAsP5zsdwCNBI2u9r3nuW0BaQs3oeDwLmaaYrGqA94MxA30sps0n4TLqy',
      stockStatus: StockStatus.inStock,
      isOnSale: false,
    ),
  ];

  List<Product> get _filteredProducts {
    var filtered = _products;

    if (_selectedCategory != 'All Items') {
      // Simulación de filtro por categoría
      filtered = filtered.where((product) =>
      product.category == _selectedCategory
      ).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((product) =>
          product.name.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    return filtered;
  }

  void _checkout() {
    context.showConfirmation(
      title: 'Proceder al pago',
      message: 'Total: \$${_cartTotal.toStringAsFixed(2)} con $_cartItemCount items',
      confirmText: 'Confirmar',
      cancelText: 'Cancelar',
      type: ConfirmationType.info,
      customIcon: FontAwesomeIcons.cartShopping,
      onConfirm: () {
        // Cerrar el modal y navegar al checkout
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CheckoutScreen(),
          ),
        );
      },
      onCancel: () {
        // Solo cerrar el modal (ya lo maneja el modal automáticamente)
      },
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
            child: Stack(
              children: [
                Column(
                  children: [
                    _buildSearchAndFilterSection(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(AppTheme.spacingLg),
                        child: _buildProductGrid(),
                      ),
                    ),
                  ],
                ),
                if (_cartItemCount > 0) _buildFloatingCart(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopAppBar(BuildContext context) {
    return CustomTopAppBar(
      title: 'Verdant POS',
      showBackButton: false,
      actions: [
        AppBarButton(
          icon: FontAwesomeIcons.barcode,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const QuickScannerScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSearchAndFilterSection() {
    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.fromLTRB(AppTheme.spacingLg, AppTheme.spacingLg, AppTheme.spacingLg, 0),
      child: Column(
        children: [
          // Search Bar
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _searchController,
                  label: '',
                  hint: 'Buscar productos o escanear productos...',
                  icon: FontAwesomeIcons.magnifyingGlass,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  borderRadius: AppTheme.borderRadiusXXl,
                  showLabel: false,
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                    icon: FaIcon(FontAwesomeIcons.times, size: 16, color: AppTheme.outline),
                    onPressed: () {
                      setState(() {
                        _searchQuery = '';
                        _searchController.clear();
                      });
                    },
                  )
                      : null,
                ),
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
                ),
                child: IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.barcode,
                    size: 20,
                    color: AppTheme.primary,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),
          // Category Chips
          CustomFilterChips(
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
            borderRadius: AppTheme.borderRadiusFull,
            selectedColor: AppTheme.primary,
            unselectedColor: AppTheme.surfaceContainerHighest,
            selectedTextColor: AppTheme.onPrimary,
            unselectedTextColor: AppTheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppTheme.spacingMd),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    if (_filteredProducts.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Column(
          children: [
            FaIcon(
              FontAwesomeIcons.boxOpen,
              size: 64,
              color: AppTheme.outline.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppTheme.spacingLg),
            Text(
              'No products found',
              style: TextStyle(
                fontSize: AppTheme.fontSizeBody,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppTheme.spacingMd,
        mainAxisSpacing: AppTheme.spacingMd,
        childAspectRatio: 0.75,
      ),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () => _addToCart(product),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
          border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3)),
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
            // Product Image
            Stack(
              children: [
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
                          color: AppTheme.surfaceContainerHigh,
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
                ),
                if (product.isOnSale)
                  Positioned(
                    top: AppTheme.spacingSm,
                    left: AppTheme.spacingSm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingSm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.errorContainer,
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMd),
                      ),
                      child: Text(
                        'Sale -10%',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ),
                if (product.stockStatus == StockStatus.inStock)
                  Positioned(
                    top: AppTheme.spacingSm,
                    left: AppTheme.spacingSm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingSm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.tertiaryFixed,
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMd),
                      ),
                      child: Text(
                        'In Stock',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.onTertiaryFixed,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // Product Info
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
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
                  const SizedBox(height: 2),
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeSmall,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingSm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.primary,
                            ),
                          ),
                          if (product.originalPrice != null)
                            Text(
                              '\$${product.originalPrice!.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 10,
                                decoration: TextDecoration.lineThrough,
                                color: AppTheme.outline,
                              ),
                            ),
                        ],
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryContainer,
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
                        ),
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.plus,
                            size: 20,
                            color: AppTheme.onPrimaryContainer,
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
      bottom: 10, // Aumentado de 20 a 80 para dejar espacio
      left: AppTheme.spacingLg,
      right: AppTheme.spacingLg,
      child: Container(
        height: 64,
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
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXl),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
                        ),
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.shoppingCart,
                            size: 16,
                            color: AppTheme.onPrimary,
                          ),
                        ),
                      ),
                      Positioned(
                        top: -6,
                        right: -6,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            color: AppTheme.tertiary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '$_cartItemCount',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.onTertiary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: AppTheme.spacingMd),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Current Order',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.onInverseSurface.withValues(alpha: 0.8),
                        ),
                      ),
                      Text(
                        '\$${_cartTotal.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.onInverseSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: _checkout,
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXl),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
                  ),
                  child: const Row(
                    children: [
                      Text(
                        'Checkout',
                        style: TextStyle(
                          fontSize: AppTheme.fontSizeLabel,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.onPrimary,
                        ),
                      ),
                      SizedBox(width: AppTheme.spacingSm),
                      FaIcon(
                        FontAwesomeIcons.arrowRight,
                        size: 16,
                        color: AppTheme.onPrimary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCustomSnackBar(String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 180, // Justo arriba del floating cart (80 + 64 + 16)
        left: AppTheme.spacingLg,
        right: AppTheme.spacingLg,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg, vertical: AppTheme.spacingMd),
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: AppTheme.spacingSm),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 1), () {
      overlayEntry.remove();
    });
  }

  void _addToCart(Product product) {
    setState(() {
      _cartItemCount++;
      _cartTotal += product.price;
    });

    _showCustomSnackBar('${product.name} agregado al carrito');
  }
}

// Modelos
enum StockStatus { inStock, lowStock, critical }

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final StockStatus stockStatus;
  final bool isOnSale;
  final String? category;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    required this.stockStatus,
    this.isOnSale = false,
    this.category,
  });
}