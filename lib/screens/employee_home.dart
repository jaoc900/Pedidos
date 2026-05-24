import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/enums/user_role_enum.dart';
import 'package:pedidos/screens/notifications_screen.dart';
import 'package:pedidos/screens/orders_screen.dart';
import 'package:pedidos/screens/customers_screen.dart';
import 'package:pedidos/screens/payments_management_screen.dart';
import 'package:pedidos/screens/inventory_screen.dart';
import 'package:pedidos/screens/deliveries_screen.dart';
import 'package:pedidos/screens/invoices_screen.dart';
import 'package:pedidos/screens/profile_screen.dart';

import 'package:pedidos/models/order_data_model.dart';
import 'package:pedidos/models/navItem_model.dart';
import 'package:pedidos/models/payment_data_model.dart';
import 'package:pedidos/models/inventory_alert_model.dart';

class EmployeeHome extends StatefulWidget {
  const EmployeeHome({super.key});

  @override
  State<EmployeeHome> createState() => _EmployeeHomeState();
}

class _EmployeeHomeState extends State<EmployeeHome> {
  // TODO: Obtener el rol del usuario logueado desde el sistema de autenticación
  UserRole _currentUserRole = UserRole.driver;
  int _currentIndex = 0;

  // Pantallas principales según rol
  late List<Widget> _screens;

  // Datos de ejemplo para el dashboard
  final Map<String, dynamic> _userData = {
    'name': 'Alejandro',
    'avatar': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCM7u9-vwKpMXZJUw_Aod3sFx-7w3XNwXcHt_kkTqJJ1W38_2aX9PXoPcg8H06f5-ncpCwFQaYjh2RRarnHpnE5Oe7UieKAwNVHYrHSwtMosSyMmlh-t8SeHekzmBOuaj_A1H_dQoDPKs0J-qzx87UuwkJKp9fHacRpP6Au0tztdxpz4oz7uU_uJMuLnUtFrDRF5kKhOGiqLSsPupf-jskp_jXTGD2xQ-FSlpG4j7lonOmNdrRD9bwt_aBXmpIA5vX7qVwKc5L1G7DX',
  };

  @override
  void initState() {
    super.initState();
    _updateScreensByRole();
  }

  void _updateScreensByRole() {
    switch (_currentUserRole) {
      case UserRole.admin:
        _screens = [
          _buildDashboardContent(), // Dashboard
          const OrdersScreen(),      // Órdenes
          const CustomersScreen(),   // Clientes
          const PaymentsManagementScreen(), // Pagos
          const ProfileScreen(),      // Perfil
        ];
        break;
      case UserRole.seller:
        _screens = [
          _buildDashboardContent(),
          const OrdersScreen(),
          const CustomersScreen(),
          const ProfileScreen(),
        ];
        break;
      case UserRole.warehouse:
        _screens = [
          _buildDashboardContent(),
          const InventoryScreen(),
          const OrdersScreen(),
          const ProfileScreen(),
        ];
        break;
      case UserRole.driver:
        _screens = [
          _buildDashboardContent(),
          const DeliveriesScreen(),
          const OrdersScreen(),
          const ProfileScreen(),
        ];
        break;
      case UserRole.accountant:
        _screens = [
          _buildDashboardContent(),
          const PaymentsManagementScreen(),
          const InvoicesScreen(),
          const ProfileScreen(),
        ];
        break;
    }
  }

