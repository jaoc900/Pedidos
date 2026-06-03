import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/screens/modals/confirmation_modal.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';
import 'package:pedidos/widgets/custom_outlined_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Configuraciones de la aplicación
  bool _darkMode = false;
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _autoBackup = true;
  bool _saveHistory = true;
  bool _locationServices = false;
  bool _dataSaver = false;
  bool _offlineMode = false;

  String _selectedLanguage = 'Español';
  String _selectedCurrency = 'MXN - Peso Mexicano';
  String _selectedDateFormat = 'DD/MM/YYYY';
  String _selectedTimeZone = 'America/Mexico_City';

  final List<String> _languages = ['Español', 'English', 'Português', 'Français'];
  final List<String> _currencies = [
    'MXN - Peso Mexicano',
    'USD - Dólar Americano',
    'EUR - Euro',
    'COP - Peso Colombiano',
    'ARS - Peso Argentino',
  ];
  final List<String> _dateFormats = ['DD/MM/YYYY', 'MM/DD/YYYY', 'YYYY/MM/DD'];
  final List<String> _timeZones = [
    'America/Mexico_City',
    'America/Los_Angeles',
    'America/New_York',
    'Europe/Madrid',
    'Europe/London',
  ];

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
                  // Apariencia
                  _buildSectionHeader('Apariencia', FontAwesomeIcons.palette),
                  const SizedBox(height: AppTheme.spacingMd),
                  _buildSwitchTile(
                    title: 'Modo oscuro',
                    subtitle: 'Cambiar tema de la aplicación',
                    value: _darkMode,
                    onChanged: (value) {
                      setState(() {
                        _darkMode = value;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(value ? 'Modo oscuro activado' : 'Modo claro activado'),
                          backgroundColor: AppTheme.primary,
                        ),
                      );
                    },
                    icon: FontAwesomeIcons.moon,
                  ),
                  const SizedBox(height: AppTheme.spacingLg),

                  // Preferencias de Idioma
                  _buildSectionHeader('Idioma y Región', FontAwesomeIcons.language),
                  const SizedBox(height: AppTheme.spacingMd),
                  _buildDropdownTile(
                    title: 'Idioma',
                    subtitle: 'Selecciona el idioma de la aplicación',
                    value: _selectedLanguage,
                    items: _languages,
                    icon: FontAwesomeIcons.language,
                    onChanged: (value) {
                      setState(() {
                        _selectedLanguage = value;
                      });
                    },
                  ),
                  _buildDropdownTile(
                    title: 'Moneda',
                    subtitle: 'Moneda predeterminada',
                    value: _selectedCurrency,
                    items: _currencies,
                    icon: FontAwesomeIcons.dollarSign,
                    onChanged: (value) {
                      setState(() {
                        _selectedCurrency = value;
                      });
                    },
                  ),
                  _buildDropdownTile(
                    title: 'Formato de fecha',
                    subtitle: 'Formato para mostrar fechas',
                    value: _selectedDateFormat,
                    items: _dateFormats,
                    icon: FontAwesomeIcons.calendar,
                    onChanged: (value) {
                      setState(() {
                        _selectedDateFormat = value;
                      });
                    },
                  ),
                  _buildDropdownTile(
                    title: 'Zona horaria',
                    subtitle: 'Selecciona tu zona horaria',
                    value: _selectedTimeZone,
                    items: _timeZones,
                    icon: FontAwesomeIcons.clock,
                    onChanged: (value) {
                      setState(() {
                        _selectedTimeZone = value;
                      });
                    },
                  ),
                  const SizedBox(height: AppTheme.spacingXl),

                  // Notificaciones
                  _buildSectionHeader('Notificaciones', FontAwesomeIcons.bell),
                  const SizedBox(height: AppTheme.spacingMd),
                  _buildSwitchTile(
                    title: 'Notificaciones',
                    subtitle: 'Recibir notificaciones en general',
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                        if (!value) {
                          _emailNotifications = false;
                          _pushNotifications = false;
                        }
                      });
                    },
                    icon: FontAwesomeIcons.bell,
                  ),
                  if (_notificationsEnabled) ...[
                    const SizedBox(height: AppTheme.spacingSm),
                    Padding(
                      padding: const EdgeInsets.only(left: AppTheme.spacingXl),
                      child: Column(
                        children: [
                          _buildSwitchTile(
                            title: 'Notificaciones por email',
                            subtitle: 'Recibir notificaciones por correo',
                            value: _emailNotifications,
                            onChanged: (value) {
                              setState(() {
                                _emailNotifications = value;
                              });
                            },
                            icon: FontAwesomeIcons.envelope,
                            compact: true,
                          ),
                          _buildSwitchTile(
                            title: 'Notificaciones push',
                            subtitle: 'Recibir notificaciones en el dispositivo',
                            value: _pushNotifications,
                            onChanged: (value) {
                              setState(() {
                                _pushNotifications = value;
                              });
                            },
                            icon: FontAwesomeIcons.mobile,
                            compact: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: AppTheme.spacingLg),
                  _buildSwitchTile(
                    title: 'Sonidos',
                    subtitle: 'Reproducir sonidos en notificaciones',
                    value: _soundEnabled,
                    onChanged: (value) {
                      setState(() {
                        _soundEnabled = value;
                      });
                    },
                    icon: FontAwesomeIcons.volumeUp,
                  ),
                  _buildSwitchTile(
                    title: 'Vibración',
                    subtitle: 'Activar vibración en notificaciones',
                    value: _vibrationEnabled,
                    onChanged: (value) {
                      setState(() {
                        _vibrationEnabled = value;
                      });
                    },
                    icon: FontAwesomeIcons.mobile,
                  ),
                  const SizedBox(height: AppTheme.spacingXl),

                  // Datos y Almacenamiento
                  _buildSectionHeader('Datos y Almacenamiento', FontAwesomeIcons.database),
                  const SizedBox(height: AppTheme.spacingMd),
                  _buildSwitchTile(
                    title: 'Copia de seguridad automática',
                    subtitle: 'Respaldar datos automáticamente',
                    value: _autoBackup,
                    onChanged: (value) {
                      setState(() {
                        _autoBackup = value;
                      });
                    },
                    icon: FontAwesomeIcons.cloudUpload,
                  ),
                  _buildSwitchTile(
                    title: 'Guardar historial',
                    subtitle: 'Mantener registro de actividades',
                    value: _saveHistory,
                    onChanged: (value) {
                      setState(() {
                        _saveHistory = value;
                      });
                    },
                    icon: FontAwesomeIcons.clock,
                  ),
                  _buildSwitchTile(
                    title: 'Modo ahorro de datos',
                    subtitle: 'Reducir consumo de datos móviles',
                    value: _dataSaver,
                    onChanged: (value) {
                      setState(() {
                        _dataSaver = value;
                      });
                    },
                    icon: FontAwesomeIcons.gaugeHigh,
                  ),
                  _buildSwitchTile(
                    title: 'Modo offline',
                    subtitle: 'Trabajar sin conexión a internet',
                    value: _offlineMode,
                    onChanged: (value) {
                      setState(() {
                        _offlineMode = value;
                      });
                    },
                    icon: FontAwesomeIcons.wifi,
                  ),
                  const SizedBox(height: AppTheme.spacingXl),

                  // Privacidad y Seguridad
                  _buildSectionHeader('Privacidad y Seguridad', FontAwesomeIcons.shield),
                  const SizedBox(height: AppTheme.spacingMd),
                  _buildSwitchTile(
                    title: 'Servicios de ubicación',
                    subtitle: 'Permitir acceso a la ubicación',
                    value: _locationServices,
                    onChanged: (value) {
                      setState(() {
                        _locationServices = value;
                      });
                    },
                    icon: FontAwesomeIcons.locationDot,
                  ),
                  _buildActionTile(
                    title: 'Datos personales',
                    subtitle: 'Gestionar tus datos personales',
                    icon: FontAwesomeIcons.userLock,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Gestión de datos personales'),
                          backgroundColor: AppTheme.primary,
                        ),
                      );
                    },
                  ),
                  _buildActionTile(
                    title: 'Historial de accesos',
                    subtitle: 'Ver inicios de sesión recientes',
                    icon: FontAwesomeIcons.history,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Mostrando historial de accesos'),
                          backgroundColor: AppTheme.primary,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AppTheme.spacingXl),

                  // Acerca de
                  _buildSectionHeader('Acerca de', FontAwesomeIcons.infoCircle),
                  const SizedBox(height: AppTheme.spacingMd),
                  _buildInfoTile(
                    title: 'Versión de la aplicación',
                    value: '1.0.0 (build 101)',
                    icon: FontAwesomeIcons.codeBranch,
                  ),
                  _buildInfoTile(
                    title: 'Términos y condiciones',
                    subtitle: 'Consulta nuestros términos de uso',
                    icon: FontAwesomeIcons.fileContract,
                    onTap: () {
                      _showTermsDialog(context);
                    },
                  ),
                  _buildInfoTile(
                    title: 'Política de privacidad',
                    subtitle: 'Cómo protegemos tus datos',
                    icon: FontAwesomeIcons.shieldHeart,
                    onTap: () {
                      _showPrivacyDialog(context);
                    },
                  ),
                  _buildInfoTile(
                    title: 'Licencias',
                    subtitle: 'Bibliotecas de código abierto',
                    icon: FontAwesomeIcons.code,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Mostrando licencias de software'),
                          backgroundColor: AppTheme.primary,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AppTheme.spacingXl),

                  // Botón de reset
                  Container(
                    margin: const EdgeInsets.only(bottom: AppTheme.spacingXl),
                    child: CustomOutlinedButton(
                      text: 'Restablecer configuración',
                      onPressed: _resetSettings,
                      icon: FontAwesomeIcons.arrowRotateLeft,
                      textColor: AppTheme.error,
                      borderColor: AppTheme.error,
                      iconColor: AppTheme.error,
                      borderRadius: AppTheme.borderRadiusXXl,
                      fontSize: AppTheme.fontSizeLabel,
                      iconSize: 18,
                      height: 56,
                      fullWidth: true,
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
      title: 'Configuración',
      showBackButton: true,
      onBackPressed: () => Navigator.pop(context),
      actions:[
        AppBarButton(
            icon: FontAwesomeIcons.save,
            onPressed: ()=>{})
      ]
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

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required FaIconData icon,
    bool compact = false,
  }) {
    return Padding(
      padding: compact ? const EdgeInsets.only(left: 36) : EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icono
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(right: AppTheme.spacingMd),
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
          // Texto (expande para ocupar espacio)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeBody,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeSmall,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          // Switch
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownTile({
    required String title,
    required String subtitle,
    required String value,
    required List<String> items,
    required FaIconData icon,
    required Function(String) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
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
        trailing: DropdownButton<String>(
          value: value,
          underline: const SizedBox(),
          icon: FaIcon(
            FontAwesomeIcons.chevronDown,
            size: 14,
            color: AppTheme.primary,
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(
                  fontSize: AppTheme.fontSizeSmall,
                  color: AppTheme.onSurface,
                ),
              ),
            );
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required FaIconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
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
      trailing: const FaIcon(
        FontAwesomeIcons.chevronRight,
        size: 16,
        color: AppTheme.outline,
      ),
      onTap: onTap,
    );
  }

  Widget _buildInfoTile({
    required String title,
    String? value,
    String? subtitle,
    required FaIconData icon,
    VoidCallback? onTap,
  }) {
    return ListTile(
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
          fontSize: AppTheme.fontSizeBody,
          fontWeight: FontWeight.w600,
          color: AppTheme.onSurface,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
        subtitle,
        style: TextStyle(
          fontSize: AppTheme.fontSizeSmall,
          color: AppTheme.onSurfaceVariant,
        ),
      )
          : null,
      trailing: onTap != null
          ? const FaIcon(
        FontAwesomeIcons.chevronRight,
        size: 16,
        color: AppTheme.outline,
      )
          : Text(
        value ?? '',
        style: TextStyle(
          fontSize: AppTheme.fontSizeBody,
          fontWeight: FontWeight.w600,
          color: AppTheme.primary,
        ),
      ),
      onTap: onTap,
    );
  }

  void _resetSettings() {
    ConfirmationModal.show(
      context,
      title: 'Restablecer configuración',
      message: '¿Estás seguro de que deseas restablecer toda la configuración a sus valores predeterminados?',
      confirmText: 'Restablecer',
      cancelText: 'Cancelar',
      type: ConfirmationType.warning,
      customIcon: FontAwesomeIcons.arrowRotateLeft,
      onConfirm: () {
        setState(() {
          _darkMode = false;
          _notificationsEnabled = true;
          _emailNotifications = true;
          _pushNotifications = true;
          _soundEnabled = true;
          _vibrationEnabled = true;
          _autoBackup = true;
          _saveHistory = true;
          _locationServices = false;
          _dataSaver = false;
          _offlineMode = false;
          _selectedLanguage = 'Español';
          _selectedCurrency = 'MXN - Peso Mexicano';
          _selectedDateFormat = 'DD/MM/YYYY';
          _selectedTimeZone = 'America/Mexico_City';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Configuración restablecida'),
            backgroundColor: AppTheme.primary,
          ),
        );
      },
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