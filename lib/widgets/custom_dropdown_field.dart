import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';

class CustomDropdownField extends StatelessWidget {
  final String? value;
  final String label;
  final String hint;
  final List<String> items;
  final FaIconData icon;
  final ValueChanged<String?>? onChanged;
  final String? Function(String?)? validator;
  final String? errorText;
  final bool enabled;
  final bool readOnly;
  final bool showLabel;
  final double borderRadius;

  const CustomDropdownField({
    super.key,
    required this.value,
    required this.label,
    required this.hint,
    required this.items,
    required this.icon,
    this.onChanged,
    this.validator,
    this.errorText,
    this.enabled = true,
    this.readOnly = false,
    this.showLabel = true,
    this.borderRadius = AppTheme.borderRadiusLg,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LABEL
        if (showLabel && label.isNotEmpty)
          Row(
            children: [
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
                    borderRadius: BorderRadius.circular(
                      AppTheme.borderRadiusSm,
                    ),
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
                    borderRadius: BorderRadius.circular(
                      AppTheme.borderRadiusSm,
                    ),
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

        if (showLabel && label.isNotEmpty)
          const SizedBox(height: AppTheme.spacingSm),

        AbsorbPointer(
          absorbing: !enabled || readOnly,
          child: DropdownButtonFormField<String>(
            value: value,
            validator: enabled ? validator : null,
            onChanged: onChanged,
            isExpanded: true,
            borderRadius: BorderRadius.circular(borderRadius),

            style: TextStyle(
              color: enabled
                  ? AppTheme.onSurface
                  : AppTheme.outline,
              fontSize: AppTheme.fontSizeBody,
            ),

            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: AppTheme.outlineVariant,
                fontSize: AppTheme.fontSizeBody,
              ),

              prefixIcon: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingLg),
                child: FaIcon(
                  icon,
                  size: 20,
                  color: _getIconColor(hasError),
                ),
              ),

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

            icon: FaIcon(
              FontAwesomeIcons.chevronDown,
              size: 14,
              color: enabled
                  ? AppTheme.onSurfaceVariant
                  : AppTheme.outline,
            ),

            dropdownColor: AppTheme.surfaceContainerLowest,

            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
          ),
        ),

        if (errorText != null &&
            errorText!.isNotEmpty &&
            !enabled)
          Padding(
            padding: const EdgeInsets.only(
              top: AppTheme.spacingSm,
            ),
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
        color: hasError
            ? AppTheme.error
            : AppTheme.outlineVariant,
        width: 1,
      ),
    );
  }

  OutlineInputBorder _buildFocusedBorder(bool hasError) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(
        color: hasError
            ? AppTheme.error
            : AppTheme.primary,
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