  void _onNavItemTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNavBar(),
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
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.primary,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      _userData['avatar'],
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppTheme.surfaceContainerHigh,
                          child: const Center(
                            child: FaIcon(
                              FontAwesomeIcons.user,
                              size: 20,
                              color: AppTheme.primary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingLg),
                Text(
                  'Employee Portal',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeTitle,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.loginButtonColor,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                );
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: FaIcon(
                    FontAwesomeIcons.bell,
                    size: 20,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hola, ${_userData['name']}',
          style: TextStyle(
            fontSize: AppTheme.fontSizeHeadline,
            fontWeight: FontWeight.w700,
            color: AppTheme.onSurface,
          ),
        ),
        const SizedBox(height: AppTheme.spacingSm),
        Text(
          'Aquí tienes el resumen de tu actividad para hoy.',
          style: TextStyle(
            fontSize: AppTheme.fontSizeBody,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTopAppBar(),
          _buildWelcomeSection(),
          const SizedBox(height: AppTheme.spacingXl),
          _buildDashboardByRole(),
        ],
      ),
    );
  }

  Widget _buildDashboardByRole() {
    switch (_currentUserRole) {
      case UserRole.admin:
        return _buildAdminDashboard();
      case UserRole.seller:
        return _buildSellerDashboard();
      case UserRole.warehouse:
        return _buildWarehouseDashboard();
      case UserRole.driver:
        return _buildDriverDashboard();
      case UserRole.accountant:
        return _buildAccountantDashboard();
    }
  }

  // ========== DASHBOARD POR ROL ==========

  Widget _buildAdminDashboard() {
    return Column(
      children: [
        _buildSummaryCard(
          title: 'Órdenes Activas',
          value: '24',
          icon: FontAwesomeIcons.clipboardList,
          iconColor: AppTheme.primary,
        ),
        const SizedBox(height: AppTheme.spacingLg),
        _buildPriorityTaskCard(),
        const SizedBox(height: AppTheme.spacingLg),
        _buildRecentOrdersList(),
        const SizedBox(height: AppTheme.spacingLg),
        _buildMetricsGrid(),
      ],
    );
  }

  Widget _buildSellerDashboard() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                title: 'Ventas Hoy',
                value: '\$8,450',
                icon: FontAwesomeIcons.cartShopping,
                iconColor: AppTheme.primary,
              ),
            ),
            const SizedBox(width: AppTheme.spacingLg),
            Expanded(
              child: _buildSummaryCard(
                title: 'Clientes Nuevos',
                value: '8',
                icon: FontAwesomeIcons.userPlus,
                iconColor: AppTheme.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingLg),
        _buildRecentOrdersList(),
        const SizedBox(height: AppTheme.spacingLg),
        _buildGoalsCard(),
      ],
    );
  }

  Widget _buildWarehouseDashboard() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                title: 'Productos Stock Bajo',
                value: '12',
                icon: FontAwesomeIcons.box,
                iconColor: AppTheme.warning,
              ),
            ),
            const SizedBox(width: AppTheme.spacingLg),
            Expanded(
              child: _buildSummaryCard(
                title: 'Órdenes por Preparar',
                value: '18',
                icon: FontAwesomeIcons.clipboardList,
                iconColor: AppTheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingLg),
        _buildInventoryAlertList(),
      ],
    );
  }

  Widget _buildDriverDashboard() {
    return Column(
      children: [
        _buildSummaryCard(
          title: 'Órdenes Activas',
          value: '12',
          icon: FontAwesomeIcons.truck,
          iconColor: AppTheme.primary,
        ),
        const SizedBox(height: AppTheme.spacingLg),
        _buildPriorityTaskCard(),
        const SizedBox(height: AppTheme.spacingLg),
        _buildRecentOrdersList(),
      ],
    );
  }

  Widget _buildAccountantDashboard() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                title: 'Pagos Pendientes',
                value: '\$12,450',
                icon: FontAwesomeIcons.moneyBill,
                iconColor: AppTheme.warning,
              ),
            ),
            const SizedBox(width: AppTheme.spacingLg),
            Expanded(
              child: _buildSummaryCard(
                title: 'Facturas por Cobrar',
                value: '14',
                icon: FontAwesomeIcons.fileInvoice,
                iconColor: AppTheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingLg),
        _buildPaymentsList(),
        const SizedBox(height: AppTheme.spacingLg),
        _buildMetricsGrid(),
      ],
    );
  }

  // ========== COMPONENTES REUTILIZABLES ==========

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required FaIconData icon,
    required Color iconColor,
  }) {
    return Container(
      width: double.infinity,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: AppTheme.fontSizeSmall,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: AppTheme.fontSizeTitle,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.onSurface,
                ),
              ),
            ],
          ),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: FaIcon(
                icon,
                size: 28,
                color: iconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityTaskCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Entrega Prioritaria',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeTitle,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: AppTheme.spacingSm),
              Text(
                'Cliente: Logística Avanzada S.A.\nEntrega estimada: 14:30 PM',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeBody,
                  color: AppTheme.onPrimaryContainer.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: AppTheme.spacingLg),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                ),
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.primary,
                  ),
                  child: const Text('Ver Detalles'),
                ),
              ),
            ],
          ),
          Positioned(
            right: -20,
            bottom: -20,
            child: FaIcon(
              FontAwesomeIcons.truckFast,
              size: 100,
              color: AppTheme.onPrimaryContainer.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentOrdersList() {
    final orders = [
      OrderData.fromDetailed(
        id: '#ORD-5842',
        address: 'Calle Mayor, 15',
        status: 'En ruta',
        amount: 1240.00,
        statusColor: AppTheme.primary,
        statusIcon: FontAwesomeIcons.truck,
        client: 'Jardines del Prado',
        items: 12,
      ),
      OrderData.fromDetailed(
        id: '#ORD-5841',
        address: 'Av. Libertad, 240',
        status: 'Pendiente',
        amount: 850.50,
        statusColor: AppTheme.warning,
        statusIcon: FontAwesomeIcons.clock,
        client: 'Vivero San Pedro',
        items: 5,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Órdenes Recientes',
              style: TextStyle(
                fontSize: AppTheme.fontSizeTitle,
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurface,
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primary,
              ),
              child: const Text('Ver todas'),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingLg),
        ...orders.map((order) => Padding(
          padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
          child: _buildOrderItem(order),
        )),
      ],
    );
  }

  Widget _buildOrderItem(OrderData order) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
            ),
            child: Center(
              child: FaIcon(
                FontAwesomeIcons.box,
                size: 24,
                color: AppTheme.outline,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingLg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.id,
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeLabel,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  order.address,
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeSmall,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${order.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeLabel,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingSm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: order.statusColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                ),
                child: Text(
                  order.status,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: order.statusColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: 'Clientes',
            value: '148',
            subtitle: '+3 hoy',
            icon: FontAwesomeIcons.users,
            iconColor: AppTheme.primary,
          ),
        ),
        const SizedBox(width: AppTheme.spacingLg),
        Expanded(
          child: _buildMetricCard(
            title: 'Pagos',
            value: '\$12.4k',
            subtitle: '80% meta',
            icon: FontAwesomeIcons.moneyBill,
            iconColor: AppTheme.tertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required FaIconData icon,
    required Color iconColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: AppTheme.fontSizeSmall,
              fontWeight: FontWeight.w500,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: AppTheme.fontSizeTitle,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.onSurface,
                ),
              ),
              FaIcon(
                icon,
                size: 20,
                color: iconColor,
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryAlertList() {
    final alerts = [
      InventoryAlert(product: 'Fertilizante Orgánico', stock: 3, critical: true),
      InventoryAlert(product: 'Semillas Premium', stock: 8, critical: false),
      InventoryAlert(product: 'Herramienta Podadora', stock: 2, critical: true),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alertas de Inventario',
          style: TextStyle(
            fontSize: AppTheme.fontSizeTitle,
            fontWeight: FontWeight.w600,
            color: AppTheme.onSurface,
          ),
        ),
        const SizedBox(height: AppTheme.spacingLg),
        ...alerts.map((alert) => Padding(
          padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
              border: Border.all(
                color: alert.critical ? AppTheme.errorContainer : AppTheme.warningContainer,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: alert.critical
                        ? AppTheme.errorContainer
                        : AppTheme.warningContainer,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
                  ),
                  child: Center(
                    child: FaIcon(
                      alert.critical ? FontAwesomeIcons.circleExclamation : FontAwesomeIcons.exclamationTriangle,
                      size: 20,
                      color: alert.critical ? AppTheme.error : AppTheme.warning,
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingLg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert.product,
                        style: TextStyle(
                          fontSize: AppTheme.fontSizeBody,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Stock: ${alert.stock} unidades',
                        style: TextStyle(
                          fontSize: AppTheme.fontSizeSmall,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: alert.critical ? AppTheme.error : AppTheme.warning,
                  ),
                  child: const Text('Reabastecer'),
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildPaymentsList() {
    final payments = [
      PaymentData.simple(
        id: 'PAY-001',
        client: 'Javier Arboleda',
        date: '24 Oct, 2023',
        amount: 1250.00,
        status: 'Pendiente',
        isPending: true,
      ),
      PaymentData.simple(
        id: 'PAY-002',
        client: 'Elena Martínez',
        date: '23 Oct, 2023',
        amount: 3400.00,
        status: 'Completado',
        isPending: false,
      ),
      PaymentData.simple(
        id: 'PAY-003',
        client: 'Constructora Sur',
        date: '22 Oct, 2023',
        amount: 12800.00,
        status: 'Completado',
        isPending: false,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pagos Recientes',
          style: TextStyle(
            fontSize: AppTheme.fontSizeTitle,
            fontWeight: FontWeight.w600,
            color: AppTheme.onSurface,
          ),
        ),
        const SizedBox(height: AppTheme.spacingLg),
        ...payments.map((payment) => Padding(
          padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
              border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: payment.isPending
                        ? AppTheme.warningContainer
                        : AppTheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
                  ),
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.user,
                      size: 20,
                      color: payment.isPending ? AppTheme.warning : AppTheme.secondary,
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingLg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        payment.client,
                        style: TextStyle(
                          fontSize: AppTheme.fontSizeBody,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        payment.status,
                        style: TextStyle(
                          fontSize: AppTheme.fontSizeSmall,
                          color: payment.isPending ? AppTheme.warning : AppTheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '\$${payment.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeLabel,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildGoalsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Metas del Mes',
            style: TextStyle(
              fontSize: AppTheme.fontSizeTitle,
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurface,
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          _buildGoalProgress(
            label: 'Ventas',
            current: 75,
            total: 100,
            color: AppTheme.primary,
          ),
          const SizedBox(height: AppTheme.spacingLg),
          _buildGoalProgress(
            label: 'Clientes Nuevos',
            current: 18,
            total: 25,
            color: AppTheme.secondary,
          ),
        ],
      ),
    );
  }

  Widget _buildGoalProgress({
    required String label,
    required double current,
    required double total,
    required Color color,
  }) {
    final percentage = (current / total) * 100;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: AppTheme.fontSizeLabel,
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurface,
              ),
            ),
            Text(
              '${percentage.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: AppTheme.fontSizeLabel,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingSm),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
          child: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: AppTheme.surfaceContainerHigh,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: AppTheme.spacingSm),
        Text(
          '$current de $total completados',
          style: TextStyle(
            fontSize: AppTheme.fontSizeSmall,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  // ========== BOTTOM NAVIGATION BAR ==========

  Widget _buildBottomNavBar() {
    final items = _getNavItemsByRole();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg, vertical: AppTheme.spacingSm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return _buildNavItem(
                index: index,
                icon: item.icon,
                label: item.label,
                isSelected: _currentIndex == index,
                onTap: () => _onNavItemTap(index),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  List<NavItem> _getNavItemsByRole() {
    switch (_currentUserRole) {
      case UserRole.admin:
        return [
          NavItem(icon: FontAwesomeIcons.chartPie, label: 'Dashboard'),
          NavItem(icon: FontAwesomeIcons.receipt, label: 'Órdenes'),
          NavItem(icon: FontAwesomeIcons.users, label: 'Clientes'),
          NavItem(icon: FontAwesomeIcons.moneyBill, label: 'Pagos'),
          NavItem(icon: FontAwesomeIcons.user, label: 'Perfil'),
        ];
      case UserRole.seller:
        return [
          NavItem(icon: FontAwesomeIcons.chartPie, label: 'Dashboard'),
          NavItem(icon: FontAwesomeIcons.receipt, label: 'Órdenes'),
          NavItem(icon: FontAwesomeIcons.users, label: 'Clientes'),
          NavItem(icon: FontAwesomeIcons.user, label: 'Perfil'),
        ];
      case UserRole.warehouse:
        return [
          NavItem(icon: FontAwesomeIcons.chartPie, label: 'Dashboard'),
          NavItem(icon: FontAwesomeIcons.box, label: 'Inventario'),
          NavItem(icon: FontAwesomeIcons.receipt, label: 'Órdenes'),
          NavItem(icon: FontAwesomeIcons.user, label: 'Perfil'),
        ];
      case UserRole.driver:
        return [
          NavItem(icon: FontAwesomeIcons.chartPie, label: 'Dashboard'),
          NavItem(icon: FontAwesomeIcons.truck, label: 'Entregas'),
          NavItem(icon: FontAwesomeIcons.receipt, label: 'Órdenes'),
          NavItem(icon: FontAwesomeIcons.user, label: 'Perfil'),
        ];
      case UserRole.accountant:
        return [
          NavItem(icon: FontAwesomeIcons.chartPie, label: 'Dashboard'),
          NavItem(icon: FontAwesomeIcons.moneyBill, label: 'Pagos'),
          NavItem(icon: FontAwesomeIcons.fileInvoice, label: 'Facturas'),
          NavItem(icon: FontAwesomeIcons.user, label: 'Perfil'),
        ];
      default:
        return [
          NavItem(icon: FontAwesomeIcons.chartPie, label: 'Dashboard'),
          NavItem(icon: FontAwesomeIcons.user, label: 'Perfil'),
        ];
    }
  }

  Widget _buildNavItem({
    required int index,
    required FaIconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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