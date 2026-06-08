import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';
import 'package:pedidos/widgets/primary_button.dart';
import 'package:pedidos/enums/botton_status_enum.dart';
import 'package:pedidos/widgets/custom_text_field.dart';
import 'package:pedidos/screens/modals/confirmation_modal.dart';
import 'package:pedidos/screens/pos_payment_succes_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  PaymentMethod _selectedPaymentMethod = PaymentMethod.cash;
  String _amountInput = "0.00";
  final double _subtotal = 1245.50;
  final double _tax = 199.28;
  final String _transactionId = "2490-AGR";

  double get _total => _subtotal + _tax;
  double get _paid => double.tryParse(_amountInput) ?? 0.0;
  double get _change => _paid >= _total ? _paid - _total : 0.0;

  void _pressKey(String key) {
    setState(() {
      if (key == 'backspace') {
        if (_amountInput.length > 1) {
          _amountInput = _amountInput.substring(0, _amountInput.length - 1);
          if (_amountInput.isEmpty) _amountInput = "0.00";
        } else {
          _amountInput = "0.00";
        }
      } else if (key == '.') {
        if (!_amountInput.contains('.')) {
          _amountInput += '.';
        }
      } else {
        if (_amountInput == "0.00" || _amountInput == "0") {
          _amountInput = key;
        } else {
          if (_amountInput.contains('.')) {
            final decimals = _amountInput.split('.')[1];
            if (decimals.length < 2) {
              _amountInput += key;
            }
          } else {
            _amountInput += key;
          }
        }
      }
    });
  }

  void _selectPaymentMethod(PaymentMethod method) {
    setState(() {
      _selectedPaymentMethod = method;
    });
  }

  void _completeSale() {
    if (_paid < _total) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('El monto pagado es insuficiente'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }

    // Usar ConfirmationModal para mostrar el resumen de la venta
    context.showConfirmation(
      title: 'Venta Completada',
      message: 'Transacción: #$_transactionId\n\n'
          'Total: \$${_total.toStringAsFixed(2)}\n'
          'Pagado: \$${_paid.toStringAsFixed(2)}\n'
          'Cambio: \$${_change.toStringAsFixed(2)}',
      confirmText: 'Ver Recibo',
      cancelText: 'Cerrar',
      type: ConfirmationType.success,
      customIcon: FontAwesomeIcons.receipt,
      onConfirm: () {
        // Navegar a la pantalla de éxito
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PaymentSuccessScreen(),
          ),
        );
      },
      onCancel: () {
        // Solo cerrar el modal y volver al POS
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;
    final isTablet = screenSize.width >= 600;
    final isTabletLandscape = isTablet && isLandscape;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopAppBar(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(AppTheme.spacingLg),
                child: Center(
                  child: isTabletLandscape
                      ? _buildTabletLandscapeLayout()
                      : _buildMobilePortraitLayout(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Layout para tablet en horizontal (Checkout a la izquierda, Pago a la derecha)
  Widget _buildTabletLandscapeLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sección izquierda: Checkout (Resumen)
        Expanded(
          flex: 1,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTransactionHeader(),
                const SizedBox(height: AppTheme.spacingLg),
                _buildSummaryCard(),
                const SizedBox(height: AppTheme.spacingLg),
                _buildConfirmButton(),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppTheme.spacingXl),
        // Sección derecha: Método de Pago y Numpad
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildPaymentMethods(),
              const SizedBox(height: AppTheme.spacingLg),
              _buildAmountInput(),
              const SizedBox(height: AppTheme.spacingLg),
              _buildNumpad(),
            ],
          ),
        ),
      ],
    );
  }

  // Layout para móvil y tablet en vertical
  Widget _buildMobilePortraitLayout() {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width >= 600;
    final maxWidth = isTablet ? 500.0 : double.infinity;

    return SizedBox(
      width: maxWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTransactionHeader(),
          const SizedBox(height: AppTheme.spacingLg),
          _buildSummaryCard(),
          const SizedBox(height: AppTheme.spacingLg),
          _buildPaymentMethods(),
          const SizedBox(height: AppTheme.spacingLg),
          _buildAmountInput(),
          const SizedBox(height: AppTheme.spacingLg),
          _buildNumpad(),
          const SizedBox(height: AppTheme.spacingLg),
          _buildConfirmButton(),
        ],
      ),
    );
  }

  Widget _buildTopAppBar() {
    return CustomTopAppBar(
      title: 'Método de pago',
      showBackButton: true,
    );
  }

  Widget _buildTransactionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Checkout',
              style: TextStyle(
                fontSize: AppTheme.fontSizeSmall,
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurfaceVariant,
                letterSpacing: 1,
              ),
            ),
            Text(
              'Transacción #$_transactionId',
              style: TextStyle(
                fontSize: AppTheme.fontSizeHeadline,
                fontWeight: FontWeight.w700,
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
            color: AppTheme.secondaryContainer,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
          ),
          child: Text(
            'PENDIENTE',
            style: TextStyle(
              fontSize: AppTheme.fontSizeLabel,
              fontWeight: FontWeight.w700,
              color: AppTheme.onSecondaryContainer,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard() {
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
        children: [
          _buildSummaryRow('Subtotal', '\$${_subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: AppTheme.spacingSm),
          _buildSummaryRow('Impuestos (16%)', '\$${_tax.toStringAsFixed(2)}'),
          const Divider(height: AppTheme.spacingLg),
          _buildSummaryRow(
            'Total',
            '\$${_total.toStringAsFixed(2)}',
            isBold: true,
            isHighlighted: true,
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainer,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cambio',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeLabel,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  '\$${_change.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: _change > 0 ? AppTheme.primary : AppTheme.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, bool isHighlighted = false}) {
    return Row(
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
          value,
          style: TextStyle(
            fontSize: isBold ? AppTheme.fontSizeTitle : AppTheme.fontSizeBody,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            color: isHighlighted ? AppTheme.primary : AppTheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethods() {
    final methods = [
      (method: PaymentMethod.cash, icon: FontAwesomeIcons.moneyBill, label: 'Efectivo'),
      (method: PaymentMethod.card, icon: FontAwesomeIcons.creditCard, label: 'Tarjeta'),
      (method: PaymentMethod.transfer, icon: FontAwesomeIcons.buildingColumns, label: 'Transf.'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Método de Pago',
          style: TextStyle(
            fontSize: AppTheme.fontSizeLabel,
            fontWeight: FontWeight.w600,
            color: AppTheme.onSurfaceVariant,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),
        Row(
          children: methods.map((item) {
            final isSelected = _selectedPaymentMethod == item.method;
            return Expanded(
              child: GestureDetector(
                onTap: () => _selectPaymentMethod(item.method),
                child: Container(
                  margin: EdgeInsets.only(
                    right: item.method == PaymentMethod.transfer ? 0 : AppTheme.spacingMd,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingLg),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primaryContainer
                        : AppTheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
                    border: Border.all(
                      color: isSelected ? AppTheme.primary : AppTheme.outlineVariant,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      FaIcon(
                        item.icon,
                        size: 24,
                        color: isSelected ? AppTheme.onPrimaryContainer : AppTheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: AppTheme.spacingSm),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: AppTheme.fontSizeSmall,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? AppTheme.onPrimaryContainer : AppTheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAmountInput() {
    return CustomTextField(
      controller: TextEditingController(text: _amountInput),
      label: '',
      hint: '',
      icon: FontAwesomeIcons.dollarSign,
      readOnly: true,
      textAlign: TextAlign.right,
      borderRadius: AppTheme.borderRadiusXl,
      showLabel: false,
      customPrefix: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
        child: Text(
          '\$',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
      ),
      textStyle: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: AppTheme.onSurface,
      ),
    );
  }

  Widget _buildNumpad() {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize = screenWidth < 400 ? 56.0 : 64.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = 3;
        final spacing = AppTheme.spacingMd;
        final buttonWidth = (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: columns,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          childAspectRatio: buttonWidth / buttonSize,
          children: [
            _buildNumpadButton('1'),
            _buildNumpadButton('2'),
            _buildNumpadButton('3'),
            _buildNumpadButton('4'),
            _buildNumpadButton('5'),
            _buildNumpadButton('6'),
            _buildNumpadButton('7'),
            _buildNumpadButton('8'),
            _buildNumpadButton('9'),
            _buildNumpadButton('.'),
            _buildNumpadButton('0'),
            _buildNumpadButton('backspace', isBackspace: true),
          ],
        );
      },
    );
  }

  Widget _buildNumpadButton(String key, {bool isBackspace = false}) {
    return GestureDetector(
      onTap: () => _pressKey(key),
      child: Container(
        decoration: BoxDecoration(
          color: isBackspace ? AppTheme.errorContainer : AppTheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        ),
        child: Center(
          child: isBackspace
              ? FaIcon(
            FontAwesomeIcons.deleteLeft,
            size: 24,
            color: AppTheme.error,
          )
              : Text(
            key,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return PrimaryButton(
      text: 'Finalizar Venta',
      onPressed: _completeSale,
      icon: FontAwesomeIcons.circleCheck,
      state: ButtonState.active,
      borderRadius: AppTheme.borderRadiusFull,
      fullWidth: true,
    );
  }
}

enum PaymentMethod {
  cash,
  card,
  transfer,
}