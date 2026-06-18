// lib/widgets/side_menu.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/services/user_preferences.dart';
import 'package:pedidos/enums/user_role_enum.dart';
import 'package:pedidos/screens/login_screen.dart';
import 'package:pedidos/screens/profile_screen.dart';
import 'package:pedidos/screens/settings_screen.dart';
import 'package:pedidos/screens/notifications_screen.dart';
import 'package:pedidos/screens/about_screen.dart';
import 'package:pedidos/screens/security_screen.dart';
import 'package:pedidos/screens/payment_calendar_screen.dart';
import 'package:pedidos/screens/taxes_screen.dart';
import 'package:pedidos/screens/budget_comparison_screen.dart';
import 'package:pedidos/screens/employees_screen.dart';
import 'package:pedidos/screens/membership_flow_screen.dart';
import 'package:pedidos/screens/payment_methods_screen.dart';
import 'package:pedidos/screens/expense_categories_screen.dart';
import 'package:pedidos/screens/price_list_screen.dart';
import 'package:pedidos/screens/reports_screen.dart';
import 'package:pedidos/screens/employee_roles_screen.dart'; // Importar pantalla de roles

class SideMenu extends StatefulWidget {
  final VoidCallback onClose;

  const SideMenu({
    super.key,
    required this.onClose,
  });

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  late UserPreferences _userPrefs;
  bool _isLoading = true;
  UserRole _userRole = UserRole.seller;
  String _userName = '';
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      _userPrefs = UserPreferences();
      await _userPrefs.init();

      _userName = _userPrefs.getFullName();
      _userEmail = _userPrefs.getUserEmail() ?? '';
      final role = _userPrefs.getUserRole();
      _userRole = _mapRoleToEnum(role);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  UserRole _mapRoleToEnum(int? role) {
    switch (role) {
      case 4:
        return UserRole.admin;
      case 3:
        return UserRole.accountant;
      case 2:
        return UserRole.warehouse;
      case 1:
        return UserRole.seller;
      default:
        return UserRole.seller;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingLg),
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
                      widget.onClose();
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
                      widget.onClose();
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
                      widget.onClose();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SecurityScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: AppTheme.spacingXl),

                  // Sección de Productos (solo admin y vendedor)
                  if (_userRole == UserRole.admin || _userRole == UserRole.seller) ...[
                    _buildSectionHeader('Productos', FontAwesomeIcons.box),
                    const SizedBox(height: AppTheme.spacingMd),
                    _buildMenuItem(
                      icon: FontAwesomeIcons.tags,
                      title: 'Lista de Precios',
                      subtitle: 'Consulta y gestiona precios de productos',
                      onTap: () {
                        widget.onClose();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PriceListScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingXl),
                  ],

                  // Sección de Finanzas (solo admin y contador)
                  if (_userRole == UserRole.admin || _userRole == UserRole.accountant) ...[
                    _buildSectionHeader('Finanzas', FontAwesomeIcons.moneyBill),
                    const SizedBox(height: AppTheme.spacingMd),
                    _buildMenuItem(
                      icon: FontAwesomeIcons.creditCard,
                      title: 'Métodos de Pago',
                      subtitle: 'Gestiona tus tarjetas y formas de pago',
                      onTap: () {
                        widget.onClose();
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
                        widget.onClose();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ExpenseCategoriesScreen()),
                        );
                      },
                    ),
                    _buildMenuItem(
                      icon: FontAwesomeIcons.chartLine,
                      title: 'Reportes Financieros',
                      subtitle: 'Análisis y estadísticas',
                      onTap: () {
                        widget.onClose();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ReportsScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingXl),
                  ],

