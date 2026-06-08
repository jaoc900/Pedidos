import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/widgets/primary_button.dart';
import 'package:pedidos/widgets/custom_outlined_button.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final Map<String, dynamic>? transactionData;

  const PaymentSuccessScreen({
    super.key,
    this.transactionData,
  });

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _checkAnimationController;
  late Animation<double> _checkAnimation;

  final String _orderId = "#GC-88421";
  final String _date = "Oct 24, 2023";
  final String _time = "14:32";
  final String _paymentMethod = "Visa ending in 4412";

  final List<OrderItem> _orderItems = [
    OrderItem(name: "Monstera Deliciosa", quantity: 1, price: 45.00, variant: null),
    OrderItem(name: "Ceramic Planter", quantity: 1, price: 32.00, variant: "Large / Grey"),
    OrderItem(name: "Organic Potting Mix", quantity: 2, price: 9.00, variant: "5L Bag"),
  ];

  double get _subtotal => _orderItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  double get _tax => _subtotal * 0.08;
  double get _total => _subtotal + _tax;

  @override
  void initState() {
    super.initState();
    _checkAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _checkAnimation = CurvedAnimation(
      parent: _checkAnimationController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _checkAnimationController.dispose();
    super.dispose();
  }

  void _onNewSale() {
    Navigator.pushReplacementNamed(context, '/pos');
  }

  void _onPrint() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Enviando a impresora...'),
        backgroundColor: AppTheme.primary,
      ),
    );
  }

  void _onEmail() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Enviando recibo por email...'),
        backgroundColor: AppTheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: CustomTopAppBar(
        title: 'Gestión Comercial',
        showBackButton: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(
                  isSmallScreen ? AppTheme.spacingLg : AppTheme.spacingXl,
                ),
                child: Center(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: isLandscape ? 800 : 500,
                    ),
                    child: Column(
                      children: [
                        _buildSuccessHeader(),
                        const SizedBox(height: AppTheme.spacingLg),
                        _buildReceipt(),
                        const SizedBox(height: AppTheme.spacingLg),
                        _buildActions(),
                        const SizedBox(height: AppTheme.spacingXl),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessHeader() {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _checkAnimation,
          builder: (context, child) {
            return Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Center(
                child: Transform.scale(
                  scale: _checkAnimation.value,
                  child: CustomPaint(
                    size: const Size(48, 48),
                    painter: CheckMarkPainter(
                      progress: _checkAnimation.value,
                      color: AppTheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: AppTheme.spacingLg),
        Text(
          'Pago correcto',
          style: TextStyle(
            fontSize: AppTheme.fontSizeHeadline,
            fontWeight: FontWeight.w700,
            color: AppTheme.onBackground,
          ),
        ),
        const SizedBox(height: AppTheme.spacingSm),
        Text(
          'Transacción realizada con éxito.',
          style: TextStyle(
            fontSize: AppTheme.fontSizeBody,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildReceipt() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.outlineVariant.withValues(alpha: 0.5),
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              child: Column(
                children: [
                  _buildReceiptRow('Order ID', _orderId),
                  const SizedBox(height: AppTheme.spacingSm),
                  _buildReceiptRow('Date/Time', '$_date • $_time'),
                ],
              ),
            ),
            // Items
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Column(
                children: _orderItems.map((item) => _buildReceiptItem(item)).toList(),
              ),
            ),
            // Totals
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              color: AppTheme.surfaceContainerLow,
              child: Column(
                children: [
                  _buildReceiptRow('Subtotal', '\$${_subtotal.toStringAsFixed(2)}'),
                  const SizedBox(height: AppTheme.spacingSm),
                  _buildReceiptRow('Tax (8%)', '\$${_tax.toStringAsFixed(2)}'),
                  const SizedBox(height: AppTheme.spacingMd),
                  Container(
                    padding: const EdgeInsets.only(top: AppTheme.spacingSm),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: AppTheme.outlineVariant),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                            fontSize: AppTheme.fontSizeTitle,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primary,
                          ),
                        ),
                        Text(
                          '\$${_total.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: AppTheme.fontSizeTitle,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Payment Method
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
                    ),
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.creditCard,
                        size: 20,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment Method',
                          style: TextStyle(
                            fontSize: AppTheme.fontSizeSmall,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          _paymentMethod,
                          style: TextStyle(
                            fontSize: AppTheme.fontSizeLabel,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppTheme.fontSizeSmall,
            fontWeight: FontWeight.w500,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: AppTheme.fontSizeLabel,
            fontWeight: FontWeight.w600,
            color: AppTheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildReceiptItem(OrderItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeLabel,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.variant != null
                      ? 'Qty: ${item.quantity} • ${item.variant}'
                      : 'Qty: ${item.quantity}',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeSmall,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${(item.price * item.quantity).toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: AppTheme.fontSizeLabel,
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        PrimaryButton(
          text: 'Nueva Venta',
          onPressed: _onNewSale,
          icon: FontAwesomeIcons.cartShopping,
          borderRadius: AppTheme.borderRadiusXXl,
          fullWidth: true,
        ),
        const SizedBox(height: AppTheme.spacingSm),
        Row(
          children: [
            Expanded(
              child: CustomOutlinedButton(
                text: 'Imprimir',
                onPressed: _onPrint,
                icon: FontAwesomeIcons.print,
                textColor: AppTheme.secondary,
                borderColor: AppTheme.secondary,
                iconColor: AppTheme.secondary,
                borderRadius: AppTheme.borderRadiusXXl,
                fontSize: AppTheme.fontSizeLabel,
                iconSize: 18,
                height: 48,
                fullWidth: true,
              ),
            ),
            const SizedBox(width: AppTheme.spacingMd),
            Expanded(
              child: CustomOutlinedButton(
                text: 'Email',
                onPressed: _onEmail,
                icon: FontAwesomeIcons.envelope,
                textColor: AppTheme.secondary,
                borderColor: AppTheme.secondary,
                iconColor: AppTheme.secondary,
                borderRadius: AppTheme.borderRadiusXXl,
                fontSize: AppTheme.fontSizeLabel,
                iconSize: 18,
                height: 48,
                fullWidth: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;
  final String? variant;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
    this.variant,
  });
}

class CheckMarkPainter extends CustomPainter {
  final double progress;
  final Color color;

  CheckMarkPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final p1 = Offset(size.width * 0.2, size.height * 0.5);
    final p2 = Offset(size.width * 0.45, size.height * 0.75);
    final p3 = Offset(size.width * 0.8, size.height * 0.25);

    final path = Path();

    if (progress < 0.5) {
      // Dibujar solo la primera línea (de p1 a p2)
      final t = progress * 2;
      final currentX = p1.dx + (p2.dx - p1.dx) * t;
      final currentY = p1.dy + (p2.dy - p1.dy) * t;
      path.moveTo(p1.dx, p1.dy);
      path.lineTo(currentX, currentY);
    } else {
      // Dibujar la primera línea completa
      path.moveTo(p1.dx, p1.dy);
      path.lineTo(p2.dx, p2.dy);

      // Dibujar la segunda línea (de p2 a p3)
      final t = (progress - 0.5) * 2;
      final currentX = p2.dx + (p3.dx - p2.dx) * t;
      final currentY = p2.dy + (p3.dy - p2.dy) * t;
      path.lineTo(currentX, currentY);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CheckMarkPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
