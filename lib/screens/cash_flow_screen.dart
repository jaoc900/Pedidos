import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pedidos/models/cashflow_model.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';

class CashFlowScreen extends StatefulWidget {
  const CashFlowScreen({super.key});

  @override
  State<CashFlowScreen> createState() => _CashFlowScreenState();
}

class _CashFlowScreenState extends State<CashFlowScreen> {
  String _selectedPeriod = 'Semanal';
  final List<String> _periods = ['Semanal', 'Mensual', 'Trimestral'];
  int _selectedWeek = 2;
  int _selectedYear = 2025;

  // Datos de ejemplo
  final List<CashFlowItem> _cashInflows = [
    CashFlowItem(description: 'Cobro a Clientes', amount: 45000.00, date: DateTime(2025, 5, 15), category: 'Operativo'),
    CashFlowItem(description: 'Ventas de Contado', amount: 28000.00, date: DateTime(2025, 5, 18), category: 'Operativo'),
    CashFlowItem(description: 'Anticipo Cliente', amount: 12000.00, date: DateTime(2025, 5, 20), category: 'Operativo'),
    CashFlowItem(description: 'Intereses Ganados', amount: 850.00, date: DateTime(2025, 5, 10), category: 'Financiero'),
  ];

  final List<CashFlowItem> _cashOutflows = [
    CashFlowItem(description: 'Pago a Proveedores', amount: 32000.00, date: DateTime(2025, 5, 14), category: 'Operativo'),
    CashFlowItem(description: 'Nómina', amount: 18500.00, date: DateTime(2025, 5, 5), category: 'Operativo'),
    CashFlowItem(description: 'Servicios Públicos', amount: 5200.00, date: DateTime(2025, 5, 12), category: 'Operativo'),
    CashFlowItem(description: 'Arrendamiento', amount: 15000.00, date: DateTime(2025, 5, 1), category: 'Operativo'),
    CashFlowItem(description: 'Equipo de Cómputo', amount: 8000.00, date: DateTime(2025, 5, 8), category: 'Inversión'),
    CashFlowItem(description: 'Pago de Impuestos', amount: 12500.00, date: DateTime(2025, 5, 22), category: 'Operativo'),
  ];