                  // Sección de Configuración (todos los roles)
                  _buildSectionHeader('Configuración', FontAwesomeIcons.gear),
                  const SizedBox(height: AppTheme.spacingMd),
                  _buildMenuItem(
                    icon: FontAwesomeIcons.sliders,
                    title: 'Preferencias',
                    subtitle: 'Idioma, tema y unidades',
                    onTap: () {
                      widget.onClose();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsScreen()),
                      );
                    },
                  ),
                  if (_userRole == UserRole.admin) ...[
                    _buildMenuItem(
                      icon: FontAwesomeIcons.calendar,
                      title: 'Calendario de Pagos',
                      subtitle: 'Visualiza fechas de pago',
                      onTap: () {
                        widget.onClose();
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
                        widget.onClose();
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
                        widget.onClose();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const TaxesScreen()),
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: AppTheme.spacingXl),

                  // Sección de Personal (solo admin)
                  if (_userRole == UserRole.admin) ...[
                    _buildSectionHeader('Personal', FontAwesomeIcons.usersGear),
                    const SizedBox(height: AppTheme.spacingMd),
                    _buildMenuItem(
                      icon: FontAwesomeIcons.userPlus,
                      title: 'Empleados',
                      subtitle: 'Gestión de usuarios y permisos',
                      badge: '3',
                      onTap: () {
                        widget.onClose();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EmployeesScreen()),
                        );
                      },
                    ),
                    // Nuevo menú para Roles de Empleados
                    _buildMenuItem(
                      icon: FontAwesomeIcons.userShield,
                      title: 'Roles de Empleados',
                      subtitle: 'Gestiona los roles y permisos',
                      onTap: () {
                        widget.onClose();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EmployeeRolesScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingXl),
                  ],

                  // Sección de Membresía (todos)
                  _buildSectionHeader('Membresía', FontAwesomeIcons.crown),
                  const SizedBox(height: AppTheme.spacingMd),
                  _buildMenuItem(
                    icon: FontAwesomeIcons.crown,
                    title: 'Flujo de Membresía',
                    subtitle: 'Planes, beneficios y suscripción',
                    badge: 'NUEVO',
                    onTap: () {
                      widget.onClose();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MembershipFlowScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: AppTheme.spacingXl),

                  // Sección de Soporte (todos)
               /*   _buildSectionHeader('Soporte', FontAwesomeIcons.headset),
                  const SizedBox(height: AppTheme.spacingMd),
                  _buildMenuItem(
                    icon: FontAwesomeIcons.questionCircle,
                    title: 'Ayuda',
                    subtitle: 'Preguntas frecuentes y tutoriales',
                    onTap: () {
                      widget.onClose();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HelpScreen()),
                      );
                    },
                  ),*/
                  /*_buildMenuItem(
                    icon: FontAwesomeIcons.message,
                    title: 'Soporte Técnico',
                    subtitle: 'Contacta con nosotros',
                    badge: '2',
                    onTap: () {
                      widget.onClose();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SupportScreen()),
                      );
                    },
                  ),*/
                 /* if (_userRole == UserRole.admin) ...[
                    _buildMenuItem(
                      icon: FontAwesomeIcons.cloudUpload,
                      title: 'Copia de Seguridad',
                      subtitle: 'Respaldar y restaurar datos',
                      onTap: () {
                        widget.onClose();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const BackupScreen()),
                        );
                      },
                    ),
                  ],*/
                 // const SizedBox(height: AppTheme.spacingXl),

                  // Sección de Información (todos)
                  _buildSectionHeader('Información', FontAwesomeIcons.infoCircle),
                  const SizedBox(height: AppTheme.spacingMd),
                  _buildMenuItem(
                    icon: FontAwesomeIcons.info,
                    title: 'Acerca de',
                    subtitle: 'Versión 1.0.0',
                    onTap: () {
                      widget.onClose();
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
                      widget.onClose();
                      _showTermsDialog(context);
                    },
                  ),
                  _buildMenuItem(
                    icon: FontAwesomeIcons.shieldHeart,
                    title: 'Privacidad',
                    subtitle: 'Protección de datos',
                    onTap: () {
                      widget.onClose();
                      _showPrivacyDialog(context);
                    },
                  ),
                  const SizedBox(height: AppTheme.spacingXl),

                  // Botón de cerrar sesión
                  _buildLogoutButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuHeader() {
    if (_isLoading) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppTheme.primary, AppTheme.primaryContainer],
          ),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primary, AppTheme.primaryContainer],
        ),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.user,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _userName.isNotEmpty ? _userName : 'Usuario',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _userEmail,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _getRoleString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getRoleString() {
    switch (_userRole) {
      case UserRole.admin:
        return 'Administrador';
      case UserRole.seller:
        return 'Vendedor';
      case UserRole.warehouse:
        return 'Almacén';
      case UserRole.driver:
        return 'Repartidor';
      case UserRole.accountant:
        return 'Contador';
    }
  }

  Widget _buildSectionHeader(String title, FaIconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
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
          FaIcon(
            icon,
            size: 14,
            color: AppTheme.primary,
          ),
          const SizedBox(width: AppTheme.spacingMd),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
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
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: FaIcon(
              icon,
              size: 18,
              color: AppTheme.primary,
            ),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.onSurface,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 11,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
        trailing: badge != null
            ? Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: badge == 'NUEVO' ? AppTheme.primary : AppTheme.error,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            badge,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        )
            : FaIcon(
          FontAwesomeIcons.chevronRight,
          size: 14,
          color: AppTheme.outline,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg, vertical: AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.errorContainer.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.error.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: FaIcon(
              FontAwesomeIcons.arrowRightFromBracket,
              size: 18,
              color: AppTheme.error,
            ),
          ),
        ),
        title: Text(
          'Cerrar Sesión',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.error,
          ),
        ),
        subtitle: Text(
          'Salir de tu cuenta actual',
          style: TextStyle(
            fontSize: 11,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
        onTap: () {
          widget.onClose();
          _showLogoutDialog();
        },
      ),
    );
  }

  void _showLogoutDialog() {
    final context = this.context;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await _userPrefs.logout();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
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
      builder: (dialogContext) => AlertDialog(
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
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Política de Privacidad'),
        content: const SingleChildScrollView(
          child: Text(
            'Política de privacidad de la aplicación...\n\n'
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
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}