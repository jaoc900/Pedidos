import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/screens/new_order_screen.dart';
import 'package:pedidos/screens/modals/confirmation_modal.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'Todas';

  final List<String> _filters = ['Todas', 'Pendientes', 'En Camino', 'Entregadas'];

  final List<Order> _orders = [
    Order(
      id: '#ORD-8829-24',
      customer: 'Jardines del Prado',
      status: 'En Camino',
      statusColor: const Color(0xFF289045),
      statusBgColor: const Color(0xFFE8F5E9),
      date: '14 Oct, 2023',
      items: 12,
      amount: 1240.00,
    ),
    Order(
      id: '#ORD-8712-24',
      customer: 'Vivero San Pedro',
      status: 'Pendiente',
      statusColor: const Color(0xFFFF9800),
      statusBgColor: const Color(0xFFFFF3E0),
      date: '15 Oct, 2023',
      items: 5,
      amount: 450.50,
    ),
    Order(
      id: '#ORD-8699-24',
      customer: 'EcoHogar Paisajismo',
      status: 'Entregada',
      statusColor: const Color(0xFF6B7280),
      statusBgColor: const Color(0xFFF3F4F6),
      date: '12 Oct, 2023',
      items: 28,
      amount: 3890.00,
    ),
  ];

  List<Order> get _filteredOrders {
    return _orders.where((order) {
      final matchesFilter = _selectedFilter == 'Todas' || order.status == _selectedFilter;
      final matchesSearch = _searchQuery.isEmpty ||
          order.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          order.customer.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // Header personalizado (reemplaza el AppBar)
          _buildCustomHeader(),
          // Contenido principal
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título de la sección
                  _buildSectionTitle(),
                  const SizedBox(height: AppTheme.spacingLg),
                  // Barra de búsqueda
                  _buildSearchBar(),
                  const SizedBox(height: AppTheme.spacingLg),
                  // Filtros
                  _buildFilters(),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Lista de órdenes (a lo ancho)
                  _buildOrdersList(),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Banner promocional
                  _buildPromotionalBanner(),
                  const SizedBox(height: AppTheme.spacingXl),
                ],
              ),
            ),
          ),
        ],
      ),
      // Botón flotante para agregar
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewOrderScreen()),
          );
        },
        backgroundColor: AppTheme.loginButtonColor,
        elevation: 4,
        shape: const CircleBorder(),
        heroTag: 'new_order_fab',
        child: const FaIcon(
          FontAwesomeIcons.plus,
          size: 24,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildCustomHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg, vertical: AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.magnifyingGlass,
                  size: 20,
                  color: AppTheme.primary,
                ),
                const SizedBox(width: AppTheme.spacingMd),
                Text(
                  'VerdantOrders',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeTitle,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.loginButtonColor,
                  ),
                ),
              ],
            ),
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.bell,
                  size: 20,
                  color: Colors.grey.shade600,
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle() {
    return Text(
      'Pedidos',
      style: TextStyle(
        fontSize: AppTheme.fontSizeHeadline,
        fontWeight: FontWeight.w700,
        color: AppTheme.loginButtonColor,
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: AppTheme.outlineVariant),
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Buscar por número o cliente...',
          hintStyle: TextStyle(
            color: AppTheme.outline,
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
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingLg,
            vertical: AppTheme.spacingLg,
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: AppTheme.spacingMd),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = filter;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingXl,
                vertical: AppTheme.spacingSm,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primary
                    : AppTheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
              ),
              child: Center(
                child: Text(
                  filter,
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeLabel,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? AppTheme.onPrimary
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

  Widget _buildOrdersList() {
    if (_filteredOrders.isEmpty) {
      return Center(
        child: Column(
          children: [
            const SizedBox(height: AppTheme.spacingXxl),
            FaIcon(
              FontAwesomeIcons.boxOpen,
              size: 64,
              color: AppTheme.outline.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppTheme.spacingLg),
            Text(
              'No se encontraron pedidos',
              style: TextStyle(
                fontSize: AppTheme.fontSizeBody,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        for (var order in _filteredOrders) ...[
          _buildOrderCard(order),
          const SizedBox(height: AppTheme.spacingLg),
        ],
      ],
    );
  }

  Widget _buildOrderCard(Order order) {
    return Container(
      width: double.infinity, // Ocupa todo el ancho disponible
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: AppTheme.surfaceVariant),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: ID y Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.id,
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeSmall,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        color: AppTheme.outline,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.customer,
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeBody,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.onSurface,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingMd,
                    vertical: AppTheme.spacingSm,
                  ),
                  decoration: BoxDecoration(
                    color: order.statusBgColor,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                  ),
                  child: Text(
                    order.status,
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeSmall,
                      fontWeight: FontWeight.w700,
                      color: order.statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingLg),
            // Detalles: Fecha y Items
            Row(
              children: [
                _buildInfoChip(
                  icon: FontAwesomeIcons.calendar,
                  label: order.date,
                ),
                const SizedBox(width: AppTheme.spacingLg),
                _buildInfoChip(
                  icon: FontAwesomeIcons.box,
                  label: '${order.items} items',
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingLg),
            const Divider(color: AppTheme.outlineVariant),
            const SizedBox(height: AppTheme.spacingLg),
            // Footer: Monto y Acciones
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${order.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeTitle,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.loginButtonColor,
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        _cancelOrder(order);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.error,
                        minimumSize: Size.zero,
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('Cancelar'),
                    ),
                    const SizedBox(width: AppTheme.spacingLg),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const NewOrderScreen()),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.primary,
                        minimumSize: Size.zero,
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Row(
                        children: const [
                          Text('Ver detalles'),
                          SizedBox(width: 4),
                          FaIcon(FontAwesomeIcons.chevronRight, size: 14),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required FaIconData icon,
    required String label,
  }) {
    return Row(
      children: [
        FaIcon(
          icon,
          size: 14,
          color: AppTheme.outline,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: AppTheme.fontSizeSmall,
            color: AppTheme.outline,
          ),
        ),
      ],
    );
  }

  Widget _buildPromotionalBanner() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        child: Stack(
          children: [
            // Imagen de fondo
            Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuCsSJadJfo-1tbuNWF0mZEBJDG9bteIrdQEqqNEaWGR-61PD8Pl_YwXTkyGEyzuzH8BwtX-bPx-afXRg8GgUXpo19pBGw0YTrtKhAk9E_53EbdCBPxXuzH6YDOAjwF-Ep4uKsq__MWz-HCVa3jjqIf8HEE9QZJjcDZqct6nLMAAQF3KpkCtvXSQont9e5pWy3jXO0WoXYgawCwJAiUSs-Vt_sCENNuNDNlIpCDCSIMMWHJShUbQsEOCy5dpiOwr3RngNT5MqoVr8DuV',
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 180,
                  color: AppTheme.primaryContainer,
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.tree,
                      size: 64,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
            // Gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Contenido
            Positioned(
              bottom: AppTheme.spacingLg,
              left: AppTheme.spacingLg,
              right: AppTheme.spacingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Impulsa tu negocio',
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeSmall,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Optimiza tu logística de viveros hoy mismo.',
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeBody,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _cancelOrder(Order order) {
    context.showConfirmation(
      title: 'Cancelar Pedido',
      message: '¿Estás seguro de que deseas cancelar el pedido ${order.id}?\n\nEsta acción no se puede deshacer.',
      confirmText: 'Cancelar Pedido',
      cancelText: 'Seguir',
      type: ConfirmationType.warning,
      customIcon: FontAwesomeIcons.circleXmark,
      onConfirm: () {
        // Lógica para cancelar el pedido
        setState(() {
          _orders.remove(order);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pedido ${order.id} cancelado'),
            backgroundColor: AppTheme.error,
          ),
        );
      },
    );
  }
}

// Modelo de datos para pedidos
class Order {
  final String id;
  final String customer;
  final String status;
  final Color statusColor;
  final Color statusBgColor;
  final String date;
  final int items;
  final double amount;

  Order({
    required this.id,
    required this.customer,
    required this.status,
    required this.statusColor,
    required this.statusBgColor,
    required this.date,
    required this.items,
    required this.amount,
  });
}