import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/widgets/primary_button.dart';
import 'package:pedidos/widgets/custom_outlined_button.dart';
import 'package:pedidos/enums/botton_status_enum.dart';

class ConnectionErrorScreen extends StatefulWidget {
  final VoidCallback? onRetry;
  final String? errorMessage;

  const ConnectionErrorScreen({
    super.key,
    this.onRetry,
    this.errorMessage,
  });

  @override
  State<ConnectionErrorScreen> createState() => _ConnectionErrorScreenState();
}

class _ConnectionErrorScreenState extends State<ConnectionErrorScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isRetrying = false;
  String _lastCheckTime = "Hace un momento";

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _handleRetry() async {
    if (_isRetrying) return;

    setState(() {
      _isRetrying = true;
    });

    // Actualizar timestamp
    final now = DateTime.now();
    setState(() {
      _lastCheckTime = 'Hoy, ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    });

    // Simular verificación de conexión
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRetrying = false;
    });

    if (widget.onRetry != null) {
      widget.onRetry!();
    }
  }

  void _contactSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Abriendo chat de soporte...'),
        backgroundColor: AppTheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopAppBar(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(
                  isSmallScreen ? AppTheme.spacingLg : AppTheme.spacingXl,
                ),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildErrorIllustration(),
                        const SizedBox(height: AppTheme.spacingLg),
                        _buildErrorMessage(),
                        const SizedBox(height: AppTheme.spacingLg),
                        _buildActionButtons(),
                        const SizedBox(height: AppTheme.spacingLg),
                        _buildSystemStatusCard(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _buildBottomNavigationBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingLg,
        vertical: AppTheme.spacingMd,
      ),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.arrowLeft,
                  size: 20,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingLg),
          Text(
            'System Status',
            style: TextStyle(
              fontSize: AppTheme.fontSizeTitle,
              fontWeight: FontWeight.w700,
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorIllustration() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDtjJvS5HvsPgVD4LNZu3HxYBRqJF1ZcXNk3V6VO4YTMtZVTOh_aW0tvJ75oHOudSkR9sbYCWcVwKzUKM3r9HtuD0Qbj2c1UfILwpjQFP2bdFUCBsHpfoAiSrTxgl2Gou7SBB9OlutsphY5KqDA1VtG_Cdi6VXF6OD4LCETszBG3UMOgcHmHPyQcHkxVlS2KT-Wdfc3xC38PlziomknNHinxbruEuPMuPLB2OzSpGCCMrZsM80x5l3k8hxHqouKeusYEZxPIaJ47Ka6',
              width: 280,
              height: 280,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryContainer.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.wifi,
                      size: 80,
                      color: AppTheme.primary,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorMessage() {
    return Column(
      children: [
        Text(
          'Error de Conexión',
          style: TextStyle(
            fontSize: AppTheme.fontSizeHeadline,
            fontWeight: FontWeight.w700,
            color: AppTheme.onBackground,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppTheme.spacingSm),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
          child: Text(
            widget.errorMessage ??
                'Algo salió mal. No pudimos conectar con el servidor. Por favor, verifica tu conexión a internet e inténtalo de nuevo.',
            style: TextStyle(
              fontSize: AppTheme.fontSizeBody,
              color: AppTheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        PrimaryButton(
          text: _isRetrying ? 'Reintentando...' : 'Reintentar',
          onPressed: _isRetrying ? null : _handleRetry,
          icon: FontAwesomeIcons.rotateRight,
          state: _isRetrying ? ButtonState.loading : ButtonState.active,
          activeColor: const Color(0xFF1B5E20),
          textColor: AppTheme.onPrimary,
          iconColor: AppTheme.onPrimary,
          borderRadius: AppTheme.borderRadiusXl,
          fontSize: AppTheme.fontSizeLabel,
          iconSize: 18,
          height: 48,
          fullWidth: true,
        ),
        const SizedBox(height: AppTheme.spacingSm),
        CustomOutlinedButton(
          text: 'Contactar Soporte',
          onPressed: _contactSupport,
          icon: FontAwesomeIcons.headset,
          textColor: const Color(0xFF1B5E20),
          borderColor: const Color(0xFF1B5E20),
          iconColor: const Color(0xFF1B5E20),
          borderRadius: AppTheme.borderRadiusXl,
          fontSize: AppTheme.fontSizeLabel,
          iconSize: 18,
          height: 48,
          fullWidth: true,
        ),
      ],
    );
  }

  Widget _buildSystemStatusCard() {
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Estado del Sistema',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeLabel,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.outline,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingSm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.errorContainer,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppTheme.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Desconectado',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeSmall,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.onErrorContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Text(
            'Última comprobación: $_lastCheckTime',
            style: TextStyle(
              fontSize: AppTheme.fontSizeBody,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    final navItems = [
      (icon: FontAwesomeIcons.chartSimple, label: 'Dashboard', active: false),
      (icon: FontAwesomeIcons.boxesStacked, label: 'Inventory', active: false),
      (icon: FontAwesomeIcons.cartShopping, label: 'Orders', active: false),
      (icon: FontAwesomeIcons.gear, label: 'Settings', active: true),
    ];

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppTheme.borderRadiusXl)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: navItems.map((item) {
          final isActive = item.active;
          return GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg, vertical: AppTheme.spacingSm),
              decoration: BoxDecoration(
                color: isActive ? AppTheme.secondaryContainer : Colors.transparent,
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    item.icon,
                    size: 22,
                    color: isActive ? AppTheme.onSecondaryContainer : AppTheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isActive ? AppTheme.onSecondaryContainer : AppTheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}