import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: CustomTopAppBar(
        title: 'Acerca de',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
        actions: [
          AppBarButton(
            icon: FontAwesomeIcons.share,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sincronizando con la nube...'),
                  backgroundColor: AppTheme.primary,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingXl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo y nombre de la app
                  _buildAppLogo(),
                  const SizedBox(height: AppTheme.spacingXl),

                  // Información de la app
                  _buildAppInfo(),
                  const SizedBox(height: AppTheme.spacingXl),

                  // Versión y derechos
                  _buildFooter(),
                  const SizedBox(height: AppTheme.spacingXl * 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppLogo() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.primary,
                AppTheme.primaryContainer,
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Center(
            child: FaIcon(
              FontAwesomeIcons.seedling,
              size: 48,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: AppTheme.spacingLg),
        Text(
          'VerdantGrowth',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            color: AppTheme.onSurface,
          ),
        ),
        const SizedBox(height: AppTheme.spacingSm),
        Text(
          'Versión 1.0.0 (build 101)',
          style: TextStyle(
            fontSize: AppTheme.fontSizeLabel,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildAppInfo() {
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
                'Sobre la aplicación',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeTitle,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Text(
            'VerdantGrowth es una plataforma integral de gestión empresarial diseñada para optimizar el control de inventarios, ventas, finanzas y relaciones con clientes. Nuestra misión es ayudar a las empresas a crecer de manera sostenible a través de la tecnología.',
            style: TextStyle(
              fontSize: AppTheme.fontSizeBody,
              color: AppTheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          _buildInfoRow(
            icon: FontAwesomeIcons.checkCircle,
            label: 'Lanzamiento inicial',
            value: 'Mayo 2025',
          ),
          _buildInfoRow(
            icon: FontAwesomeIcons.code,
            label: 'Desarrollado con',
            value: 'Flutter & Firebase',
          ),
          _buildInfoRow(
            icon: FontAwesomeIcons.mobile,
            label: 'Plataformas',
            value: 'iOS, Android, Web',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required FaIconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      child: Row(
        children: [
          FaIcon(
            icon,
            size: 14,
            color: AppTheme.primary,
          ),
          const SizedBox(width: AppTheme.spacingMd),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: AppTheme.fontSizeSmall,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: AppTheme.fontSizeSmall,
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        const Divider(color: AppTheme.outlineVariant),
        const SizedBox(height: AppTheme.spacingLg),
        Text(
          '© 2025 VerdantGrowth. Todos los derechos reservados.',
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.outline,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppTheme.spacingSm),
        Text(
          'Hecho con ❤️ en México',
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.outline,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}