import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/widgets/custom_text_field.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';
import 'package:pedidos/widgets/custom_outlined_button.dart';
import 'package:pedidos/widgets/primary_button.dart';
import 'package:pedidos/enums/botton_status_enum.dart';

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
      appBar: CustomTopAppBar(
        title: 'Finalizar pago',
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
                      _buildHeaderSection(),
                      const SizedBox(height: AppTheme.spacingXl),
                      _buildCheckoutGrid(),
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

  Widget _buildHeaderSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 700;

        if (isDesktop) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Frase a la izquierda
              Expanded(
                child: Text(
                  'Complete sus detalles de pago para activar los beneficios profesionales de su cuenta.',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeBody,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacingLg),
              // Botón a la derecha
              CustomOutlinedButton(
                text: 'Pago Seguro',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Información de pago seguro'),
                      backgroundColor: AppTheme.primary,
                    ),
                  );
                },
                icon: FontAwesomeIcons.shield,
                textColor: AppTheme.loginButtonColor,
                borderColor: AppTheme.loginButtonColor,
                borderRadius: AppTheme.borderRadiusXl,
                fontSize: AppTheme.fontSizeLabel,
                iconSize: 18,
                height: 48,
                fullWidth: false,
              ),
            ],
          );
        } else {
          // Versión móvil: frase arriba, botón abajo
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Complete sus detalles de pago para activar los beneficios profesionales de su cuenta.',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeBody,
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppTheme.spacingLg),
              CustomOutlinedButton(
                text: 'Pago Seguro',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Información de pago seguro'),
                      backgroundColor: AppTheme.primary,
                    ),
                  );
                },
                icon: FontAwesomeIcons.shield,
                textColor: AppTheme.loginButtonColor,
                borderColor: AppTheme.loginButtonColor,
                borderRadius: AppTheme.borderRadiusXXl,
                fontSize: AppTheme.fontSizeLabel,
                iconSize: 18,
                height: 48,
                fullWidth: true, // Ancho completo en móvil
              ),
            ],
          );
        }
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
                // Número de Tarjeta
                CustomTextField(
                  controller: _cardNumberController,
                  label: 'Número de Tarjeta',
                  hint: '0000 0000 0000 0000',
                  icon: FontAwesomeIcons.creditCard,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  borderRadius: AppTheme.borderRadiusXXl,
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

                // Nombre del Titular
                CustomTextField(
                  controller: _cardHolderController,
                  label: 'Nombre del Titular',
                  hint: 'Como aparece en la tarjeta',
                  icon: FontAwesomeIcons.user,
                  textInputAction: TextInputAction.next,
                  borderRadius: AppTheme.borderRadiusXXl,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Ingrese el nombre del titular';
                    return null;
                  },
                ),
                const SizedBox(height: AppTheme.spacingLg),

                // Fila: Vencimiento y CVC
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _expiryController,
                        label: 'Vencimiento (MM/AA)',
                        hint: 'MM/AA',
                        icon: FontAwesomeIcons.calendar,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        borderRadius: AppTheme.borderRadiusXXl,
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
                      child: CustomTextField(
                        controller: _cvcController,
                        label: 'CVC',
                        hint: '•••',
                        icon: FontAwesomeIcons.lock,
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        borderRadius: AppTheme.borderRadiusXXl,
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

          // Información de seguridad
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

          // Checkbox y garantía
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

          // Términos y Condiciones
          TextButton(
            onPressed: () {
              _showTermsDialog();
            },
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

// Método para mostrar diálogo de términos
  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Términos y Condiciones'),
        content: const SingleChildScrollView(
          child: Text(
            'Aquí irían los términos y condiciones completos del pago...\n\n'
                'Este es un texto de ejemplo para mostrar cómo se vería el diálogo.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
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

          // Botón de pago - Usando PrimaryButton
          PrimaryButton(
            text: 'Pagar Ahora',
            onPressed: _isLoading ? null : _handlePayment,
            state: _isLoading ? ButtonState.loading : ButtonState.active,
            icon: FontAwesomeIcons.checkCircle,
            activeColor: AppTheme.loginButtonColor,
            textColor: Colors.white,
            iconColor: Colors.white,
            borderRadius: AppTheme.borderRadiusXXl,
            fontSize: AppTheme.fontSizeLabel,
            iconSize: 18,
            height: 56,
            fullWidth: true,
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
}