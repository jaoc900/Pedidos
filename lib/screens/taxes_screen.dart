import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pedidos/models/tax_period_model.dart';
import 'package:pedidos/enums/taxes_status_enum.dart';
import 'package:pedidos/models/chart_data_model.dart';

class TaxesScreen extends StatefulWidget {
  const TaxesScreen({super.key});

  @override
  State<TaxesScreen> createState() => _TaxesScreenState();
}

class _TaxesScreenState extends State<TaxesScreen> {
  int _selectedYear = 2025;
  String _selectedPeriod = '2025';
  final List<String> _years = ['2023', '2024', '2025'];

  // Datos de impuestos por período
  final List<TaxPeriod> _taxPeriods = [
    TaxPeriod(
      period: 'Enero 2025',
      date: DateTime(2025, 1, 31),
      iva: 12500.00,
      isr: 8500.00,
      ieps: 1200.00,
      status: TaxStatus.paid,
      paymentDate: DateTime(2025, 2, 15),
    ),
    TaxPeriod(
      period: 'Febrero 2025',
      date: DateTime(2025, 2, 28),
      iva: 13800.00,
      isr: 9200.00,
      ieps: 1350.00,
      status: TaxStatus.paid,
      paymentDate: DateTime(2025, 3, 15),
    ),
    TaxPeriod(
      period: 'Marzo 2025',
      date: DateTime(2025, 3, 31),
      iva: 14200.00,
      isr: 9800.00,
      ieps: 1400.00,
      status: TaxStatus.paid,
      paymentDate: DateTime(2025, 4, 15),
    ),
    TaxPeriod(
      period: 'Abril 2025',
      date: DateTime(2025, 4, 30),
      iva: 15600.00,
      isr: 10500.00,
      ieps: 1550.00,
      status: TaxStatus.pending,
      paymentDate: DateTime(2025, 5, 17),
    ),
    TaxPeriod(
      period: 'Mayo 2025',
      date: DateTime(2025, 5, 31),
      iva: 16800.00,
      isr: 11200.00,
      ieps: 1680.00,
      status: TaxStatus.upcoming,
      paymentDate: DateTime(2025, 6, 17),
    ),
  ];

  List<TaxPeriod> get _filteredPeriods {
    return _taxPeriods.where((period) {
      return period.period.contains(_selectedPeriod);
    }).toList();
  }

