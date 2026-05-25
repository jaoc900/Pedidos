import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';

class PaymentCheckoutScreen extends StatefulWidget {
  final String planName;
  final double planPrice;

  const PaymentCheckoutScreen({
    super.key,
    this.planName = 'Plan Growth Pro',
    this.planPrice = 299.00,
  });

  @override
  State<PaymentCheckoutScreen> createState() => _PaymentCheckoutScreenState();
}

class _PaymentCheckoutScreenState extends State<PaymentCheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();

  bool _isLoading = false;
  bool _saveCard = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    super.dispose();
  }

  void _handlePayment() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Pago realizado exitosamente!'),
            backgroundColor: AppTheme.secondary,
          ),
        );
        Navigator.pop(context);
      });
    }
  }

  String _formatCardNumber(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    final List<String> groups = [];
    for (int i = 0; i < digits.length; i += 4) {
      if (i + 4 <= digits.length) {
        groups.add(digits.substring(i, i + 4));
      } else {
        groups.add(digits.substring(i));
      }
    }
    return groups.join(' ');
  }

  String _formatExpiry(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length >= 2) {
      return '${digits.substring(0, 2)}/${digits.substring(2, digits.length > 4 ? 4 : digits.length)}';
    }
    return digits;
  }

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
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderSection(),
                      const SizedBox(height: AppTheme.spacingXl),
                      _buildCheckoutGrid(),
                      const SizedBox(height: AppTheme.spacingXl),
                      _buildFooterPromotion(),
                      const SizedBox(height: AppTheme.spacingXl * 2),
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

  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXl, vertical: AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
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
                  'Finalizar Pago',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeTitle,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 700;

        return Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppTheme.spacingLg,
          runSpacing: AppTheme.spacingMd,
          children: [
            SizedBox(
              width: isDesktop ? 500 : double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Finalizar Pago de Membresía',
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeHeadline,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingSm),
                  Text(
                    'Complete sus detalles de pago para activar los beneficios profesionales de su cuenta.',
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeBody,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isDesktop)
              Container(
                width: 160,
                height: 48,
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.loginButtonColor, width: 1.5),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.shield,
                        size: 18,
                        color: AppTheme.loginButtonColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Pago Seguro',
                        style: TextStyle(
                          fontSize: AppTheme.fontSizeLabel,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.loginButtonColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildCheckoutGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 900;

        if (isDesktop) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 8,
                child: _buildPaymentForm(),
              ),
              const SizedBox(width: AppTheme.spacingLg),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    _buildOrderSummary(),
                    const SizedBox(height: AppTheme.spacingLg),
                    _buildHelpCard(),
                  ],
                ),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              _buildPaymentForm(),
              const SizedBox(height: AppTheme.spacingLg),
              _buildOrderSummary(),
              const SizedBox(height: AppTheme.spacingLg),
              _buildHelpCard(),
            ],
          );
        }
      },
    );
  }

  Widget _buildPaymentForm() {
    return Container(
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
                'Método de Pago',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeTitle,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurface,
                ),
              ),
              FaIcon(
                FontAwesomeIcons.creditCard,
                size: 24,
                color: AppTheme.primary,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingXl),
          Form(
            key: _formKey,
            child: Column(
              children: [
                _buildFormField(
                  controller: _cardNumberController,
                  label: 'Número de Tarjeta',
                  hint: '0000 0000 0000 0000',
                  icon: FontAwesomeIcons.creditCard,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final formatted = _formatCardNumber(value);
                    _cardNumberController.value = TextEditingValue(
                      text: formatted,
                      selection: TextSelection.collapsed(offset: formatted.length),
                    );
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Ingrese el número de tarjeta';
                    if (value.replaceAll(' ', '').length < 16) return 'Número de tarjeta inválido';
                    return null;
                  },
                ),
                const SizedBox(height: AppTheme.spacingLg),
                _buildFormField(
                  controller: _cardHolderController,
                  label: 'Nombre del Titular',
                  hint: 'Como aparece en la tarjeta',
                  icon: FontAwesomeIcons.user,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Ingrese el nombre del titular';
                    return null;
                  },
                ),
                const SizedBox(height: AppTheme.spacingLg),
                Row(
                  children: [
                    Expanded(
                      child: _buildFormField(
                        controller: _expiryController,
                        label: 'Vencimiento (MM/AA)',
                        hint: 'MM/AA',
                        icon: FontAwesomeIcons.calendar,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          final formatted = _formatExpiry(value);
                          _expiryController.value = TextEditingValue(
                            text: formatted,
                            selection: TextSelection.collapsed(offset: formatted.length),
                          );
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Requerido';
                          if (value.length < 5) return 'Formato inválido';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingLg),
                    Expanded(
                      child: _buildFormField(
                        controller: _cvcController,
                        label: 'CVC',
                        hint: '•••',
                        icon: FontAwesomeIcons.lock,
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Requerido';
                          if (value.length < 3) return 'CVC inválido';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
            ),
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.lock,
                  size: 20,
                  color: AppTheme.primary,
                ),
                const SizedBox(width: AppTheme.spacingMd),
                Expanded(
                  child: Text(
                    'Sus datos están protegidos con encriptación de grado bancario. No almacenamos los números completos de su tarjeta en nuestros servidores.',
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeSmall,
                      color: AppTheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Row(
            children: [
              Checkbox(
                value: _saveCard,
                onChanged: (value) {
                  setState(() {
                    _saveCard = value ?? false;
                  });
                },
                activeColor: AppTheme.primary,
              ),
              const Text('Guardar tarjeta para futuros pagos'),
              const Spacer(),
              Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.check,
                    size: 16,
                    color: AppTheme.secondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Garantía de 30 días',
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeLabel,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.primary,
              alignment: Alignment.centerLeft,
            ),
            child: const Text('Términos y Condiciones'),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required FaIconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    void Function(String)? onChanged,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppTheme.fontSizeLabel,
            fontWeight: FontWeight.w600,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppTheme.spacingSm),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppTheme.outlineVariant,
              fontSize: AppTheme.fontSizeBody,
            ),
            suffixIcon: FaIcon(
              icon,
              size: 18,
              color: AppTheme.outline,
            ),
            filled: true,
            fillColor: AppTheme.surfaceContainerLowest,
            border: _buildInputBorder(),
            enabledBorder: _buildInputBorder(),
            focusedBorder: _buildFocusedBorder(),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingLg,
              vertical: AppTheme.spacingLg,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummary() {
    final tax = widget.planPrice * 0.16;
    final total = widget.planPrice + tax;

    return Container(
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
                'Resumen',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeTitle,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurface,
                ),
              ),
              FaIcon(
                FontAwesomeIcons.bagShopping,
                size: 24,
                color: AppTheme.primary,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingSm,
              vertical: AppTheme.spacingSm,
            ),
            decoration: BoxDecoration(
              color: AppTheme.secondaryFixed,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
            ),
            child: Text(
              widget.planName,
              style: TextStyle(
                fontSize: AppTheme.fontSizeSmall,
                fontWeight: FontWeight.w700,
                color: AppTheme.onPrimaryFixed,
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          _buildSummaryRow('Subtotal', '\$${widget.planPrice.toStringAsFixed(2)}'),
          _buildSummaryRow('IVA (16%)', '\$${tax.toStringAsFixed(2)}'),
          const Divider(),
          const SizedBox(height: AppTheme.spacingSm),
          _buildSummaryRow('Total', '\$${total.toStringAsFixed(2)}', isBold: true, isLarge: true),
          const SizedBox(height: AppTheme.spacingXl),
          Container(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handlePayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.loginButtonColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
                ),
                elevation: 2,
              ),
              child: _isLoading
                  ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(FontAwesomeIcons.checkCircle, size: 18),
                  SizedBox(width: AppTheme.spacingSm),
                  Text('Pagar Ahora'),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Text(
            'Al confirmar, autorizas el cargo recurrente mensual según los términos seleccionados.',
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, bool isLarge = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingSm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isLarge ? AppTheme.fontSizeBody : AppTheme.fontSizeSmall,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isLarge ? AppTheme.fontSizeTitle : AppTheme.fontSizeBody,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              color: AppTheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpCard() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
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
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.primaryContainer.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.headset,
                size: 24,
                color: AppTheme.primary,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingLg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¿Necesitas ayuda?',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeLabel,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Contacta a nuestro equipo 24/7',
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

  Widget _buildFooterPromotion() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingXl),
      decoration: BoxDecoration(
        color: AppTheme.inverseSurface,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 600;

          if (isDesktop) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppTheme.tertiary,
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
                        ),
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.rocket,
                            size: 40,
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
                              '¿Deseas facturación corporativa?',
                              style: TextStyle(
                                fontSize: AppTheme.fontSizeTitle,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Para cuentas Enterprise con múltiples usuarios, ofrecemos métodos de pago vía transferencia bancaria.',
                              style: TextStyle(
                                fontSize: AppTheme.fontSizeBody,
                                color: AppTheme.onInverseSurface.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppTheme.spacingLg),
                Container(
                  width: 200,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.tertiaryFixed,
                      foregroundColor: AppTheme.onTertiaryFixed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
                      ),
                    ),
                    child: const Text('Hablar con Ventas'),
                  ),
                ),
              ],
            );
          } else {
            return Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppTheme.tertiary,
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
                      ),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.rocket,
                          size: 32,
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
                            '¿Deseas facturación corporativa?',
                            style: TextStyle(
                              fontSize: AppTheme.fontSizeTitle,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Para cuentas Enterprise con múltiples usuarios, ofrecemos métodos de pago vía transferencia bancaria.',
                            style: TextStyle(
                              fontSize: AppTheme.fontSizeSmall,
                              color: AppTheme.onInverseSurface.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingLg),
                Container(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.tertiaryFixed,
                      foregroundColor: AppTheme.onTertiaryFixed,
                    ),
                    child: const Text('Hablar con Ventas'),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  OutlineInputBorder _buildInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
      borderSide: BorderSide(color: AppTheme.outlineVariant, width: 1),
    );
  }

  OutlineInputBorder _buildFocusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
      borderSide: const BorderSide(color: AppTheme.primary, width: 2),
    );
  }
}