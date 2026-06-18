// home.dart (actualizado)
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/enums/user_role_enum.dart';
import 'package:pedidos/screens/admin_dashboard.dart';
import 'package:pedidos/screens/orders_screen.dart';
import 'package:pedidos/screens/customers_screen.dart';
import 'package:pedidos/screens/inventory_screen.dart';
import 'package:pedidos/screens/profile_screen.dart';
import 'package:pedidos/screens/deliveries_screen.dart';
import 'package:pedidos/screens/payments_management_screen.dart';
import 'package:pedidos/screens/invoices_screen.dart';
import 'package:pedidos/screens/pos_movil_catalog_screen.dart';
import 'package:pedidos/screens/pos_quick_scanner_screen.dart';
import 'package:pedidos/models/navItem_model.dart';
import 'package:pedidos/services/user_preferences.dart';
import 'package:pedidos/widgets/side_menu.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  UserRole _currentUserRole = UserRole.seller;
  int _currentIndex = 0;
  bool _isLoading = true;
  late UserPreferences _userPrefs;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Pantallas principales según rol (solo las más importantes)
  late List<Widget> _screens;
  late List<NavItem> _navItems;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      _userPrefs = UserPreferences();
      await _userPrefs.init();

      final userRole = _userPrefs.getUserRole();
      _currentUserRole = _mapRoleToEnum(userRole);

      _updateScreensByRole();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  UserRole _mapRoleToEnum(int? role) {
    switch (role) {
      case 4:
        return UserRole.admin;
      case 3:
        return UserRole.accountant;
      case 2:
        return UserRole.warehouse;
      case 1:
        return UserRole.seller;
      default:
        return UserRole.seller;
    }
  }

  void _updateScreensByRole() {
    switch (_currentUserRole) {
      case UserRole.admin:
      // Solo las pantallas más importantes para admin
        _screens = [
          const AdminDashboard(),    // Dashboard principal
          const OrdersScreen(),       // Órdenes
          const CustomersScreen(),    // Clientes
          const InventoryScreen(),    // Inventario
        ];
        _navItems = [
          NavItem(icon: FontAwesomeIcons.chartPie, label: 'Dashboard'),
          NavItem(icon: FontAwesomeIcons.receipt, label: 'Órdenes'),
          NavItem(icon: FontAwesomeIcons.users, label: 'Clientes'),
          NavItem(icon: FontAwesomeIcons.box, label: 'Inventario'),
        ];
        break;

      case UserRole.seller:
      // Pantallas importantes para vendedor
        _screens = [
          const PointOfSaleScreen(),   // POS principal
          const OrdersScreen(),         // Órdenes
          const CustomersScreen(),      // Clientes
          const QuickScannerScreen(),   // Scanner rápido
        ];
        _navItems = [
          NavItem(icon: FontAwesomeIcons.cashRegister, label: 'POS'),
          NavItem(icon: FontAwesomeIcons.receipt, label: 'Órdenes'),
          NavItem(icon: FontAwesomeIcons.users, label: 'Clientes'),
          NavItem(icon: FontAwesomeIcons.qrcode, label: 'Escanear'),
        ];
        break;

      case UserRole.warehouse:
      // Pantallas importantes para almacén
        _screens = [
          const InventoryScreen(),   // Inventario
          const OrdersScreen(),       // Órdenes
        ];
        _navItems = [
          NavItem(icon: FontAwesomeIcons.box, label: 'Inventario'),
          NavItem(icon: FontAwesomeIcons.receipt, label: 'Órdenes'),
        ];
        break;

      case UserRole.driver:
      // Pantallas importantes para repartidor
        _screens = [
          const DeliveriesScreen(),   // Entregas
          const OrdersScreen(),        // Órdenes
          const ProfileScreen(),       // Perfil
        ];
        _navItems = [
          NavItem(icon: FontAwesomeIcons.truck, label: 'Entregas'),
          NavItem(icon: FontAwesomeIcons.receipt, label: 'Órdenes'),
        ];
        break;

      case UserRole.accountant:
      // Pantallas importantes para contador
        _screens = [
          const PaymentsManagementScreen(),   // Pagos
          const InvoicesScreen(),              // Facturas
        ];
        _navItems = [
          NavItem(icon: FontAwesomeIcons.moneyBill, label: 'Pagos'),
          NavItem(icon: FontAwesomeIcons.fileInvoice, label: 'Facturas'),
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
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.background,
      drawer:  SideMenu(onClose: _onMenuClose),
      body: Column(
        children: [
          CustomTopAppBar(
            title: _navItems[_currentIndex].label,
            profileImageUrl: null,
            scaffoldKey: _scaffoldKey,
            actions: [
              AppBarButton(
                icon: FontAwesomeIcons.bell,
                onPressed: () {
                  // Navegar a notificaciones
                },
                showBadge: true,
                badgeCount: 3,
              ),
            ],
          ),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  void _onMenuClose() {
    // Aquí puedes agregar lógica adicional si la necesitas
    // Por ahora, solo cerramos el drawer
    // El drawer se cierra automáticamente al navegar
  }

  Widget _buildBottomNavBar() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 380;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200, width: 1),
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
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 8 : AppTheme.spacingLg,
            vertical: AppTheme.spacingSm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _navItems.asMap().entries.map((entry) {
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

  Widget _buildNavItem({
    required int index,
    required FaIconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 380;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 8 : 12,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              icon,
              size: isSmallScreen ? 20 : 22,
              color: isSelected ? AppTheme.loginButtonColor : Colors.grey.shade500,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: isSmallScreen ? 10 : 11,
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

// Widget auxiliar para botones en el AppBar
class AppBarButton extends StatelessWidget {
  final FaIconData icon;
  final VoidCallback onPressed;
  final bool showBadge;
  final int badgeCount;

  const AppBarButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.showBadge = false,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: FaIcon(icon, size: 20),
          onPressed: onPressed,
          color: AppTheme.onSurfaceVariant,
        ),
        if (showBadge && badgeCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                '$badgeCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}