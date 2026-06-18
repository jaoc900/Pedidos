// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/screens/modals/confirmation_modal.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';
import 'package:pedidos/widgets/custom_outlined_button.dart';
import 'package:pedidos/core/network/http_client.dart';
import 'package:pedidos/core/network/api_client.dart';
import 'package:pedidos/models/user_preferences_model.dart';
import 'package:pedidos/services/user_preferences.dart';
import 'package:pedidos/providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Configuraciones de la aplicación
  bool _darkMode = false;
  bool _emailNotifications = true;
  bool _pushNotifications = true;

  // Estados
  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;

  late ApiClient _apiClient;
  late UserPreferences _userPrefs;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // Inicializar UserPreferences
      _userPrefs = UserPreferences();
      await _userPrefs.init();

      // Inicializar API client
      final httpClient = HttpClient();
      _apiClient = ApiClient(httpClient);

      // Cargar preferencias
      await _loadPreferences();

      // Cargar estado del tema desde UserPreferences
      _darkMode = _userPrefs.getDarkMode();
    } catch (e) {
      print('Error en inicialización: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al cargar las preferencias';
      });
    }
  }

  Future<void> _loadPreferences() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Intentar cargar desde el backend
      final response = await _apiClient.getUserPreferences();
      final preferences = UserPreferencesModel.fromJson(response);

      setState(() {
        _emailNotifications = preferences.sendSms;
        _pushNotifications = preferences.sendPush;
        _isLoading = false;
      });
    } catch (e) {
    }
  }



  Future<void> _saveEmailPreference(bool value) async {
    if (_isSaving) return;

    setState(() {
      _emailNotifications = value;
      _isSaving = true;
    });

    try {
      await _apiClient.updateSendSmsPreference(value);

      setState(() {
        _isSaving = false;
      });

      _showSuccess(value ? 'Notificaciones por email activadas' : 'Notificaciones por email desactivadas');
    } catch (e) {
      setState(() {
        _isSaving = false;
      });
      _showError('Error al actualizar preferencia de email');
    }
  }

  Future<void> _savePushPreference(bool value) async {
    if (_isSaving) return;

    setState(() {
      _pushNotifications = value;
      _isSaving = true;
    });

    try {
      await _apiClient.updateSendPushPreference(value);

      setState(() {
        _isSaving = false;
      });

      _showSuccess(value ? 'Notificaciones push activadas' : 'Notificaciones push desactivadas');
    } catch (e) {
      setState(() {
        _isSaving = false;
      });
      _showError('Error al actualizar preferencia de push');
    }
  }

  Future<void> _saveDarkModePreference(bool value) async {
    setState(() {
      _darkMode = value;
    });

    try {
      // Usar UserPreferences para guardar
      await _userPrefs.saveDarkMode(value);

      // También notificar al ThemeProvider
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      await themeProvider.toggleTheme(value);

      _showSuccess(value ? 'Modo oscuro activado' : 'Modo claro activado');
    } catch (e) {
      _showError('Error al guardar la preferencia de tema');
      setState(() {
        _darkMode = !value;
      });
    }
  }

  Future<void> _resetSettings() async {
    await ConfirmationModal.show(
      context,
      title: 'Restablecer configuración',
      message: '¿Estás seguro de que deseas restablecer toda la configuración a sus valores predeterminados?',
      confirmText: 'Restablecer',
      cancelText: 'Cancelar',
      type: ConfirmationType.warning,
      customIcon: FontAwesomeIcons.arrowRotateLeft,
      onConfirm: () async {
        try {
          setState(() {
            _isLoading = true;
          });

          // Resetear preferencias en el backend
          await _apiClient.resetUserPreferences();

          // Obtener preferencias por defecto
          final response = await _apiClient.getUserPreferences();
          final preferences = UserPreferencesModel.fromJson(response);

          // Resetear tema a claro
          final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
          await themeProvider.toggleTheme(false);

          setState(() {
            _darkMode = false;
            _emailNotifications = preferences.sendSms;
            _pushNotifications = preferences.sendPush;
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Configuración restablecida a valores predeterminados'),
              backgroundColor: AppTheme.primary,
            ),
          );
        } catch (e) {
          setState(() {
            _isLoading = false;
          });
          _showError('Error al restablecer la configuración');
        }
      },
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.error,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: CustomTopAppBar(
        title: 'Configuración',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
        actions: [
          AppBarButton(
            icon: FontAwesomeIcons.rotateLeft,
            onPressed: _resetSettings,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.circleExclamation,
              size: 48,
              color: AppTheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: TextStyle(fontSize: 16, color: AppTheme.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadPreferences,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
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
            onChanged: _saveDarkModePreference,
            icon: FontAwesomeIcons.moon,
          ),
          const SizedBox(height: AppTheme.spacingLg),

          // Notificaciones
          _buildSectionHeader('Notificaciones', FontAwesomeIcons.bell),
          const SizedBox(height: AppTheme.spacingMd),
          _buildSwitchTile(
            title: 'Notificaciones por email',
            subtitle: 'Recibir notificaciones por correo',
            value: _emailNotifications,
            onChanged: _saveEmailPreference,
            icon: FontAwesomeIcons.envelope,
          ),
          const SizedBox(height: AppTheme.spacingSm),
          _buildSwitchTile(
            title: 'Notificaciones push',
            subtitle: 'Recibir notificaciones en el dispositivo',
            value: _pushNotifications,
            onChanged: _savePushPreference,
            icon: FontAwesomeIcons.mobile,
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
        FaIcon(icon, size: 16, color: AppTheme.primary),
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
              child: FaIcon(icon, size: 18, color: AppTheme.primary),
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
            onChanged: _isSaving ? null : onChanged,
            activeColor: AppTheme.primary,
          ),
        ],
      ),
    );
  }
}