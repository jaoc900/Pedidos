import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  String _selectedSubject = '';
  bool _isLoading = false;

  final List<String> _subjects = [
    'Soporte Técnico',
    'Ventas y Consultoría',
    'Facturación',
    'Otro',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedSubject.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor selecciona un asunto'),
            backgroundColor: AppTheme.error,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // Simular envío
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mensaje enviado correctamente'),
          backgroundColor: AppTheme.secondary,
        ),
      );

      _formKey.currentState!.reset();
      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
      setState(() {
        _selectedSubject = '';
      });
    }
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Hero Section
                      _buildHeroSection(),
                      const SizedBox(height: AppTheme.spacingLg),
                      // Bento Layout
                      _buildBentoLayout(),
                      const SizedBox(height: AppTheme.spacingLg),
                      // Global Trust Banner
                      _buildGlobalTrustBanner(),
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
        color: AppTheme.surface,
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
                  'Verdant Pro',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeHeadline,
                    fontWeight: FontWeight.w800,
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

  Widget _buildHeroSection() {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
              child: Image.network(
                'https://lh3.googleusercontent.com/aida/ADBb0uhvw4_rWW3aekOpKDCWkQmE-k7MYBGiAZtIulrk12DvkeRr_404fsb_X2T19u_sm4wq8C_h7Rz-0m-Uu0fnhYvyaOSZORs6XnWRW2ff2Hnw1GDvz-4fcxIbYHGUOlJqAxY5EewpmZlC8gKg9UgP3mpOpsQo4vNjrh6jo29_0KwF696ZzfcD33xbCE1wUzt383HRnoiZ2oeEgNA02tnDq_W5IwtkZUMds0vOra1FQULl2sSqzCvi18j01LU',
                fit: BoxFit.cover,
                opacity: const AlwaysStoppedAnimation(0.1),
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppTheme.surfaceContainerLow,
                  );
                },
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Contacto',
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeHeadline,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingLg),
                  SizedBox(
                    width: 500,
                    child: Text(
                      'Estamos aquí para apoyar su crecimiento global. Ya sea una consulta técnica o una alianza estratégica, nuestro equipo de expertos en Verdant Ops está listo para conversar.',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeBody,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBentoLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 800;

        if (isDesktop) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 8,
                child: _buildContactForm(),
              ),
              const SizedBox(width: AppTheme.spacingLg),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    _buildQuickSupportCard(),
                    const SizedBox(height: AppTheme.spacingLg),
                    _buildOfficesCard(),
                  ],
                ),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              _buildContactForm(),
              const SizedBox(height: AppTheme.spacingLg),
              _buildQuickSupportCard(),
              const SizedBox(height: AppTheme.spacingLg),
              _buildOfficesCard(),
            ],
          );
        }
      },
    );
  }

  Widget _buildContactForm() {
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Envíanos un mensaje',
              style: TextStyle(
                fontSize: AppTheme.fontSizeTitle,
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurface,
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _nameController,
                    label: 'Nombre Completo',
                    hint: 'Ej. Juan Pérez',
                    icon: FontAwesomeIcons.user,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Requerido';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: AppTheme.spacingLg),
                Expanded(
                  child: _buildTextField(
                    controller: _emailController,
                    label: 'Correo Electrónico',
                    hint: 'juan@ejemplo.com',
                    icon: FontAwesomeIcons.envelope,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Requerido';
                      }
                      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Correo inválido';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingLg),
            _buildDropdownField(
              label: 'Asunto',
              value: _selectedSubject,
              items: _subjects,
              icon: FontAwesomeIcons.tag,
              hint: 'Seleccione una opción',
              onChanged: (value) {
                setState(() {
                  _selectedSubject = value;
                });
              },
            ),
            const SizedBox(height: AppTheme.spacingLg),
            _buildTextField(
              controller: _messageController,
              label: 'Mensaje',
              hint: 'Cuéntanos cómo podemos ayudarte...',
              icon: FontAwesomeIcons.message,
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Requerido';
                }
                return null;
              },
            ),
            const SizedBox(height: AppTheme.spacingLg),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _submitForm,
                icon: _isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : const FaIcon(FontAwesomeIcons.paperPlane, size: 18),
                label: Text(_isLoading ? 'Enviando...' : 'Enviar Mensaje'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.loginButtonColor,
                  foregroundColor: AppTheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                  ),
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
    TextInputType keyboardType = TextInputType.text,
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
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppTheme.outlineVariant,
              fontSize: AppTheme.fontSizeBody,
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
            color: AppTheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
            border: Border.all(color: AppTheme.outlineVariant),
          ),
          child: DropdownButtonFormField<String>(
            initialValue: value.isEmpty ? null : value,
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

  Widget _buildQuickSupportCard() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.secondaryContainer,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
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
            children: [
              FaIcon(
                FontAwesomeIcons.headset,
                size: 20,
                color: AppTheme.onSecondaryContainer,
              ),
              const SizedBox(width: AppTheme.spacingSm),
              Text(
                'Soporte Rápido',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeLabel,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.onSecondaryContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Llamando...'),
                  backgroundColor: AppTheme.primary,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainerLowest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.phone,
                        size: 20,
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
                          'Llámanos',
                          style: TextStyle(
                            fontSize: AppTheme.fontSizeSmall,
                            color: AppTheme.onSecondaryContainer,
                          ),
                        ),
                        Text(
                          '+1 (555) 012-3456',
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
          ),
          const SizedBox(height: AppTheme.spacingMd),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Abriendo cliente de correo'),
                  backgroundColor: AppTheme.primary,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainerLowest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.envelope,
                        size: 20,
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
                          'Correo Electrónico',
                          style: TextStyle(
                            fontSize: AppTheme.fontSizeSmall,
                            color: AppTheme.onSecondaryContainer,
                          ),
                        ),
                        Text(
                          'soporte@verdant.pro',
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
          ),
        ],
      ),
    );
  }

  Widget _buildOfficesCard() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nuestras Oficinas',
            style: TextStyle(
              fontSize: AppTheme.fontSizeLabel,
              fontWeight: FontWeight.w700,
              color: AppTheme.onSurface,
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
            child: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDP8hGYaagK5RATyIzdP3QJlyC4nb2np93R7cnji1UQLQNQ5psucgMjEG-turfq0SJ7crDbC8wrphjDGEvGv9ER17-M53mhPSJYPMGfstxfQm1fWBXUGMSZyy_ibVmJC6vss-BIfZzW1OwpWkgxFHu3qlpJ0jdAhDkI2JJn0R3iXJqP_XQNCtup0ihOTCblRNY1GtpfCQcASwuiAusGUDbmJJy-C8Zh4jWT62e6nRZqEdkv8QWpGJNjhUmQ3z7NqgFTt7vYhUTaRCHE',
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 120,
                  color: AppTheme.surfaceContainer,
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.map,
                      size: 32,
                      color: AppTheme.outline,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Text(
            'Sede Central',
            style: TextStyle(
              fontSize: AppTheme.fontSizeLabel,
              fontWeight: FontWeight.w700,
              color: AppTheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Paseo de la Castellana 200,\n28046 Madrid, España',
            style: TextStyle(
              fontSize: AppTheme.fontSizeBody,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const FaIcon(FontAwesomeIcons.map, size: 16),
              label: const Text('Ver en el Mapa'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.secondary,
                side: BorderSide(color: AppTheme.secondary, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlobalTrustBanner() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Operaciones Globales',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeTitle,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.onTertiaryContainer,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Verdant Pro gestiona más de 5,000 hectáreas en 4 continentes con precisión tecnológica.',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeBody,
                    color: AppTheme.onTertiaryContainer.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _buildAvatarIcon(),
              const SizedBox(width: 4),
              _buildAvatarIcon(),
              const SizedBox(width: 4),
              _buildAvatarIcon(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.tertiaryContainer, width: 2),
        color: Colors.white,
      ),
      child: ClipOval(
        child: Image.network(
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBpeOEXY9ca5FCQ-ncuGenlxxWy734YUqCMNCaviI5dsCAUML9doUezErcWq3c82iI9WXE1pNFBrYqW-oSlHjnLpMnlnqNQ-CPYvc_JqnhoJjw9M_lB-qZxYJyLTLFIS7xoJaPBIevP_ew6fRCNcy5bdu9ry3wX4PMAupgAHYwbzVIFr5N5VdPxWyCymfkOx6Wn07BlbYv-QMPdi-8Q_Z4i8wUUTIB6hD1r_EquYtA__LQEaFPSFsSCjxf8A_SCeUYWW7BV5LlnHLMo',
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: AppTheme.primaryContainer,
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.user,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
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