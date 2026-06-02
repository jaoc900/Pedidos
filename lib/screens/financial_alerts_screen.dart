import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/enums/alert_type_enum.dart';
import 'package:pedidos/enums/severity_alert_enum.dart';
import 'package:pedidos/models/alert_model.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';

class FinancialAlertsScreen extends StatefulWidget {
  const FinancialAlertsScreen({super.key});

  @override
  State<FinancialAlertsScreen> createState() => _FinancialAlertsScreenState();
}

class _FinancialAlertsScreenState extends State<FinancialAlertsScreen> {
  String _selectedFilter = 'Todas';
  final List<String> _filters = ['Todas', 'Presupuesto', 'Pagos', 'Stock', 'Vencimientos'];

  final List<Alert> _alerts = [
    Alert(
      id: '1',
      title: 'Presupuesto de Ventas excedido',
      description: 'El presupuesto de ventas ha alcanzado el 95% con 5 días restantes.',
      type: AlertType.budget,
      severity: Severity.warning,
      date: DateTime(2025, 5, 20),
      isRead: false,
      actionText: 'Ver detalles',
    ),
    Alert(
      id: '2',
      title: 'Pago a proveedor próximo a vencer',
      description: 'La factura #INV-2025-001 de Agroinsumos S.A. vence en 3 días. Monto: \$12,500.00',
      type: AlertType.payment,
      severity: Severity.warning,
      date: DateTime(2025, 5, 19),
      isRead: false,
      actionText: 'Registrar pago',
    ),
    Alert(
      id: '3',
      title: 'Pago vencido - Factura #ORD-9421',
      description: 'El pago del cliente Carlos Méndez está vencido por 5 días. Monto: \$1,240.00',
      type: AlertType.payment,
      severity: Severity.critical,
      date: DateTime(2025, 5, 18),
      isRead: false,
      actionText: 'Contactar cliente',
    ),
    Alert(
      id: '4',
      title: 'Stock bajo - Fertilizante Orgánico',
      description: 'El stock del producto "Fertilizante Orgánico N-P-K" está por debajo del mínimo (12 unidades restantes).',
      type: AlertType.stock,
      severity: Severity.critical,
      date: DateTime(2025, 5, 17),
      isRead: true,
      actionText: 'Reabastecer',
    ),
    Alert(
      id: '5',
      title: 'Pago de servicios públicos',
      description: 'La factura de electricidad vence en 7 días. Monto estimado: \$3,500.00',
      type: AlertType.payment,
      severity: Severity.info,
      date: DateTime(2025, 5, 16),
      isRead: true,
      actionText: 'Ver factura',
    ),
    Alert(
      id: '6',
      title: 'Meta de ahorro trimestral',
      description: 'Has alcanzado el 75% de la meta de ahorro para este trimestre.',
      type: AlertType.budget,
      severity: Severity.success,
      date: DateTime(2025, 5, 15),
      isRead: true,
      actionText: 'Ver progreso',
    ),
    Alert(
      id: '7',
      title: 'Vencimiento de préstamo bancario',
      description: 'El pago del préstamo bancario vence en 15 días. Monto: \$15,000.00',
      type: AlertType.dueDate,
      severity: Severity.warning,
      date: DateTime(2025, 5, 14),
      isRead: false,
      actionText: 'Programar pago',
    ),
    Alert(
      id: '8',
      title: 'Inventario crítico - Semillas Premium',
      description: 'El producto "Semillas Premium Mix" tiene solo 5 unidades disponibles.',
      type: AlertType.stock,
      severity: Severity.critical,
      date: DateTime(2025, 5, 13),
      isRead: false,
      actionText: 'Ordenar ahora',
    ),
  ];

  List<Alert> get _filteredAlerts {
    if (_selectedFilter == 'Todas') {
      return _alerts;
    }
    return _alerts.where((alert) {
      switch (_selectedFilter) {
        case 'Presupuesto':
          return alert.type == AlertType.budget;
        case 'Pagos':
          return alert.type == AlertType.payment;
        case 'Stock':
          return alert.type == AlertType.stock;
        case 'Vencimientos':
          return alert.type == AlertType.dueDate;
        default:
          return true;
      }
    }).toList();
  }

  int get _unreadCount => _alerts.where((a) => !a.isRead).length;

  void _markAsRead(Alert alert) {
    setState(() {
      alert.isRead = true;
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var alert in _alerts) {
        alert.isRead = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Todas las alertas marcadas como leídas'),
        backgroundColor: AppTheme.primary,
      ),
    );
  }

