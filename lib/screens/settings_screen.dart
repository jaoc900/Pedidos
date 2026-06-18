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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: CustomTopAppBar(
          title: 'Configuración',
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
          actions:[
            AppBarButton(
                icon: FontAwesomeIcons.save,
                onPressed: ()=>{})
          ]
      ),
      body: Column(
        children: [
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
}