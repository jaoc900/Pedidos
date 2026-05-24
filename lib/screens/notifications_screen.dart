import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/screens/modals/confirmation_modal.dart';
import 'package:pedidos/models/notification_item_model.dart';
import 'package:pedidos/enums/notification_type_enum.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFilter = 'Todas';
  final List<String> _filters = ['Todas', 'No leídas', 'Leídas'];

  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'Nuevo pedido recibido',
      message: 'El cliente "Jardines del Prado" ha realizado un pedido de 50 unidades de Fertilizante Orgánico.',
      time: DateTime.now().subtract(const Duration(minutes: 5)),
      type: NotificationType.order,
      isRead: false,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDOGDZ5MwC5WBi4nK9r4tyMgiqkFY5o7yiJ2fWpZN9kb1k2P1aNFLexio9_F1oIOw4J6AOCPcHP8h907PWMB4bCKWmcm3rWPkDt4kmnpMzs_xGzYlhD2jqiuF8D2XRrjQSaT1z298YvHdiBakdLmXjFy95h6FfB2uEocn1Lo_U3yil93SyWFzkIgl5Evbbec8XiWNDmyKPyhWQ8z7EUGqze6pNI0VcxMseDIqRM_MW42882ywJ_JGwtVenViBMxfb4E3uU-bWAkuST0',
    ),
    NotificationItem(
      id: '2',
      title: 'Alerta de Stock Bajo',
      message: 'El producto "Semillas Girasol Pro" está por debajo del umbral mínimo (5 unidades restantes).',
      time: DateTime.now().subtract(const Duration(hours: 2)),
      type: NotificationType.alert,
      isRead: false,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCuTfLijgdv3y_ASh_ny-oqq0US1GtMSJ-zKJFzFlCLNBQgDfc7Al23Uz7jkounjYEs4fGq-a8KzukkhwYEGF506dmaH6QxMxcJYseBRgPb0R5gGE3oD3yD8iQXmuQXKkjpbj8eN-XpepJELzGQk-DnMtofcq8MWbQa9RzJAwQI8hPIHLafRNyCBCNTeSpMB8OGKQf2XoDBDxqsfoz-mG_tKLanjktsaMpFqq-P8hVbLvjUh2Qt3rLBmHy-CUfKtgRbKhfnBoHpvptR',
    ),
    NotificationItem(
      id: '3',
      title: 'Pago confirmado',
      message: 'Se ha verificado el depósito bancario de la Factura F-2024-051 por \$1,250.00.',
      time: DateTime.now().subtract(const Duration(hours: 5)),
      type: NotificationType.payment,
      isRead: true,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBp8eCTQhRBL6AsodvBFOqfA9p-gQ6g_VUPqMQq9M81mEZV2fvjZuM3Xy1clmeRPCR5hYxswlSkdZtsS2L1n59B3yZOUvcFo8ffBofopRrtkR2Mp8jJHjxETbVtkATqGApiEL3cOgdel1w6_pP9R6bjPZB16x6hY-QEmB23PkhfKQczE_RoY1LdkJQBSA0UtSKnmQ4W3UW2Bxxq-Py5UM1IQobx3mEqH8NGqdjF_9CuirsLfSVYw_X7n8Girn5MUKeQX1IVkqOWuFNa',
    ),
    NotificationItem(
      id: '4',
      title: 'Resumen semanal listo',
      message: 'Tu reporte de ventas de la última semana ya está disponible para análisis.',
      time: DateTime.now().subtract(const Duration(days: 1)),
      type: NotificationType.report,
      isRead: true,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuC_Mcf8RJhjhrC2FuBpInEuF41WSWSOEmGEQ1U_o5Y4ppD64qRnfPeMh8AkyIHR-35FI_gH0zcvo8dyVyepGj5jkkxjnbpTb7IGvTEyVqzeqHk4Eb4Z5_aLwc9YLsws2SvXNxqeTXX9HpRlxlw5ots4NeiAwsjTD-ozmksaHZIA85ZD-WvSAPM54ZlkL50Dcb_gt3V_lHP_HIO0rcMbFUvwM-oYJGCzVQIDBalEr9ge77fc5wWfefb72vNLAATNGpX6WHjcz0cYzbg5',
    ),
    NotificationItem(
      id: '5',
      title: 'Pedido en camino',
      message: 'El transporte ha recogido los productos del pedido #99280 con destino a Sucursal Centro.',
      time: DateTime.now().subtract(const Duration(days: 1)),
      type: NotificationType.shipping,
      isRead: true,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBp8eCTQhRBL6AsodvBFOqfA9p-gQ6g_VUPqMQq9M81mEZV2fvjZuM3Xy1clmeRPCR5hYxswlSkdZtsS2L1n59B3yZOUvcFo8ffBofopRrtkR2Mp8jJHjxETbVtkATqGApiEL3cOgdel1w6_pP9R6bjPZB16x6hY-QEmB23PkhfKQczE_RoY1LdkJQBSA0UtSKnmQ4W3UW2Bxxq-Py5UM1IQobx3mEqH8NGqdjF_9CuirsLfSVYw_X7n8Girn5MUKeQX1IVkqOWuFNa',
    ),
    NotificationItem(
      id: '6',
      title: 'Nuevo cliente registrado',
      message: 'El cliente "Ana García" se ha registrado en la plataforma.',
      time: DateTime.now().subtract(const Duration(days: 2)),
      type: NotificationType.user,
      isRead: true,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBv_6iZ29fNDT9qzWxDsmKL2dSfXzmNo85liJ-wV1CW46883sjJQuX3X8aGsUhAVXzWS5AYwbj34abpIVpbyp5eCmgHyMy6pBNZE6AQq5GVxBaKg3fCyVan7njjhkxfr--2xeOca6agoJ0C4TZtG5gjs2nOuw0PO1_miNOOt2H6piXw5LcfRZCcZjCAn6LgE2UjCVwBS9q58jPHjko4L9MEZJZLlYpZIbKSpfzomNeKBL-xaV4AAvCxceRExeU_xnc8m0arrCqrhdsX',
    ),
  ];

  List<NotificationItem> get _filteredNotifications {
    List<NotificationItem> filtered = _notifications;

    switch (_selectedFilter) {
      case 'No leídas':
        filtered = filtered.where((n) => !n.isRead).toList();
        break;
      case 'Leídas':
        filtered = filtered.where((n) => n.isRead).toList();
        break;
      default:
        break;
    }

    return filtered;
  }

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  void _markAsRead(NotificationItem notification) {
    setState(() {
      notification.isRead = true;
    });
  }

  void _markAllAsRead() {
    if (_unreadCount == 0) return;

    ConfirmationModal.show(
      context,
      title: 'Marcar todas como leídas',
      message: '¿Deseas marcar todas las notificaciones como leídas?',
      confirmText: 'Marcar',
      cancelText: 'Cancelar',
      type: ConfirmationType.info,
      customIcon: FontAwesomeIcons.checkDouble,
      onConfirm: () {
        setState(() {
          for (var notification in _notifications) {
            notification.isRead = true;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Todas las notificaciones marcadas como leídas'),
            backgroundColor: AppTheme.primary,
          ),
        );
      },
    );
  }

  void _clearAllNotifications() {
    if (_notifications.isEmpty) return;

    ConfirmationModal.show(
      context,
      title: 'Eliminar notificaciones',
      message: '¿Estás seguro de que deseas eliminar todas las notificaciones?',
      confirmText: 'Eliminar',
      cancelText: 'Cancelar',
      type: ConfirmationType.warning,
      customIcon: FontAwesomeIcons.trashCan,
      onConfirm: () {
        setState(() {
          _notifications.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Todas las notificaciones han sido eliminadas'),
            backgroundColor: AppTheme.error,
          ),
        );
      },
    );
  }

  void _deleteNotification(NotificationItem notification) {
    ConfirmationModal.show(
      context,
      title: 'Eliminar notificación',
      message: '¿Deseas eliminar esta notificación?',
      confirmText: 'Eliminar',
      cancelText: 'Cancelar',
      type: ConfirmationType.warning,
      customIcon: FontAwesomeIcons.trashCan,
      onConfirm: () {
        setState(() {
          _notifications.remove(notification);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notificación eliminada'),
            backgroundColor: AppTheme.error,
          ),
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Ahora mismo';
    } else if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours} h';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} días';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          _buildTopAppBar(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingXl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Filtros
                  _buildFilters(),
                  const SizedBox(height: AppTheme.spacingLg),
                  // Lista de notificaciones
                  _buildNotificationsList(),
                  const SizedBox(height: AppTheme.spacingXl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXl, vertical: AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.background,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
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
                  'Notificaciones',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeTitle,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
                if (_unreadCount > 0)
                  Container(
                    margin: const EdgeInsets.only(left: AppTheme.spacingSm),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingSm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.error,
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                    ),
                    child: Text(
                      '$_unreadCount',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            Row(
              children: [
                if (_unreadCount > 0)
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.checkDouble,
                      size: 20,
                      color: AppTheme.primary,
                    ),
                    onPressed: _markAllAsRead,
                    tooltip: 'Marcar todas como leídas',
                  ),
                if (_notifications.isNotEmpty)
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.trashCan,
                      size: 20,
                      color: AppTheme.error,
                    ),
                    onPressed: _clearAllNotifications,
                    tooltip: 'Eliminar todas',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: AppTheme.spacingMd),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = filter;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingXl,
                vertical: AppTheme.spacingSm,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primary
                    : AppTheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
              ),
              child: Center(
                child: Text(
                  filter,
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeLabel,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? AppTheme.onPrimary
                        : AppTheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationsList() {
    if (_filteredNotifications.isEmpty) {
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
              FontAwesomeIcons.bellSlash,
              size: 64,
              color: AppTheme.outline.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppTheme.spacingLg),
            Text(
              _selectedFilter == 'No leídas'
                  ? 'No tienes notificaciones no leídas'
                  : 'No hay notificaciones',
              style: TextStyle(
                fontSize: AppTheme.fontSizeBody,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              'Las nuevas notificaciones aparecerán aquí',
              style: TextStyle(
                fontSize: AppTheme.fontSizeSmall,
                color: AppTheme.outline,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        for (var notification in _filteredNotifications) ...[
          _buildNotificationCard(notification),
          const SizedBox(height: AppTheme.spacingLg),
        ],
      ],
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    Color bgColor;
    Color borderColor;
    Color iconColor;
    FaIconData icon;
    String actionText;

    switch (notification.type) {
      case NotificationType.order:
        bgColor = AppTheme.primaryContainer.withValues(alpha: 0.1);
        borderColor = AppTheme.primary;
        iconColor = AppTheme.primary;
        icon = FontAwesomeIcons.cartShopping;
        actionText = 'Ver pedido';
        break;
      case NotificationType.alert:
        bgColor = AppTheme.errorContainer.withValues(alpha: 0.2);
        borderColor = AppTheme.error;
        iconColor = AppTheme.error;
        icon = FontAwesomeIcons.triangleExclamation;
        actionText = 'Gestionar';
        break;
      case NotificationType.payment:
        bgColor = AppTheme.secondaryContainer.withValues(alpha: 0.1);
        borderColor = AppTheme.secondary;
        iconColor = AppTheme.secondary;
        icon = FontAwesomeIcons.moneyBill;
        actionText = 'Ver detalles';
        break;
      case NotificationType.report:
        bgColor = AppTheme.tertiaryContainer.withValues(alpha: 0.1);
        borderColor = AppTheme.tertiary;
        iconColor = AppTheme.tertiary;
        icon = FontAwesomeIcons.chartLine;
        actionText = 'Ver reporte';
        break;
      case NotificationType.shipping:
        bgColor = AppTheme.infoContainer.withValues(alpha: 0.1);
        borderColor = AppTheme.info;
        iconColor = AppTheme.info;
        icon = FontAwesomeIcons.truck;
        actionText = 'Rastrear';
        break;
      case NotificationType.user:
        bgColor = AppTheme.tertiaryContainer.withValues(alpha: 0.1);
        borderColor = AppTheme.tertiary;
        iconColor = AppTheme.tertiary;
        icon = FontAwesomeIcons.userPlus;
        actionText = 'Ver perfil';
        break;
    }

    return GestureDetector(
      onTap: () => _markAsRead(notification),
      child: Container(
        decoration: BoxDecoration(
          color: notification.isRead ? AppTheme.surfaceContainerLowest : bgColor,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
          border: Border.all(
            color: notification.isRead ? AppTheme.outlineVariant : borderColor,
            width: notification.isRead ? 1 : 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icono
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
                    ),
                    child: Center(
                      child: FaIcon(
                        icon,
                        size: 24,
                        color: iconColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingLg),
                  // Contenido
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                notification.title,
                                style: TextStyle(
                                  fontSize: AppTheme.fontSizeBody,
                                  fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.w700,
                                  color: AppTheme.onSurface,
                                ),
                              ),
                            ),
                            if (!notification.isRead)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: iconColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.message,
                          style: TextStyle(
                            fontSize: AppTheme.fontSizeSmall,
                            color: AppTheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingMd),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.clock,
                                  size: 12,
                                  color: AppTheme.outline,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _formatTime(notification.time),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppTheme.outline,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${notification.title} - $actionText'),
                                        backgroundColor: AppTheme.primary,
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: iconColor,
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    actionText,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppTheme.spacingMd),
                                GestureDetector(
                                  onTap: () => _deleteNotification(notification),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    child: FaIcon(
                                      FontAwesomeIcons.trashCan,
                                      size: 14,
                                      color: AppTheme.outline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}