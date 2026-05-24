import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pedidos/models/transaction_model.dart';

class PaymentsManagementScreen extends StatefulWidget {
  const PaymentsManagementScreen({super.key});

  @override
  State<PaymentsManagementScreen> createState() => _PaymentsManagementScreenState();
}

class _PaymentsManagementScreenState extends State<PaymentsManagementScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // TopAppBar
          _buildTopAppBar(context),
          // Contenido principal
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Financial Summary Card
                  _buildFinancialSummaryCard(),
                  const SizedBox(height: AppTheme.spacingLg),
                  // Pending Payments
                  _buildPendingPaymentsCard(),
                  const SizedBox(height: AppTheme.spacingLg),
                  // Distribution Chart Section
                  _buildDistributionChart(),
                  const SizedBox(height: AppTheme.spacingLg),
                  // Recent History
                  _buildRecentHistory(),
                  const SizedBox(height: AppTheme.spacingLg * 2),
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
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingXl,
        vertical: AppTheme.spacingLg,
      ),
      decoration: BoxDecoration(
        color: AppTheme.background,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Botón de regreso
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
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

            // Título
            Text(
              'Gestión de Pagos',
              style: TextStyle(
                fontSize: AppTheme.fontSizeTitle,
                fontWeight: FontWeight.w700,
                color: AppTheme.loginButtonColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: AppTheme.surfaceVariant.withValues(alpha: 0.3)),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Recaudado este Mes',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeLabel,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$42,850.00',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeHeadline,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
                ),
                child: FaIcon(
                  FontAwesomeIcons.wallet,
                  size: 24,
                  color: AppTheme.primaryContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingSm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                ),
                child: Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.arrowUp,
                      size: 12,
                      color: AppTheme.primary,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '12.5%',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeSmall,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppTheme.spacingSm),
              Text(
                'vs. mes anterior',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeSmall,
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPendingPaymentsCard() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: AppTheme.surfaceVariant.withValues(alpha: 0.3)),
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
              Text(
                'Pagos Pendientes',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeLabel,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '14',
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeTitle,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.error,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'facturas activas',
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeSmall,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            decoration: BoxDecoration(
              color: AppTheme.errorContainer.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: FaIcon(
              FontAwesomeIcons.clock,
              size: 24,
              color: AppTheme.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistributionChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            'DISTRIBUCIÓN POR MÉTODO',
            style: TextStyle(
              fontSize: AppTheme.fontSizeLabel,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              color: AppTheme.loginButtonColor,
            ),
          ),
        ),
        const SizedBox(height: AppTheme.spacingSm),
        Container(
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
            border: Border.all(color: AppTheme.surfaceVariant.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
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
                            const titles = ['Transf.', 'Tarjeta', 'Efectivo'];
                            if (value.toInt() >= 0 && value.toInt() < titles.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  titles[value.toInt()],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.onSurfaceVariant,
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
                                color: AppTheme.onSurfaceVariant,
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
                    barGroups: [
                      _buildBarGroup(0, 85, AppTheme.loginButtonColor),
                      _buildBarGroup(1, 45, const Color(0xFF289045)),
                      _buildBarGroup(2, 25, const Color(0xFFA3E14C)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingLg),
              // Leyenda de porcentajes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildLegendItem('Transferencia', '85%', AppTheme.loginButtonColor),
                  _buildLegendItem('Tarjeta', '45%', const Color(0xFF289045)),
                  _buildLegendItem('Efectivo', '25%', const Color(0xFFA3E14C)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  BarChartGroupData _buildBarGroup(int x, double height, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: height,
          color: color,
          width: 40,
          borderRadius: BorderRadius.circular(8),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 100,
            color: AppTheme.surfaceVariant.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, String percentage, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$label $percentage',
          style: TextStyle(
            fontSize: AppTheme.fontSizeSmall,
            fontWeight: FontWeight.w500,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentHistory() {
    final transactions = [
      TransactionData(
        name: 'Javier Arboleda',
        time: 'Hoy, 10:45 AM',
        amount: 1250.00,
        status: 'Completado',
        statusColor: AppTheme.primary,
        isCompleted: true,
      ),
      TransactionData(
        name: 'Elena Martínez',
        time: 'Ayer, 04:12 PM',
        amount: 3400.00,
        status: 'Completado',
        statusColor: AppTheme.primary,
        isCompleted: true,
      ),
      TransactionData(
        name: 'Constructora Sur',
        time: '22 May, 11:20 AM',
        amount: 12800.00,
        status: 'Completado',
        statusColor: AppTheme.primary,
        isCompleted: true,
      ),
      TransactionData(
        name: 'Roberto Gómez',
        time: '21 May, 09:15 AM',
        amount: 850.00,
        status: 'Pendiente',
        statusColor: AppTheme.error,
        isCompleted: false,
      ),
      TransactionData(
        name: 'Finca El Oasis',
        time: '20 May, 05:40 PM',
        amount: 5200.00,
        status: 'Completado',
        statusColor: AppTheme.primary,
        isCompleted: true,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'HISTORIAL RECIENTE',
              style: TextStyle(
                fontSize: AppTheme.fontSizeLabel,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
                color: AppTheme.loginButtonColor,
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primary,
              ),
              child: const Row(
                children: [
                  Text('Ver todo'),
                  SizedBox(width: 4),
                  FaIcon(FontAwesomeIcons.chevronRight, size: 14),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingSm),
        ...transactions.map((transaction) => Padding(
          padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
          child: _buildTransactionItem(transaction),
        )),
      ],
    );
  }

  Widget _buildTransactionItem(TransactionData transaction) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: AppTheme.surfaceVariant.withValues(alpha: 0.2)),
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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: transaction.isCompleted
                      ? AppTheme.secondaryContainer.withValues(alpha: 0.2)
                      : AppTheme.errorContainer.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: FaIcon(
                    FontAwesomeIcons.user,
                    size: 20,
                    color: transaction.isCompleted ? AppTheme.primary : AppTheme.error,
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacingLg),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.name,
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeLabel,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    transaction.time,
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeSmall,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${transaction.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeLabel,
                  fontWeight: FontWeight.w700,
                  color: transaction.isCompleted ? AppTheme.loginButtonColor : AppTheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                transaction.status,
                style: TextStyle(
                  fontSize: AppTheme.fontSizeSmall,
                  fontWeight: FontWeight.w600,
                  color: transaction.statusColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}