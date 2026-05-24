import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/screens/orders_screen.dart';
import 'package:pedidos/screens/notifications_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}
class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // TopAppBar
          _buildTopAppBar(context),
          // Contenido principal
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingXl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Section
                  _buildWelcomeSection(),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Bento Metrics Grid
                  _buildBentoGrid(),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Recent Activity Section
                  _buildRecentActivity(),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Quick Actions Banner (Reporte Semanal)
                  _buildWeeklyReportBanner(),
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
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXl, vertical: AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.background,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
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
                // Avatar de perfil
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.primaryContainer,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuDY8qEs_fHpWSUS07h2xPpseJpoGAcVIAe46Q6nEkgvxuZKxxq5IUG7m3pkj3NxJdA3F7oqxeJd5e-NN2hfLzXXavdIfYZAEYEf12xopfzI-_plbRSeP6p-rbeoPeQbMBL69AfgJJWlrIThrCfz7cyXt3L1U9zqJ3xnyTRu_G7fAslgzht7KCAHTAV6oyoHEr-oo1KulVGEie7MW7S4diypaZcO4ZCveY_Ids7i735YwnodrAuS88rB4aPM8pmyQP1hhTSUTFwuJbU7',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppTheme.primaryContainer,
                          child: const FaIcon(
                            FontAwesomeIcons.user,
                            size: 20,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMd),
                Text(
                  'Home',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: AppTheme.fontSizeBody,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
            // Botón de notificaciones
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
                  color: AppTheme.primary,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NotificationsScreen())
                  );
                },
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
          'Hola de nuevo, Admin',
          style: TextStyle(
            fontSize: AppTheme.fontSizeTitle,
            fontWeight: FontWeight.w600,
            color: AppTheme.onSurface,
          ),
        ),
        const SizedBox(height: AppTheme.spacingSm),
        Text(
          'Aquí tienes el resumen de hoy.',
          style: TextStyle(
            fontSize: AppTheme.fontSizeBody,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildBentoGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLarge = constraints.maxWidth > 500;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: AppTheme.spacingLg,
          crossAxisSpacing: AppTheme.spacingLg,
          childAspectRatio: isLarge ? 2.2 : 1.8,
          children: [
            // Major Card: Ventas de hoy
            _buildSalesCard(),
            // Card: Pedidos pendientes
            _buildPendingOrdersCard(),
            // Card: Nuevos Clientes
            _buildNewClientsCard(),
          ],
        );
      },
    );
  }

  Widget _buildSalesCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
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
      padding: const EdgeInsets.all(AppTheme.spacingXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ventas de hoy',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeLabel,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
              FaIcon(
                FontAwesomeIcons.chartLine,
                size: 20,
                color: AppTheme.primary,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\$12,450.00',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeDisplay,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.arrowUp,
                    size: 12,
                    color: AppTheme.secondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '+12% vs ayer',
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeSmall,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPendingOrdersCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
      ),
      padding: const EdgeInsets.all(AppTheme.spacingXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.receipt,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '24',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeTitle,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Pedidos pendientes',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeSmall,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.onPrimaryContainer.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNewClientsCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
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
      padding: const EdgeInsets.all(AppTheme.spacingXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.secondaryContainer,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.users,
                size: 20,
                color: AppTheme.secondary,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '18',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeTitle,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Clientes nuevos',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeSmall,
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Actividad Reciente',
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
              child: const Text('Ver todo'),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingLg),
        Column(
          children: [
            _buildActivityItem(
              icon: FontAwesomeIcons.cartShopping,
              title: 'Nuevo pedido #4592',
              subtitle: 'Hace 5 minutos • \$120.00',
              iconColor: AppTheme.secondary,
              iconBgColor: AppTheme.secondaryContainer,
            ),
            const SizedBox(height: AppTheme.spacingMd),
            _buildActivityItem(
              icon: FontAwesomeIcons.userPlus,
              title: 'Registro: Ana García',
              subtitle: 'Hace 15 minutos',
              iconColor: AppTheme.tertiary,
              iconBgColor: AppTheme.tertiaryContainer.withValues(alpha: 0.2),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required FaIconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required Color iconBgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: FaIcon(
                icon,
                size: 20,
                color: iconColor,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingLg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeLabel,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeSmall,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          FaIcon(
            FontAwesomeIcons.chevronRight,
            size: 16,
            color: AppTheme.outline,
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyReportBanner() {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.3),
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
              'https://lh3.googleusercontent.com/aida-public/AB6AXuD80QwJyvQKfByMsTCU8iVy81k8GZYUjrAOv8oDB4Jmcy03qvjAvCZqKZbnCgNfxrI_GaYJsiG3KkX8HewCzra3aXxHFj9civrhkrBOnSgK3OIpl7dpzOGNvprK2oCxcAOjWyfdVaXoiM1QzVuIJ2avsitcUmK4sNd01knazB50RsTiGcbUWpHUPinpq-qTOtnSWFLtUT3XB5P9OIkvC8itjeWPtutMaZa99tXMa1d9-rC7my1VLyfDPzcJQWXbBuRHhgZTVQAJOOoE',
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.3),
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 160,
                  color: AppTheme.primary,
                );
              },
            ),
            // Contenido
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingXl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Reporte Semanal',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeTitle,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.secondaryFixed,
                          foregroundColor: AppTheme.onSecondaryFixed,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                          ),
                        ),
                        child: const Text('Descargar PDF'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg, vertical: AppTheme.spacingSm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: FontAwesomeIcons.chartPie,
                label: 'Dashboard',
                isSelected: true,
                onTap: () {},
              ),
              _buildNavItem(
                icon: FontAwesomeIcons.receipt,
                label: 'Órdenes',
                isSelected: false,
                onTap: () {
                  // En tu bottom navigation o sidebar
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OrdersScreen())
                  );
                },
              ),
              _buildNavItem(
                icon: FontAwesomeIcons.users,
                label: 'Clientes',
                isSelected: false,
                onTap: () {},
              ),
              _buildNavItem(
                icon: FontAwesomeIcons.box,
                label: 'Artículos',
                isSelected: false,
                onTap: () {},
              ),
              _buildNavItem(
                icon: FontAwesomeIcons.fileAlt,
                label: 'Reportes',
                isSelected: false,
                onTap: () {},
              ),
              _buildNavItem(
                icon: FontAwesomeIcons.moneyBill,
                label: 'Pagos',
                isSelected: false,
                onTap: () {},
              ),
              _buildNavItem(
                icon: FontAwesomeIcons.ellipsisH,
                label: 'Más',
                isSelected: false,
                onTap: () {},
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              color: isSelected ? AppTheme.primary : Colors.grey.shade400,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppTheme.primary : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}