  void _clearAllAlerts() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpiar alertas'),
        content: const Text('¿Estás seguro de que deseas eliminar todas las alertas?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _alerts.clear();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Todas las alertas han sido eliminadas'),
                  backgroundColor: AppTheme.error,
                ),
              );
            },
            child: const Text('Eliminar', style: TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );
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
                  // Resumen de alertas
                  _buildAlertsSummary(),
                  const SizedBox(height: AppTheme.spacingLg),
                  // Filtros
                  _buildFilters(),
                  const SizedBox(height: AppTheme.spacingLg),
                  // Lista de alertas
                  _buildAlertsList(),
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
    return CustomTopAppBar(
        title: 'Alertas financieras',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
        actions:[
          AppBarButton(
              icon: FontAwesomeIcons.save,
              onPressed: () =>{})
        ]
    );
  }

  Widget _buildAlertsSummary() {
    final counts = {
      'critical': _alerts.where((a) => a.severity == Severity.critical && !a.isRead).length,
      'warning': _alerts.where((a) => a.severity == Severity.warning && !a.isRead).length,
      'info': _alerts.where((a) => a.severity == Severity.info && !a.isRead).length,
    };

    return Row(
      children: [
        Expanded(
          child: _buildSummaryItem(
            title: 'Críticas',
            count: counts['critical']!,
            color: AppTheme.error,
            icon: FontAwesomeIcons.circleExclamation,
          ),
        ),
        const SizedBox(width: AppTheme.spacingMd),
        Expanded(
          child: _buildSummaryItem(
            title: 'Advertencias',
            count: counts['warning']!,
            color: AppTheme.warning,
            icon: FontAwesomeIcons.triangleExclamation,
          ),
        ),
        const SizedBox(width: AppTheme.spacingMd),
        Expanded(
          child: _buildSummaryItem(
            title: 'Informativas',
            count: counts['info']!,
            color: AppTheme.info,
            icon: FontAwesomeIcons.circleInfo,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem({
    required String title,
    required int count,
    required Color color,
    required FaIconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          FaIcon(icon, size: 20, color: color),
          const SizedBox(height: 4),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
        ],
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

  Widget _buildAlertsList() {
    if (_filteredAlerts.isEmpty) {
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
              'No hay alertas',
              style: TextStyle(
                fontSize: AppTheme.fontSizeBody,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              'Todas tus alertas están resueltas',
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
        for (var alert in _filteredAlerts) ...[
          _buildAlertCard(alert),
          const SizedBox(height: AppTheme.spacingLg),
        ],
      ],
    );
  }

  Widget _buildAlertCard(Alert alert) {
    Color bgColor;
    Color borderColor;
    Color iconColor;
    FaIconData icon;

    switch (alert.severity) {
      case Severity.critical:
        bgColor = AppTheme.errorContainer.withValues(alpha: 0.2);
        borderColor = AppTheme.error;
        iconColor = AppTheme.error;
        icon = FontAwesomeIcons.circleExclamation;
        break;
      case Severity.warning:
        bgColor = AppTheme.warningContainer.withValues(alpha: 0.2);
        borderColor = AppTheme.warning;
        iconColor = AppTheme.warning;
        icon = FontAwesomeIcons.triangleExclamation;
        break;
      case Severity.success:
        bgColor = AppTheme.secondaryContainer.withValues(alpha: 0.2);
        borderColor = AppTheme.secondary;
        iconColor = AppTheme.secondary;
        icon = FontAwesomeIcons.circleCheck;
        break;
      default:
        bgColor = AppTheme.infoContainer.withValues(alpha: 0.2);
        borderColor = AppTheme.info;
        iconColor = AppTheme.info;
        icon = FontAwesomeIcons.circleInfo;
    }

    return GestureDetector(
      onTap: () => _markAsRead(alert),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
          border: Border.all(
            color: alert.isRead ? AppTheme.outlineVariant : borderColor,
            width: alert.isRead ? 1 : 2,
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
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: FaIcon(
                        icon,
                        size: 20,
                        color: iconColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingLg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                alert.title,
                                style: TextStyle(
                                  fontSize: AppTheme.fontSizeBody,
                                  fontWeight: alert.isRead ? FontWeight.w600 : FontWeight.w700,
                                  color: AppTheme.onSurface,
                                ),
                              ),
                            ),
                            if (!alert.isRead)
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
                          alert.description,
                          style: TextStyle(
                            fontSize: AppTheme.fontSizeSmall,
                            color: AppTheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
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
                                  _formatDate(alert.date),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppTheme.outline,
                                  ),
                                ),
                              ],
                            ),
                            if (alert.actionText != null)
                              TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Acción: ${alert.actionText}'),
                                      backgroundColor: AppTheme.primary,
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: AppTheme.primary,
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  alert.actionText!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hoy';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} días';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}