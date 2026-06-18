import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';
import 'package:pedidos/models/payment_method_model.dart';
import 'package:pedidos/core/network/http_client.dart';
import 'package:pedidos/core/network/api_client.dart';

class AddPaymentMethodScreen extends StatefulWidget {
  final PaymentMethod? paymentMethod;

  const AddPaymentMethodScreen({super.key, this.paymentMethod});

  @override
  State<AddPaymentMethodScreen> createState() => _AddPaymentMethodScreenState();
}

class _AddPaymentMethodScreenState extends State<AddPaymentMethodScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  int _selectedIconIndex = 0;
  Color _selectedColor = AppTheme.primary;
  bool _isActive = true;
  bool _isLoading = false;

  late ApiClient _apiClient;

  final List<Map<String, dynamic>> _icons = [
    {'icon': FontAwesomeIcons.moneyBill, 'name': 'moneyBill', 'label': 'Efectivo'},
    {'icon': FontAwesomeIcons.buildingColumns, 'name': 'buildingColumns', 'label': 'Banco'},
    {'icon': FontAwesomeIcons.creditCard, 'name': 'creditCard', 'label': 'Tarjeta'},
    {'icon': FontAwesomeIcons.qrcode, 'name': 'qrcode', 'label': 'Código QR'},
    {'icon': FontAwesomeIcons.paypal, 'name': 'paypal', 'label': 'PayPal'},
    {'icon': FontAwesomeIcons.mobileScreenButton, 'name': 'mobile', 'label': 'Móvil'},
    {'icon': FontAwesomeIcons.wallet, 'name': 'wallet', 'label': 'Cartera'},
    {'icon': FontAwesomeIcons.bitcoin, 'name': 'bitcoin', 'label': 'Bitcoin'},
    {'icon': FontAwesomeIcons.applePay, 'name': 'applePay', 'label': 'Apple Pay'},
    {'icon': FontAwesomeIcons.googlePay, 'name': 'googlePay', 'label': 'Google Pay'},
  ];

  final List<Color> _colorOptions = [
    AppTheme.primary,
    AppTheme.secondary,
    AppTheme.tertiary,
    AppTheme.error,
    const Color(0xFF9C27B0), // Morado
    const Color(0xFF2196F3), // Azul
    const Color(0xFF009688), // Teal
    const Color(0xFFFF9800), // Naranja
    const Color(0xFF795548), // Marrón
    const Color(0xFF607D8B), // Gris azulado
    const Color(0xFFE91E63), // Rosa
    const Color(0xFF00BCD4), // Cian
  ];

  @override
  void initState() {
    super.initState();
    _initialize();
    if (widget.paymentMethod != null) {
      _loadPaymentMethodData();
    }
  }

  Future<void> _initialize() async {
    final httpClient = HttpClient();
    _apiClient = ApiClient(httpClient);
  }

  void _loadPaymentMethodData() {
    final method = widget.paymentMethod!;
    _nameController.text = method.name;
    _isActive = method.isActive;

    // Buscar el índice del icono existente
    final iconIndex = _icons.indexWhere((i) => i['name'] == method.icon);
    if (iconIndex != -1) _selectedIconIndex = iconIndex;

    // Buscar el color existente
    if (method.color != null) {
      try {
        final hexColor = method.color!;
        if (hexColor.startsWith('#')) {
          final color = Color(int.parse('0xFF${hexColor.substring(1)}'));
          if (_colorOptions.contains(color)) {
            _selectedColor = color;
          }
        }
      } catch (e) {
        _selectedColor = AppTheme.primary;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _savePaymentMethod() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final selectedIcon = _icons[_selectedIconIndex];
      final colorHex =
          '#${_selectedColor.value.toRadixString(16).substring(2)}';

      final data = {
        'name': _nameController.text.trim(),
        'icon': selectedIcon['name'],
        'color': colorHex,
        'isActive': _isActive,
      };

      if (widget.paymentMethod == null) {
        await _apiClient.createPaymentMethod(data);
      } else {
        await _apiClient.updatePaymentMethod(
          widget.paymentMethod!.id.toString(),
          data,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.paymentMethod == null
                ? 'Método de pago creado exitosamente'
                : 'Método de pago actualizado exitosamente',
          ),
          backgroundColor: AppTheme.primary,
        ),
      );

      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: AppTheme.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: CustomTopAppBar(
        title: widget.paymentMethod == null ? 'Agregar método de pago' : 'Editar método de pago',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
        actions: [
          AppBarButton(
            icon: FontAwesomeIcons.floppyDisk,
            onPressed: _savePaymentMethod,
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            const SizedBox(height: AppTheme.spacingLg),
            _buildBentoGrid(),
            const SizedBox(height: AppTheme.spacingXl),
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
          'Métodos de Pago',
          style: TextStyle(
            fontSize: AppTheme.fontSizeTitle,
            fontWeight: FontWeight.w700,
            color: AppTheme.onSurface,
          ),
        ),
        const SizedBox(height: AppTheme.spacingSm),
        Text(
          'Configura los métodos de pago que estarán disponibles para tus clientes. Asigna un nombre, icono y color representativo.',
          style: TextStyle(
            fontSize: AppTheme.fontSizeBody,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildBentoGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 700;

        if (isDesktop) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 7,
                child: _buildFormArea(),
              ),
              const SizedBox(width: AppTheme.spacingLg),
              Expanded(
                flex: 5,
                child: _buildVisualCard(),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              _buildFormArea(),
              const SizedBox(height: AppTheme.spacingLg),
              _buildVisualCard(),
            ],
          );
        }
      },
    );
  }

  Widget _buildFormArea() {
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.tag,
                      size: 14,
                      color: AppTheme.primary,
                    ),
                    const SizedBox(width: AppTheme.spacingSm),
                    Text(
                      'Nombre del Método',
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
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa el nombre';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Ej. Transferencia Bancaria, Tarjeta de Crédito...',
                    hintStyle: TextStyle(
                      color: AppTheme.outlineVariant,
                      fontSize: AppTheme.fontSizeBody,
                    ),
                    filled: true,
                    fillColor: AppTheme.surface,
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
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Selector de Icono
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.icons,
                      size: 14,
                      color: AppTheme.primary,
                    ),
                    const SizedBox(width: AppTheme.spacingSm),
                    Text(
                      'Seleccionar Icono',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeLabel,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingSm),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: AppTheme.spacingMd,
                    mainAxisSpacing: AppTheme.spacingMd,
                    childAspectRatio: 1,
                  ),
                  itemCount: _icons.length,
                  itemBuilder: (context, index) {
                    final isSelected = _selectedIconIndex == index;
                    final iconData = _icons[index]['icon'] as FaIconData;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIconIndex = index;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _selectedColor
                              : AppTheme.surface,
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
                          border: Border.all(
                            color: isSelected
                                ? _selectedColor
                                : AppTheme.outlineVariant,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Center(
                          child: FaIcon(
                            iconData,
                            size: 22,
                            color: isSelected
                                ? Colors.white
                                : AppTheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Selector de Color
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.palette,
                      size: 14,
                      color: AppTheme.primary,
                    ),
                    const SizedBox(width: AppTheme.spacingSm),
                    Text(
                      'Seleccionar Color',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeLabel,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingSm),
                Wrap(
                  spacing: AppTheme.spacingMd,
                  runSpacing: AppTheme.spacingMd,
                  children: _colorOptions.map((color) {
                    final isSelected = _selectedColor == color;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColor = color;
                        });
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? Colors.white : Colors.transparent,
                            width: 3,
                          ),
                          boxShadow: isSelected
                              ? [
                            BoxShadow(
                              color: color.withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                              : null,
                        ),
                        child: isSelected
                            ? const Center(
                          child: FaIcon(
                            FontAwesomeIcons.check,
                            size: 16,
                            color: Colors.white,
                          ),
                        )
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingLg),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualCard() {
    final selectedIcon = _icons[_selectedIconIndex]['icon'] as FaIconData;
    final color = _selectedColor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        image: DecorationImage(
          image: const NetworkImage(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCibnU-a4dNd5b16ENMmnq72FKxbUpwIgDsE9Mh27pr5-_UQlUgKTnGd15xBebiLxnka4nDjTClHtK4jB9ZhNavicG6MQPee6a6xrtpGgdYjiresiHqp1jdFO26Ux005nIbMDbEUTxBzhqusvFc_jWC07Hi9DpCDAm1WNUdB3cR5r7QDjwQmX6PM-LFgTRoSK0DCuVc-niJKSeNyOVj5wjodH_dmcWGU6CX_lMejbfNUbbF9kxO4t5djRPVN3nwdarijfuOy-JCFmkG',
          ),
          fit: BoxFit.cover,
          opacity: 0.15,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icono de vista previa
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
            ),
            child: Center(
              child: FaIcon(
                selectedIcon,
                size: 32,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Text(
            _nameController.text.isEmpty ? 'Nuevo Método de Pago' : _nameController.text,
            style: TextStyle(
              fontSize: AppTheme.fontSizeTitle,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            'Los métodos de pago permiten a tus clientes realizar transacciones de forma rápida y segura.',
            style: TextStyle(
              fontSize: AppTheme.fontSizeSmall,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          // Estado
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _isActive ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: FaIcon(
                    _isActive ? FontAwesomeIcons.check : FontAwesomeIcons.xmark,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacingSm),
              Text(
                _isActive ? 'Método Activo' : 'Método Inactivo',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeSmall,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ],
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