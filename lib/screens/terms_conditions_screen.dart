import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';

class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({super.key});

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  bool _isLoading = false;

  void _acceptTerms() {
    setState(() {
      _isLoading = true;
    });

    // Simular proceso de aceptación
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Términos aceptados correctamente'),
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
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    children: [
                      _buildHeroSection(),
                      const SizedBox(height: AppTheme.spacingLg),
                      _buildContent(),
                      const SizedBox(height: AppTheme.spacingXl),
                      _buildAcceptButton(),
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
            Expanded(
              child: Text(
                'Términos y Condiciones',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeTitle,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
          child: Stack(
            children: [
              Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuDxZk0_3L4ikquDVWU2xuwDB4jbKLPKiAizSEUfne6XFTqYvxRK2R9RXni84kwcumtWBV7NWkDpY7RmjqdKimWl5vNHj4Zw9enOpvjk00PsC28MYqLZbjdLpC2b4dgVdSPxDsgMS5OAaBuFzI9cC5QSVj9Jzf8H85bIaAZSaFguCsGbAx2duGWXW-I37-JFplQgZ4kFUZ1kw_fm4I0h3KGxI9uzK3NbxuITELawZTMlAWzdyaYTUgqdg0jTzfma2BAE-ZyCtcvEEgrJ',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 180,
                    color: AppTheme.primaryContainer.withValues(alpha: 0.1),
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.fileContract,
                        size: 48,
                        color: AppTheme.primary,
                      ),
                    ),
                  );
                },
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        AppTheme.surfaceContainerLowest.withValues(alpha: 0.9),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: AppTheme.spacingLg,
                left: AppTheme.spacingLg,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingSm,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                  ),
                  child: Text(
                    'Documento Oficial',
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeSmall,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: AppTheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppTheme.spacingLg),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Verdant Professional',
              style: TextStyle(
                fontSize: AppTheme.fontSizeHeadline,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
            ),
            Text(
              'Última actualización: 24 de Mayo, 2025',
              style: TextStyle(
                fontSize: AppTheme.fontSizeSmall,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContent() {
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
          _buildSection(
            number: '1',
            title: 'Aceptación de los Términos',
            content:
            'Al acceder y utilizar esta aplicación ("Servicio"), usted acepta cumplir y estar sujeto a los siguientes Términos y Condiciones. Si no está de acuerdo con alguna parte de estos términos, no podrá utilizar nuestro Servicio.',
          ),
          const SizedBox(height: AppTheme.spacingLg),
          _buildSection(
            number: '2',
            title: 'Descripción del Servicio',
            content:
            'Verdant Professional proporciona una plataforma para la gestión de órdenes, pedidos, inventarios y finanzas comerciales. Nos reservamos el derecho de modificar o interrumpir el Servicio en cualquier momento.',
          ),
          const SizedBox(height: AppTheme.spacingLg),
          _buildHighlightSection(
            number: '3',
            title: 'Registro y Cuentas',
            content:
            'Para utilizar ciertas funciones, debe registrarse y crear una cuenta. Usted es responsable de mantener la confidencialidad de su contraseña y de todas las actividades que ocurran bajo su cuenta.',
          ),
          const SizedBox(height: AppTheme.spacingLg),
          _buildSection(
            number: '4',
            title: 'Privacidad de los Datos',
            content:
            'Su uso del Servicio también está sujeto a nuestra Política de Privacidad. Al utilizar el Servicio, usted acepta la recopilación y el uso de su información según lo establecido en dicha política.',
          ),
          const SizedBox(height: AppTheme.spacingLg),
          _buildSection(
            number: '5',
            title: 'Propiedad Intelectual',
            content:
            'Todo el contenido, marcas y logotipos incluidos en el Servicio son propiedad de Verdant o de sus licenciantes y están protegidos por leyes de derechos de autor y propiedad intelectual.',
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Row(
            children: [
              Expanded(
                child: _buildCardSection(
                  icon: FontAwesomeIcons.gavel,
                  number: '6',
                  title: 'Limitación',
                  content:
                  'Verdant no será responsable de ningún daño indirecto, incidental o consecuente resultante del uso o la imposibilidad de usar el Servicio.',
                  color: AppTheme.primary,
                  bgColor: AppTheme.secondaryContainer.withValues(alpha: 0.2),
                ),
              ),
              const SizedBox(width: AppTheme.spacingLg),
              Expanded(
                child: _buildCardSection(
                  icon: FontAwesomeIcons.clock,
                  number: '7',
                  title: 'Cambios',
                  content:
                  'Nos reservamos el derecho de actualizar estos términos en cualquier momento. Notificaremos cambios significativos aquí.',
                  color: AppTheme.tertiary,
                  bgColor: AppTheme.tertiaryContainer.withValues(alpha: 0.1),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          _buildSection(
            number: '8',
            title: 'Contacto',
            content:
            'Si tiene alguna pregunta sobre estos Términos, por favor contáctenos a través de nuestro centro de soporte especializado para profesionales.',
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String number,
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  number,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppTheme.spacingMd),
            Text(
              title,
              style: TextStyle(
                fontSize: AppTheme.fontSizeTitle,
                fontWeight: FontWeight.w700,
                color: AppTheme.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingSm),
        Padding(
          padding: const EdgeInsets.only(left: 36),
          child: Text(
            content,
            style: TextStyle(
              fontSize: AppTheme.fontSizeBody,
              color: AppTheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHighlightSection({
    required String number,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
        border: Border(left: BorderSide(color: AppTheme.primary, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    number,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Text(
                title,
                style: TextStyle(
                  fontSize: AppTheme.fontSizeTitle,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Padding(
            padding: const EdgeInsets.only(left: 36),
            child: Text(
              content,
              style: TextStyle(
                fontSize: AppTheme.fontSizeBody,
                color: AppTheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardSection({
    required FaIconData icon,
    required String number,
    required String title,
    required String content,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(
                icon,
                size: 20,
                color: color,
              ),
              const SizedBox(width: AppTheme.spacingSm),
              Text(
                number,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            title,
            style: TextStyle(
              fontSize: AppTheme.fontSizeLabel,
              fontWeight: FontWeight.w700,
              color: AppTheme.onSurface,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            content,
            style: TextStyle(
              fontSize: AppTheme.fontSizeSmall,
              color: AppTheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcceptButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingSm),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _acceptTerms,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          foregroundColor: AppTheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingLg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
          ),
          elevation: 4,
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
            : const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Aceptar y Continuar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: AppTheme.spacingSm),
            FaIcon(
              FontAwesomeIcons.circleCheck,
              size: 18,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}