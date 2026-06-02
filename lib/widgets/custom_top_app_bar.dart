import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';

class CustomTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? profileImageUrl;
  final Widget? customProfileImage;
  final VoidCallback? onProfileTap;
  final List actions;
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

  bool _isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width > 600;
  }

  double _height(BuildContext context) {
    return _isTablet(context) ? 76 : 64;
  }

  double _avatarSize(BuildContext context) {
    return _isTablet(context) ? 44 : 40;
  }

  double _iconSize(BuildContext context) {
    return _isTablet(context) ? 22 : 20;
  }

  Widget _circleBox(double size, Widget child) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTablet(context);

    return Material(
      elevation: elevation,
      color: backgroundColor ?? AppTheme.background,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: _height(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXl),
            child: Row(
              children: [
                // LEFT SECTION
                Flexible(
                  child: Row(
                    children: [
                      if (showBackButton)
                        GestureDetector(
                          onTap: onBackPressed ?? () => Navigator.pop(context),
                          child: _circleBox(
                            40,
                            Center(
                              child: FaIcon(
                                FontAwesomeIcons.arrowLeft,
                                size: _iconSize(context),
                                color: iconColor ?? AppTheme.primary,
                              ),
                            ),
                          ),
                        ),

                      if (showBackButton)
                        const SizedBox(width: AppTheme.spacingMd),

                      if (profileImageUrl != null || customProfileImage != null)
                        GestureDetector(
                          onTap: onProfileTap,
                          child: Container(
                            width: _avatarSize(context),
                            height: _avatarSize(context),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppTheme.primaryContainer,
                                width: 2,
                              ),
                            ),
                            child: ClipOval(
                              child: customProfileImage ??
                                  Image.network(
                                    profileImageUrl ?? '',
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) {
                                      return Container(
                                        color: AppTheme.primaryContainer,
                                        child: Center(
                                          child: FaIcon(
                                            FontAwesomeIcons.user,
                                            size: _iconSize(context),
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                            ),
                          ),
                        ),

                      if ((profileImageUrl != null || customProfileImage != null) &&
                          title.isNotEmpty)
                        const SizedBox(width: AppTheme.spacingMd),

                      if (title.isNotEmpty)
                        Flexible(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: AppTheme.fontSizeTitle,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                              color: titleColor ?? AppTheme.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // RIGHT ACTIONS
                if (actions.isNotEmpty)
                  Row(
                    children: actions
                        .map(
                          (action) => Padding(
                        padding: const EdgeInsets.only(left: AppTheme.spacingMd),
                        child: action,
                      ),
                    )
                        .toList(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );

  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}

class AppBarButton extends StatelessWidget {
  final FaIconData icon;
  final VoidCallback onPressed;
  final Color? color;
  final bool showBadge;
  final int badgeCount;

  const AppBarButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color,
    this.showBadge = false,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final size = isTablet ? 44.0 : 40.0;
    final iconSize = isTablet ? 22.0 : 20.0;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: Center(
              child: FaIcon(
                icon,
                size: iconSize,
                color: color ?? AppTheme.primary,
              ),
            ),
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
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
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