import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/screens/admin_home_screen.dart';
import 'package:pedidos/screens/admin_dashboard.dart';
import 'package:pedidos/screens/orders_screen.dart';
import 'package:pedidos/screens/customers_screen.dart';
import 'package:pedidos/screens/inventory_screen.dart';
import 'package:pedidos/screens/reports_screen.dart';
import 'package:pedidos/screens/finances_screen.dart';
import 'package:pedidos/screens/more_screen.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    AdminDashboard(),
    OrdersScreen(),
    CustomersScreen(),
    InventoryScreen(),
    ReportsScreen(),
    FinancesScreen(),
    MoreScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade100,
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
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingLg,
            vertical: AppTheme.spacingSm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: FontAwesomeIcons.chartPie,
                label: 'Dashboard',
              ),
              _buildNavItem(
                index: 1,
                icon: FontAwesomeIcons.receipt,
                label: 'Órdenes',
              ),
              _buildNavItem(
                index: 2,
                icon: FontAwesomeIcons.users,
                label: 'Clientes',
              ),
              _buildNavItem(
                index: 3,
                icon: FontAwesomeIcons.box,
                label: 'Artículos',
              ),
              _buildNavItem(
                index: 4,
                icon: FontAwesomeIcons.fileAlt,
                label: 'Reportes',
              ),
              _buildNavItem(
                index: 5,
                icon: FontAwesomeIcons.moneyBill,
                label: 'Finanzas',
              ),
              _buildNavItem(
                index: 6,
                icon: FontAwesomeIcons.ellipsis,
                label: 'Más',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required FaIconData icon,
    required String label,
  }) {
    bool isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            icon,
            size: 18,
            color: isSelected
                ? AppTheme.primary
                : Colors.grey.shade500,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? AppTheme.primary
                  : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}