import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pedidos/models/balance_item.dart';
import 'package:pedidos/models/composition_data_model.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';

class BalanceSheetScreen extends StatefulWidget {
  const BalanceSheetScreen({super.key});

  @override
  State<BalanceSheetScreen> createState() => _BalanceSheetScreenState();
}

class _BalanceSheetScreenState extends State<BalanceSheetScreen> {
  String _selectedPeriod = 'Mensual';
  final List<String> _periods = ['Mensual', 'Trimestral', 'Semestral', 'Anual'];
  int _selectedMonth = 4; // Mayo (0-indexed)
  int _selectedYear = 2025;

  // Datos de ejemplo - Activos
  final List<BalanceItem> _currentAssets = [
    BalanceItem(description: 'Efectivo y Equivalentes', amount: 125000.00, category: 'Corriente'),
    BalanceItem(description: 'Cuentas por Cobrar', amount: 85000.00, category: 'Corriente'),
    BalanceItem(description: 'Inventarios', amount: 95000.00, category: 'Corriente'),
    BalanceItem(description: 'Documentos por Cobrar', amount: 25000.00, category: 'Corriente'),
  ];

  final List<BalanceItem> _nonCurrentAssets = [
    BalanceItem(description: 'Propiedad, Planta y Equipo', amount: 450000.00, category: 'No Corriente'),
    BalanceItem(description: 'Depreciación Acumulada', amount: -85000.00, category: 'No Corriente'),
    BalanceItem(description: 'Activos Intangibles', amount: 35000.00, category: 'No Corriente'),
    BalanceItem(description: 'Inversiones a Largo Plazo', amount: 55000.00, category: 'No Corriente'),
  ];

  // Datos de ejemplo - Pasivos
  final List<BalanceItem> _currentLiabilities = [
    BalanceItem(description: 'Cuentas por Pagar', amount: 45000.00, category: 'Corriente'),
    BalanceItem(description: 'Documentos por Pagar', amount: 25000.00, category: 'Corriente'),
    BalanceItem(description: 'Impuestos por Pagar', amount: 12500.00, category: 'Corriente'),
    BalanceItem(description: 'Obligaciones Laborales', amount: 18500.00, category: 'Corriente'),
  ];

  final List<BalanceItem> _nonCurrentLiabilities = [
    BalanceItem(description: 'Préstamos Bancarios LP', amount: 180000.00, category: 'No Corriente'),
    BalanceItem(description: 'Obligaciones Financieras', amount: 45000.00, category: 'No Corriente'),
    BalanceItem(description: 'Provisiones', amount: 15000.00, category: 'No Corriente'),
  ];

  // Datos de ejemplo - Capital Contable
  final List<BalanceItem> _equity = [
    BalanceItem(description: 'Capital Social', amount: 250000.00, category: 'Capital'),
    BalanceItem(description: 'Reservas', amount: 35000.00, category: 'Capital'),
    BalanceItem(description: 'Utilidades Retenidas', amount: 42000.00, category: 'Capital'),
    BalanceItem(description: 'Utilidad del Ejercicio', amount: 18500.00, category: 'Capital'),
  ];

  double get _totalCurrentAssets => _currentAssets.fold(0, (sum, item) => sum + item.amount);
  double get _totalNonCurrentAssets => _nonCurrentAssets.fold(0, (sum, item) => sum + item.amount);
  double get _totalAssets => _totalCurrentAssets + _totalNonCurrentAssets;

  double get _totalCurrentLiabilities => _currentLiabilities.fold(0, (sum, item) => sum + item.amount);
  double get _totalNonCurrentLiabilities => _nonCurrentLiabilities.fold(0, (sum, item) => sum + item.amount);
  double get _totalLiabilities => _totalCurrentLiabilities + _totalNonCurrentLiabilities;

  double get _totalEquity => _equity.fold(0, (sum, item) => sum + item.amount);
  double get _totalLiabilitiesEquity => _totalLiabilities + _totalEquity;