  double get _totalIva => _filteredPeriods.fold(0, (sum, p) => sum + p.iva);
  double get _totalIsr => _filteredPeriods.fold(0, (sum, p) => sum + p.isr);
  double get _totalIeps => _filteredPeriods.fold(0, (sum, p) => sum + p.ieps);
  double get _totalTaxes => _totalIva + _totalIsr + _totalIeps;
  double get _pendingTaxes => _filteredPeriods
      .where((p) => p.status != TaxStatus.paid)
      .fold(0, (sum, p) => sum + p.iva + p.isr + p.ieps);

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
                  // Selector de año
                  _buildYearSelector(),
                  const SizedBox(height: AppTheme.spacingLg),
                  // Resumen de impuestos
                  _buildTaxSummary(),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Gráfico de distribución
                  _buildTaxDistributionChart(),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Lista de períodos
                  _buildTaxPeriodsList(),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Declaraciones pendientes
                  _buildPendingDeclarations(),
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
            offset: const Offset(0, 2),
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
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.arrowLeft,
                        size: 20,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingLg),
                Text(
                  'Impuestos',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeTitle,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.fileExport,
                  size: 20,
                  color: AppTheme.primary,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Exportar reporte de impuestos'),
                      backgroundColor: AppTheme.primary,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYearSelector() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingSm),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: AppTheme.outlineVariant),
      ),
      child: Row(
        children: [
          const SizedBox(width: AppTheme.spacingMd),
          const FaIcon(
            FontAwesomeIcons.calendar,
            size: 16,
            color: AppTheme.primary,
          ),
          const SizedBox(width: AppTheme.spacingMd),
          const Text(
            'Año:',
            style: TextStyle(
              fontSize: AppTheme.fontSizeBody,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: AppTheme.spacingMd),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedPeriod,
                icon: FaIcon(
                  FontAwesomeIcons.chevronDown,
                  size: 14,
                  color: AppTheme.primary,
                ),
                items: _years.map((String year) {
                  return DropdownMenuItem<String>(
                    value: year,
                    child: Text(
                      year,
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeBody,
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

  Widget _buildTaxSummary() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            title: 'IVA',
            value: '\$${_totalIva.toStringAsFixed(2)}',
            icon: FontAwesomeIcons.percent,
            color: AppTheme.primary,
            bgColor: AppTheme.primaryContainer.withValues(alpha: 0.2),
          ),
        ),
        const SizedBox(width: AppTheme.spacingLg),
        Expanded(
          child: _buildSummaryCard(
            title: 'ISR',
            value: '\$${_totalIsr.toStringAsFixed(2)}',
            icon: FontAwesomeIcons.chartLine,
            color: AppTheme.secondary,
            bgColor: AppTheme.secondaryContainer.withValues(alpha: 0.2),
          ),
        ),
        const SizedBox(width: AppTheme.spacingLg),
        Expanded(
          child: _buildSummaryCard(
            title: 'IEPS',
            value: '\$${_totalIeps.toStringAsFixed(2)}',
            icon: FontAwesomeIcons.bottleWater,
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
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppTheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaxDistributionChart() {
    final data = [
      ChartData(label: 'IVA', value: _totalIva, color: AppTheme.primary),
      ChartData(label: 'ISR', value: _totalIsr, color: AppTheme.secondary),
      ChartData(label: 'IEPS', value: _totalIeps, color: AppTheme.tertiary),
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
            'Distribución de Impuestos',
            style: TextStyle(
              fontSize: AppTheme.fontSizeTitle,
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurface,
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: data.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return PieChartSectionData(
                    value: item.value,
                    title: item.label,
                    color: item.color,
                    radius: 80,
                    titleStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: AppTheme.spacingLg,
            children: data.map((item) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: item.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${item.label}: \$${item.value.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeSmall,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTaxPeriodsList() {
    final periods = _filteredPeriods;

    return Container(
      width: double.infinity, // Ocupa todo el ancho
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
              'Declaraciones Mensuales',
              style: TextStyle(
                fontSize: AppTheme.fontSizeTitle,
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurface,
              ),
            ),
          ),
          const Divider(height: 0, color: AppTheme.outlineVariant),
          // Tabla responsiva que ocupa todo el ancho
          LayoutBuilder(
            builder: (context, constraints) {
              final isSmallScreen = constraints.maxWidth < 600;

              if (isSmallScreen) {
                // Vista de tarjetas para móvil
                return Column(
                  children: periods.map((period) {
                    final total = period.iva + period.isr + period.ieps;
                    Color statusColor;
                    String statusText;

                    switch (period.status) {
                      case TaxStatus.paid:
                        statusColor = AppTheme.secondary;
                        statusText = 'Pagada';
                        break;
                      case TaxStatus.pending:
                        statusColor = AppTheme.warning;
                        statusText = 'Pendiente';
                        break;
                      case TaxStatus.upcoming:
                        statusColor = AppTheme.info;
                        statusText = 'Próxima';
                        break;
                    }

                    return Container(
                      margin: const EdgeInsets.all(AppTheme.spacingMd),
                      padding: const EdgeInsets.all(AppTheme.spacingLg),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
                        border: Border.all(color: AppTheme.outlineVariant),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                period.period,
                                style: TextStyle(
                                  fontSize: AppTheme.fontSizeBody,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.onSurface,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppTheme.spacingSm,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                                ),
                                child: Text(
                                  statusText,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: statusColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppTheme.spacingMd),
                          _buildDetailRow('IVA', '\$${period.iva.toStringAsFixed(2)}'),
                          _buildDetailRow('ISR', '\$${period.isr.toStringAsFixed(2)}'),
                          _buildDetailRow('IEPS', '\$${period.ieps.toStringAsFixed(2)}'),
                          const Divider(),
                          _buildDetailRow(
                            'Total',
                            '\$${total.toStringAsFixed(2)}',
                            isBold: true,
                            color: AppTheme.primary,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              } else {
                // Tabla para desktop/tablet
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: constraints.maxWidth,
                    ),
                    child: DataTable(
                      columnSpacing: 32,
                      headingRowColor: WidgetStateProperty.resolveWith(
                            (states) => AppTheme.surfaceContainerLow,
                      ),
                      columns: const [
                        DataColumn(label: Text('Período', style: TextStyle(fontWeight: FontWeight.w600))),
                        DataColumn(label: Text('IVA', style: TextStyle(fontWeight: FontWeight.w600))),
                        DataColumn(label: Text('ISR', style: TextStyle(fontWeight: FontWeight.w600))),
                        DataColumn(label: Text('IEPS', style: TextStyle(fontWeight: FontWeight.w600))),
                        DataColumn(label: Text('Total', style: TextStyle(fontWeight: FontWeight.w600))),
                        DataColumn(label: Text('Estado', style: TextStyle(fontWeight: FontWeight.w600))),
                      ],
                      rows: periods.map((period) {
                        final total = period.iva + period.isr + period.ieps;
                        Color statusColor;
                        String statusText;

                        switch (period.status) {
                          case TaxStatus.paid:
                            statusColor = AppTheme.secondary;
                            statusText = 'Pagada';
                            break;
                          case TaxStatus.pending:
                            statusColor = AppTheme.warning;
                            statusText = 'Pendiente';
                            break;
                          case TaxStatus.upcoming:
                            statusColor = AppTheme.info;
                            statusText = 'Próxima';
                            break;
                        }

                        return DataRow(
                          cells: [
                            DataCell(Text(period.period)),
                            DataCell(Text('\$${period.iva.toStringAsFixed(2)}')),
                            DataCell(Text('\$${period.isr.toStringAsFixed(2)}')),
                            DataCell(Text('\$${period.ieps.toStringAsFixed(2)}')),
                            DataCell(
                              Text(
                                '\$${total.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppTheme.spacingSm,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                                ),
                                child: Text(
                                  statusText,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: statusColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

// Método auxiliar para las filas de detalles en móvil
  Widget _buildDetailRow(String label, String value, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: AppTheme.fontSizeSmall,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: AppTheme.fontSizeBody,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: color ?? AppTheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingDeclarations() {
    final pendingPeriods = _filteredPeriods.where((p) => p.status != TaxStatus.paid).toList();

    if (pendingPeriods.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        decoration: BoxDecoration(
          color: AppTheme.secondaryContainer.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
          border: Border.all(color: AppTheme.secondary.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.secondaryContainer,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.checkCircle,
                  size: 24,
                  color: AppTheme.secondary,
                ),
              ),
            ),
            const SizedBox(width: AppTheme.spacingLg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '¡Tus impuestos están al día!',
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeBody,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'No tienes declaraciones pendientes',
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeSmall,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.warningContainer.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: AppTheme.warning.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.warningContainer,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: FaIcon(
                    FontAwesomeIcons.triangleExclamation,
                    size: 24,
                    color: AppTheme.warning,
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacingLg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Declaraciones Pendientes',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeBody,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.warning,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tienes ${pendingPeriods.length} declaración(es) por pagar',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeSmall,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          ...pendingPeriods.map((period) => Padding(
            padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
            child: Container(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        period.period,
                        style: TextStyle(
                          fontSize: AppTheme.fontSizeLabel,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Vence: ${_formatDate(period.paymentDate)}',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.outline,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${(period.iva + period.isr + period.ieps).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: AppTheme.fontSizeTitle,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.error,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: AppTheme.spacingLg),
                      // Botón Pagar con ancho fijo
                      SizedBox(
                        width: 80,
                        height: 36,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Pagar declaración de ${period.period}'),
                                backgroundColor: AppTheme.primary,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text('Pagar', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )).toList(),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}