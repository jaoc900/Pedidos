import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';

class IncomeStatementScreen extends StatefulWidget {
  const IncomeStatementScreen({super.key});

  @override
  State<IncomeStatementScreen> createState() => _IncomeStatementScreenState();
}

class _IncomeStatementScreenState extends State<IncomeStatementScreen> {
  String _selectedPeriod = 'Mensual';
  final List<String> _periods = ['Mensual', 'Trimestral', 'Semestral', 'Anual'];
  int _selectedMonth = 4; // Mayo (0-indexed)
  int _selectedYear = 2025;

  // Datos de ejemplo
  final Map<String, double> _incomeData = {
    'Venta de Productos': 125000,
    'Servicios': 35000,
    'Otros Ingresos': 5000,
  };

  final Map<String, double> _expenseData = {
    'Costo de Ventas': 65000,
    'Gastos Operativos': 25000,
    'Gastos Administrativos': 15000,
    'Gastos de Ventas': 8000,
  };

  double get _totalIncome => _incomeData.values.reduce((a, b) => a + b);
  double get _totalExpenses => _expenseData.values.reduce((a, b) => a + b);
  double get _grossProfit => _totalIncome - (_expenseData['Costo de Ventas'] ?? 0);
  double get _operatingProfit => _grossProfit - (_expenseData['Gastos Operativos'] ?? 0) - (_expenseData['Gastos Administrativos'] ?? 0) - (_expenseData['Gastos de Ventas'] ?? 0);
  double get _netProfit => _totalIncome - _totalExpenses;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: CustomTopAppBar(
          title: 'Estado de resultados',
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
          actions:[
            AppBarButton(
                icon: FontAwesomeIcons.floppyDisk,
                onPressed: () =>{})
          ]
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingXl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Selector de período
                  _buildPeriodSelector(),
                  const SizedBox(height: AppTheme.spacingLg),
                  // Resumen de resultados
                  _buildSummaryCards(),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Gráfico comparativo
                  _buildComparativeChart(),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Detalle de ingresos
                  _buildIncomeSection(),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Detalle de gastos
                  _buildExpenseSection(),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Cálculo de resultados
                  _buildProfitCalculation(),
                  const SizedBox(height: AppTheme.spacingXl * 2),
                ],
              ),
            ),
          ),
        ],
      ),
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
          // Selector de mes/año
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_selectedMonth > 0) {
                          _selectedMonth--;
                        } else {
                          _selectedMonth = 11;
                          _selectedYear--;
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
                        '${_getMonthName(_selectedMonth)} $_selectedYear',
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
                        if (_selectedMonth < 11) {
                          _selectedMonth++;
                        } else {
                          _selectedMonth = 0;
                          _selectedYear++;
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

  String _getMonthName(int month) {
    const months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return months[month];
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            title: 'Ingresos Totales',
            value: '\$${_totalIncome.toStringAsFixed(2)}',
            icon: FontAwesomeIcons.arrowUp,
            color: AppTheme.secondary,
            bgColor: AppTheme.secondaryContainer.withValues(alpha: 0.2),
          ),
        ),
        const SizedBox(width: AppTheme.spacingLg),
        Expanded(
          child: _buildSummaryCard(
            title: 'Gastos Totales',
            value: '\$${_totalExpenses.toStringAsFixed(2)}',
            icon: FontAwesomeIcons.arrowDown,
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

  Widget _buildComparativeChart() {
    final months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'];
    final incomeData = [85000, 92000, 88000, 95000, 102000, 98000];
    final expenseData = [62000, 68000, 65000, 70000, 75000, 72000];

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
                maxY: 120000,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < months.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              months[value.toInt()],
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
                  horizontalInterval: 20000,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppTheme.outlineVariant.withValues(alpha: 0.3),
                      strokeWidth: 1,
                    );
                  },
                ),
                barGroups: List.generate(months.length, (index) {
                  return BarChartGroupData(
                    x: index,
                    barsSpace: 4,
                    barRods: [
                      BarChartRodData(
                        toY: incomeData[index].toDouble(),
                        color: AppTheme.secondary,
                        width: 16,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      BarChartRodData(
                        toY: expenseData[index].toDouble(),
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
              _buildLegendItem('Ingresos', AppTheme.secondary),
              const SizedBox(width: AppTheme.spacingLg),
              _buildLegendItem('Gastos', AppTheme.error),
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

  Widget _buildIncomeSection() {
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
                  'INGRESOS',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeLabel,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    color: AppTheme.onSurface,
                  ),
                ),
                const Spacer(),
                Text(
                  '\$${_totalIncome.toStringAsFixed(2)}',
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
          ..._incomeData.entries.map((entry) => _buildDetailRow(
            label: entry.key,
            value: entry.value,
            isIncome: true,
          )),
        ],
      ),
    );
  }

  Widget _buildExpenseSection() {
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
                  'GASTOS',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeLabel,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    color: AppTheme.onSurface,
                  ),
                ),
                const Spacer(),
                Text(
                  '\$${_totalExpenses.toStringAsFixed(2)}',
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
          ..._expenseData.entries.map((entry) => _buildDetailRow(
            label: entry.key,
            value: entry.value,
            isIncome: false,
          )),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required double value,
    required bool isIncome,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg, vertical: AppTheme.spacingMd),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: AppTheme.fontSizeBody,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
          Text(
            '\$${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: AppTheme.fontSizeBody,
              fontWeight: FontWeight.w600,
              color: isIncome ? AppTheme.secondary : AppTheme.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfitCalculation() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          _buildCalculationRow(
            label: 'Ingresos Totales',
            value: _totalIncome,
            color: AppTheme.secondary,
          ),
          _buildCalculationRow(
            label: '(-) Costo de Ventas',
            value: _expenseData['Costo de Ventas'] ?? 0,
            color: AppTheme.error,
            isSubtraction: true,
          ),
          const Divider(),
          _buildCalculationRow(
            label: 'Utilidad Bruta',
            value: _grossProfit,
            color: AppTheme.onSurface,
            isBold: true,
          ),
          const SizedBox(height: AppTheme.spacingSm),
          _buildCalculationRow(
            label: '(-) Gastos Operativos',
            value: (_expenseData['Gastos Operativos'] ?? 0) +
                (_expenseData['Gastos Administrativos'] ?? 0) +
                (_expenseData['Gastos de Ventas'] ?? 0),
            color: AppTheme.error,
            isSubtraction: true,
          ),
          const Divider(),
          _buildCalculationRow(
            label: 'Utilidad Operativa',
            value: _operatingProfit,
            color: AppTheme.onSurface,
            isBold: true,
          ),
          const SizedBox(height: AppTheme.spacingSm),
          _buildCalculationRow(
            label: 'Utilidad Neta del Ejercicio',
            value: _netProfit,
            color: _netProfit >= 0 ? AppTheme.secondary : AppTheme.error,
            isBold: true,
            isLarge: true,
          ),
        ],
      ),
    );
  }

  Widget _buildCalculationRow({
    required String label,
    required double value,
    required Color color,
    bool isSubtraction = false,
    bool isBold = false,
    bool isLarge = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingSm),
      child: Row(
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
            '${isSubtraction ? '-' : ''}\$${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isLarge ? AppTheme.fontSizeTitle : AppTheme.fontSizeBody,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}