  double get _workingCapital => _totalCurrentAssets - _totalCurrentLiabilities;
  double get _currentRatio => _totalCurrentAssets / _totalCurrentLiabilities;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: CustomTopAppBar(
          title: 'Balance general',
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
                  // Resumen de balance
                  _buildBalanceSummary(),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Gráfico de composición
                  _buildCompositionChart(),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Activos
                  _buildAssetsSection(),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Pasivos
                  _buildLiabilitiesSection(),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Capital Contable
                  _buildEquitySection(),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Indicadores financieros
                  _buildFinancialRatios(),
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

  Widget _buildBalanceSummary() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            title: 'Activos Totales',
            value: '\$${_totalAssets.toStringAsFixed(2)}',
            icon: FontAwesomeIcons.buildingColumns,
            color: AppTheme.secondary,
            bgColor: AppTheme.secondaryContainer.withValues(alpha: 0.2),
          ),
        ),
        const SizedBox(width: AppTheme.spacingLg),
        Expanded(
          child: _buildSummaryCard(
            title: 'Pasivos Totales',
            value: '\$${_totalLiabilities.toStringAsFixed(2)}',
            icon: FontAwesomeIcons.receipt,
            color: AppTheme.error,
            bgColor: AppTheme.errorContainer.withValues(alpha: 0.2),
          ),
        ),
        const SizedBox(width: AppTheme.spacingLg),
        Expanded(
          child: _buildSummaryCard(
            title: 'Capital Contable',
            value: '\$${_totalEquity.toStringAsFixed(2)}',
            icon: FontAwesomeIcons.chartLine,
            color: AppTheme.tertiary,
            bgColor: AppTheme.tertiaryContainer.withValues(alpha: 0.2),
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
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppTheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompositionChart() {
    final compositionData = [
      CompositionData(label: 'Activos', value: _totalAssets, color: AppTheme.secondary),
      CompositionData(label: 'Pasivos', value: _totalLiabilities, color: AppTheme.error),
      CompositionData(label: 'Capital', value: _totalEquity, color: AppTheme.tertiary),
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
          Text(
            'Composición del Balance',
            style: TextStyle(
              fontSize: AppTheme.fontSizeTitle,
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurface,
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _totalAssets * 1.2,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < compositionData.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              compositionData[value.toInt()].label,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.onSurfaceVariant,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: 40,
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
                  horizontalInterval: 50000,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppTheme.outlineVariant.withValues(alpha: 0.3),
                      strokeWidth: 1,
                    );
                  },
                ),
                barGroups: compositionData.asMap().entries.map((entry) {
                  final index = entry.key;
                  final data = entry.value;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: data.value,
                        color: data.color,
                        width: 40,
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
            children: compositionData.map((data) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
                child: _buildLegendItem(data.label, data.color),
              );
            }).toList(),
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

  Widget _buildAssetsSection() {
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
                  'ACTIVOS',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeLabel,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    color: AppTheme.onSurface,
                  ),
                ),
                const Spacer(),
                Text(
                  '\$${_totalAssets.toStringAsFixed(2)}',
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
          _buildSubsectionTitle('Activos Corrientes', _totalCurrentAssets),
          ..._currentAssets.map((item) => _buildBalanceItem(item)),
          _buildSubsectionTitle('Activos No Corrientes', _totalNonCurrentAssets),
          ..._nonCurrentAssets.map((item) => _buildBalanceItem(item)),
        ],
      ),
    );
  }

  Widget _buildLiabilitiesSection() {
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
                  'PASIVOS',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeLabel,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    color: AppTheme.onSurface,
                  ),
                ),
                const Spacer(),
                Text(
                  '\$${_totalLiabilities.toStringAsFixed(2)}',
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
          _buildSubsectionTitle('Pasivos Corrientes', _totalCurrentLiabilities),
          ..._currentLiabilities.map((item) => _buildBalanceItem(item)),
          _buildSubsectionTitle('Pasivos No Corrientes', _totalNonCurrentLiabilities),
          ..._nonCurrentLiabilities.map((item) => _buildBalanceItem(item)),
        ],
      ),
    );
  }

  Widget _buildEquitySection() {
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
                    color: AppTheme.tertiary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingSm),
                Text(
                  'CAPITAL CONTABLE',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeLabel,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    color: AppTheme.onSurface,
                  ),
                ),
                const Spacer(),
                Text(
                  '\$${_totalEquity.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeLabel,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.tertiary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0, color: AppTheme.outlineVariant),
          ..._equity.map((item) => _buildBalanceItem(item)),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TOTAL PASIVO + CAPITAL',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeBody,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.onSurface,
                  ),
                ),
                Text(
                  '\$${_totalLiabilitiesEquity.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeBody,
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

  Widget _buildSubsectionTitle(String title, double total) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppTheme.spacingLg, AppTheme.spacingMd, AppTheme.spacingLg, AppTheme.spacingSm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: AppTheme.fontSizeLabel,
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurface,
            ),
          ),
          Text(
            '\$${total.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: AppTheme.fontSizeLabel,
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceItem(BalanceItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg, vertical: AppTheme.spacingSm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item.description,
            style: TextStyle(
              fontSize: AppTheme.fontSizeBody,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
          Text(
            '\$${item.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: AppTheme.fontSizeBody,
              fontWeight: FontWeight.w500,
              color: item.amount < 0 ? AppTheme.error : AppTheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialRatios() {
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
            'Indicadores Financieros',
            style: TextStyle(
              fontSize: AppTheme.fontSizeTitle,
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurface,
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          _buildRatioRow(
            label: 'Capital de Trabajo',
            value: '\$${_workingCapital.toStringAsFixed(2)}',
            isPositive: _workingCapital >= 0,
          ),
          const SizedBox(height: AppTheme.spacingMd),
          _buildRatioRow(
            label: 'Razón Corriente',
            value: _currentRatio.toStringAsFixed(2),
            isPositive: _currentRatio >= 1,
          ),
          const SizedBox(height: AppTheme.spacingMd),
          _buildRatioRow(
            label: 'Prueba Ácida',
            value: ((_totalCurrentAssets - 95000) / _totalCurrentLiabilities).toStringAsFixed(2),
            isPositive: ((_totalCurrentAssets - 95000) / _totalCurrentLiabilities) >= 1,
          ),
        ],
      ),
    );
  }

  Widget _buildRatioRow({
    required String label,
    required String value,
    required bool isPositive,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppTheme.fontSizeBody,
            fontWeight: FontWeight.w500,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingMd,
            vertical: AppTheme.spacingSm,
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
                size: 12,
                color: isPositive ? AppTheme.secondary : AppTheme.error,
              ),
              const SizedBox(width: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: AppTheme.fontSizeBody,
                  fontWeight: FontWeight.w700,
                  color: isPositive ? AppTheme.secondary : AppTheme.error,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}