// lib/widgets/custom_top_app_bar.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';

class CustomTopAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  final String? profileImageUrl;
  final VoidCallback? onProfileTap;
  final List<Widget>? actions;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CustomTopAppBar({
    super.key,
    required this.title,
    this.profileImageUrl,
    this.onProfileTap,
    this.actions,
    this.scaffoldKey,
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.surfaceContainerLowest,
      child: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingLg,
            vertical: 0,
          ),
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerLowest,
            border: Border(
              bottom: BorderSide(
                color: AppTheme.outlineVariant.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              showBackButton ? _buildBackButton(context) : _buildMenuButton(),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              if (actions != null) ...actions!,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton() {
    return GestureDetector(
      onTap: () {
        if (scaffoldKey != null) {
          scaffoldKey!.currentState?.openDrawer();
        } else if (onProfileTap != null) {
          onProfileTap!();
        }
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.surfaceContainer,
        ),
        child: profileImageUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  profileImageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: FaIcon(
                        FontAwesomeIcons.user,
                        size: 20,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    );
                  },
                ),
              )
            : const Center(
                child: FaIcon(
                  FontAwesomeIcons.user,
                  size: 20,
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap:
          onBackPressed ??
          () {
            Navigator.pop(context);
          },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.surfaceContainer,
        ),
        child: const Center(
          child: FaIcon(
            FontAwesomeIcons.chevronLeft,
            size: 20,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

// AppBarButton widget
class AppBarButton extends StatelessWidget {
  final FaIconData icon;
  final VoidCallback onPressed;
  final bool showBadge;
  final int badgeCount;
  final Color? color;

  const AppBarButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.showBadge = false,
    this.badgeCount = 0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? AppTheme.onSurfaceVariant;

    return Stack(
      children: [
        IconButton(
          icon: FaIcon(icon, size: 20, color: iconColor),
          onPressed: onPressed,
        ),
        if (showBadge && badgeCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                badgeCount > 9 ? '9+' : '$badgeCount',
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
