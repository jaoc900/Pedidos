import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/screens/upgrade_flow_screen.dart';
import 'package:pedidos/screens/painters/donut_chart_painter.dart';
import 'package:pedidos/models/transaction_model.dart';
import 'package:pedidos/screens/payment_checkout_screen.dart';
import 'package:pedidos/screens/membership_history_screen.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';
import 'package:pedidos/widgets/primary_button.dart';
import 'package:pedidos/widgets/custom_outlined_button.dart';
import 'package:pedidos/enums/botton_status_enum.dart';

class MembershipFlowScreen extends StatelessWidget {
  const MembershipFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar:  CustomTopAppBar(
        title: 'Detalle de membresía',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingXl),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      _buildHeaderSection(context),
                      const SizedBox(height: AppTheme.spacingXl),
                      // Bento Grid Dashboard
                      _buildBentoGrid(context),
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

  Widget _buildHeaderSection(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 700;

        return Column(
          children: [
            if (isDesktop)
            // Versión Desktop: Texto izquierda, Botones derecha
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Texto a la izquierda
                  SizedBox(
                    width: 400,
                    child: Text(
                      'Administra tu suscripción y consulta el uso de tus recursos en tiempo real.',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeBody,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  // Botones a la derecha
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Botón Historial
                      SizedBox(
                        width: 140,
                        height: 48,
                        child: CustomOutlinedButton(
                          text: 'Historial',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MembershipHistoryScreen(),
                              ),
                            );
                          },
                          icon: FontAwesomeIcons.clock,
                          textColor: AppTheme.loginButtonColor,
                          borderColor: AppTheme.loginButtonColor,
                          borderRadius: AppTheme.borderRadiusXXl,
                          fontSize: AppTheme.fontSizeLabel,
                          iconSize: 18,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingMd),
                      // Botón Upgrade
                      SizedBox(
                        width: 140,
                        height: 48,
                        child: PrimaryButton(
                          text: 'Upgrade',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UpgradeFlowScreen(),
                              ),
                            );
                          },
                          icon: FontAwesomeIcons.arrowUp,
                          activeColor: AppTheme.loginButtonColor,
                          textColor: Colors.white,
                          iconColor: Colors.white,
                          borderRadius: AppTheme.borderRadiusXXl,
                          fontSize: AppTheme.fontSizeLabel,
                          iconSize: 18,
                          state: ButtonState.active,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            else
            // Versión Móvil: Texto arriba, Botones abajo
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Texto
                  Text(
                    'Administra tu suscripción y consulta el uso de tus recursos en tiempo real.',
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeBody,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingLg),
                  // Botones
                  Row(
                    children: [
                      Expanded(
                        child: CustomOutlinedButton(
                          text: 'Historial',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MembershipHistoryScreen(),
                              ),
                            );
                          },
                          icon: FontAwesomeIcons.clock,
                          textColor: AppTheme.loginButtonColor,
                          borderColor: AppTheme.loginButtonColor,
                          borderRadius: AppTheme.borderRadiusXXl,
                          fontSize: AppTheme.fontSizeLabel,
                          iconSize: 18,
                          height: 48,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingMd),
                      Expanded(
                        child: PrimaryButton(
                          text: 'Upgrade',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UpgradeFlowScreen(),
                              ),
                            );
                          },
                          icon: FontAwesomeIcons.arrowUp,
                          activeColor: AppTheme.loginButtonColor,
                          textColor: Colors.white,
                          iconColor: Colors.white,
                          borderRadius: AppTheme.borderRadiusXXl,
                          fontSize: AppTheme.fontSizeLabel,
                          iconSize: 18,
                          height: 48,
                          state: ButtonState.active,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        );
      },
    );
  }

  Widget _buildBentoGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 900;

        if (isDesktop) {
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 8,
                    child: _buildPlanCard(context),
                  ),
                  const SizedBox(width: AppTheme.spacingLg),
                  Expanded(
                    flex: 4,
                    child: _buildSubscriptionStatus(context),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingLg),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: _buildFeatureUsage(),
                  ),
                  const SizedBox(width: AppTheme.spacingLg),
                  Expanded(
                    flex: 8,
                    child: _buildRecentTransactions(context),
                  ),
                ],
              ),
            ],
          );
        } else {
          return Column(
            children: [
              _buildPlanCard(context),
              const SizedBox(height: AppTheme.spacingLg),
              _buildSubscriptionStatus(context),
              const SizedBox(height: AppTheme.spacingLg),
              _buildFeatureUsage(),
              const SizedBox(height: AppTheme.spacingLg),
              _buildRecentTransactions(context),
            ],
          );
        }
      },
    );
  }

  Widget _buildPlanCard(BuildContext context) {
    return Container(
      height: 320,
      padding: const EdgeInsets.all(AppTheme.spacingXl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -40,
            top: -60,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingMd,
                      vertical: AppTheme.spacingSm,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryFixed,
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                    ),
                    child: Text(
                      'Membresía Activa',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeSmall,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.onPrimaryFixed,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingLg),
                  Text(
                    'Plan Growth Pro',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.loginButtonColor,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingSm),
                  Text(
                    'Tu solución completa para gestión escalable',
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeBody,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Próximo cobro: 15 de Oct, 2024',
                        style: TextStyle(
                          fontSize: AppTheme.fontSizeLabel,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '\$299.00',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.onSurface,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '/mes',
                            style: TextStyle(
                              fontSize: AppTheme.fontSizeBody,
                              color: AppTheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Botón Cambiar Plan - Usando PrimaryButton con borderRadiusXXl
                  SizedBox(
                    width: 140,
                    height: 48,
                    child: PrimaryButton(
                      text: 'Cambiar Plan',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const UpgradeFlowScreen()),
                        );
                      },
                      activeColor: AppTheme.loginButtonColor,
                      textColor: Colors.white,
                      borderRadius: AppTheme.borderRadiusXXl,
                      fontSize: AppTheme.fontSizeLabel,
                      state: ButtonState.active,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionStatus(BuildContext context) {
    return Container(
      height: 320,
      padding: const EdgeInsets.all(AppTheme.spacingXl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3)),
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
                'Estado',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeTitle,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurface,
                ),
              ),
              FaIcon(
                FontAwesomeIcons.calendarCheck,
                size: 20,
                color: AppTheme.primary,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingXl),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progreso del periodo',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeLabel,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '22 de 30 días',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeLabel,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingSm),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                  child: LinearProgressIndicator(
                    value: 0.733,
                    backgroundColor: AppTheme.surfaceContainerHigh,
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingLg),
                Text(
                  'Faltan 8 días para la renovación automática.',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeSmall,
                    color: AppTheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const Divider(),
          const SizedBox(height: AppTheme.spacingLg),
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PaymentCheckoutScreen(
                      planName: 'Plan Growth Pro',
                      planPrice: 299.00,
                    ),
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primary,
              ),
              child: const Text('Renovar suscripción manualmente'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureUsage() {
    return Container(
      height: 420,
      padding: const EdgeInsets.all(AppTheme.spacingXl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3)),
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
            'Uso de Funciones',
            style: TextStyle(
              fontSize: AppTheme.fontSizeTitle,
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurface,
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDonutChart(
                  percentage: 80,
                  label: 'Pedidos',
                  value: '8,000',
                  total: '10,000',
                ),
                const SizedBox(height: AppTheme.spacingLg),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Pedidos Utilizados',
                            style: TextStyle(
                              fontSize: AppTheme.fontSizeLabel,
                              color: AppTheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '8,000',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeLabel,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingMd),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceContainerHigh,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Restante',
                            style: TextStyle(
                              fontSize: AppTheme.fontSizeLabel,
                              color: AppTheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '2,000',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeLabel,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonutChart({
    required double percentage,
    required String label,
    required String value,
    required String total,
  }) {
    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(160, 160),
            painter: DonutChartPainter(
              percentages: [percentage, 100 - percentage],
              colors: [AppTheme.primary, AppTheme.surfaceContainerHigh],
              strokeWidth: 12,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: AppTheme.fontSizeSmall,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(BuildContext context) {
    final transactions = [
      TransactionData(
        name: 'Factura INV-2024-009',
        time: '15 Sep, 2024',
        amount: 299.00,
        status: 'Pagado',
        statusColor: AppTheme.secondary,
        isCompleted: true,
      ),
      TransactionData(
        name: 'Factura INV-2024-008',
        time: '15 Ago, 2024',
        amount: 299.00,
        status: 'Pagado',
        statusColor: AppTheme.secondary,
        isCompleted: true,
      ),
      TransactionData(
        name: 'Factura INV-2024-007',
        time: '15 Jul, 2024',
        amount: 299.00,
        status: 'Pagado',
        statusColor: AppTheme.secondary,
        isCompleted: true,
      ),
      TransactionData(
        name: 'Factura INV-2024-006',
        time: '15 Jun, 2024',
        amount: 299.00,
        status: 'Pagado',
        statusColor: AppTheme.secondary,
        isCompleted: true,
      ),
    ];

    return Container(
      height: 420,
      width: double.infinity, // Ocupa todo el ancho
      padding: const EdgeInsets.all(AppTheme.spacingXl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3)),
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
                'Historial de Pagos',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeTitle,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurface,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.filter,
                      size: 16,
                      color: AppTheme.outline,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.download,
                      size: 16,
                      color: AppTheme.outline,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          // Tabla que ocupa todo el ancho
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isSmallScreen = constraints.maxWidth < 500;

                if (isSmallScreen) {
                  // Vista de tarjetas para móvil
                  return ListView.separated(
                    itemCount: transactions.length,
                    separatorBuilder: (context, index) => const SizedBox(height: AppTheme.spacingMd),
                    itemBuilder: (context, index) {
                      final t = transactions[index];
                      return Container(
                        padding: const EdgeInsets.all(AppTheme.spacingLg),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  t.name,
                                  style: const TextStyle(
                                    fontSize: AppTheme.fontSizeLabel,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppTheme.spacingSm,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: t.statusColor.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                                  ),
                                  child: Text(
                                    t.status,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: t.statusColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppTheme.spacingSm),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  t.time,
                                  style: TextStyle(
                                    fontSize: AppTheme.fontSizeSmall,
                                    color: AppTheme.onSurfaceVariant,
                                  ),
                                ),
                                Text(
                                  '\$${t.amount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: AppTheme.fontSizeBody,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppTheme.spacingSm),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: FaIcon(
                                  FontAwesomeIcons.eye,
                                  size: 16,
                                  color: AppTheme.primary,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }

                // Tabla completa para desktop/tablet
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
                        DataColumn(
                          label: Text('Factura', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                        DataColumn(
                          label: Text('Fecha', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                        DataColumn(
                          label: Text('Monto', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                        DataColumn(
                          label: Text('Estado', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                        DataColumn(
                          label: Text('', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ],
                      rows: transactions.map((t) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                t.name,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            DataCell(Text(t.time)),
                            DataCell(
                              Text(
                                '\$${t.amount.toStringAsFixed(2)}',
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppTheme.spacingSm,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: t.statusColor.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                                ),
                                child: Text(
                                  t.status,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: t.statusColor,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              IconButton(
                                icon: FaIcon(
                                  FontAwesomeIcons.eye,
                                  size: 16,
                                  color: AppTheme.primary,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MembershipHistoryScreen(),
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primary,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Ver historial completo'),
                  SizedBox(width: 4),
                  FaIcon(FontAwesomeIcons.chevronRight, size: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}