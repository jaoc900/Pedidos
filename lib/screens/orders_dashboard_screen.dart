import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/screens/painters/donut_chart_painter.dart';
import 'package:pedidos/models/kpi_model.dart';
import 'package:pedidos/models/bar_data_model.dart';
import 'package:pedidos/models/order_data_model.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';

class OrdersDashboardScreen extends StatelessWidget {
  const OrdersDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: CustomTopAppBar(
        title: 'Gestión de Órdenes',
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Contenido principal
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingXl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // KPI Section (Horizontal Scroll)
                  _buildKPISection(),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Charts Grid
                  _buildChartsGrid(),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Recent Orders List
                  _buildRecentOrders(),
                  const SizedBox(height: AppTheme.spacingXl * 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKPISection() {
    final kpis = [
      KPIData(title: 'Total Órdenes', value: '1,284', color: AppTheme.primary),
      KPIData(title: 'Pendientes', value: '56', color: AppTheme.error),
      KPIData(title: 'En camino', value: '142', color: AppTheme.secondary),
      KPIData(title: 'Eficiencia', value: '98.4%', color: AppTheme.tertiary),
    ];

    return SizedBox(
      height: 120,
      child: Row(
        children: kpis.map((kpi) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingSm),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    kpi.title,
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeSmall,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    kpi.value,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: kpi.color,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChartsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 700;

        if (isDesktop) {
          return SizedBox(
            height: 200, // 👈 altura uniforme para ambos charts
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox.expand(child: _buildBarChartCard()),
                ),
                const SizedBox(width: AppTheme.spacingLg),
                Expanded(
                  flex: 1,
                  child: SizedBox.expand(child: _buildDonutChartCard()),
                ),
              ],
            ),
          );
        } else {
          return Column(
            children: [
              _buildBarChartCard(),
              const SizedBox(height: AppTheme.spacingLg),
              _buildDonutChartCard(),
            ],
          );
        }
      },
    );
  }

  Widget _buildBarChartCard() {
    // Datos de ejemplo para la gráfica de barras
    final List<BarData> bars = [
      BarData(day: 'L', height: 40, isHighlighted: false),
      BarData(day: 'M', height: 65, isHighlighted: false),
      BarData(day: 'X', height: 90, isHighlighted: true),
      BarData(day: 'J', height: 50, isHighlighted: false),
      BarData(day: 'V', height: 75, isHighlighted: false),
      BarData(day: 'S', height: 60, isHighlighted: false),
      BarData(day: 'D', height: 85, isHighlighted: false),
    ];

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Volumen de Pedidos',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeLabel,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.onSurface,
                ),
              ),
              FaIcon(
                FontAwesomeIcons.ellipsisVertical,
                size: 16,
                color: AppTheme.onSurfaceVariant,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          // Gráfica de barras
          SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: bars.map((bar) {
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: bar.height,
                        decoration: BoxDecoration(
                          color: bar.isHighlighted
                              ? AppTheme.primary
                              : AppTheme.primaryContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          // Días
          Row(
            children: bars.map((bar) {
              return Expanded(
                child: Center(
                  child: Text(
                    bar.day,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: bar.isHighlighted
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: bar.isHighlighted
                          ? AppTheme.primary
                          : AppTheme.onSurfaceVariant,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDonutChartCard() {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Leyenda - usa Flexible para que no fuerce ancho infinito
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Distribución',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeLabel,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingLg),
                _buildLegendItem('Completado (70%)', AppTheme.primary),
                const SizedBox(height: AppTheme.spacingSm),
                _buildLegendItem('En camino (20%)', AppTheme.secondary),
                const SizedBox(height: AppTheme.spacingSm),
                _buildLegendItem('Pendiente (10%)', AppTheme.error),
              ],
            ),
          ),
          const SizedBox(width: AppTheme.spacingLg),
          // Donut Chart
          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(100, 100),
                  painter: DonutChartPainter(
                    percentages: [70, 20, 10],
                    colors: [
                      AppTheme.primary,
                      AppTheme.secondary,
                      AppTheme.error,
                    ],
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Flexible(
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppTheme.spacingSm),

          // La clave: el texto debe ajustarse al espacio disponible
          Expanded(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,  // evita overflow
              softWrap: false,                  // evita salto inesperado
              style: TextStyle(
                fontSize: AppTheme.fontSizeSmall,
                fontWeight: FontWeight.w500,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentOrders() {
    final orders = [
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
                fontWeight: FontWeight.w700,
                color: AppTheme.onSurface,
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(foregroundColor: AppTheme.primary),
              child: const Text('Ver todo'),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingLg),
        ...orders.map(
          (order) => Padding(
            padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
            child: _buildOrderCard(order),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderCard(OrderData order) {
    return Container(
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    order.id,
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeLabel,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingSm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingSm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: order.statusBgColor,
                      borderRadius: BorderRadius.circular(
                        AppTheme.borderRadiusFull,
                      ),
                    ),
                    child: Text(
                      order.status,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: order.statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                order.client,
                style: TextStyle(
                  fontSize: AppTheme.fontSizeBody,
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '\$${order.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeSmall,
                  color: AppTheme.outline,
                ),
              ),
            ],
          ),
          FaIcon(
            FontAwesomeIcons.chevronRight,
            size: 20,
            color: AppTheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
