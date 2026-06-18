import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/screens/payments_management_screen.dart';
import 'package:pedidos/screens/expenses_dashboard_screen.dart';
import 'package:pedidos/screens/register_expense_screen.dart';
import 'package:pedidos/screens/payment_calendar_screen.dart';
import 'package:pedidos/screens/suppliers_screen.dart';
import 'package:pedidos/screens/income_statement_screen.dart';
import 'package:pedidos/screens/cash_flow_screen.dart';
import 'package:pedidos/screens/balance_sheet_screen.dart';
import 'package:pedidos/screens/budget_comparison_screen.dart';
import 'package:pedidos/screens/financial_alerts_screen.dart';
import 'package:pedidos/screens/pending_invoices_screen.dart';
import 'package:pedidos/screens/taxes_screen.dart';
import 'package:pedidos/models/report_data_model.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';

class FinancesScreen extends StatelessWidget {
  const FinancesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: CustomTopAppBar(
        title: 'Finanzas',
        showBackButton: false,
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
                  // Hero Summary / Balance Section
                  _buildBalanceSection(),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Transacciones Financieras
                  _buildTransactionsSection(context),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Reportes Financieros (Horizontal Scrolling)
                  _buildReportsSection(context),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Gestión de Presupuestos
                  _buildBudgetSection(context),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Cuentas por Pagar
                  _buildAccountsPayableSection(context),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Impuestos
                  _buildTaxesSection(context),
                  const SizedBox(height: AppTheme.spacingXl * 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 600;

        if (isDesktop) {
          return SizedBox(
            height: 160,
            child: Row(
              children: [
                // Card grande (Balance)
                Expanded(
                  flex: 5,
                  child: SizedBox.expand(
                    child: _buildBalanceCard(),
                  ),
                ),

                const SizedBox(width: AppTheme.spacingLg),

                // Ingresos y Egresos en un solo renglón
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox.expand(
                          child: _buildMetricCard(
                            title: 'Ingresos',
                            value: '\$12.4k',
                            icon: FontAwesomeIcons.moneyBill,
                            iconColor: AppTheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingMd),
                      Expanded(
                        child: SizedBox.expand(
                          child: _buildMetricCard(
                            title: 'Egresos',
                            value: '\$8.1k',
                            icon: FontAwesomeIcons.receipt,
                            iconColor: AppTheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Column(
            children: [
              _buildBalanceCard(),
              const SizedBox(height: AppTheme.spacingLg),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      title: 'Ingresos',
                      value: '\$12.4k',
                      icon: FontAwesomeIcons.moneyBill,
                      iconColor: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingLg),
                  Expanded(
                    child: _buildMetricCard(
                      title: 'Egresos',
                      value: '\$8.1k',
                      icon: FontAwesomeIcons.receipt,
                      iconColor: AppTheme.error,
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildBalanceCard() {
    return GestureDetector(
      onTap: () {},
      child: Container(
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
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Balance Total General',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeLabel,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.onPrimaryContainer.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$450,230',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingLg),
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.arrowUp,
                      size: 14,
                      color: AppTheme.secondaryFixed,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '+12.5% vs mes anterior',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeSmall,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              right: -20,
              bottom: -20,
              child: FaIcon(
                FontAwesomeIcons.buildingColumns,
                size: 80,
                color: AppTheme.onPrimaryContainer.withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required FaIconData icon,
    required Color iconColor,
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
          FaIcon(
            icon,
            size: 24,
            color: iconColor,
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            title,
            style: TextStyle(
              fontSize: AppTheme.fontSizeSmall,
              fontWeight: FontWeight.w500,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
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

  Widget _buildTransactionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Transacciones',
              style: TextStyle(
                fontSize: AppTheme.fontSizeTitle,
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurface,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Ver todas'),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingLg),
        // Pagos de Clientes
        _buildTransactionItem(
          title: 'Pagos de Clientes',
          subtitle: '12 pendientes hoy',
          icon: FontAwesomeIcons.users,
          iconBgColor: AppTheme.secondaryContainer,
          iconColor: AppTheme.onSecondaryContainer,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PaymentsManagementScreen()),
            );
          },
        ),
        const SizedBox(height: AppTheme.spacingMd),
        // Gastos
        _buildTransactionItem(
          title: 'Gastos',
          subtitle: 'Historial de egresos',
          icon: FontAwesomeIcons.arrowDown,
          iconBgColor: AppTheme.tertiaryContainer,
          iconColor: AppTheme.onTertiaryContainer,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ExpensesDashboardScreen()),
            );
          },
        ),
        const SizedBox(height: AppTheme.spacingMd),
        // Registrar Gasto Operativo (Botón destacado)
        _buildPrimaryTransactionItem(
          title: 'Registrar Gasto Operativo',
          subtitle: 'Nueva entrada manual',
          icon: FontAwesomeIcons.circlePlus,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterExpenseScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTransactionItem({
    required String title,
    required String subtitle,
    required FaIconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
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
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
              ),
              child: Center(
                child: FaIcon(
                  icon,
                  size: 24,
                  color: iconColor,
                ),
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
                      color: AppTheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeSmall,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            FaIcon(
              FontAwesomeIcons.chevronRight,
              size: 20,
              color: AppTheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrimaryTransactionItem({
    required String title,
    required String subtitle,
    required FaIconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        decoration: BoxDecoration(
          color: AppTheme.primary,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
              ),
              child: Center(
                child: FaIcon(
                  icon,
                  size: 24,
                  color: Colors.white,
                ),
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
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeSmall,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            FaIcon(
              FontAwesomeIcons.arrowRight,
              size: 20,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsSection(BuildContext context) {
    final reports = [
      ReportData(
        title: 'Estado de Resultados',
        subtitle: 'Actualizado hace 2h',
        icon: FontAwesomeIcons.chartSimple,
        iconColor: AppTheme.primary,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const IncomeStatementScreen()),
          );
        },
      ),
      ReportData(
        title: 'Flujo de Caja',
        subtitle: 'Proyección semanal',
        icon: FontAwesomeIcons.wallet,
        iconColor: AppTheme.secondary,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CashFlowScreen()),
          );
        },
      ),
      ReportData(
        title: 'Balance General',
        subtitle: 'Cierre de mes anterior',
        icon: FontAwesomeIcons.scaleBalanced,
        iconColor: AppTheme.tertiary,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BalanceSheetScreen()),
          );
        },
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reportes',
          style: TextStyle(
            fontSize: AppTheme.fontSizeTitle,
            fontWeight: FontWeight.w600,
            color: AppTheme.onSurface,
          ),
        ),
        const SizedBox(height: AppTheme.spacingLg),
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: reports.length,
            separatorBuilder: (context, index) => const SizedBox(width: AppTheme.spacingLg),
            itemBuilder: (context, index) {
              final report = reports[index];
              return GestureDetector(
                onTap: report.onTap,
                child: Container(
                  width: 240,
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
                      FaIcon(
                        report.icon,
                        size: 32,
                        color: report.iconColor,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            report.title,
                            style: TextStyle(
                              fontSize: AppTheme.fontSizeLabel,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            report.subtitle,
                            style: TextStyle(
                              fontSize: AppTheme.fontSizeSmall,
                              color: AppTheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Presupuestos',
            style: TextStyle(
              fontSize: AppTheme.fontSizeTitle,
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurface,
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          // Barra de progreso
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Presupuesto Mensual',
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeLabel,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.onSurface,
                    ),
                  ),
                  Text(
                    '75%',
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeLabel,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingSm),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                child: LinearProgressIndicator(
                  value: 0.75,
                  backgroundColor: AppTheme.surfaceContainerHigh,
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                  minHeight: 8,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Row(
            children: [
              Expanded(
                child: _buildBudgetButton(
                  title: 'Comparativa',
                  icon: FontAwesomeIcons.chartLine,
                  iconColor: AppTheme.secondary,
                  bgColor: AppTheme.surfaceContainerLowest,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BudgetComparisonScreen()),
                    );
                  },
                ),
              ),
              const SizedBox(width: AppTheme.spacingLg),
              Expanded(
                child: _buildBudgetButton(
                  title: 'Alertas',
                  icon: FontAwesomeIcons.bell,
                  iconColor: AppTheme.onErrorContainer,
                  bgColor: AppTheme.errorContainer,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FinancialAlertsScreen()),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetButton({
    required String title,
    required FaIconData icon,
    required Color iconColor,
    required Color bgColor,
    required VoidCallback onTap, // ← Agregar el parámetro onTap
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
          border: Border.all(color: AppTheme.outlineVariant),
        ),
        child: Column(
          children: [
            FaIcon(
              icon,
              size: 24,
              color: iconColor,
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              title,
              style: TextStyle(
                fontSize: AppTheme.fontSizeSmall,
                fontWeight: FontWeight.w500,
                color: AppTheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountsPayableSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cuentas por Pagar',
          style: TextStyle(
            fontSize: AppTheme.fontSizeTitle,
            fontWeight: FontWeight.w600,
            color: AppTheme.onSurface,
          ),
        ),
        const SizedBox(height: AppTheme.spacingLg),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
            border: Border.all(color: AppTheme.outlineVariant),
          ),
          child: Column(
            children: [
              _buildPayableItem(
                title: 'Facturas Pendientes',
                badge: '5',
                icon: FontAwesomeIcons.clock,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PendingInvoicesScreen()),
                  );
                },
              ),
              const Divider(height: 0, color: AppTheme.outlineVariant),
              _buildPayableItem(
                title: 'Proveedores',
                icon: FontAwesomeIcons.industry,
                hasChevron: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SuppliersScreen()),
                  );
                },
              ),
              const Divider(height: 0, color: AppTheme.outlineVariant),
              _buildPayableItem(
                title: 'Fechas de Pago',
                icon: FontAwesomeIcons.calendar,
                hasChevron: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PaymentCalendarScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPayableItem({
    required String title,
    String? badge,
    required FaIconData icon,
    bool hasChevron = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                FaIcon(
                  icon,
                  size: 20,
                  color: AppTheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppTheme.spacingLg),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeLabel,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.onSurface,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingSm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                if (hasChevron) ...[
                  const SizedBox(width: AppTheme.spacingSm),
                  FaIcon(
                    FontAwesomeIcons.chevronRight,
                    size: 16,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaxesSection(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context)=> const TaxesScreen()));
      },
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
          border: Border.all(color: AppTheme.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.buildingColumns,
                  size: 32,
                  color: AppTheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(width: AppTheme.spacingLg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Impuestos',
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeTitle,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Resumen fiscal y declaraciones pendientes.',
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeBody,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            FaIcon(
              FontAwesomeIcons.arrowRight,
              size: 20,
              color: AppTheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
