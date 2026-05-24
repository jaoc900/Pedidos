import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';

class CustomerPaymentsScreen extends StatelessWidget {
  const CustomerPaymentsScreen({super.key});

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
                children: [
                  // Customer Profile Summary
                  _buildCustomerProfile(),
                  const SizedBox(height: AppTheme.spacingLg),
                  // Stats Bento Grid
                  _buildStatsGrid(),
                  const SizedBox(height: AppTheme.spacingLg),
                  // Payment List
                  _buildPaymentList(),
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
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg, vertical: AppTheme.spacingLg),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Botón de regresar
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
                  'Customer Payments',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeTitle,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
            // Botón de búsqueda
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.magnifyingGlass,
                  size: 20,
                  color: AppTheme.primary,
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerProfile() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
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
      child: Row(
        children: [
          // Avatar
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2), width: 2),
            ),
            child: ClipOval(
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuDa5iAkepwQrbHPRO8n58C0qFgnnGjzhB1mxuySZ_NgHfsAUOrQwfpDrrB5u3sB5WnU3GASWOpKQFO5Ue_sRlVv03NXjkuSivY86nX_l16PUZCQtC_PbhyfFnAl1evCJrtDb_5ogIhxI5BCPffWFmqjism-YfKbATWx4wvrwYAEk-lVMEtbwnQZFotVWtbjb-FkfJwpoQaG16g7cXdkGXAfcq9Zyjg1bHWbbgx0t7-bCs9E4eSLqECs-rshhAqlqdhnEbcl7piYMAxm',
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppTheme.primaryContainer,
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.user,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingLg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jonathan Miller',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeTitle,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Acme Corp • Premium Client',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeBody,
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

  Widget _buildStatsGrid() {
    return Row(
      children: [
        // Total Paid
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
              border: Border.all(color: AppTheme.primaryContainer.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TOTAL PAID',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeSmall,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$12,450.00',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeTitle,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppTheme.spacingMd),
        // Pending Payments
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            decoration: BoxDecoration(
              color: AppTheme.error.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
              border: Border.all(color: AppTheme.errorContainer.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PENDING',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeSmall,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: AppTheme.error,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$2,340.00',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeTitle,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentList() {
    final payments = [
      PaymentData(
        id: 'PAY-001',
        date: 'Oct 24, 2023',
        amount: 1240.50,
        status: 'Completed',
        method: 'Credit Card',
        statusColor: AppTheme.secondary,
        statusBgColor: const Color(0xFFE8F5E9),
        icon: FontAwesomeIcons.creditCard,
      ),
      PaymentData(
        id: 'PAY-002',
        date: 'Oct 18, 2023',
        amount: 450.00,
        status: 'Completed',
        method: 'Bank Transfer',
        statusColor: AppTheme.secondary,
        statusBgColor: const Color(0xFFE8F5E9),
        icon: FontAwesomeIcons.buildingColumns,
      ),
      PaymentData(
        id: 'PAY-003',
        date: 'Oct 15, 2023',
        amount: 890.75,
        status: 'Pending',
        method: 'Cash',
        statusColor: const Color(0xFFFF9800),
        statusBgColor: const Color(0xFFFFF3E0),
        icon: FontAwesomeIcons.moneyBill,
      ),
      PaymentData(
        id: 'PAY-004',
        date: 'Oct 10, 2023',
        amount: 2890.75,
        status: 'Completed',
        method: 'Credit Card',
        statusColor: AppTheme.secondary,
        statusBgColor: const Color(0xFFE8F5E9),
        icon: FontAwesomeIcons.creditCard,
      ),
      PaymentData(
        id: 'PAY-005',
        date: 'Sep 28, 2023',
        amount: 89.90,
        status: 'Completed',
        method: 'PayPal',
        statusColor: AppTheme.secondary,
        statusBgColor: const Color(0xFFE8F5E9),
        icon: FontAwesomeIcons.paypal,
      ),
    ];

    return Column(
      children: [
        for (var payment in payments) ...[
          _buildPaymentCard(payment),
          const SizedBox(height: AppTheme.spacingLg),
        ],
      ],
    );
  }

  Widget _buildPaymentCard(PaymentData payment) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.2)),
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
          // Header: Payment ID y Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment ID',
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeLabel,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    payment.id,
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeTitle,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onSurface,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingMd,
                  vertical: AppTheme.spacingSm,
                ),
                decoration: BoxDecoration(
                  color: payment.statusBgColor,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                ),
                child: Text(
                  payment.status,
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeSmall,
                    fontWeight: FontWeight.w700,
                    color: payment.statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          const Divider(color: AppTheme.outlineVariant),
          const SizedBox(height: AppTheme.spacingLg),
          // Footer: Método, Fecha y Monto
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      FaIcon(
                        payment.icon,
                        size: 14,
                        color: AppTheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: AppTheme.spacingSm),
                      Text(
                        payment.method,
                        style: TextStyle(
                          fontSize: AppTheme.fontSizeSmall,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingSm),
                  Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.calendar,
                        size: 14,
                        color: AppTheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: AppTheme.spacingSm),
                      Text(
                        payment.date,
                        style: TextStyle(
                          fontSize: AppTheme.fontSizeSmall,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                '\$${payment.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeBody,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Modelo de datos para pagos
class PaymentData {
  final String id;
  final String date;
  final double amount;
  final String status;
  final String method;
  final Color statusColor;
  final Color statusBgColor;
  final FaIconData icon;

  PaymentData({
    required this.id,
    required this.date,
    required this.amount,
    required this.status,
    required this.method,
    required this.statusColor,
    required this.statusBgColor,
    required this.icon,
  });
}