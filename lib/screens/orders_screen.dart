import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/screens/new_order_screen.dart';
import 'package:pedidos/screens/modals/confirmation_modal.dart';
import 'package:pedidos/models/order_data_model.dart';
import 'package:pedidos/widgets/custom_text_field.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';
import 'package:pedidos/widgets/custom_chips.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'Todas';

  final List<String> _filters = ['Todas', 'Pendientes', 'En Camino', 'Entregadas'];

  final List<OrderData> _orders = [
    OrderData.fromSimple(
      id: '#ORD-9921',
      date: 'Oct 24, 2023',
      amount: 1240.50,
      status: 'Pending',
      statusColor: const Color(0xFFFF9800),
      statusBgColor: const Color(0xFFFFF3E0),
    ),
    OrderData.fromSimple(
      id: '#ORD-9845',
      date: 'Oct 18, 2023',
      amount: 450.00,
      status: 'Delivered',
      statusColor: AppTheme.loginButtonColor,
      statusBgColor: const Color(0xFFE8F5E9),
    ),
    OrderData.fromSimple(
      id: '#ORD-9812',
      date: 'Oct 12, 2023',
      amount: 2890.75,
      status: 'In Transit',
      statusColor: const Color(0xFF2196F3),
      statusBgColor: const Color(0xFFE3F2FD),
    ),
    OrderData.fromSimple(
      id: '#ORD-9777',
      date: 'Sep 28, 2023',
      amount: 89.90,
      status: 'Delivered',
      statusColor: AppTheme.loginButtonColor,
      statusBgColor: const Color(0xFFE8F5E9),
    ),
  ];

  List<OrderData> get _filteredOrders {
    return _orders.where((order) {
      final matchesFilter = _selectedFilter == 'Todas' || order.status == _selectedFilter;
      final matchesSearch = _searchQuery.isEmpty ||
          order.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          order.client.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // Contenido principal
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
    return CustomTopAppBar(
      title: 'Órdenes',
      showBackButton: false,
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
      const FilterChipData(label: 'Cancelados', value: 'cancelados', icon: FontAwesomeIcons.xmark),
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

  Widget _buildOrderCard(OrderData order) {
    return Container(
      width: double.infinity, // Ocupa todo el ancho disponible
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: AppTheme.surfaceContainerHighest),
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
                      order.client,
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

  void _cancelOrder(OrderData order) {
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