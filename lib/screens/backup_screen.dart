import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/screens/modals/confirmation_modal.dart';
import 'package:pedidos/models/backup_history_model.dart';
import 'package:pedidos/enums/backup_status_enum.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';
import 'package:pedidos/widgets/custom_text_field.dart';
import 'package:pedidos/widgets/custom_chips.dart';
import 'package:pedidos/widgets/primary_button.dart';
import 'package:pedidos/widgets/custom_outlined_button.dart';
import 'package:pedidos/enums/botton_status_enum.dart';

class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  bool _autoBackup = true;
  bool _backupOnWifiOnly = true;
  bool _includeMedia = true;
  bool _includeSettings = true;
  String _backupFrequency = 'Diario';
  final List<String> _frequencies = ['Diario', 'Semanal', 'Mensual', 'Manual'];

  bool _isLoading = false;
  double _backupProgress = 0.0;

  final List<BackupHistory> _backupHistory = [
    BackupHistory(
      id: '1',
      date: DateTime(2025, 5, 22, 23, 30),
      size: '245 MB',
      type: 'Automático',
      status: BackupStatus.success,
    ),
    BackupHistory(
      id: '2',
      date: DateTime(2025, 5, 21, 23, 30),
      size: '238 MB',
      type: 'Automático',
      status: BackupStatus.success,
    ),
    BackupHistory(
      id: '3',
      date: DateTime(2025, 5, 20, 15, 45),
      size: '240 MB',
      type: 'Manual',
      status: BackupStatus.success,
    ),
    BackupHistory(
      id: '4',
      date: DateTime(2025, 5, 19, 23, 30),
      size: '0 B',
      type: 'Automático',
      status: BackupStatus.failed,
    ),
  ];

  Future<void> _createBackup() async {
    setState(() {
      _isLoading = true;
      _backupProgress = 0.0;
    });

    // Simular progreso de backup
    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(Duration(milliseconds: 200));
      setState(() {
        _backupProgress = i / 100;
      });
    }

    setState(() {
      _isLoading = false;
      _backupProgress = 0.0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copia de seguridad creada exitosamente'),
        backgroundColor: AppTheme.primary,
      ),
    );
  }

  void _restoreBackup(BackupHistory backup) {
    ConfirmationModal.show(
      context,
      title: 'Restaurar copia',
      message: '¿Estás seguro de que deseas restaurar esta copia de seguridad?\n\nFecha: ${_formatDate(backup.date)}\nTamaño: ${backup.size}',
      confirmText: 'Restaurar',
      cancelText: 'Cancelar',
      type: ConfirmationType.warning,
      customIcon: FontAwesomeIcons.arrowRotateLeft,
      onConfirm: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Restaurando copia de ${_formatDate(backup.date)}...'),
            backgroundColor: AppTheme.primary,
          ),
        );
      },
    );
  }

  void _deleteBackup(BackupHistory backup) {
    ConfirmationModal.show(
      context,
      title: 'Eliminar copia',
      message: '¿Estás seguro de que deseas eliminar esta copia de seguridad?',
      confirmText: 'Eliminar',
      cancelText: 'Cancelar',
      type: ConfirmationType.warning,
      customIcon: FontAwesomeIcons.trashCan,
      onConfirm: () {
        setState(() {
          _backupHistory.remove(backup);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Copia de seguridad eliminada'),
            backgroundColor: AppTheme.error,
          ),
        );
      },
    );
  }

  void _exportBackup() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exportando copia de seguridad...'),
        backgroundColor: AppTheme.primary,
      ),
    );
  }

  void _importBackup() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Importando copia de seguridad...'),
        backgroundColor: AppTheme.primary,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          _buildTopAppBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingXl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Acciones principales
                  _buildActionButtons(),
                  const SizedBox(height: AppTheme.spacingXl),

                  // Configuración de backup
                  _buildBackupSettings(),
                  const SizedBox(height: AppTheme.spacingXl),

                  // Espacio de almacenamiento
                  _buildStorageInfo(),
                  const SizedBox(height: AppTheme.spacingXl),

                  // Historial de backups
                  _buildBackupHistory(),
                  const SizedBox(height: AppTheme.spacingXl * 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopAppBar() {
    return CustomTopAppBar(
      title: 'Copia de Seguridad',
      showBackButton: true,
      onBackPressed: () => Navigator.pop(context),
      actions: [
        AppBarButton(
          icon: FontAwesomeIcons.cloud,
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
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: CustomOutlinedButton(
            text: 'Crear Backup',
            onPressed: _createBackup,
            icon: FontAwesomeIcons.cloudArrowUp,
            textColor: AppTheme.primary,
            borderColor: AppTheme.primary,
            iconColor: AppTheme.primary,
            borderRadius: AppTheme.borderRadiusXl,
            fontSize: AppTheme.fontSizeLabel,
            iconSize: 28,
            height: 100,
            fullWidth: true,
          ),
        ),
        const SizedBox(width: AppTheme.spacingLg),
        Expanded(
          child: CustomOutlinedButton(
            text: 'Exportar',
            onPressed: _exportBackup,
            icon: FontAwesomeIcons.fileExport,
            textColor: AppTheme.secondary,
            borderColor: AppTheme.secondary,
            iconColor: AppTheme.secondary,
            borderRadius: AppTheme.borderRadiusXl,
            fontSize: AppTheme.fontSizeLabel,
            iconSize: 28,
            height: 100,
            fullWidth: true,
          ),
        ),
        const SizedBox(width: AppTheme.spacingLg),
        Expanded(
          child: CustomOutlinedButton(
            text: 'Importar',
            onPressed: _importBackup,
            icon: FontAwesomeIcons.fileImport,
            textColor: AppTheme.tertiary,
            borderColor: AppTheme.tertiary,
            iconColor: AppTheme.tertiary,
            borderRadius: AppTheme.borderRadiusXl,
            fontSize: AppTheme.fontSizeLabel,
            iconSize: 28,
            height: 100,
            fullWidth: true,
          ),
        ),
      ],
    );
  }

  Widget _buildBackupSettings() {
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
                'Configuración',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeTitle,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          _buildSwitchTile(
            title: 'Copia automática',
            subtitle: 'Realizar backups automáticos periódicamente',
            value: _autoBackup,
            onChanged: (value) {
              setState(() {
                _autoBackup = value;
              });
            },
            icon: FontAwesomeIcons.cloud,
          ),
          if (_autoBackup) ...[
            const SizedBox(height: AppTheme.spacingSm),
            _buildDropdownTile(
              title: 'Frecuencia',
              subtitle: 'Backup $_backupFrequency',
              value: _backupFrequency,
              items: _frequencies,
              icon: FontAwesomeIcons.clock,
              onChanged: (value) {
                setState(() {
                  _backupFrequency = value;
                });
              },
            ),
          ],
          const Divider(),
          _buildSwitchTile(
            title: 'Solo WiFi',
            subtitle: 'Realizar backups solo cuando haya conexión WiFi',
            value: _backupOnWifiOnly,
            onChanged: (value) {
              setState(() {
                _backupOnWifiOnly = value;
              });
            },
            icon: FontAwesomeIcons.wifi,
          ),
          _buildSwitchTile(
            title: 'Incluir multimedia',
            subtitle: 'Incluir imágenes y documentos en el backup',
            value: _includeMedia,
            onChanged: (value) {
              setState(() {
                _includeMedia = value;
              });
            },
            icon: FontAwesomeIcons.image,
          ),
          _buildSwitchTile(
            title: 'Incluir configuración',
            subtitle: 'Incluir preferencias y ajustes de la app',
            value: _includeSettings,
            onChanged: (value) {
              setState(() {
                _includeSettings = value;
              });
            },
            icon: FontAwesomeIcons.gear,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required FaIconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingSm),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: FaIcon(icon, size: 18, color: AppTheme.primary),
            ),
          ),
          const SizedBox(width: AppTheme.spacingLg),
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
    return Padding(
      padding: const EdgeInsets.only(left: 56, bottom: AppTheme.spacingSm),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeSmall,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
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
          DropdownButton<String>(
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
                child: Text(item),
              );
            }).toList(),
            onChanged: (newValue) {
              if (newValue != null) {
                onChanged(newValue);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStorageInfo() {
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
                'Almacenamiento',
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
                child: _buildStorageIndicator(
                  used: 2.5,
                  total: 5.0,
                  label: 'Backups',
                ),
              ),
              const SizedBox(width: AppTheme.spacingLg),
              Expanded(
                child: _buildStorageCard(
                  label: 'Último backup',
                  value: 'Hoy, 23:30',
                  icon: FontAwesomeIcons.clock,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStorageIndicator({
    required double used,
    required double total,
    required String label,
  }) {
    final percentage = used / total;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Espacio utilizado',
          style: TextStyle(
            fontSize: AppTheme.fontSizeSmall,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppTheme.spacingSm),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: AppTheme.surfaceContainerHigh,
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: AppTheme.spacingSm),
        Text(
          '${used.toStringAsFixed(1)} GB de ${total.toStringAsFixed(1)} GB usados',
          style: TextStyle(
            fontSize: 10,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildStorageCard({
    required String label,
    required String value,
    required FaIconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
      ),
      child: Column(
        children: [
          FaIcon(
            icon,
            size: 20,
            color: AppTheme.primary,
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            value,
            style: TextStyle(
              fontSize: AppTheme.fontSizeLabel,
              fontWeight: FontWeight.w700,
              color: AppTheme.onSurface,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackupHistory() {
    if (_backupHistory.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
          border: Border.all(color: AppTheme.outlineVariant),
        ),
        child: Column(
          children: [
            FaIcon(
              FontAwesomeIcons.history,
              size: 48,
              color: AppTheme.outline.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppTheme.spacingLg),
            Text(
              'No hay copias de seguridad',
              style: TextStyle(
                fontSize: AppTheme.fontSizeBody,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              'Las copias aparecerán aquí después de crear tu primer backup',
              style: TextStyle(
                fontSize: AppTheme.fontSizeSmall,
                color: AppTheme.outline,
              ),
            ),
          ],
        ),
      );
    }

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
                  'Historial de Backups',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeTitle,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_backupHistory.length} backups',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeSmall,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0, color: AppTheme.outlineVariant),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _backupHistory.length,
            separatorBuilder: (context, index) => const Divider(height: 0, color: AppTheme.outlineVariant),
            itemBuilder: (context, index) {
              final backup = _backupHistory[index];
              return _buildHistoryItem(backup);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(BackupHistory backup) {
    final isSuccess = backup.status == BackupStatus.success;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg, vertical: AppTheme.spacingMd),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isSuccess
                  ? AppTheme.secondaryContainer.withValues(alpha: 0.2)
                  : AppTheme.errorContainer.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: FaIcon(
                isSuccess ? FontAwesomeIcons.checkCircle : FontAwesomeIcons.exclamationCircle,
                size: 20,
                color: isSuccess ? AppTheme.secondary : AppTheme.error,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingLg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  backup.type == 'Automático' ? 'Backup Automático' : 'Backup Manual',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeBody,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_formatDate(backup.date)} • ${backup.size}',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeSmall,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (isSuccess)
            Row(
              children: [
                IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.arrowRotateLeft,
                    size: 16,
                    color: AppTheme.primary,
                  ),
                  onPressed: () => _restoreBackup(backup),
                  tooltip: 'Restaurar',
                ),
                IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.trashCan,
                    size: 16,
                    color: AppTheme.error,
                  ),
                  onPressed: () => _deleteBackup(backup),
                  tooltip: 'Eliminar',
                ),
              ],
            ),
          if (!isSuccess)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingSm,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AppTheme.errorContainer,
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
              ),
              child: Text(
                'Fallido',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.error,
                ),
              ),
            ),
        ],
      ),
    );
  }
}