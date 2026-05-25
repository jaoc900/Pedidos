import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:flutter/gestures.dart';

class UpgradeFlowScreen extends StatefulWidget {
  const UpgradeFlowScreen({super.key});

  @override
  State<UpgradeFlowScreen> createState() => _UpgradeFlowScreenState();
}

class _UpgradeFlowScreenState extends State<UpgradeFlowScreen> {
  int _selectedPlan = 1; // 0: Basic, 1: Pro, 2: Enterprise
  String _selectedPaymentMethod = 'credit_card';
  bool _acceptTerms = false;
  bool _isLoading = false;

  final List<PlanData> _plans = [
    PlanData(
      id: 0,
      name: 'Basic',
      price: 99.00,
      priceId: 'price_basic',
      description: 'Para negocios que están comenzando',
      features: [
        'Hasta 500 órdenes/mes',
        '10 usuarios',
        'Soporte por email',
        'Reportes básicos',
        'API básica',
      ],
      color: AppTheme.primary,
      isPopular: false,
    ),
    PlanData(
      id: 1,
      name: 'Growth Pro',
      price: 299.00,
      priceId: 'price_pro',
      description: 'Para negocios en crecimiento',
      features: [
        'Hasta 10,000 órdenes/mes',
        '50 usuarios',
        'Soporte prioritario',
        'Reportes avanzados',
        'API completa',
        'Automatizaciones',
        'Panel de analytics',
      ],
      color: AppTheme.loginButtonColor,
      isPopular: true,
    ),
    PlanData(
      id: 2,
      name: 'Enterprise',
      price: 799.00,
      priceId: 'price_enterprise',
      description: 'Para grandes corporaciones',
      features: [
        'Órdenes ilimitadas',
        'Usuarios ilimitados',
        'Soporte 24/7',
        'Reportes personalizados',
        'API completa + Webhooks',
        'Automatizaciones avanzadas',
        'SLA garantizado',
        'Account Manager dedicado',
      ],
      color: AppTheme.tertiary,
      isPopular: false,
    ),
  ];

