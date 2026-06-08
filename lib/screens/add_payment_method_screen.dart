import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';
import 'package:pedidos/widgets/custom_text_field.dart';
import 'package:pedidos/widgets/custom_dropdown_field.dart';

class AddPaymentMethodScreen extends StatefulWidget {
  const AddPaymentMethodScreen({super.key});

  @override
  State<AddPaymentMethodScreen> createState() => _AddPaymentMethodScreenState();
}

class _AddPaymentMethodScreenState extends State<AddPaymentMethodScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  String _selectedType = '';
  bool _isLoading = false;

  final List<String> _paymentTypes = [
    'Transferencia',
    'Efectivo',
    'Tarjeta',
    'Pago QR',
    'PayPal',
    'Otro',
  ];

  final List<Map<String, dynamic>> _suggestedMethods = [
    {'icon': FontAwesomeIcons.buildingColumns, 'name': 'Banco Local', 'type': 'Transferencia'},
    {'icon': FontAwesomeIcons.qrcode, 'name': 'Pago QR', 'type': 'Pago QR'},
    {'icon': FontAwesomeIcons.creditCard, 'name': 'Tarjeta de Crédito', 'type': 'Tarjeta'},
    {'icon': FontAwesomeIcons.paypal, 'name': 'PayPal', 'type': 'PayPal'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  void _savePaymentMethod() {
    if (_formKey.currentState!.validate()) {
      if (_selectedType.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor selecciona un tipo de pago'),
            backgroundColor: AppTheme.error,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // Simular guardado
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Método de pago guardado exitosamente'),
            backgroundColor: AppTheme.primary,
          ),
        );

        Navigator.pop(context);
      });
    }
  }

  void _useSuggestedMethod(String name, String type) {
    setState(() {
      _nameController.text = name;
      _selectedType = type;
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Form Container
                  _buildForm(),
                  const SizedBox(height: AppTheme.spacingLg),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopAppBar(BuildContext context) {
    return CustomTopAppBar(
      title: 'Registrar métodos',
      showBackButton: true,
      onBackPressed: () => Navigator.pop(context),
      actions: [
        AppBarButton(
            icon: FontAwesomeIcons.save,
            onPressed: () => {})
      ],
    );
  }

  Widget _buildForm() {
    return Container(
      width: double.infinity,
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Nombre del Método
            CustomTextField(
              controller: _nameController,
              label: 'Nombre del Método',
              hint: 'Ej: Banco Nacional o Stripe',
              icon: FontAwesomeIcons.tag,
              textInputAction: TextInputAction.next,
              borderRadius: AppTheme.borderRadiusXXl,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa el nombre';
                }
                return null;
              },
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Tipo de Pago
            _buildDropdownField(
              label: 'Tipo de Pago',
              value: _selectedType,
              items: _paymentTypes,
              icon: FontAwesomeIcons.moneyBill,
              hint: 'Seleccione una opción',
              onChanged: (value) {
                setState(() {
                  _selectedType = value ?? '';
                });
              },
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Detalles/Instrucciones
            CustomTextField(
              controller: _detailsController,
              label: 'Detalles/Instrucciones',
              hint: 'Ingrese números de cuenta, CLABE o instrucciones para el cliente...',
              icon: FontAwesomeIcons.fileLines,
              maxLines: 4,
              textInputAction: TextInputAction.done,
              borderRadius: AppTheme.borderRadiusXXl,
            ),
            const SizedBox(height: AppTheme.spacingLg),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required FaIconData icon,
    required String hint,
    required Function(String?) onChanged,
  }) {
    return CustomDropdownField(
      value: items.contains(value) ? value : null,
      label: label,
      hint: hint,
      items: items,
      icon: icon,
      onChanged: onChanged,
      enabled: true,
      showLabel: true,
      borderRadius: AppTheme.borderRadiusXXl,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Seleccione una opción';
        }
        return null;
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required FaIconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FaIcon(
              icon,
              size: 14,
              color: AppTheme.primary,
            ),
            const SizedBox(width: AppTheme.spacingSm),
            Text(
              label,
              style: TextStyle(
                fontSize: AppTheme.fontSizeLabel,
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingSm),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppTheme.outlineVariant,
              fontSize: AppTheme.fontSizeBody,
            ),
            filled: true,
            fillColor: AppTheme.surfaceBright,
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

  Widget _buildSuggestedMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Métodos Sugeridos',
          style: TextStyle(
            fontSize: AppTheme.fontSizeLabel,
            fontWeight: FontWeight.w600,
            color: AppTheme.onSurface,
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppTheme.spacingLg,
            mainAxisSpacing: AppTheme.spacingLg,
            childAspectRatio: 1.2,
          ),
          itemCount: _suggestedMethods.length,
          itemBuilder: (context, index) {
            final method = _suggestedMethods[index];
            return GestureDetector(
              onTap: () => _useSuggestedMethod(method['name'] as String, method['type'] as String),
              child: Container(
                padding: const EdgeInsets.all(AppTheme.spacingLg),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
                  border: Border.all(color: AppTheme.outlineVariant),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: FaIcon(
                          method['icon'] as FaIconData,
                          size: 24,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingSm),
                    Text(
                      method['name'] as String,
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeSmall,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
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