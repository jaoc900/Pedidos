import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';

class RegisterExpenseScreen extends StatefulWidget {
  const RegisterExpenseScreen({super.key});

  @override
  State<RegisterExpenseScreen> createState() => _RegisterExpenseScreenState();
}

class _RegisterExpenseScreenState extends State<RegisterExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String _selectedCategory = '';
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  final List<String> _categories = [
    'Combustible',
    'Alquiler',
    'Insumos',
    'Servicios',
    'Otros',
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primary,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _formatDate(picked);
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _saveExpense() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor selecciona una categoría'),
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

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gasto registrado exitosamente'),
              backgroundColor: AppTheme.primary,
            ),
          );
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // TopAppBar con botón de guardar
          _buildTopAppBar(context),
          // Contenido principal
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingXl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Hero Illustration Card
                  _buildHeroCard(),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Form Container
                  _buildForm(),
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
    return CustomTopAppBar(
      title: 'Registrar gasto',
      showBackButton: true,
      onBackPressed: () => Navigator.pop(context),
      actions:[
        AppBarButton(
            icon: FontAwesomeIcons.save,
            onPressed: () =>{})
      ]
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
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
                'Nueva Transacción',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeSmall,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                  color: AppTheme.onPrimaryContainer.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Mantén tus finanzas\nbajo control',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeTitle,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
          Positioned(
            right: -20,
            bottom: -30,
            child: FaIcon(
              FontAwesomeIcons.wallet,
              size: 100,
              color: AppTheme.onPrimaryContainer.withValues(alpha: 0.2),
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
        border: Border.all(color: AppTheme.surfaceContainerHigh),
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
            // Categoría del Gasto
            _buildDropdownField(
              label: 'Categoría del Gasto',
              value: _selectedCategory,
              items: _categories,
              hint: 'Selecciona una opción',
              icon: FontAwesomeIcons.tag,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
            const SizedBox(height: AppTheme.spacingLg),
            // Monto
            _buildAmountField(),
            const SizedBox(height: AppTheme.spacingLg),
            // Fecha del Gasto
            _buildDateField(),
            const SizedBox(height: AppTheme.spacingLg),
            // Descripción
            _buildDescriptionField(),
            const SizedBox(height: AppTheme.spacingLg),
            // Adjuntar Comprobante
            _buildAttachmentSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required String hint,
    required FaIconData icon,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FaIcon(icon, size: 14, color: AppTheme.primary),
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
            color: AppTheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
            border: Border.all(color: AppTheme.outlineVariant),
          ),
          child: DropdownButtonFormField<String>(
            value: value.isEmpty ? null : value,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppTheme.spacingLg,
              ),
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
              return DropdownMenuItem<String>(value: item, child: Text(item));
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildAmountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FaIcon(
              FontAwesomeIcons.dollarSign,
              size: 14,
              color: AppTheme.primary,
            ),
            const SizedBox(width: AppTheme.spacingSm),
            Text(
              'Monto',
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
          controller: _amountController,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa el monto';
            }
            if (double.tryParse(value) == null) {
              return 'Ingresa un monto válido';
            }
            return null;
          },
          decoration: InputDecoration(
            prefixText: '\$ ',
            prefixStyle: TextStyle(
              fontSize: AppTheme.fontSizeTitle,
              fontWeight: FontWeight.w600,
              color: AppTheme.primary,
            ),
            hintText: '0.00',
            hintStyle: TextStyle(
              color: AppTheme.outlineVariant,
              fontSize: AppTheme.fontSizeTitle,
            ),
            filled: true,
            fillColor: AppTheme.surfaceContainerLow,
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

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FaIcon(
              FontAwesomeIcons.calendar,
              size: 14,
              color: AppTheme.primary,
            ),
            const SizedBox(width: AppTheme.spacingSm),
            Text(
              'Fecha del Gasto',
              style: TextStyle(
                fontSize: AppTheme.fontSizeLabel,
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingSm),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
              border: Border.all(color: AppTheme.outlineVariant),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _dateController.text.isEmpty
                      ? _formatDate(_selectedDate)
                      : _dateController.text,
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeBody,
                    color: AppTheme.onSurface,
                  ),
                ),
                FaIcon(
                  FontAwesomeIcons.chevronDown,
                  size: 16,
                  color: AppTheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FaIcon(
              FontAwesomeIcons.alignLeft,
              size: 14,
              color: AppTheme.primary,
            ),
            const SizedBox(width: AppTheme.spacingSm),
            Text(
              'Descripción',
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
          controller: _descriptionController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Detalles del gasto...',
            hintStyle: TextStyle(
              color: AppTheme.outlineVariant,
              fontSize: AppTheme.fontSizeBody,
            ),
            filled: true,
            fillColor: AppTheme.surfaceContainerLow,
            border: _buildInputBorder(),
            enabledBorder: _buildInputBorder(),
            focusedBorder: _buildFocusedBorder(),
            contentPadding: const EdgeInsets.all(AppTheme.spacingLg),
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FaIcon(
              FontAwesomeIcons.paperclip,
              size: 14,
              color: AppTheme.primary,
            ),
            const SizedBox(width: AppTheme.spacingSm),
            Text(
              'Adjuntar Comprobante',
              style: TextStyle(
                fontSize: AppTheme.fontSizeLabel,
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingSm),
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Funcionalidad: Adjuntar comprobante'),
                backgroundColor: AppTheme.primary,
              ),
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
              border: Border.all(
                color: AppTheme.outlineVariant,
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.camera,
                      size: 24,
                      color: AppTheme.onSecondaryContainer,
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingSm),
                Text(
                  'Subir foto o documento',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeLabel,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Formatos: JPG, PNG o PDF',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeSmall,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
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