  double get _totalInflows => _cashInflows.fold(0, (sum, item) => sum + item.amount);
  double get _totalOutflows => _cashOutflows.fold(0, (sum, item) => sum + item.amount);
  double get _netCashFlow => _totalInflows - _totalOutflows;
  double get _initialCash => 150000.00;
  double get _finalCash => _initialCash + _netCashFlow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          _buildTopAppBar(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingXl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Selector de período
                  _buildPeriodSelector(),
                  const SizedBox(height: AppTheme.spacingLg),
                  // Resumen de flujo de caja
                  _buildCashFlowSummary(),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Gráfico de flujo de caja
                  _buildCashFlowChart(),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Entradas de efectivo
                  _buildCashInflowsSection(),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Salidas de efectivo
                  _buildCashOutflowsSection(),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Saldo final
                  _buildFinalBalanceCard(),
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
        title: 'Flujo de caja',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
        actions:[
          AppBarButton(
              icon: FontAwesomeIcons.save,
              onPressed: () =>{})
        ]
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingSm),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: AppTheme.outlineVariant),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Selector de semana/mes
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_selectedWeek > 1) {
                          _selectedWeek--;
                        }
                      });
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceContainer,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.chevronLeft,
                          size: 14,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Semana $_selectedWeek, $_selectedYear',
                        style: TextStyle(
                          fontSize: AppTheme.fontSizeBody,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_selectedWeek < 52) {
                          _selectedWeek++;
                        }
                      });
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceContainer,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.chevronRight,
                          size: 14,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Selector de período
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainer,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedPeriod,
                icon: FaIcon(
                  FontAwesomeIcons.chevronDown,
                  size: 14,
                  color: AppTheme.primary,
                ),
                items: _periods.map((String period) {
                  return DropdownMenuItem<String>(
                    value: period,
                    child: Text(
                      period,
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeLabel,
                        color: AppTheme.onSurface,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPeriod = newValue!;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCashFlowSummary() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            title: 'Entradas',
            value: '\$${_totalInflows.toStringAsFixed(2)}',
            icon: FontAwesomeIcons.arrowDown,
            color: AppTheme.secondary,
            bgColor: AppTheme.secondaryContainer.withValues(alpha: 0.2),
          ),
        ),
        const SizedBox(width: AppTheme.spacingLg),
        Expanded(
          child: _buildSummaryCard(
            title: 'Salidas',
            value: '\$${_totalOutflows.toStringAsFixed(2)}',
            icon: FontAwesomeIcons.arrowUp,
            color: AppTheme.error,
            bgColor: AppTheme.errorContainer.withValues(alpha: 0.2),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required FaIconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: AppTheme.fontSizeSmall,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
              FaIcon(
                icon,
                size: 20,
                color: color,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppTheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCashFlowChart() {
    final weeks = ['Sem 1', 'Sem 2', 'Sem 3', 'Sem 4'];
    final inflowData = [32000.0, 28000.0, 45000.0, 35000.0];
    final outflowData = [25000.0, 22000.0, 38000.0, 28000.0];

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
                'Flujo de Caja Semanal',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeTitle,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurface,
                ),
              ),
              FaIcon(
                FontAwesomeIcons.chartLine,
                size: 20,
                color: AppTheme.outline,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 50000,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < weeks.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              weeks[value.toInt()],
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
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
                          '\$${(value / 1000).toStringAsFixed(0)}k',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppTheme.outline,
                          ),
                        );
                      },
                      reservedSize: 45,
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
                  horizontalInterval: 10000,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppTheme.outlineVariant.withValues(alpha: 0.3),
                      strokeWidth: 1,
                    );
                  },
                ),
                barGroups: List.generate(weeks.length, (index) {
                  return BarChartGroupData(
                    x: index,
                    barsSpace: 4,
                    barRods: [
                      BarChartRodData(
                        toY: inflowData[index],
                        color: AppTheme.secondary,
                        width: 16,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      BarChartRodData(
                        toY: outflowData[index],
                        color: AppTheme.error,
                        width: 16,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Entradas', AppTheme.secondary),
              const SizedBox(width: AppTheme.spacingLg),
              _buildLegendItem('Salidas', AppTheme.error),
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
            fontWeight: FontWeight.w500,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildCashInflowsSection() {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.secondary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingSm),
                Text(
                  'ENTRADAS DE EFECTIVO',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeLabel,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    color: AppTheme.onSurface,
                  ),
                ),
                const Spacer(),
                Text(
                  '\$${_totalInflows.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeLabel,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.secondary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0, color: AppTheme.outlineVariant),
          ..._cashInflows.map((item) => _buildCashFlowItem(item, isInflow: true)),
        ],
      ),
    );
  }

  Widget _buildCashOutflowsSection() {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.error,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingSm),
                Text(
                  'SALIDAS DE EFECTIVO',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeLabel,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    color: AppTheme.onSurface,
                  ),
                ),
                const Spacer(),
                Text(
                  '\$${_totalOutflows.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeLabel,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.error,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0, color: AppTheme.outlineVariant),
          ..._cashOutflows.map((item) => _buildCashFlowItem(item, isInflow: false)),
        ],
      ),
    );
  }

  Widget _buildCashFlowItem(CashFlowItem item, {required bool isInflow}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg, vertical: AppTheme.spacingMd),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isInflow
                  ? AppTheme.secondaryContainer.withValues(alpha: 0.2)
                  : AppTheme.errorContainer.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
            ),
            child: Center(
              child: FaIcon(
                isInflow ? FontAwesomeIcons.arrowDown : FontAwesomeIcons.arrowUp,
                size: 14,
                color: isInflow ? AppTheme.secondary : AppTheme.error,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingLg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.description,
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeBody,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingSm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusSm),
                      ),
                      child: Text(
                        item.category,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingSm),
                    Text(
                      _formatDate(item.date),
                      style: TextStyle(
                        fontSize: 10,
                        color: AppTheme.outline,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            '${isInflow ? '+' : '-'}\$${item.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: AppTheme.fontSizeBody,
              fontWeight: FontWeight.w700,
              color: isInflow ? AppTheme.secondary : AppTheme.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinalBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          _buildBalanceRow(
            label: 'Saldo Inicial',
            value: _initialCash,
            color: AppTheme.onSurface,
          ),
          const SizedBox(height: AppTheme.spacingSm),
          _buildBalanceRow(
            label: 'Flujo Neto del Período',
            value: _netCashFlow,
            color: _netCashFlow >= 0 ? AppTheme.secondary : AppTheme.error,
            showSign: true,
          ),
          const Divider(),
          const SizedBox(height: AppTheme.spacingSm),
          _buildBalanceRow(
            label: 'Saldo Final',
            value: _finalCash,
            color: _finalCash >= 0 ? AppTheme.secondary : AppTheme.error,
            isBold: true,
            isLarge: true,
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceRow({
    required String label,
    required double value,
    required Color color,
    bool showSign = false,
    bool isBold = false,
    bool isLarge = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isLarge ? AppTheme.fontSizeTitle : AppTheme.fontSizeBody,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
        Text(
          '${showSign && value >= 0 ? '+' : ''}\$${value.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isLarge ? AppTheme.fontSizeTitle : AppTheme.fontSizeBody,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}