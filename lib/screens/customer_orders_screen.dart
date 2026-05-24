import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';

class CustomerOrdersScreen extends StatelessWidget {
  const CustomerOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: Column(
        children: [
          // TopAppBar
          _buildTopAppBar(context),
          // Contenido principal - Ocupa todo el espacio disponible
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Column(
                children: [
                  // Customer Profile Summary
                  _buildCustomerProfile(),
                  const SizedBox(height: AppTheme.spacingLg),
                  // Stats Bento Grid
                  _buildStatsGrid(),
                  const SizedBox(height: AppTheme.spacingLg),
                  // Order List - Ocupa todo el ancho
                  _buildOrderList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg, vertical: AppTheme.spacingLg),
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
                // Botón de regresar
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
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
                  'Customer Orders',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeTitle,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
            // Botón de búsqueda
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.magnifyingGlass,
                  size: 20,
                  color: AppTheme.primary,
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerProfile() {
    return Container(
      width: double.infinity, // Ocupa todo el ancho
      padding: const EdgeInsets.all(AppTheme.spacingLg),
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
      child: Row(
        children: [
          // Avatar
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2), width: 2),
            ),
            child: ClipOval(
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuDa5iAkepwQrbHPRO8n58C0qFgnnGjzhB1mxuySZ_NgHfsAUOrQwfpDrrB5u3sB5WnU3GASWOpKQFO5Ue_sRlVv03NXjkuSivY86nX_l16PUZCQtC_PbhyfFnAl1evCJrtDb_5ogIhxI5BCPffWFmqjism-YfKbATWx4wvrwYAEk-lVMEtbwnQZFotVWtbjb-FkfJwpoQaG16g7cXdkGXAfcq9Zyjg1bHWbbgx0t7-bCs9E4eSLqECs-rshhAqlqdhnEbcl7piYMAxm',
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppTheme.primaryContainer,
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.user,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingLg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jonathan Miller',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeTitle,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Acme Corp • Premium Client',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeBody,
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

  Widget _buildStatsGrid() {
    return Row(
      children: [
        // Total Spent
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
              border: Border.all(color: AppTheme.primaryContainer.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TOTAL SPENT',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeSmall,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$12,450.00',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeTitle,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppTheme.spacingMd),
        // Active Orders
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            decoration: BoxDecoration(
              color: AppTheme.secondary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
              border: Border.all(color: AppTheme.secondaryContainer.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ACTIVE ORDERS',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeSmall,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: AppTheme.secondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '03',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeTitle,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderList() {
    final orders = [
      OrderData(
        id: '#ORD-9921',
        date: 'Oct 24, 2023',
        amount: 1240.50,
        status: 'Pending',
        statusColor: const Color(0xFFFF9800),
        statusBgColor: const Color(0xFFFFF3E0),
      ),
      OrderData(
        id: '#ORD-9845',
        date: 'Oct 18, 2023',
        amount: 450.00,
        status: 'Delivered',
        statusColor: AppTheme.loginButtonColor,
        statusBgColor: const Color(0xFFE8F5E9),
      ),
      OrderData(
        id: '#ORD-9812',
        date: 'Oct 12, 2023',
        amount: 2890.75,
        status: 'In Transit',
        statusColor: const Color(0xFF2196F3),
        statusBgColor: const Color(0xFFE3F2FD),
      ),
      OrderData(
        id: '#ORD-9777',
        date: 'Sep 28, 2023',
        amount: 89.90,
        status: 'Delivered',
        statusColor: AppTheme.loginButtonColor,
        statusBgColor: const Color(0xFFE8F5E9),
      ),
    ];

    return Column(
      children: [
        for (var order in orders) ...[
          _buildOrderCard(order),
          const SizedBox(height: AppTheme.spacingLg),
        ],
      ],
    );
  }

  Widget _buildOrderCard(OrderData order) {
    return Container(
      width: double.infinity, // Ocupa todo el ancho disponible
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.2)),
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
          // Header: Order ID y Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order ID',
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeLabel,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.id,
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeTitle,
                      fontWeight: FontWeight.w600,
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
          const Divider(color: AppTheme.outlineVariant),
          const SizedBox(height: AppTheme.spacingLg),
          // Footer: Fecha y Monto
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.calendar,
                    size: 14,
                    color: AppTheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppTheme.spacingSm),
                  Text(
                    order.date,
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeBody,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Text(
                '\$${order.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeBody,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Modelo de datos para órdenes
class OrderData {
  final String id;
  final String date;
  final double amount;
  final String status;
  final Color statusColor;
  final Color statusBgColor;

  OrderData({
    required this.id,
    required this.date,
    required this.amount,
    required this.status,
    required this.statusColor,
    required this.statusBgColor,
  });
}