  void _handleUpgrade() {
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes aceptar los términos y condiciones'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simular proceso de pago
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Plan ${_plans[_selectedPlan].name} activado exitosamente!'),
          backgroundColor: AppTheme.secondary,
        ),
      );

      Navigator.pop(context);
    });
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
                      // Header
                      _buildHeader(),
                      const SizedBox(height: AppTheme.spacingXl),
                      // Planes
                      _buildPlansSection(),
                      const SizedBox(height: AppTheme.spacingXl),
                      // Método de pago
                      _buildPaymentMethodSection(),
                      const SizedBox(height: AppTheme.spacingXl),
                      // Resumen
                      _buildSummarySection(),
                      const SizedBox(height: AppTheme.spacingXl),
                      // Términos y botón
                      _buildTermsAndButton(),
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
        color: Colors.white,
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
                  'Upgrade Plan',
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

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Elige el plan perfecto para ti',
          style: TextStyle(
            fontSize: AppTheme.fontSizeHeadline,
            fontWeight: FontWeight.w700,
            color: AppTheme.onSurface,
          ),
        ),
        const SizedBox(height: AppTheme.spacingSm),
        Text(
          'Selecciona el plan que mejor se adapte a las necesidades de tu negocio. Puedes cambiar o cancelar en cualquier momento.',
          style: TextStyle(
            fontSize: AppTheme.fontSizeBody,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildPlansSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: AppTheme.spacingMd),
            Text(
              'Planes disponibles',
              style: TextStyle(
                fontSize: AppTheme.fontSizeTitle,
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingLg),
        LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 800;

            if (isDesktop) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (int i = 0; i < _plans.length; i++) ...[
                    Expanded(
                      child: _buildPlanCard(_plans[i], i == _selectedPlan),
                    ),
                    if (i < _plans.length - 1) const SizedBox(width: AppTheme.spacingLg),
                  ],
                ],
              );
            } else {
              return Column(
                children: [
                  for (int i = 0; i < _plans.length; i++) ...[
                    _buildPlanCard(_plans[i], i == _selectedPlan),
                    if (i < _plans.length - 1) const SizedBox(height: AppTheme.spacingLg),
                  ],
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildPlanCard(PlanData plan, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPlan = plan.id;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? plan.color.withValues(alpha: 0.05) : AppTheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
          border: Border.all(
            color: isSelected ? plan.color : AppTheme.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: plan.color.withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header del plan
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              decoration: BoxDecoration(
                color: isSelected ? plan.color : Colors.transparent,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppTheme.borderRadiusXl),
                  topRight: Radius.circular(AppTheme.borderRadiusXl),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        plan.name,
                        style: TextStyle(
                          fontSize: AppTheme.fontSizeTitle,
                          fontWeight: FontWeight.w800,
                          color: isSelected ? Colors.white : plan.color,
                        ),
                      ),
                      if (plan.isPopular)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacingSm,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : AppTheme.primaryContainer,
                            borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                          ),
                          child: Text(
                            'POPULAR',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: isSelected ? plan.color : AppTheme.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingSm),
                  Text(
                    plan.description,
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeSmall,
                      color: isSelected ? Colors.white.withValues(alpha: 0.8) : AppTheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingLg),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '\$${plan.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: isSelected ? Colors.white : AppTheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '/mes',
                        style: TextStyle(
                          fontSize: AppTheme.fontSizeSmall,
                          color: isSelected ? Colors.white.withValues(alpha: 0.7) : AppTheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Features
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Características:',
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeSmall,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? plan.color : AppTheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  ...plan.features.map((feature) => Padding(
                    padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
                    child: Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.circleCheck,
                          size: 14,
                          color: isSelected ? plan.color : AppTheme.secondary,
                        ),
                        const SizedBox(width: AppTheme.spacingSm),
                        Expanded(
                          child: Text(
                            feature,
                            style: TextStyle(
                              fontSize: AppTheme.fontSizeSmall,
                              color: isSelected ? AppTheme.onSurfaceVariant : AppTheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: AppTheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Text(
                'Método de pago',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeTitle,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          _buildPaymentOption(
            value: 'credit_card',
            title: 'Tarjeta de crédito/débito',
            subtitle: 'Visa, Mastercard, American Express',
            icon: FontAwesomeIcons.creditCard,
            isSelected: _selectedPaymentMethod == 'credit_card',
            onTap: () => setState(() => _selectedPaymentMethod = 'credit_card'),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          _buildPaymentOption(
            value: 'paypal',
            title: 'PayPal',
            subtitle: 'Paga con tu cuenta de PayPal',
            icon: FontAwesomeIcons.paypal,
            isSelected: _selectedPaymentMethod == 'paypal',
            onTap: () => setState(() => _selectedPaymentMethod = 'paypal'),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          _buildPaymentOption(
            value: 'transfer',
            title: 'Transferencia bancaria',
            subtitle: 'Pago mediante transferencia',
            icon: FontAwesomeIcons.buildingColumns,
            isSelected: _selectedPaymentMethod == 'transfer',
            onTap: () => setState(() => _selectedPaymentMethod = 'transfer'),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required String value,
    required String title,
    required String subtitle,
    required FaIconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary.withValues(alpha: 0.05) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: _selectedPaymentMethod,
              onChanged: (_) => onTap(),
              activeColor: AppTheme.primary,
            ),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary.withValues(alpha: 0.1) : AppTheme.surfaceContainer,
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
              ),
              child: Center(
                child: FaIcon(
                  icon,
                  size: 20,
                  color: isSelected ? AppTheme.primary : AppTheme.outline,
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
                      fontSize: AppTheme.fontSizeBody,
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
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection() {
    final selectedPlan = _plans[_selectedPlan];
    final tax = selectedPlan.price * 0.16;
    final total = selectedPlan.price + tax;

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
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Text(
                'Resumen del pedido',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeTitle,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          _buildSummaryRow('Plan seleccionado', selectedPlan.name),
          _buildSummaryRow('Precio mensual', '\$${selectedPlan.price.toStringAsFixed(2)}'),
          _buildSummaryRow('IVA (16%)', '\$${tax.toStringAsFixed(2)}'),
          const Divider(),
          _buildSummaryRow('Total mensual', '\$${total.toStringAsFixed(2)}', isBold: true, color: AppTheme.primary),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingSm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: AppTheme.fontSizeBody,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: AppTheme.fontSizeBody,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              color: color ?? AppTheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsAndButton() {
    return Column(
      children: [
        Row(
          children: [
            Checkbox(
              value: _acceptTerms,
              onChanged: (value) {
                setState(() {
                  _acceptTerms = value ?? false;
                });
              },
              activeColor: AppTheme.primary,
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeSmall,
                    color: AppTheme.onSurfaceVariant,
                  ),
                  children: [
                    const TextSpan(text: 'Acepto los '),
                    TextSpan(
                      text: 'términos y condiciones',
                      style: const TextStyle(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = _showTermsDialog,
                    ),
                    const TextSpan(text: ' y la '),
                    TextSpan(
                      text: 'política de privacidad',
                      style: const TextStyle(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = _showPrivacyDialog,
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingLg),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleUpgrade,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.loginButtonColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
              ),
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
                : const Text('Confirmar y pagar'),
          ),
        ),
      ],
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Términos y Condiciones'),
        content: const SingleChildScrollView(
          child: Text(
            'Términos y condiciones de la suscripción...\n\n'
                '1. El pago se realizará mensualmente de forma automática.\n'
                '2. Puedes cancelar tu suscripción en cualquier momento.\n'
                '3. Los datos de facturación deben ser correctos.\n'
                '4. Aplican cargos por uso excesivo de recursos.\n\n'
                'Versión actualizada: Mayo 2025',
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

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Política de Privacidad'),
        content: const SingleChildScrollView(
          child: Text(
            'Política de privacidad...\n\n'
                'Protegemos tus datos personales y de pago.\n'
                'No compartimos información con terceros sin consentimiento.\n'
                'Utilizamos cifrado para todas las transacciones.',
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
}

class PlanData {
  final int id;
  final String name;
  final double price;
  final String priceId;
  final String description;
  final List<String> features;
  final Color color;
  final bool isPopular;

  PlanData({
    required this.id,
    required this.name,
    required this.price,
    required this.priceId,
    required this.description,
    required this.features,
    required this.color,
    required this.isPopular,
  });
}