import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/screens/payments_management_screen.dart';
import 'package:pedidos/screens/profits_screen.dart';
import 'package:pedidos/screens/expenses_dashboard_screen.dart';
import 'package:pedidos/screens/orders_dashboard_screen.dart';
import 'package:pedidos/screens/products_dashboard_screen.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: CustomTopAppBar(
        title: 'Reportes',
        showBackButton: false,
      ),
      body: Column(
        children: [
          // Contenido principal
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingXl),
              child: Center(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // En el build principal, donde se muestran las dos tarjetas:
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 8,
                              child: _buildOrdersCard(context),
                            ),
                            const SizedBox(width: AppTheme.spacingLg),
                            Expanded(
                              flex: 4,
                              child: _buildGrowthCard(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingLg),
                      // Fila 2: Pagos + Ganancias (2 columnas)
                      Row(
                        children: [
                          Expanded(
                            child: _buildPaymentsCard(context),
                          ),
                          const SizedBox(width: AppTheme.spacingLg),
                          Expanded(
                            child: _buildProfitsCard(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingLg,),
                      Row(
                        children: [
                          Expanded(
                            child: _buildExpensesCard(context),
                          ),
                          const SizedBox(width: AppTheme.spacingLg),
                          Expanded(
                            child: _buildProductsCard(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingXl),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OrdersDashboardScreen()),
        );
      },
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
                        ),
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.receipt,
                            size: 28,
                            color: AppTheme.onSecondaryContainer,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingLg),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Órdenes',
                            style: TextStyle(
                              fontSize: AppTheme.fontSizeTitle,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Ventas y pedidos detallados.',
                            style: TextStyle(
                              fontSize: AppTheme.fontSizeBody,
                              color: AppTheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  FaIcon(
                    FontAwesomeIcons.chevronRight,
                    size: 20,
                    color: AppTheme.outline,
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(AppTheme.borderRadiusXl),
                bottomRight: Radius.circular(AppTheme.borderRadiusXl),
              ),
              child: SizedBox(
                height: 160,
                width: double.infinity,
                child: Stack(
                  children: [
                    Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuD3BFSvr6hYxxMsOPEcMSLN7NPI-ltv2QulW3U2ed9kISHNdT4lSGtlX_OykKMVv9Sf3cmEEkB3alcT4uEBM6fPI_l7vK9RTFJvflZ8ZRflRWuBFb21o8NbhYxCcYe5T3cdgesrakl6WKU1dO7YRsygm_a4cOKHRJSSSl7jUNJkrDytGbcnD_UrIBwTtfloygUJAXswSfwazHhVdY3Tcol5HIqfAsnw8tItcKPpV3r-2m1a8grgvM3omQVm5Dk049Gege81p3Mg5AK0',
                      width: double.infinity,
                      height: 160,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 160,
                          color: AppTheme.surfaceContainer,
                          child: const Center(
                            child: FaIcon(
                              FontAwesomeIcons.chartLine,
                              size: 48,
                              color: AppTheme.outline,
                            ),
                          ),
                        );
                      },
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.2),
                            Colors.transparent,
                          ],
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

  Widget _buildGrowthCard() {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FaIcon(
            FontAwesomeIcons.chartLine,
            size: 40,
            color: AppTheme.onPrimaryContainer,
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Text(
            'CRECIMIENTO MENSUAL',
            style: TextStyle(
              fontSize: AppTheme.fontSizeSmall,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              color: AppTheme.onPrimaryContainer.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            '+24.8%',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w800,
              color: AppTheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Text(
            'Basado en el último reporte de ventas.',
            style: TextStyle(
              fontSize: AppTheme.fontSizeBody,
              color: AppTheme.onPrimaryContainer.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentsCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PaymentsManagementScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppTheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
                  ),
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.moneyBill,
                      size: 28,
                      color: AppTheme.onTertiaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingLg),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pagos',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeTitle,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Historial de ingresos y cobranzas.',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeBody,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            FaIcon(
              FontAwesomeIcons.chevronRight,
              size: 20,
              color: AppTheme.outline,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProductsDashboardScreen()), // O la pantalla de productos que tengas
        );
      },
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryContainer.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
                  ),
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.box,
                      size: 28,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingLg),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Productos',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeTitle,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Inventario y gestión de productos.',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeBody,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            FaIcon(
              FontAwesomeIcons.chevronRight,
              size: 20,
              color: AppTheme.outline,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpensesCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ExpensesDashboardScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppTheme.errorContainer, // Color para gastos
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
                  ),
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.moneyBillTrendUp, // Icono de gastos
                      size: 28,
                      color: AppTheme.onErrorContainer,
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingLg),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gastos',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeTitle,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Control detallado de egresos.',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeBody,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const FaIcon(
              FontAwesomeIcons.chevronRight,
              size: 20,
              color: AppTheme.outline,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfitsCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfitsScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryFixed,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
                  ),
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.chartLine,
                      size: 28,
                      color: AppTheme.onSecondaryFixed,
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingLg),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ganancias',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeTitle,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Análisis de rentabilidad neta.',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeBody,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            FaIcon(
              FontAwesomeIcons.chevronRight,
              size: 20,
              color: AppTheme.outline,
            ),
          ],
        ),
      ),
    );
  }
}