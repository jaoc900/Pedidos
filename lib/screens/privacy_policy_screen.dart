import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/models/privacy_model.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  bool _isAccepted = false;

  void _acceptPolicy() {
    setState(() {
      _isAccepted = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Has aceptado la Política de Privacidad'),
        backgroundColor: AppTheme.secondary,
        duration: Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isAccepted = false;
      });
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
                  // Header Visual Accent
                  _buildHeaderAccent(),
                  const SizedBox(height: AppTheme.spacingLg),
                  // Privacy Sections
                  _buildPrivacySections(),
                  const SizedBox(height: AppTheme.spacingXl),
                ],
              ),
            ),
          ),
          // Bottom Action Bar
          _buildBottomActionBar(),
        ],
      ),
    );
  }

  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXl, vertical: AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.surface.withValues(alpha: 0.9),
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
            Expanded(
              child: Text(
                'Política de Privacidad',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeTitle,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 40), // Spacer for symmetry
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderAccent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 4,
          decoration: BoxDecoration(
            color: AppTheme.tertiaryFixed,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),
        Text(
          'Última actualización: Noviembre 2024. Su privacidad es fundamental para nuestra gestión comercial.',
          style: TextStyle(
            fontSize: AppTheme.fontSizeBody,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacySections() {
    final sections = [
      PrivacySection(
        number: '1',
        title: 'Recopilación de Información',
        content:
        'Recogemos datos identificativos, de contacto y transaccionales necesarios para la operación comercial, incluyendo nombres, correos electrónicos y detalles de pedidos.',
      ),
      PrivacySection(
        number: '2',
        title: 'Uso de los Datos',
        content:
        'La información se utiliza exclusivamente para mejorar el servicio comercial, procesar pedidos de manera eficiente y ofrecer análisis detallados sobre su actividad en la plataforma.',
      ),
      PrivacySection(
        number: '3',
        title: 'Protección de la Información',
        content:
        'Implementamos protocolos de seguridad de grado industrial y encriptación de extremo a extremo para asegurar que su información esté protegida contra accesos no autorizados.',
        hasIcon: true,
        icon: FontAwesomeIcons.shield,
      ),
      PrivacySection(
        number: '4',
        title: 'Cookies',
        content:
        'Utilizamos tecnologías similares a las cookies para recordar sus preferencias y personalizar su experiencia de usuario dentro del panel de control.',
      ),
      PrivacySection(
        number: '5',
        title: 'Derechos del Usuario',
        content:
        'Usted tiene derecho inalienable al acceso, rectificación y eliminación de sus datos personales. Puede gestionar estas opciones desde la sección de configuración de su perfil.',
      ),
      PrivacySection(
        number: '6',
        title: 'Compartición con Terceros',
        content: 'Nunca vendemos sus datos personales a anunciantes o terceros bajo ninguna circunstancia.',
        isHighlighted: true,
      ),
      PrivacySection(
        number: '7',
        title: 'Cambios en la Política',
        content:
        'Nos reservamos el derecho de modificar esta política. Notificaremos cualquier cambio sustancial a través de la aplicación o vía correo electrónico.',
      ),
      PrivacySection(
        number: '8',
        title: 'Contacto de Privacidad',
        content: 'Para dudas sobre el tratamiento de sus datos, contacte a nuestro Oficial de Privacidad:',
        hasContact: true,
        contactEmail: 'privacidad@comercialpro.com',
      ),
    ];

    return Column(
      children: sections.map((section) => Padding(
        padding: const EdgeInsets.only(bottom: AppTheme.spacingLg),
        child: _buildPrivacySection(section),
      )).toList(),
    );
  }

  Widget _buildPrivacySection(PrivacySection section) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
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
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    section.number,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Expanded(
                child: Text(
                  section.title,
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeTitle,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),
          if (section.hasIcon)
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Row(
                children: [
                  FaIcon(
                    section.icon,
                    size: 24,
                    color: AppTheme.primaryContainer,
                  ),
                  const SizedBox(width: AppTheme.spacingMd),
                  Expanded(
                    child: Text(
                      section.content,
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeBody,
                        color: AppTheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else if (section.isHighlighted)
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              margin: const EdgeInsets.only(left: 40),
              decoration: BoxDecoration(
                color: AppTheme.tertiaryContainer.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
                border: Border(left: BorderSide(color: AppTheme.tertiaryContainer, width: 4)),
              ),
              child: Text(
                section.content,
                style: TextStyle(
                  fontSize: AppTheme.fontSizeBody,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
            )
          else if (section.hasContact)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: Text(
                      section.content,
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeBody,
                        color: AppTheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  GestureDetector(
                    onTap: () {
                      // Aquí se podría abrir el cliente de correo
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Abrir cliente de correo'),
                          backgroundColor: AppTheme.primary,
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.envelope,
                            size: 16,
                            color: AppTheme.primary,
                          ),
                          const SizedBox(width: AppTheme.spacingSm),
                          Text(
                            section.contactEmail,
                            style: TextStyle(
                              fontSize: AppTheme.fontSizeBody,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            else
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Text(
                  section.content,
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

  Widget _buildBottomActionBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.surface.withValues(alpha: 0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -4),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: AppTheme.outlineVariant.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _acceptPolicy,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.loginButtonColor,
              foregroundColor: AppTheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
              ),
              elevation: 4,
            ),
            child: const Text(
              'He leído y acepto',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
