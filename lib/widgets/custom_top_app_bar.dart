import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';

class CustomTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? profileImageUrl;
  final Widget? customProfileImage;
  final VoidCallback? onProfileTap;
  final List<AppBarButton> actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? iconColor;
  final double elevation;
  final bool centerTitle;

  const CustomTopAppBar({
    super.key,
    required this.title,
    this.profileImageUrl,
    this.customProfileImage,
    this.onProfileTap,
    this.actions = const [],
    this.showBackButton = false,
    this.onBackPressed,
    this.backgroundColor,
    this.titleColor,
    this.iconColor,
    this.elevation = 0.5,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingXl,
        vertical: AppTheme.spacingLg,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.background,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        boxShadow: elevation > 0
            ? [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: Offset(0, elevation),
          ),
        ]
            : null,
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left section
            Row(
              children: [
                // Back button
                if (showBackButton)
                  GestureDetector(
                    onTap: onBackPressed ?? () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.arrowLeft,
                          size: 20,
                          color: iconColor ?? AppTheme.primary,
                        ),
                      ),
                    ),
                  ),
                if (showBackButton) const SizedBox(width: AppTheme.spacingMd),

                // Profile image
                if (profileImageUrl != null || customProfileImage != null)
                  GestureDetector(
                    onTap: onProfileTap,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.primaryContainer,
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: customProfileImage ??
                            (profileImageUrl != null
                                ? Image.network(
                              profileImageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 40,
                                  height: 40,
                                  color: AppTheme.primaryContainer,
                                  child: const Center(
                                    child: FaIcon(
                                      FontAwesomeIcons.user,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                            )
                                : Container(
                              width: 40,
                              height: 40,
                              color: AppTheme.primaryContainer,
                              child: const Center(
                                child: FaIcon(
                                  FontAwesomeIcons.user,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            )),
                      ),
                    ),
                  ),

                if ((profileImageUrl != null || customProfileImage != null) && title.isNotEmpty)
                  const SizedBox(width: AppTheme.spacingMd),

                // Title
                if (title.isNotEmpty)
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: AppTheme.fontSizeBody,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                      color: titleColor ?? AppTheme.primary,
                    ),
                  ),
              ],
            ),

            // Right section - Actions
            if (actions.isNotEmpty)
              Row(
                children: actions.map((action) {
                  return Padding(
                    padding: const EdgeInsets.only(left: AppTheme.spacingMd),
                    child: action,
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(72);
}

// Botón configurable para las acciones
class AppBarButton extends StatelessWidget {
  final FaIconData icon;
  final VoidCallback onPressed;
  final Color? color;
  final double size;
  final bool showBadge;
  final int badgeCount;

  const AppBarButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color,
    this.size = 20,
    this.showBadge = false,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: FaIcon(
              icon,
              size: size,
              color: color ?? AppTheme.primary,
            ),
            onPressed: onPressed,
            padding: EdgeInsets.zero,
          ),
        ),
        if (showBadge && badgeCount > 0)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppTheme.error,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 18,
                minHeight: 18,
              ),
              child: Text(
                badgeCount > 99 ? '99+' : badgeCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}