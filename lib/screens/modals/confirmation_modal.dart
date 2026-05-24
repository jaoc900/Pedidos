import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';

/// Tipo de modal de confirmación
enum ConfirmationType {
  warning,
  info,
  success,
  error,
}

/// Configuración del modal
class ConfirmationConfig {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final ConfirmationType type;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final FaIconData? customIcon;
  final BuildContext context; // Agregar context a la configuración

  const ConfirmationConfig({
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    required this.type,
    required this.onConfirm,
    this.onCancel,
    this.customIcon,
    required this.context, // Requerir context
  });
}

/// Modal de confirmación genérico
class ConfirmationModal extends StatelessWidget {
  final ConfirmationConfig config;

  const ConfirmationModal({
    super.key,
    required this.config,
  });

  /// Método estático para mostrar el modal
  static Future<void> show(
      BuildContext context, {
        required String title,
        required String message,
        required VoidCallback onConfirm,
        String confirmText = 'Confirmar',
        String cancelText = 'Cancelar',
        ConfirmationType type = ConfirmationType.warning,
        VoidCallback? onCancel,
        FaIconData? customIcon,
      }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppTheme.onBackground.withValues(alpha: 0.3),
      builder: (dialogContext) => ConfirmationModal(
        config: ConfirmationConfig(
          title: title,
          message: message,
          confirmText: confirmText,
          cancelText: cancelText,
          type: type,
          onConfirm: onConfirm,
          onCancel: onCancel,
          customIcon: customIcon,
          context: dialogContext, // Pasar el context del diálogo
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppTheme.spacingLg),
      child: Container(
        width: 340,
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingXl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icono
              _buildIcon(),
              const SizedBox(height: AppTheme.spacingXl),
              // Título
              Text(
                config.title,
                style: TextStyle(
                  fontSize: AppTheme.fontSizeTitle,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingSm),
              // Mensaje
              Text(
                config.message,
                style: TextStyle(
                  fontSize: AppTheme.fontSizeBody,
                  color: AppTheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingXl),
              // Botones
              _buildButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    FaIconData icon;
    Color iconColor;
    Color backgroundColor;

    if (config.customIcon != null) {
      icon = config.customIcon!;
      iconColor = AppTheme.primary;
      backgroundColor = AppTheme.primaryContainer.withValues(alpha: 0.2);
    } else {
      switch (config.type) {
        case ConfirmationType.warning:
          icon = FontAwesomeIcons.triangleExclamation;
          iconColor = AppTheme.error;
          backgroundColor = AppTheme.errorContainer;
          break;
        case ConfirmationType.info:
          icon = FontAwesomeIcons.circleInfo;
          iconColor = AppTheme.primary;
          backgroundColor = AppTheme.primaryContainer;
          break;
        case ConfirmationType.success:
          icon = FontAwesomeIcons.circleCheck;
          iconColor = AppTheme.secondary;
          backgroundColor = AppTheme.secondaryContainer;
          break;
        case ConfirmationType.error:
          icon = FontAwesomeIcons.circleXmark;
          iconColor = AppTheme.error;
          backgroundColor = AppTheme.errorContainer;
          break;
      }
    }

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: FaIcon(
          icon,
          size: 32,
          color: iconColor,
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        // Botón Confirmar
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              config.onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.loginButtonColor,
              foregroundColor: AppTheme.onPrimaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
              ),
              elevation: 0,
            ),
            child: Text(
              config.confirmText,
              style: TextStyle(
                fontSize: AppTheme.fontSizeLabel,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),
        // Botón Cancelar
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: () {
              if (config.onCancel != null) {
                config.onCancel!();
              } else {
                Navigator.pop(config.context);
              }
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: AppTheme.loginButtonColor,
              side: BorderSide(color: AppTheme.loginButtonColor, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
              ),
            ),
            child: Text(
              config.cancelText,
              style: TextStyle(
                fontSize: AppTheme.fontSizeLabel,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Extensión para usar el modal de forma más sencilla
extension ConfirmationModalExtension on BuildContext {
  Future<void> showConfirmation({
    required String title,
    required String message,
    required VoidCallback onConfirm,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
    ConfirmationType type = ConfirmationType.warning,
    VoidCallback? onCancel,
    FaIconData? customIcon,
  }) {
    return ConfirmationModal.show(
      this,
      title: title,
      message: message,
      onConfirm: onConfirm,
      confirmText: confirmText,
      cancelText: cancelText,
      type: type,
      onCancel: onCancel,
      customIcon: customIcon,
    );
  }
}