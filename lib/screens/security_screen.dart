import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/screens/modals/confirmation_modal.dart';
import 'package:pedidos/enums/device_type_enum.dart';
import 'package:pedidos/models/login_device_model.dart';
import 'package:pedidos/models/login_history_model.dart';
import 'package:pedidos/enums/login_status_enum.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  // Configuraciones de seguridad
  bool _twoFactorEnabled = false;
  bool _biometricEnabled = true;
  bool _pinLockEnabled = false;
  bool _autoLockEnabled = true;
  bool _loginNotifications = true;
  bool _suspiciousActivityAlerts = true;
  bool _sessionTimeout = true;
  bool _encryptData = true;

  String _pinCode = '';
  String _autoLockTime = '5 minutos';
  String _sessionTimeoutTime = '15 minutos';

  final List<String> _autoLockOptions = ['1 minuto', '5 minutos', '15 minutos', '30 minutos', '1 hora'];
  final List<String> _sessionTimeoutOptions = ['5 minutos', '15 minutos', '30 minutos', '1 hora', 'Nunca'];

  final List<LoginDevice> _connectedDevices = [
    LoginDevice(
      id: '1',
      name: 'iPhone 15 Pro',
      location: 'Ciudad de México, México',
      lastActive: DateTime.now().subtract(const Duration(minutes: 5)),
      isCurrent: true,
      deviceType: DeviceType.mobile,
    ),
    LoginDevice(
      id: '2',
      name: 'MacBook Pro',
      location: 'Ciudad de México, México',
      lastActive: DateTime.now().subtract(const Duration(hours: 2)),
      isCurrent: false,
      deviceType: DeviceType.desktop,
    ),
    LoginDevice(
      id: '3',
      name: 'iPad Air',
      location: 'Guadalajara, México',
      lastActive: DateTime.now().subtract(const Duration(days: 2)),
      isCurrent: false,
      deviceType: DeviceType.tablet,
    ),
  ];

  final List<LoginHistory> _loginHistory = [
    LoginHistory(
      id: '1',
      date: DateTime.now().subtract(const Duration(minutes: 30)),
      location: 'Ciudad de México, México',
      device: 'iPhone 15 Pro',
      ip: '187.189.45.23',
      status: LoginStatus.success,
    ),
    LoginHistory(
      id: '2',
      date: DateTime.now().subtract(const Duration(hours: 5)),
      location: 'Ciudad de México, México',
      device: 'MacBook Pro',
      ip: '187.189.45.23',
      status: LoginStatus.success,
    ),
    LoginHistory(
      id: '3',
      date: DateTime.now().subtract(const Duration(days: 1)),
      location: 'Guadalajara, México',
      device: 'iPad Air',
      ip: '201.150.32.67',
      status: LoginStatus.success,
    ),
    LoginHistory(
      id: '4',
      date: DateTime.now().subtract(const Duration(days: 3)),
      location: 'Desconocido',
      device: 'Dispositivo desconocido',
      ip: '45.67.89.12',
      status: LoginStatus.failed,
    ),
  ];

  void _changePassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cambiar Contraseña'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña actual',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Nueva contraseña',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirmar nueva contraseña',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Contraseña actualizada correctamente'),
                  backgroundColor: AppTheme.primary,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Actualizar'),
          ),
        ],
      ),
    );
  }

  void _setupPinCode() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Configurar PIN'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Ingresa un código PIN de 4 dígitos'),
            const SizedBox(height: AppTheme.spacingLg),
            TextField(
              maxLength: 4,
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Código PIN',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _pinCode = value;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_pinCode.length == 4) {
                Navigator.pop(context);
                setState(() {
                  _pinLockEnabled = true;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('PIN configurado correctamente'),
                    backgroundColor: AppTheme.primary,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Ingresa un PIN de 4 dígitos'),
                    backgroundColor: AppTheme.error,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _revokeDevice(LoginDevice device) {
    ConfirmationModal.show(
      context,
      title: 'Revocar dispositivo',
      message: '¿Estás seguro de que deseas revocar el acceso de "${device.name}"?\n\nEste dispositivo ya no podrá acceder a tu cuenta.',
      confirmText: 'Revocar',
      cancelText: 'Cancelar',
      type: ConfirmationType.warning,
      customIcon: FontAwesomeIcons.mobileScreen,
      onConfirm: () {
        setState(() {
          _connectedDevices.remove(device);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Dispositivo ${device.name} revocado'),
            backgroundColor: AppTheme.error,
          ),
        );
      },
    );
  }

  void _revokeAllDevices() {
    ConfirmationModal.show(
      context,
      title: 'Revocar todos los dispositivos',
      message: '¿Estás seguro de que deseas revocar el acceso de todos los dispositivos?\n\nDeberás iniciar sesión nuevamente en cada dispositivo.',
      confirmText: 'Revocar todos',
      cancelText: 'Cancelar',
      type: ConfirmationType.warning,
      customIcon: FontAwesomeIcons.mobileScreen,
      onConfirm: () {
        setState(() {
          _connectedDevices.removeWhere((device) => !device.isCurrent);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Todos los dispositivos han sido revocados'),
            backgroundColor: AppTheme.error,
          ),
        );
      },
    );
  }

  String _formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Ahora mismo';
    } else if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes} minutos';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours} horas';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else {
      return 'Hace ${difference.inDays} días';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: CustomTopAppBar(
        title: 'Seguridad',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
        actions: [
          AppBarButton(
              icon: FontAwesomeIcons.floppyDisk,
              onPressed: () => {})
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
                  // Seguridad de la cuenta
                  _buildAccountSecurity(),
                  const SizedBox(height: AppTheme.spacingXl),

                  // Autenticación
                  _buildAuthenticationSection(),
                  const SizedBox(height: AppTheme.spacingXl),

                  // Dispositivos conectados
                  _buildConnectedDevices(),
                  const SizedBox(height: AppTheme.spacingXl),

                  // Historial de accesos
                  _buildLoginHistory(),
                  const SizedBox(height: AppTheme.spacingXl),

                  // Privacidad de datos
                  _buildDataPrivacy(),
                  const SizedBox(height: AppTheme.spacingXl * 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSecurity() {
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
                'Seguridad de la cuenta',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeTitle,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          ListTile(
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.lock,
                  size: 20,
                  color: AppTheme.primary,
                ),
              ),
            ),
            title: const Text('Cambiar contraseña'),
            subtitle: const Text('Actualiza tu contraseña cada 90 días'),
            trailing: const FaIcon(
              FontAwesomeIcons.chevronRight,
              size: 16,
              color: AppTheme.outline,
            ),
            onTap: _changePassword,
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Verificación en dos pasos'),
            subtitle: const Text('Añade una capa extra de seguridad'),
            value: _twoFactorEnabled,
            onChanged: (value) {
              setState(() {
                _twoFactorEnabled = value;
              });
            },
            activeThumbColor: AppTheme.primary,
            secondary: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.shield,
                  size: 20,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthenticationSection() {
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
                'Autenticación',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeTitle,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          SwitchListTile(
            title: const Text('Autenticación biométrica'),
            subtitle: const Text('Usar huella digital o Face ID'),
            value: _biometricEnabled,
            onChanged: (value) {
              setState(() {
                _biometricEnabled = value;
              });
            },
            activeThumbColor: AppTheme.primary,
            secondary: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.fingerprint,
                  size: 20,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Bloqueo con PIN'),
            subtitle: const Text('Desbloquear la app con código numérico'),
            value: _pinLockEnabled,
            onChanged: (value) {
              if (value && _pinCode.isEmpty) {
                _setupPinCode();
              } else if (!value) {
                setState(() {
                  _pinLockEnabled = false;
                });
              } else {
                setState(() {
                  _pinLockEnabled = value;
                });
              }
            },
            activeThumbColor: AppTheme.primary,
            secondary: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.pen,
                  size: 20,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Bloqueo automático'),
            subtitle: const Text('Bloquear la app después de inactividad'),
            value: _autoLockEnabled,
            onChanged: (value) {
              setState(() {
                _autoLockEnabled = value;
              });
            },
            activeThumbColor: AppTheme.primary,
            secondary: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.clock,
                  size: 20,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ),
          if (_autoLockEnabled)
            Padding(
              padding: const EdgeInsets.only(left: 56),
              child: ListTile(
                title: const Text('Tiempo de inactividad'),
                trailing: DropdownButton<String>(
                  value: _autoLockTime,
                  underline: const SizedBox(),
                  icon: FaIcon(
                    FontAwesomeIcons.chevronDown,
                    size: 14,
                    color: AppTheme.primary,
                  ),
                  items: _autoLockOptions.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      setState(() {
                        _autoLockTime = newValue;
                      });
                    }
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildConnectedDevices() {
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
                  'Dispositivos conectados',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeTitle,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                ),
                const Spacer(),
                if (_connectedDevices.length > 1)
                  TextButton(
                    onPressed: _revokeAllDevices,
                    child: const Text('Revocar todos'),
                  ),
              ],
            ),
          ),
          const Divider(height: 0, color: AppTheme.outlineVariant),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _connectedDevices.length,
            separatorBuilder: (context, index) => const Divider(height: 0, color: AppTheme.outlineVariant),
            itemBuilder: (context, index) {
              final device = _connectedDevices[index];
              return _buildDeviceItem(device);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceItem(LoginDevice device) {
    FaIconData deviceIcon;
    switch (device.deviceType) {
      case DeviceType.mobile:
        deviceIcon = FontAwesomeIcons.mobile;
        break;
      case DeviceType.tablet:
        deviceIcon = FontAwesomeIcons.tablet;
        break;
      case DeviceType.desktop:
        deviceIcon = FontAwesomeIcons.desktop;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg, vertical: AppTheme.spacingMd),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: FaIcon(
                deviceIcon,
                size: 20,
                color: AppTheme.primary,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingLg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      device.name,
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeBody,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.onSurface,
                      ),
                    ),
                    if (device.isCurrent) ...[
                      const SizedBox(width: AppTheme.spacingSm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingSm,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                        ),
                        child: Text(
                          'Actual',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${device.location} • Último acceso: ${_formatRelativeTime(device.lastActive)}',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeSmall,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (!device.isCurrent)
            IconButton(
              icon: FaIcon(
                FontAwesomeIcons.trashCan,
                size: 16,
                color: AppTheme.error,
              ),
              onPressed: () => _revokeDevice(device),
            ),
        ],
      ),
    );
  }

  Widget _buildLoginHistory() {
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
                  'Historial de accesos',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeTitle,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Historial de accesos exportado'),
                        backgroundColor: AppTheme.primary,
                      ),
                    );
                  },
                  child: const Text('Exportar'),
                ),
              ],
            ),
          ),
          const Divider(height: 0, color: AppTheme.outlineVariant),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 24,
              headingRowColor: WidgetStateProperty.resolveWith(
                    (states) => AppTheme.surfaceContainerLow,
              ),
              columns: const [
                DataColumn(label: Text('Fecha', style: TextStyle(fontWeight: FontWeight.w600))),
                DataColumn(label: Text('Ubicación', style: TextStyle(fontWeight: FontWeight.w600))),
                DataColumn(label: Text('Dispositivo', style: TextStyle(fontWeight: FontWeight.w600))),
                DataColumn(label: Text('IP', style: TextStyle(fontWeight: FontWeight.w600))),
                DataColumn(label: Text('Estado', style: TextStyle(fontWeight: FontWeight.w600))),
              ],
              rows: _loginHistory.map((history) {
                return DataRow(
                  cells: [
                    DataCell(Text(_formatRelativeTime(history.date))),
                    DataCell(Text(history.location)),
                    DataCell(Text(history.device)),
                    DataCell(Text(history.ip)),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingSm,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: history.status == LoginStatus.success
                              ? AppTheme.secondaryContainer.withValues(alpha: 0.2)
                              : AppTheme.errorContainer.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                        ),
                        child: Text(
                          history.status == LoginStatus.success ? 'Exitoso' : 'Fallido',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: history.status == LoginStatus.success ? AppTheme.secondary : AppTheme.error,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataPrivacy() {
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
                'Privacidad de datos',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeTitle,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          SwitchListTile(
            title: const Text('Notificaciones de inicio de sesión'),
            subtitle: const Text('Recibir alertas por email al iniciar sesión'),
            value: _loginNotifications,
            onChanged: (value) {
              setState(() {
                _loginNotifications = value;
              });
            },
            activeThumbColor: AppTheme.primary,
            secondary: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.bell,
                  size: 20,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Alertas de actividad sospechosa'),
            subtitle: const Text('Notificar intentos de acceso no autorizados'),
            value: _suspiciousActivityAlerts,
            onChanged: (value) {
              setState(() {
                _suspiciousActivityAlerts = value;
              });
            },
            activeThumbColor: AppTheme.primary,
            secondary: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.triangleExclamation,
                  size: 20,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Cifrado de datos'),
            subtitle: const Text('Proteger información sensible con cifrado'),
            value: _encryptData,
            onChanged: (value) {
              setState(() {
                _encryptData = value;
              });
            },
            activeThumbColor: AppTheme.primary,
            secondary: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.shield,
                  size: 20,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Cierre de sesión automático'),
            subtitle: const Text('Cerrar sesión después de inactividad'),
            value: _sessionTimeout,
            onChanged: (value) {
              setState(() {
                _sessionTimeout = value;
              });
            },
            activeThumbColor: AppTheme.primary,
            secondary: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.clock,
                  size: 20,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ),
          if (_sessionTimeout)
            Padding(
              padding: const EdgeInsets.only(left: 56),
              child: ListTile(
                title: const Text('Tiempo de inactividad'),
                trailing: DropdownButton<String>(
                  value: _sessionTimeoutTime,
                  underline: const SizedBox(),
                  icon: FaIcon(
                    FontAwesomeIcons.chevronDown,
                    size: 14,
                    color: AppTheme.primary,
                  ),
                  items: _sessionTimeoutOptions.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      setState(() {
                        _sessionTimeoutTime = newValue;
                      });
                    }
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}