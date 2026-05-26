import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';

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
                  // Header Section
                  _buildHeader(),
                  const SizedBox(height: AppTheme.spacingLg),
                  // Illustration
                  _buildIllustration(),
                  const SizedBox(height: AppTheme.spacingLg),
                  // Form Container
                  _buildForm(),
                  const SizedBox(height: AppTheme.spacingLg),
                  // Suggested Methods
                  _buildSuggestedMethods(),
                  const SizedBox(height: AppTheme.spacingXl * 2),
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
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXl, vertical: AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.background,
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
                  'Registrar Método',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeTitle,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
            Text(
              'PAYLINK',
              style: TextStyle(
                fontSize: AppTheme.fontSizeLabel,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
                color: AppTheme.loginButtonColor,
              ),
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
          'Registrar Método de Pago',
          style: TextStyle(
            fontSize: AppTheme.fontSizeTitle,
            fontWeight: FontWeight.w700,
            color: AppTheme.onSurface,
          ),
        ),
        const SizedBox(height: AppTheme.spacingSm),
        Text(
          'Configure una nueva vía de cobro para su negocio con los detalles necesarios.',
          style: TextStyle(
            fontSize: AppTheme.fontSizeBody,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildIllustration() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
      child: Stack(
        children: [
          Image.network(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCpR11GxAP8CVOMCydc8jrHPPe5edcysf7tdACkXFbG19FV_yjI95_I83m1Si4DLFoP_tRDnoJO2wsAq8Riu23tTHIiYKDhQ9tBk5aSXttbuBDwVq_jRpzQB4QGI2KJ5Z7cwUctg97xH_jAWf-mE5UvdQxIUXTXBHzaN9ZOVfHZ4NAeui7j9_fcKKUdPuP_0zQaVgo2IgCRWBu_q8uZ8w90ioIXusXnkHU6qrN4X5eL0CQpCx1ZLtWPObRWEE30rdzUVW36LrhbHKLB',
            height: 160,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 160,
                color: AppTheme.primaryContainer.withValues(alpha: 0.1),
                child: const Center(
                  child: FaIcon(
                    FontAwesomeIcons.creditCard,
                    size: 48,
                    color: AppTheme.outline,
                  ),
                ),
              );
            },
          ),
          Container(
            height: 160,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ],
      ),
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
            _buildTextField(
              controller: _nameController,
              label: 'Nombre del Método',
              hint: 'Ej: Banco Nacional o Stripe',
              icon: FontAwesomeIcons.tag,
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
                  _selectedType = value;
                });
              },
            ),
            const SizedBox(height: AppTheme.spacingLg),
            // Detalles/Instrucciones
            _buildTextField(
              controller: _detailsController,
              label: 'Detalles/Instrucciones',
              hint: 'Ingrese números de cuenta, CLABE o instrucciones para el cliente...',
              icon: FontAwesomeIcons.fileLines,
              maxLines: 4,
            ),
            const SizedBox(height: AppTheme.spacingLg),
            // Information Card
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              decoration: BoxDecoration(
                color: AppTheme.secondaryContainer.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
                border: Border.all(color: AppTheme.secondaryContainer),
              ),
              child: Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.circleInfo,
                    size: 20,
                    color: AppTheme.secondary,
                  ),
                  const SizedBox(width: AppTheme.spacingMd),
                  Expanded(
                    child: Text(
                      'Esta información será visible para sus clientes al momento de realizar el pago.',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeSmall,
                        color: AppTheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),
            // Save Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _savePaymentMethod,
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
                    : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(FontAwesomeIcons.save, size: 18),
                    SizedBox(width: AppTheme.spacingSm),
                    Text('Guardar Método'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required FaIconData icon,
    required String hint,
    required void Function(String) onChanged,
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
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceBright,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
            border: Border.all(color: AppTheme.outlineVariant),
          ),
          child: DropdownButtonFormField<String>(
            value: value.isEmpty ? null : value,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
            ),
            hint: Text(
              hint,
              style: TextStyle(
                color: AppTheme.outlineVariant,
                fontSize: AppTheme.fontSizeBody,
              ),
            ),
            icon: FaIcon(
              FontAwesomeIcons.chevronDown,
              size: 16,
              color: AppTheme.onSurfaceVariant,
            ),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: (newValue) {
              if (newValue != null) {
                onChanged(newValue);
              }
            },
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