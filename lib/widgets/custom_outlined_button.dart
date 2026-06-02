import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final FaIconData? icon;
  final Color? textColor;
  final Color? iconColor;
  final Color? borderColor;
  final double height;
  final double fontSize;
  final double iconSize;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final bool fullWidth;
  final bool isEnabled;

  const CustomOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.textColor,
    this.iconColor,
    this.borderColor,
    this.height = 56,
    this.fontSize = AppTheme.fontSizeLabel,
    this.iconSize = 20,
    this.borderRadius = AppTheme.borderRadiusXl,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
    this.fullWidth = true,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = textColor ?? AppTheme.secondary;
    final borderSideColor = borderColor ?? AppTheme.outlineVariant;

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height,
      child: GestureDetector(
        onTap: isEnabled ? onPressed : null,
        child: Container(
          width: fullWidth ? double.infinity : null,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: isEnabled ? borderSideColor : AppTheme.outlineVariant,
              width: 2,
            ),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
              children: [
                if (icon != null)
                  FaIcon(
                    icon,
                    size: iconSize,
                    color: iconColor ?? (isEnabled ? color : AppTheme.outlineVariant),
                  ),
                if (icon != null) const SizedBox(width: AppTheme.spacingSm),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    color: isEnabled ? color : AppTheme.outlineVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}