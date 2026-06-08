import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pedidos/models/budget_category_model.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';

class BudgetComparisonScreen extends StatefulWidget {
  const BudgetComparisonScreen({super.key});

  @override
  State<BudgetComparisonScreen> createState() => _BudgetComparisonScreenState();
}

class _BudgetComparisonScreenState extends State<BudgetComparisonScreen> {
  String _selectedPeriod = 'Mensual';
  final List<String> _periods = ['Mensual', 'Trimestral', 'Semestral', 'Anual'];
  int _selectedMonth = 4; // Mayo (0-indexed)
  int _selectedYear = 2025;

  // Datos de presupuesto vs real por categoría
  final List<BudgetCategory> _budgetCategories = [
    BudgetCategory(
      name: 'Ventas',
      budgeted: 120000.00,
      actual: 125000.00,
      icon: FontAwesomeIcons.cartShopping,
      color: AppTheme.primary,
    ),
    BudgetCategory(
      name: 'Costo de Ventas',
      budgeted: 65000.00,
      actual: 62000.00,
      icon: FontAwesomeIcons.box,
      color: AppTheme.secondary,
    ),
    BudgetCategory(
      name: 'Gastos Operativos',
      budgeted: 28000.00,
      actual: 26500.00,
      icon: FontAwesomeIcons.gear,
      color: AppTheme.tertiary,
    ),
    BudgetCategory(
      name: 'Gastos Administrativos',
      budgeted: 18000.00,
      actual: 17200.00,
      icon: FontAwesomeIcons.users,
      color: AppTheme.warning,
    ),
    BudgetCategory(
      name: 'Gastos de Ventas',
      budgeted: 12000.00,
      actual: 10800.00,
      icon: FontAwesomeIcons.bullhorn,
      color: AppTheme.error,
    ),
    BudgetCategory(
      name: 'Inversiones',
      budgeted: 15000.00,
      actual: 8000.00,
      icon: FontAwesomeIcons.chartLine,
      color: Colors.purple,
    ),
  ];

