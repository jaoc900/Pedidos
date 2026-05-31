import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final FaIconData icon;
  final TextInputType keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputAction textInputAction;
  final double borderRadius;

  // Nuevas propiedades
  final String? errorText;
  final bool readOnly;
  final bool enabled;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.textInputAction = TextInputAction.next,
    this.errorText,
    this.readOnly = false,
    this.enabled = true,
    this.onTap,
    this.borderRadius = AppTheme.borderRadiusLg,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FaIcon(
              icon,
              size: 14,
              color: _getIconColor(hasError),
            ),
            const SizedBox(width: AppTheme.spacingSm),
            Text(
              label,
              style: TextStyle(
                fontSize: AppTheme.fontSizeLabel,
                fontWeight: FontWeight.w600,
                color: _getLabelColor(hasError),
              ),
            ),
            if (!enabled)
              Container(
                margin: const EdgeInsets.only(left: AppTheme.spacingSm),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingSm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.outlineVariant,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusSm),
                ),
                child: Text(
                  'Deshabilitado',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
              ),
            if (readOnly)
              Container(
                margin: const EdgeInsets.only(left: AppTheme.spacingSm),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingSm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusSm),
                ),
                child: Text(
                  'Solo lectura',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingSm),
        GestureDetector(
          onTap: readOnly ? onTap : null,
          child: AbsorbPointer(
            absorbing: !enabled || readOnly,
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              maxLines: maxLines,
              validator: enabled ? validator : null,
              obscureText: obscureText,
              textInputAction: textInputAction,
              readOnly: readOnly,
              enabled: enabled,
              style: TextStyle(
                color: enabled ? AppTheme.onSurface : AppTheme.outline,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: AppTheme.outlineVariant,
                  fontSize: AppTheme.fontSizeBody,
                ),
                suffixIcon: suffixIcon,
                errorText: enabled ? errorText : null,
                filled: true,
                fillColor: _getFillColor(),
                border: _buildInputBorder(hasError),
                enabledBorder: _buildInputBorder(hasError),
                focusedBorder: _buildFocusedBorder(hasError),
                errorBorder: _buildErrorBorder(),
                focusedErrorBorder: _buildFocusedErrorBorder(),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingLg,
                  vertical: AppTheme.spacingLg,
                ),
              ),
            ),
          ),
        ),
        if (errorText != null && errorText!.isNotEmpty && !enabled)
          Padding(
            padding: const EdgeInsets.only(top: AppTheme.spacingSm),
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.circleExclamation,
                  size: 12,
                  color: AppTheme.error,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    errorText!,
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeSmall,
                      color: AppTheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Color _getIconColor(bool hasError) {
    if (!enabled) return AppTheme.outline;
    if (hasError) return AppTheme.error;
    return AppTheme.primary;
  }

  Color _getLabelColor(bool hasError) {
    if (!enabled) return AppTheme.outline;
    if (hasError) return AppTheme.error;
    return AppTheme.onSurfaceVariant;
  }

  Color _getFillColor() {
    if (!enabled) return AppTheme.surfaceContainerHigh;
    if (readOnly) return AppTheme.surfaceContainerLow;
    return AppTheme.surfaceContainerLowest;
  }

  OutlineInputBorder _buildInputBorder(bool hasError) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(
        color: hasError ? AppTheme.error : AppTheme.outlineVariant,
        width: 1,
      ),
    );
  }

  OutlineInputBorder _buildFocusedBorder(bool hasError) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(
        color: hasError ? AppTheme.error : AppTheme.primary,
        width: 2,
      ),
    );
  }

  OutlineInputBorder _buildErrorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: const BorderSide(
        color: AppTheme.error,
        width: 1,
      ),
    );
  }

  OutlineInputBorder _buildFocusedErrorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: const BorderSide(
        color: AppTheme.error,
        width: 2,
      ),
    );
  }
}