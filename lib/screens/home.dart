import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/enums/user_role_enum.dart';
import 'package:pedidos/screens/admin_dashboard.dart';
import 'package:pedidos/screens/orders_screen.dart';
import 'package:pedidos/screens/customers_screen.dart';
import 'package:pedidos/screens/inventory_screen.dart';
import 'package:pedidos/screens/reports_screen.dart';
import 'package:pedidos/screens/finances_screen.dart';
import 'package:pedidos/screens/more_screen.dart';
import 'package:pedidos/screens/notifications_screen.dart';
import 'package:pedidos/screens/profile_screen.dart';
import 'package:pedidos/screens/deliveries_screen.dart';
import 'package:pedidos/screens/payments_management_screen.dart';
import 'package:pedidos/screens/invoices_screen.dart';

import 'package:pedidos/models/order_data_model.dart';
import 'package:pedidos/models/navItem_model.dart';
import 'package:pedidos/models/payment_data_model.dart';
import 'package:pedidos/models/inventory_alert_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // TODO: Obtener el rol del usuario logueado desde el sistema de autenticación
  UserRole _currentUserRole = UserRole.admin;
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
          AdminDashboard(),
          OrdersScreen(),
          CustomersScreen(),
          InventoryScreen(),
          ReportsScreen(),
          FinancesScreen(),
          MoreScreen()
        ];
        break;
      case UserRole.seller:
        _screens = [
          const OrdersScreen(),
          const CustomersScreen(),
          const ProfileScreen(),
        ];
        break;
      case UserRole.warehouse:
        _screens = [
          const InventoryScreen(),
          const OrdersScreen(),
          const ProfileScreen(),
        ];
        break;
      case UserRole.driver:
        _screens = [
          const DeliveriesScreen(),
          const OrdersScreen(),
          const ProfileScreen(),
        ];
        break;
      case UserRole.accountant:
        _screens = [
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
          NavItem(icon: FontAwesomeIcons.box, label: 'Artículos'),
          NavItem(icon: FontAwesomeIcons.fileAlt, label: 'Reportes'),
          NavItem(icon: FontAwesomeIcons.moneyBill, label: 'Finanzas'),
          NavItem(icon: FontAwesomeIcons.ellipsisH, label: 'Más'),
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