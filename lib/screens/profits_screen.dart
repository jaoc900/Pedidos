import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pedidos/models/monthly_model.dart';
import 'package:pedidos/models/movement_model.dart';
import 'package:pedidos/enums/movement_enum.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';

class ProfitsScreen extends StatelessWidget {
  const ProfitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // TopAppBar con backbutton y perfil
          _buildTopAppBar(context),
          // Contenido principal
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingXl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary Section (Bento Inspired Cards)
                  _buildSummarySection(),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Chart Section: Comparativa Mensual
                  _buildMonthlyChart(),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Movimientos Recientes Section
                  _buildRecentMovements(),
                  const SizedBox(height: AppTheme.spacingXl * 2),
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
      title: 'Ganancias',
      showBackButton: true,
      onBackPressed: () => Navigator.pop(context),
    );
  }

  Widget _buildSummarySection() {
    return Column(
      children: [
        // Tarjeta principal: Ganancia Neta
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppTheme.spacingXl),
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
                    'Ganancia Neta',
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeLabel,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$12,450.00',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingSm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.arrowUp,
                          size: 12,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '+8.4%',
                          style: TextStyle(
                            fontSize: AppTheme.fontSizeSmall,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                right: -40,
                bottom: -40,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppTheme.spacingLg),
        // Tarjetas de Ingresos y Gastos
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: 'Total de Ingresos',
                value: '\$24,800',
                change: '+5.2%',
                icon: FontAwesomeIcons.arrowDown,
                iconColor: AppTheme.primary,
                changeColor: AppTheme.primary,
              ),
            ),
            const SizedBox(width: AppTheme.spacingLg),
            Expanded(
              child: _buildMetricCard(
                title: 'Total de Gastos',
                value: '\$12,350',
                change: '+2.1%',
                icon: FontAwesomeIcons.arrowUp,
                iconColor: AppTheme.error,
                changeColor: AppTheme.error,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String change,
    required FaIconData icon,
    required Color iconColor,
    required Color changeColor,
  }) {
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
              FaIcon(
                icon,
                size: 20,
                color: iconColor,
              ),
              Text(
                change,
                style: TextStyle(
                  fontSize: AppTheme.fontSizeSmall,
                  fontWeight: FontWeight.w700,
                  color: changeColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Text(
            title,
            style: TextStyle(
              fontSize: AppTheme.fontSizeLabel,
              fontWeight: FontWeight.w500,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: AppTheme.fontSizeTitle,
              fontWeight: FontWeight.w700,
              color: AppTheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyChart() {
    // Datos de ejemplo para Ingresos y Gastos por mes
    final List<MonthlyData> monthlyData = [
      MonthlyData(month: 'ENE', income: 60, expense: 80),
      MonthlyData(month: 'FEB', income: 70, expense: 60),
      MonthlyData(month: 'MAR', income: 40, expense: 90),
      MonthlyData(month: 'ABR', income: 85, expense: 75),
      MonthlyData(month: 'MAY', income: 55, expense: 95),
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
                'Comparativa Mensual',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeTitle,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurface,
                ),
              ),
              FaIcon(
                FontAwesomeIcons.ellipsisVertical,
                size: 20,
                color: AppTheme.outline,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingXl),
          // Gráfica de barras
          SizedBox(
            height: 160,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < monthlyData.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              monthlyData[value.toInt()].month,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.outline,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}%',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppTheme.outline,
                          ),
                        );
                      },
                      reservedSize: 35,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppTheme.outlineVariant.withValues(alpha: 0.3),
                      strokeWidth: 1,
                    );
                  },
                ),
                barGroups: monthlyData.asMap().entries.map((entry) {
                  int index = entry.key;
                  MonthlyData data = entry.value;
                  return BarChartGroupData(
                    x: index,
                    barsSpace: 4, // ← Cambiado: groupingSpace ya no existe, usar barsSpace
                    barRods: [
                      BarChartRodData(
                        toY: data.income.toDouble(),
                        color: AppTheme.primary,
                        width: 12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      BarChartRodData(
                        toY: data.expense.toDouble(),
                        color: AppTheme.primary.withValues(alpha: 0.2),
                        width: 12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          // Leyenda
          Row(
            children: [
              _buildLegendItem('Ingresos', AppTheme.primary),
              const SizedBox(width: AppTheme.spacingLg),
              _buildLegendItem('Gastos', AppTheme.primary.withValues(alpha: 0.2)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: AppTheme.fontSizeSmall,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentMovements() {
    final movements = [
      MovementData(
        title: 'Suscripción Premium',
        description: 'Hace 2 horas • Factura #892',
        amount: '+\$540.00',
        type: MovementType.income,
        icon: FontAwesomeIcons.moneyBill,
        iconBgColor: AppTheme.secondaryContainer,
        iconColor: AppTheme.secondary,
      ),
      MovementData(
        title: 'Cloud Hosting Services',
        description: 'Ayer • Servicios',
        amount: '-\$1,200.00',
        type: MovementType.expense,
        icon: FontAwesomeIcons.receipt,
        iconBgColor: AppTheme.errorContainer,
        iconColor: AppTheme.error,
      ),
      MovementData(
        title: 'Venta de Hardware',
        description: '24 Mayo • Cliente Corporativo',
        amount: '+\$3,250.00',
        type: MovementType.income,
        icon: FontAwesomeIcons.cartShopping,
        iconBgColor: AppTheme.secondaryContainer,
        iconColor: AppTheme.secondary,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Movimientos Recientes',
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
        ...movements.map((movement) => Padding(
          padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
          child: _buildMovementItem(movement),
        )),
      ],
    );
  }

  Widget _buildMovementItem(MovementData movement) {
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
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: movement.iconBgColor,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
            ),
            child: Center(
              child: FaIcon(
                movement.icon,
                size: 24,
                color: movement.iconColor,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingLg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movement.title,
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeLabel,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  movement.description,
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeSmall,
                    color: AppTheme.outline,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                movement.amount,
                style: TextStyle(
                  fontSize: AppTheme.fontSizeLabel,
                  fontWeight: FontWeight.w700,
                  color: movement.type == MovementType.income
                      ? AppTheme.primary
                      : AppTheme.error,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                movement.type == MovementType.income ? 'Recibido' : 'Pagado',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: movement.type == MovementType.income
                      ? AppTheme.primary
                      : AppTheme.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}