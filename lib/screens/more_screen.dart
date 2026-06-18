import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/screens/profile_screen.dart';
import 'package:pedidos/screens/settings_screen.dart';
import 'package:pedidos/screens/notifications_screen.dart';
import 'package:pedidos/screens/help_screen.dart';
import 'package:pedidos/screens/about_screen.dart';
import 'package:pedidos/screens/backup_screen.dart';
import 'package:pedidos/screens/security_screen.dart';
import 'package:pedidos/screens/support_screen.dart';
import 'package:pedidos/screens/payment_calendar_screen.dart';
import 'package:pedidos/screens/taxes_screen.dart';
import 'package:pedidos/screens/budget_comparison_screen.dart';
import 'package:pedidos/screens/employees_screen.dart';
import 'package:pedidos/screens/membership_flow_screen.dart';
import 'package:pedidos/screens/payment_methods_screen.dart';
import 'package:pedidos/screens/expense_categories_screen.dart';
import 'package:pedidos/screens/price_list_screen.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

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
                  // Sección de Cuenta
                  _buildSectionHeader('Cuenta', FontAwesomeIcons.user),
                  const SizedBox(height: AppTheme.spacingMd),
                  _buildMenuItem(
                    icon: FontAwesomeIcons.userCircle,
                    title: 'Mi Perfil',
                    subtitle: 'Información personal y preferencias',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfileScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: FontAwesomeIcons.bell,
                    title: 'Notificaciones',
                    subtitle: 'Configura tus alertas',
                    badge: '3',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: FontAwesomeIcons.shield,
                    title: 'Seguridad',
                    subtitle: 'Contraseña y autenticación',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SecurityScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: AppTheme.spacingXl),

                  // Sección de Productos (NUEVA)
                  _buildSectionHeader('Productos', FontAwesomeIcons.box),
                  const SizedBox(height: AppTheme.spacingMd),
                  _buildMenuItem(
                    icon: FontAwesomeIcons.tags,
                    title: 'Lista de Precios',
                    subtitle: 'Consulta y gestiona precios de productos',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PriceListScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: AppTheme.spacingXl),

                  // Sección de Finanzas
                  _buildSectionHeader('Finanzas', FontAwesomeIcons.moneyBill),
                  const SizedBox(height: AppTheme.spacingMd),
                  _buildMenuItem(
                    icon: FontAwesomeIcons.creditCard,
                    title: 'Métodos de Pago',
                    subtitle: 'Gestiona tus tarjetas y formas de pago',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PaymentMethodsScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: FontAwesomeIcons.tags,
                    title: 'Categorías de Gastos',
                    subtitle: 'Organiza tus gastos por categorías',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ExpenseCategoriesScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: AppTheme.spacingXl),

                  // Sección de Membresía
                  _buildSectionHeader('Membresía', FontAwesomeIcons.crown),
                  const SizedBox(height: AppTheme.spacingMd),
                  _buildMenuItem(
                    icon: FontAwesomeIcons.crown,
                    title: 'Flujo de Membresía',
                    subtitle: 'Planes, beneficios y suscripción',
                    badge: 'NUEVO',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MembershipFlowScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: AppTheme.spacingXl),

                  // Sección de Configuración
                  _buildSectionHeader('Configuración', FontAwesomeIcons.gear),
                  const SizedBox(height: AppTheme.spacingMd),
                  _buildMenuItem(
                    icon: FontAwesomeIcons.sliders,
                    title: 'Preferencias',
                    subtitle: 'Idioma, tema y unidades',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: FontAwesomeIcons.calendar,
                    title: 'Calendario de Pagos',
                    subtitle: 'Visualiza fechas de pago',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PaymentCalendarScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: FontAwesomeIcons.chartLine,
                    title: 'Comparativa Presupuesto',
                    subtitle: 'Análisis vs real',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const BudgetComparisonScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: FontAwesomeIcons.receipt,
                    title: 'Impuestos',
                    subtitle: 'Declaraciones y pagos',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TaxesScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: AppTheme.spacingXl),

                  // Sección de Personal
                  _buildSectionHeader('Personal', FontAwesomeIcons.usersGear),
                  const SizedBox(height: AppTheme.spacingMd),
                  _buildMenuItem(
                    icon: FontAwesomeIcons.userPlus,
                    title: 'Empleados',
                    subtitle: 'Gestión de usuarios y permisos',
                    badge: '3',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EmployeesScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: AppTheme.spacingXl),

                  // Sección de Soporte
                  // _buildSectionHeader('Soporte', FontAwesomeIcons.headset),
                  // const SizedBox(height: AppTheme.spacingMd),
                  // _buildMenuItem(
                  //   icon: FontAwesomeIcons.questionCircle,
                  //   title: 'Ayuda',
                  //   subtitle: 'Preguntas frecuentes y tutoriales',
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => const HelpScreen()),
                  //     );
                  //   },
                  // ),
                  // _buildMenuItem(
                  //   icon: FontAwesomeIcons.message,
                  //   title: 'Soporte Técnico',
                  //   subtitle: 'Contacta con nosotros',
                  //   badge: '2',
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => const SupportScreen()),
                  //     );
                  //   },
                  // ),
                  // _buildMenuItem(
                  //   icon: FontAwesomeIcons.cloudUpload,
                  //   title: 'Copia de Seguridad',
                  //   subtitle: 'Respaldar y restaurar datos',
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => const BackupScreen()),
                  //     );
                  //   },
                  // ),
                  const SizedBox(height: AppTheme.spacingXl),

                  // Sección de Información
                  _buildSectionHeader('Información', FontAwesomeIcons.infoCircle),
                  const SizedBox(height: AppTheme.spacingMd),
                  _buildMenuItem(
                    icon: FontAwesomeIcons.info,
                    title: 'Acerca de',
                    subtitle: 'Versión 1.0.0',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AboutScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: FontAwesomeIcons.fileAlt,
                    title: 'Términos y Condiciones',
                    subtitle: 'Políticas de uso',
                    onTap: () {
                      _showTermsDialog(context);
                    },
                  ),
                  _buildMenuItem(
                    icon: FontAwesomeIcons.shieldHeart,
                    title: 'Privacidad',
                    subtitle: 'Protección de datos',
                    onTap: () {
                      _showPrivacyDialog(context);
                    },
                  ),
                  const SizedBox(height: AppTheme.spacingXl),

                  // Botón de cerrar sesión
                  Container(
                    margin: const EdgeInsets.only(top: AppTheme.spacingMd, bottom: AppTheme.spacingXl),
                    decoration: BoxDecoration(
                      color: AppTheme.errorContainer.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
                    ),
                    child: ListTile(
                      leading: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppTheme.error.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.arrowRightFromBracket,
                            size: 20,
                            color: AppTheme.error,
                          ),
                        ),
                      ),
                      title: Text(
                        'Cerrar Sesión',
                        style: TextStyle(
                          fontSize: AppTheme.fontSizeBody,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.error,
                        ),
                      ),
                      subtitle: Text(
                        'Salir de tu cuenta actual',
                        style: TextStyle(
                          fontSize: AppTheme.fontSizeSmall,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                      onTap: () => _showLogoutDialog(context),
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

  Widget _buildTopAppBar(BuildContext context) {
    return CustomTopAppBar(
      title: 'Más opciones',
      showBackButton: false,
    );
  }

  Widget _buildSectionHeader(String title, FaIconData icon) {
    return Row(
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
        FaIcon(
          icon,
          size: 16,
          color: AppTheme.primary,
        ),
        const SizedBox(width: AppTheme.spacingMd),
        Text(
          title,
          style: TextStyle(
            fontSize: AppTheme.fontSizeLabel,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required FaIconData icon,
    required String title,
    required String subtitle,
    String? badge,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: AppTheme.outlineVariant),
      ),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppTheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: FaIcon(
              icon,
              size: 20,
              color: AppTheme.primary,
            ),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: AppTheme.fontSizeBody,
            fontWeight: FontWeight.w600,
            color: AppTheme.onSurface,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: AppTheme.fontSizeSmall,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
        trailing: badge != null
            ? Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingSm,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: badge == 'NUEVO' ? AppTheme.primary : AppTheme.error,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
          ),
          child: Text(
            badge,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        )
            : FaIcon(
          FontAwesomeIcons.chevronRight,
          size: 16,
          color: AppTheme.outline,
        ),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Cerrar Sesión', style: TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Términos y Condiciones'),
        content: const SingleChildScrollView(
          child: Text(
            'Términos y condiciones de uso de la aplicación...\n\n'
                '1. Aceptación de términos\n'
                '2. Uso de la plataforma\n'
                '3. Responsabilidades del usuario\n'
                '4. Privacidad de datos\n'
                '5. Modificaciones\n\n'
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

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Política de Privacidad'),
        content: const SingleChildScrollView(
          child: Text(
            'Política de privacidad de VerdantGrowth...\n\n'
                'Protegemos tus datos personales y nos comprometemos a:\n'
                '• No compartir información con terceros sin consentimiento\n'
                '• Utilizar cifrado para datos sensibles\n'
                '• Permitir acceso y modificación de tus datos\n'
                '• Eliminar datos cuando lo solicites\n\n'
                'Para más información, contacta con nuestro soporte.',
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