  double get _totalBudgeted => _budgetCategories.fold(0, (sum, item) => sum + item.budgeted);
  double get _totalActual => _budgetCategories.fold(0, (sum, item) => sum + item.actual);
  double get _totalVariance => _totalActual - _totalBudgeted;
  double get _totalVariancePercentage => (_totalVariance / _totalBudgeted) * 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: CustomTopAppBar(
          title: 'Comparativa presupuesto',
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
          actions:[
            AppBarButton(
                icon: FontAwesomeIcons.save,
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
                  // Resumen de presupuesto
                  _buildBudgetSummary(),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Gráfico comparativo
                  _buildComparisonChart(),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Tabla de categorías
                  _buildCategoriesTable(),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Análisis de variación
                  _buildVarianceAnalysis(),
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

  Widget _buildBudgetSummary() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            title: 'Presupuestado',
            value: '\$${_totalBudgeted.toStringAsFixed(2)}',
            icon: FontAwesomeIcons.chartLine,
            color: AppTheme.primary,
            bgColor: AppTheme.primaryContainer.withValues(alpha: 0.2),
          ),
        ),
        const SizedBox(width: AppTheme.spacingLg),
        Expanded(
          child: _buildSummaryCard(
            title: 'Real',
            value: '\$${_totalActual.toStringAsFixed(2)}',
            icon: FontAwesomeIcons.circleCheck,
            color: AppTheme.secondary,
            bgColor: AppTheme.secondaryContainer.withValues(alpha: 0.2),
          ),
        ),
        const SizedBox(width: AppTheme.spacingLg),
        Expanded(
          child: _buildSummaryCard(
            title: 'Variación',
            value: '${_totalVariance >= 0 ? '+' : ''}\$${_totalVariance.toStringAsFixed(2)}',
            subtitle: '${_totalVariancePercentage >= 0 ? '+' : ''}${_totalVariancePercentage.toStringAsFixed(1)}%',
            icon: _totalVariance >= 0 ? FontAwesomeIcons.arrowUp : FontAwesomeIcons.arrowDown,
            color: _totalVariance >= 0 ? AppTheme.secondary : AppTheme.error,
            bgColor: _totalVariance >= 0
                ? AppTheme.secondaryContainer.withValues(alpha: 0.2)
                : AppTheme.errorContainer.withValues(alpha: 0.2),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    String? subtitle,
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
          if (subtitle != null)
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildComparisonChart() {
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
                'Comparativa por Categoría',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeTitle,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurface,
                ),
              ),
              FaIcon(
                FontAwesomeIcons.chartSimple,
                size: 20,
                color: AppTheme.outline,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          SizedBox(
            height: 300,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _budgetCategories.map((e) => e.budgeted).reduce((a, b) => a > b ? a : b) * 1.2,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < _budgetCategories.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Transform.rotate(
                              angle: -0.5,
                              child: Text(
                                _budgetCategories[value.toInt()].name,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: 50,
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
                barGroups: _budgetCategories.asMap().entries.map((entry) {
                  final index = entry.key;
                  final category = entry.value;
                  return BarChartGroupData(
                    x: index,
                    barsSpace: 4,
                    barRods: [
                      BarChartRodData(
                        toY: category.budgeted,
                        color: AppTheme.primary,
                        width: 16,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      BarChartRodData(
                        toY: category.actual,
                        color: AppTheme.secondary,
                        width: 16,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Presupuestado', AppTheme.primary),
              const SizedBox(width: AppTheme.spacingLg),
              _buildLegendItem('Real', AppTheme.secondary),
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

  Widget _buildCategoriesTable() {
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
            child: Text(
              'Detalle por Categoría',
              style: TextStyle(
                fontSize: AppTheme.fontSizeTitle,
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurface,
              ),
            ),
          ),
          const Divider(height: 0, color: AppTheme.outlineVariant),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 32,
              headingRowColor: WidgetStateProperty.resolveWith(
                    (states) => AppTheme.surfaceContainerLow,
              ),
              columns: const [
                DataColumn(label: Text('Categoría', style: TextStyle(fontWeight: FontWeight.w600))),
                DataColumn(label: Text('Presupuestado', style: TextStyle(fontWeight: FontWeight.w600))),
                DataColumn(label: Text('Real', style: TextStyle(fontWeight: FontWeight.w600))),
                DataColumn(label: Text('Variación', style: TextStyle(fontWeight: FontWeight.w600))),
                DataColumn(label: Text('Cumplimiento', style: TextStyle(fontWeight: FontWeight.w600))),
              ],
              rows: _budgetCategories.map((category) {
                final variance = category.actual - category.budgeted;
                final percentage = (category.actual / category.budgeted) * 100;
                final isPositive = variance >= 0;

                return DataRow(
                  cells: [
                    DataCell(
                      Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: category.color.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
                            ),
                            child: Center(
                              child: FaIcon(
                                category.icon,
                                size: 14,
                                color: category.color,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingSm),
                          Text(category.name),
                        ],
                      ),
                    ),
                    DataCell(Text('\$${category.budgeted.toStringAsFixed(2)}')),
                    DataCell(Text('\$${category.actual.toStringAsFixed(2)}')),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingSm,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isPositive
                              ? AppTheme.secondaryContainer.withValues(alpha: 0.2)
                              : AppTheme.errorContainer.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FaIcon(
                              isPositive ? FontAwesomeIcons.arrowUp : FontAwesomeIcons.arrowDown,
                              size: 10,
                              color: isPositive ? AppTheme.secondary : AppTheme.error,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${variance >= 0 ? '+' : ''}\$${variance.abs().toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isPositive ? AppTheme.secondary : AppTheme.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    DataCell(
                      Row(
                        children: [
                          SizedBox(
                            width: 60,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                              child: LinearProgressIndicator(
                                value: percentage / 100,
                                backgroundColor: AppTheme.surfaceContainerHigh,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  percentage >= 100 ? AppTheme.secondary : AppTheme.warning,
                                ),
                                minHeight: 6,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingSm),
                          Text(
                            '${percentage.toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: percentage >= 100 ? AppTheme.secondary : AppTheme.warning,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVarianceAnalysis() {
    final positiveVariances = _budgetCategories.where((c) => c.actual > c.budgeted);
    final negativeVariances = _budgetCategories.where((c) => c.actual < c.budgeted);
    final topPositive = positiveVariances.isNotEmpty
        ? positiveVariances.reduce((a, b) => (a.actual - a.budgeted) > (b.actual - b.budgeted) ? a : b)
        : null;
    final topNegative = negativeVariances.isNotEmpty
        ? negativeVariances.reduce((a, b) => (a.budgeted - a.actual) > (b.budgeted - b.actual) ? a : b)
        : null;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Análisis de Variaciones',
            style: TextStyle(
              fontSize: AppTheme.fontSizeTitle,
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurface,
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Row(
            children: [
              Expanded(
                child: _buildVarianceCard(
                  title: 'Mayor Sobrecumplimiento',
                  category: topPositive?.name ?? 'N/A',
                  variance: topPositive != null ? topPositive.actual - topPositive.budgeted : 0,
                  isPositive: true,
                  icon: FontAwesomeIcons.arrowUp,
                ),
              ),
              const SizedBox(width: AppTheme.spacingLg),
              Expanded(
                child: _buildVarianceCard(
                  title: 'Mayor Desviación Negativa',
                  category: topNegative?.name ?? 'N/A',
                  variance: topNegative != null ? topNegative.budgeted - topNegative.actual : 0,
                  isPositive: false,
                  icon: FontAwesomeIcons.arrowDown,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Eficiencia General',
                        style: TextStyle(
                          fontSize: AppTheme.fontSizeLabel,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${(_totalActual / _totalBudgeted * 100).toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: _totalActual >= _totalBudgeted ? AppTheme.secondary : AppTheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: AppTheme.outlineVariant,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Categorías',
                        style: TextStyle(
                          fontSize: AppTheme.fontSizeLabel,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildStatBadge(
                            count: positiveVariances.length,
                            label: 'Sobrecumplen',
                            color: AppTheme.secondary,
                          ),
                          const SizedBox(width: AppTheme.spacingMd),
                          _buildStatBadge(
                            count: negativeVariances.length,
                            label: 'Subcumplen',
                            color: AppTheme.error,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVarianceCard({
    required String title,
    required String category,
    required double variance,
    required bool isPositive,
    required FaIconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(
          color: isPositive ? AppTheme.secondary.withValues(alpha: 0.3) : AppTheme.error.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: AppTheme.fontSizeSmall,
              fontWeight: FontWeight.w500,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Row(
            children: [
              FaIcon(
                icon,
                size: 16,
                color: isPositive ? AppTheme.secondary : AppTheme.error,
              ),
              const SizedBox(width: AppTheme.spacingSm),
              Expanded(
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeBody,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${isPositive ? '+' : '-'}\$${variance.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: AppTheme.fontSizeTitle,
              fontWeight: FontWeight.w800,
              color: isPositive ? AppTheme.secondary : AppTheme.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBadge({
    required int count,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd, vertical: AppTheme.spacingSm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: AppTheme.fontSizeTitle,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}