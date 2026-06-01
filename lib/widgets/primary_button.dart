import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/enums/botton_status_enum.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonState state;
  final FaIconData? icon;
  final double borderRadius;
  final double height;
  final double fontSize;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? loadingColor;
  final Color? textColor;
  final Color? iconColor;
  final double iconSize;
  final EdgeInsets padding;
  final bool fullWidth;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.state = ButtonState.active,
    this.icon,
    this.borderRadius = AppTheme.borderRadiusLg,
    this.height = 56,
    this.fontSize = 16,
    this.activeColor,
    this.inactiveColor,
    this.loadingColor,
    this.textColor,
    this.iconColor,
    this.iconSize = 18,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = state == ButtonState.active;
    final bool isLoading = state == ButtonState.loading;
    final bool isInactive = state == ButtonState.inactive;

    final Color backgroundColor = _getBackgroundColor();
    final Color foregroundColor = _getForegroundColor();

    // Usar GestureDetector + Container para eliminar completamente el efecto ripple
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height,
      child: GestureDetector(
        onTap: (isActive && !isLoading) ? onPressed : null,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: isActive && !isLoading
                ? [
              BoxShadow(
                color: backgroundColor.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ]
                : null,
          ),
          child: Center(
            child: _buildChild(foregroundColor),
          ),
        ),
      ),
    );
  }

  Widget _buildChild(Color foregroundColor) {
    if (state == ButtonState.loading) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                textColor ?? Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: textColor ?? Colors.white,
            ),
          ),
        ],
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            icon,
            size: iconSize,
            color: iconColor ?? foregroundColor,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: textColor ?? foregroundColor,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: textColor ?? foregroundColor,
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (state) {
      case ButtonState.active:
        return activeColor ?? AppTheme.loginButtonColor;
      case ButtonState.inactive:
        return inactiveColor ?? AppTheme.surfaceContainerHigh;
      case ButtonState.loading:
        return loadingColor ?? AppTheme.loginButtonColor;
    }
  }

  Color _getForegroundColor() {
    switch (state) {
      case ButtonState.active:
        return textColor ?? Colors.white;
      case ButtonState.inactive:
        return textColor?.withValues(alpha: 0.6) ?? AppTheme.onSurfaceVariant;
      case ButtonState.loading:
        return textColor ?? Colors.white;
    }
  }
}