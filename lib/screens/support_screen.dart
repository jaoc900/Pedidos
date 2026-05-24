import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pedidos/models/faq_model.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  String _selectedCategory = 'Problema técnico';
  final List<String> _categories = [
    'Problema técnico',
    'Facturación',
    'Cuenta y acceso',
    'Sugerencia',
    'Reporte de error',
    'Otro',
  ];

  bool _isLoading = false;
  bool _attachLogs = true;

  final List<FaqItem> _faqs = [
    FaqItem(
      question: '¿Cómo reinicio mi contraseña?',
      answer: 'Ve a la pantalla de inicio de sesión y selecciona "¿Olvidaste tu contraseña?". Recibirás un correo con instrucciones para restablecerla.',
      category: 'Cuenta y acceso',
    ),
    FaqItem(
      question: '¿Cómo exporto mis datos?',
      answer: 'En la sección "Reportes" puedes exportar tus datos en formato PDF o Excel usando el botón de exportar.',
      category: 'Reportes',
    ),
    FaqItem(
      question: '¿La app tiene costo?',
      answer: 'VerdantGrowth ofrece una versión gratuita con funcionalidades básicas. Hay planes premium con características adicionales.',
      category: 'Facturación',
    ),
    FaqItem(
      question: '¿Cómo contacto con soporte?',
      answer: 'Puedes usar este formulario, enviar un correo a soporte@verdant.com o llamar al +52 55 1234 5678 en horario laboral.',
      category: 'Soporte',
    ),
    FaqItem(
      question: '¿Mis datos están seguros?',
      answer: 'Sí, utilizamos cifrado de extremo a extremo y seguimos las mejores prácticas de seguridad para proteger tu información.',
      category: 'Seguridad',
    ),
    FaqItem(
      question: '¿Cómo actualizo la app?',
      answer: 'Las actualizaciones se realizan automáticamente desde la tienda de aplicaciones (App Store o Google Play).',
      category: 'Técnico',
    ),
  ];

  String _searchFaq = '';
  String _selectedFaqCategory = 'Todas';
  final List<String> _faqCategories = ['Todas', 'Cuenta y acceso', 'Reportes', 'Facturación', 'Soporte', 'Seguridad', 'Técnico'];

  List<FaqItem> get _filteredFaqs {
    var filtered = _faqs;

    if (_selectedFaqCategory != 'Todas') {
      filtered = filtered.where((f) => f.category == _selectedFaqCategory).toList();
    }

    if (_searchFaq.isNotEmpty) {
      filtered = filtered.where((f) =>
      f.question.toLowerCase().contains(_searchFaq.toLowerCase()) ||
          f.answer.toLowerCase().contains(_searchFaq.toLowerCase())
      ).toList();
    }

    return filtered;
  }

  void _sendSupportTicket() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa tu nombre'), backgroundColor: AppTheme.error),
      );
      return;
    }

    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa un correo válido'), backgroundColor: AppTheme.error),
      );
      return;
    }

    if (_messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor describe tu problema'), backgroundColor: AppTheme.error),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _nameController.clear();
      _emailController.clear();
      _subjectController.clear();
      _messageController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Ticket de soporte enviado! Te contactaremos pronto.'),
        backgroundColor: AppTheme.primary,
      ),
    );
  }

  void _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'soporte@verdant.com',
      query: 'subject=Soporte%20VerdantGrowth',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se puede abrir el cliente de correo'), backgroundColor: AppTheme.error),
      );
    }
  }

  void _launchPhone() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '+525512345678');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se puede realizar la llamada'), backgroundColor: AppTheme.error),
      );
    }
  }

  void _launchWhatsApp() async {
    final Uri whatsappUri = Uri(scheme: 'https', host: 'wa.me', path: '5215512345678');
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
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
                  // Contacto rápido
                  _buildQuickContact(),
                  const SizedBox(height: AppTheme.spacingXl),

                  // FAQ
                  _buildFaqSection(),
                  const SizedBox(height: AppTheme.spacingXl),

                  // Formulario de contacto
                  _buildContactForm(),
                  const SizedBox(height: AppTheme.spacingXl),
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
                  'Soporte',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeTitle,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.message,
                  size: 20,
                  color: AppTheme.primary,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Chat en vivo - Próximamente'),
                      backgroundColor: AppTheme.primary,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickContact() {
    return Column(
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
              'Contacto rápido',
              style: TextStyle(
                fontSize: AppTheme.fontSizeTitle,
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingLg),
        Row(
          children: [
            Expanded(
              child: _buildContactCard(
                title: 'Email',
                icon: FontAwesomeIcons.envelope,
                color: AppTheme.primary,
                onTap: _launchEmail,
              ),
            ),
            const SizedBox(width: AppTheme.spacingLg),
            Expanded(
              child: _buildContactCard(
                title: 'Teléfono',
                icon: FontAwesomeIcons.phone,
                color: AppTheme.secondary,
                onTap: _launchPhone,
              ),
            ),
            const SizedBox(width: AppTheme.spacingLg),
            Expanded(
              child: _buildContactCard(
                title: 'WhatsApp',
                icon: FontAwesomeIcons.whatsapp,
                color: AppTheme.tertiary,
                onTap: _launchWhatsApp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContactCard({
    required String title,
    required FaIconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingLg),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            FaIcon(
              icon,
              size: 28,
              color: color,
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              title,
              style: TextStyle(
                fontSize: AppTheme.fontSizeLabel,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqSection() {
    return Container(
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
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            child: Row(
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
                  'Preguntas frecuentes',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeTitle,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
            child: _buildFaqSearch(),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
            child: _buildFaqFilters(),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          const Divider(height: 0, color: AppTheme.outlineVariant),
          _buildFaqList(),
        ],
      ),
    );
  }

  Widget _buildFaqSearch() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: AppTheme.outlineVariant),
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchFaq = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Buscar en preguntas frecuentes...',
          hintStyle: TextStyle(color: AppTheme.outline, fontSize: AppTheme.fontSizeBody),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            child: FaIcon(FontAwesomeIcons.magnifyingGlass, size: 20, color: AppTheme.outline),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg, vertical: AppTheme.spacingLg),
        ),
      ),
    );
  }

  Widget _buildFaqFilters() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _faqCategories.length,
        separatorBuilder: (context, index) => const SizedBox(width: AppTheme.spacingMd),
        itemBuilder: (context, index) {
          final category = _faqCategories[index];
          final isSelected = _selectedFaqCategory == category;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFaqCategory = category;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg, vertical: AppTheme.spacingSm),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : AppTheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeSmall,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppTheme.onPrimary : AppTheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFaqList() {
    if (_filteredFaqs.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Column(
          children: [
            FaIcon(FontAwesomeIcons.circleInfo, size: 48, color: AppTheme.outline.withValues(alpha: 0.5)),
            const SizedBox(height: AppTheme.spacingLg),
            Text('No se encontraron preguntas', style: TextStyle(color: AppTheme.onSurfaceVariant)),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredFaqs.length,
      separatorBuilder: (context, index) => const Divider(height: 0, color: AppTheme.outlineVariant),
      itemBuilder: (context, index) {
        final faq = _filteredFaqs[index];
        return ExpansionTile(
          title: Text(
            faq.question,
            style: TextStyle(
              fontSize: AppTheme.fontSizeBody,
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurface,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Text(
                faq.answer,
                style: TextStyle(
                  fontSize: AppTheme.fontSizeBody,
                  color: AppTheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
            ),
          ],
        );
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
                'Formulario de contacto',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeTitle,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          _buildFormField(
            controller: _nameController,
            label: 'Nombre completo',
            hint: 'Ej. Juan Pérez',
            icon: FontAwesomeIcons.user,
          ),
          const SizedBox(height: AppTheme.spacingLg),
          _buildFormField(
            controller: _emailController,
            label: 'Correo electrónico',
            hint: 'juan@ejemplo.com',
            icon: FontAwesomeIcons.envelope,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: AppTheme.spacingLg),
          _buildDropdownField(
            label: 'Categoría',
            value: _selectedCategory,
            items: _categories,
            icon: FontAwesomeIcons.tag,
            onChanged: (value) {
              setState(() {
                _selectedCategory = value!;
              });
            },
          ),
          const SizedBox(height: AppTheme.spacingLg),
          _buildFormField(
            controller: _subjectController,
            label: 'Asunto',
            hint: 'Breve descripción del problema',
            icon: FontAwesomeIcons.heading,
          ),
          const SizedBox(height: AppTheme.spacingLg),
          _buildFormField(
            controller: _messageController,
            label: 'Mensaje',
            hint: 'Describe detalladamente tu problema o consulta...',
            icon: FontAwesomeIcons.message,
            maxLines: 5,
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Row(
            children: [
              Checkbox(
                value: _attachLogs,
                onChanged: (value) {
                  setState(() {
                    _attachLogs = value ?? false;
                  });
                },
                activeColor: AppTheme.primary,
              ),
              const Text('Adjutar logs de la aplicación'),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _sendSupportTicket,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : const Text('Enviar mensaje'),
            ),
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
    int maxLines = 1,
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
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppTheme.outlineVariant, fontSize: AppTheme.fontSizeBody),
            filled: true,
            fillColor: Colors.white,
            border: _buildInputBorder(),
            enabledBorder: _buildInputBorder(),
            focusedBorder: _buildFocusedBorder(),
            contentPadding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg, vertical: AppTheme.spacingLg),
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
            border: Border.all(color: AppTheme.outlineVariant),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
            ),
            icon: FaIcon(FontAwesomeIcons.chevronDown, size: 16, color: AppTheme.onSurfaceVariant),
            items: items.map((String item) {
              return DropdownMenuItem<String>(value: item, child: Text(item));
            }).toList(),
            onChanged: onChanged,
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
