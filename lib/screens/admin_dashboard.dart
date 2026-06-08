import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/screens/orders_screen.dart';
import 'package:pedidos/screens/notifications_screen.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700; // iPhone SE, 8, etc.

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // TopAppBar
         // _buildTopAppBar(context),
          // Contenido principal
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(
                isSmallScreen ? AppTheme.spacingLg : AppTheme.spacingXl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Section
                  _buildWelcomeSection(),
                  SizedBox(height: isSmallScreen ? AppTheme.spacingLg : AppTheme.spacingXl),
                  // Bento Metrics Grid
                  _buildBentoGrid(),
                  SizedBox(height: isSmallScreen ? AppTheme.spacingLg : AppTheme.spacingXl),
                  // Recent Activity Section
                  _buildRecentActivity(),
                  SizedBox(height: isSmallScreen ? AppTheme.spacingLg : AppTheme.spacingXl),
                  // Quick Actions Banner (Reporte Semanal)
                  _buildWeeklyReportBanner(),
                  // Espacio extra al final para evitar overflow
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopAppBar(BuildContext context) {
    return CustomTopAppBar(
      title: 'Home',
      profileImageUrl: 'https://lh3.googleusercont1ent.com/aida-public/AB6AXuDY8qEs_fHpWSUS07h2xPpseJpoGAcVIAe46Q6nEkgvxuZKxxq5IUG7m3pkj3NxJdA3F7oqxeJd5e-NN2hfLzXXavdIfYZAEYEf12xopfzI-_plbRSeP6p-rbeoPeQbMBL69AfgJJWlrIThrCfz7cyXt3L1U9zqJ3xnyTRu_G7fAslgzht7KCAHTAV6oyoHEr-oo1KulVGEie7MW7S4diypaZcO4ZCveY_Ids7i735YwnodrAuS88rB4aPM8pmyQP1hhTSUTFwuJbU7',
      onProfileTap: () {},
      actions: [
        AppBarButton(
          icon: FontAwesomeIcons.bell,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationsScreen()),
            );
          },
          showBadge: true,
          badgeCount: 3,
        ),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hola de nuevo, Admin',
          style: TextStyle(
            fontSize: isSmallScreen ? 20 : AppTheme.fontSizeTitle,
            fontWeight: FontWeight.w600,
            color: AppTheme.onSurface,
          ),
        ),
        const SizedBox(height: AppTheme.spacingSm),
        Text(
          'Aquí tienes el resumen de hoy.',
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : AppTheme.fontSizeBody,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildBentoGrid() {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth < 400 ? 1 : 2;

        double aspectRatio;

        if (constraints.maxWidth < 360) {
          aspectRatio = 2.4; // 🔥 más aire en teléfonos pequeños
        } else if (constraints.maxWidth < 600) {
          aspectRatio = 2.0;
        } else {
          aspectRatio = 2.2;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: isSmallScreen ? 12 : 16,
            mainAxisSpacing: isSmallScreen ? 12 : 16,
            childAspectRatio: aspectRatio,
          ),
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return _buildSalesCard();
              case 1:
                return _buildPendingOrdersCard();
              default:
                return _buildNewClientsCard();
            }
          },
        );
      },
    );
  }

  Widget _buildSalesCard() {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

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
      padding: EdgeInsets.all(
        isSmallScreen ? AppTheme.spacingMd : AppTheme.spacingXl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Ventas de hoy',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 11 : AppTheme.fontSizeLabel,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
              ),
              FaIcon(
                FontAwesomeIcons.chartLine,
                size: isSmallScreen ? 16 : 20,
                color: AppTheme.primary,
              ),
            ],
          ),

          // 🔥 REDUCIDO: Espacio entre header y monto
          SizedBox(height: isSmallScreen ? 6 : 12),

          // Amount
          Text(
            '\$12,450.00',
            style: TextStyle(
              fontSize: isSmallScreen ? 26 : AppTheme.fontSizeDisplay,
              fontWeight: FontWeight.w800,
              color: AppTheme.primary,
            ),
          ),

          // 🔥 REDUCIDO: Espacio entre monto y porcentaje
          SizedBox(height: isSmallScreen ? 2 : 6),

          // Percentage row
          Row(
            children: [
              FaIcon(
                FontAwesomeIcons.arrowUp,
                size: 10,
                color: AppTheme.secondary,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  '+12% vs ayer',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 10 : AppTheme.fontSizeSmall,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.secondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPendingOrdersCard() {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
      ),
      padding: EdgeInsets.all(
        isSmallScreen ? AppTheme.spacingMd : AppTheme.spacingXl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: isSmallScreen ? 32 : 40,
            height: isSmallScreen ? 32 : 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
            ),
            child: Center(
              child: FaIcon(
                FontAwesomeIcons.receipt,
                size: isSmallScreen ? 16 : 20,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            '24',
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : AppTheme.fontSizeTitle,
              fontWeight: FontWeight.w600,
              color: AppTheme.onPrimaryContainer,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'Pedidos pendientes',
            style: TextStyle(
              fontSize: isSmallScreen ? 10 : AppTheme.fontSizeSmall,
              fontWeight: FontWeight.w500,
              color: AppTheme.onPrimaryContainer.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewClientsCard() {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

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
      padding: EdgeInsets.all(
        isSmallScreen ? AppTheme.spacingMd : AppTheme.spacingXl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: isSmallScreen ? 32 : 40,
            height: isSmallScreen ? 32 : 40,
            decoration: BoxDecoration(
              color: AppTheme.secondaryContainer,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
            ),
            child: Center(
              child: FaIcon(
                FontAwesomeIcons.users,
                size: isSmallScreen ? 16 : 20,
                color: AppTheme.secondary,
              ),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            '18',
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : AppTheme.fontSizeTitle,
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurface,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'Clientes nuevos',
            style: TextStyle(
              fontSize: isSmallScreen ? 10 : AppTheme.fontSizeSmall,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Actividad Reciente',
              style: TextStyle(
                fontSize: isSmallScreen ? 18 : AppTheme.fontSizeTitle,
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurface,
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primary,
                padding: isSmallScreen ? const EdgeInsets.symmetric(horizontal: 8) : null,
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
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? AppTheme.spacingMd : AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
      ),
      child: Row(
        children: [
          Container(
            width: isSmallScreen ? 40 : 48,
            height: isSmallScreen ? 40 : 48,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: FaIcon(
                icon,
                size: isSmallScreen ? 16 : 20,
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
                    fontSize: isSmallScreen ? 13 : AppTheme.fontSizeLabel,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 11 : AppTheme.fontSizeSmall,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          FaIcon(
            FontAwesomeIcons.chevronRight,
            size: isSmallScreen ? 12 : 16,
            color: AppTheme.outline,
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyReportBanner() {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;
    final bannerHeight = isSmallScreen ? 120.0 : 160.0;

    return Container(
      height: bannerHeight,
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
              height: bannerHeight,
              width: double.infinity,
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.3),
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: bannerHeight,
                  color: AppTheme.primary,
                );
              },
            ),
            // Contenido
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? AppTheme.spacingLg : AppTheme.spacingXl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Reporte Semanal',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 18 : AppTheme.fontSizeTitle,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: isSmallScreen ? 120 : 150,
                      height: isSmallScreen ? 32 : 40,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.secondaryFixed,
                          foregroundColor: AppTheme.onSecondaryFixed,
                          padding: isSmallScreen ? const EdgeInsets.symmetric(horizontal: 12) : null,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                          ),
                        ),
                        child: Text(
                          'Descargar PDF',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 12 : 14,
                          ),
                        ),
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
}