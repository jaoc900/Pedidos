import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';

class EmployeeDashboard extends StatelessWidget {
  const EmployeeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth > 600;
          final isDesktop = constraints.maxWidth > 1200;

          return Row(
            children: [
              // Sidebar para tablet/desktop
              if (isTablet) _buildSidebar(),
              // Contenido principal
              Expanded(
                child: SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(
                      isTablet ? AppTheme.spacingXxl : AppTheme.spacingXl,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header con saludo
                        _buildHeader(isTablet),
                        const SizedBox(height: AppTheme.spacingXl),
                        // Layout principal: dos columnas en tablet/desktop
                        if (isDesktop)
                          _buildTwoColumnLayout(context)
                        else
                          _buildStackedLayout(context, isTablet),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        border: Border(
          right: BorderSide(
            color: AppTheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: AppTheme.spacingXxl),
          // Logo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXl),
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.seedling,
                  size: 32,
                  color: AppTheme.primary,
                ),
                const SizedBox(width: AppTheme.spacingMd),
                Text(
                  'Verdant',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeTitle,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingXxl),
          // Información del empleado
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXl),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingLg),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.userLarge,
                    size: 32,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingMd),
                Text(
                  'Alejandro Rodríguez',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeBody,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Repartidor',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeSmall,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingXxl),
          // Menú items
          _buildSidebarItem(
            icon: FontAwesomeIcons.house,
            label: 'Dashboard',
            isSelected: true,
          ),
          _buildSidebarItem(
            icon: FontAwesomeIcons.truck,
            label: 'Mis Órdenes',
            isSelected: false,
          ),
          _buildSidebarItem(
            icon: FontAwesomeIcons.clock,
            label: 'Historial',
            isSelected: false,
          ),
          _buildSidebarItem(
            icon: FontAwesomeIcons.bell,
            label: 'Notificaciones',
            isSelected: false,
            hasBadge: true,
          ),
          const Spacer(),
          // Botón de cerrar sesión
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingXl),
            child: _buildSidebarItem(
              icon: FontAwesomeIcons.arrowRightFromBracket,
              label: 'Cerrar sesión',
              isSelected: false,
              isLogout: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem({
    required FaIconData icon,
    required String label,
    required bool isSelected,
    bool isLogout = false,
    bool hasBadge = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingLg,
        vertical: AppTheme.spacingSm,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
        ),
        child: ListTile(
          leading: Stack(
            children: [
              FaIcon(
                icon,
                size: 20,
                color: isLogout
                    ? AppTheme.error
                    : (isSelected ? AppTheme.primary : AppTheme.outline),
              ),
              if (hasBadge)
                Positioned(
                  right: -4,
                  top: -4,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppTheme.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          title: Text(
            label,
            style: TextStyle(
              fontSize: AppTheme.fontSizeLabel,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isLogout
                  ? AppTheme.error
                  : (isSelected ? AppTheme.primary : AppTheme.onSurfaceVariant),
            ),
          ),
          onTap: () {
            // Navegación
          },
        ),
      ),
    );
  }

  Widget _buildHeader(bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hola, Alejandro',
          style: TextStyle(
            fontSize: isTablet ? AppTheme.fontSizeHeadline : AppTheme.fontSizeTitle,
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

  Widget _buildTwoColumnLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: _buildLeftColumn(),
        ),
        const SizedBox(width: AppTheme.spacingXl),
        Expanded(
          child: _buildRightColumn(context),
        ),
      ],
    );
  }

  Widget _buildStackedLayout(BuildContext context, bool isTablet) {
    return Column(
      children: [
        _buildLeftColumn(),
        const SizedBox(height: AppTheme.spacingXl),
        if (!isTablet) _buildMetricsRow(),
        const SizedBox(height: AppTheme.spacingXl),
        _buildRightColumn(context),
      ],
    );
  }

  Widget _buildLeftColumn() {
    return Column(
      children: [
        // Tarjeta de Órdenes Activas
        _buildActiveOrdersCard(),
        const SizedBox(height: AppTheme.spacingXl),
        // Tarjeta de Entrega Prioritaria
        _buildPriorityDeliveryCard(),
        const SizedBox(height: AppTheme.spacingXl),
        // Tarjeta de Órdenes Recientes
        _buildRecentOrdersCard(),
      ],
    );
  }

  Widget _buildMetricsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: 'Clientes',
            value: '148',
            icon: FontAwesomeIcons.users,
            iconColor: AppTheme.primary,
          ),
        ),
        const SizedBox(width: AppTheme.spacingLg),
        Expanded(
          child: _buildMetricCard(
            title: 'Pagos',
            value: '\$12.4k',
            icon: FontAwesomeIcons.moneyBill,
            iconColor: AppTheme.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildRightColumn(BuildContext context) {
    return Column(
      children: [
        // Métricas en desktop
        if (MediaQuery.of(context).size.width > 1200)
          _buildMetricsRow(),
        if (MediaQuery.of(context).size.width > 1200)
          const SizedBox(height: AppTheme.spacingXl),
        // Tarjeta de Clientes y Pagos en tablet/móvil
        _buildClientsAndPaymentsCard(),
      ],
    );
  }

  Widget _buildActiveOrdersCard() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingXl),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
            ),
            child: FaIcon(
              FontAwesomeIcons.clipboardList,
              size: 32,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(width: AppTheme.spacingLg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ÓRDENES ACTIVAS',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeLabel,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingSm),
                Text(
                  '12',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityDeliveryCard() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingXl),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                decoration: BoxDecoration(
                  color: AppTheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusMd),
                ),
                child: FaIcon(
                  FontAwesomeIcons.truckFast,
                  size: 20,
                  color: AppTheme.error,
                ),
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Text(
                'Entrega Prioritaria',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeBody,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurface,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingMd,
                  vertical: AppTheme.spacingSm,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusSm),
                ),
                child: Text(
                  'URGENTE',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeSmall,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.error,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Text(
            'Cliente: Logística Avanzada S.A.',
            style: TextStyle(
              fontSize: AppTheme.fontSizeBody,
              fontWeight: FontWeight.w500,
              color: AppTheme.onSurface,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Row(
            children: [
              FaIcon(
                FontAwesomeIcons.clock,
                size: 14,
                color: AppTheme.onSurfaceVariant,
              ),
              const SizedBox(width: AppTheme.spacingSm),
              Text(
                'Entrega estimada: 14:30 PM',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeLabel,
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primary,
                side: BorderSide(color: AppTheme.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
                ),
              ),
              child: const Text('Ver Detalles'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentOrdersCard() {
    final orders = [
      _OrderData(
        id: '#ORD-5842',
        address: 'Calle Mayor, 15',
        status: 'En ruta',
        amount: '\$1,240.00',
        statusColor: AppTheme.primary,
        statusIcon: FontAwesomeIcons.truck,
      ),
      _OrderData(
        id: '#ORD-5841',
        address: 'Av. Libertad, 240',
        status: 'Pendiente',
        amount: '\$850.50',
        statusColor: AppTheme.warning,
        statusIcon: FontAwesomeIcons.clock,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingXl),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
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
            padding: const EdgeInsets.only(bottom: AppTheme.spacingLg),
            child: _buildOrderItem(order),
          )),
        ],
      ),
    );
  }

  Widget _buildOrderItem(_OrderData order) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.id,
                style: TextStyle(
                  fontSize: AppTheme.fontSizeBody,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurface,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingSm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: order.statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusSm),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(
                      order.statusIcon,
                      size: 10,
                      color: order.statusColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      order.status,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: order.statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Row(
            children: [
              FaIcon(
                FontAwesomeIcons.locationDot,
                size: 12,
                color: AppTheme.outline,
              ),
              const SizedBox(width: AppTheme.spacingSm),
              Expanded(
                child: Text(
                  order.address,
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeSmall,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            order.amount,
            style: TextStyle(
              fontSize: AppTheme.fontSizeBody,
              fontWeight: FontWeight.w600,
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientsAndPaymentsCard() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingXl),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMetricCard(
            title: 'Clientes',
            value: '148',
            icon: FontAwesomeIcons.users,
            iconColor: AppTheme.primary,
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Divider(color: AppTheme.outlineVariant),
          const SizedBox(height: AppTheme.spacingLg),
          _buildMetricCard(
            title: 'Pagos',
            value: '\$12.4k',
            icon: FontAwesomeIcons.moneyBill,
            iconColor: AppTheme.secondary,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required FaIconData icon,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
          ),
          child: FaIcon(
            icon,
            size: 28,
            color: iconColor,
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
                  letterSpacing: 1,
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppTheme.spacingSm),
              Text(
                value,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Data class para órdenes
class _OrderData {
  final String id;
  final String address;
  final String status;
  final String amount;
  final Color statusColor;
  final FaIconData statusIcon;

  _OrderData({
    required this.id,
    required this.address,
    required this.status,
    required this.amount,
    required this.statusColor,
    required this.statusIcon,
  });
}