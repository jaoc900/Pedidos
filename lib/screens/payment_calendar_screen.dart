import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pedidos/enums/payment_status_enum.dart';
import 'package:pedidos/models/payment_event_model.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';

class PaymentCalendarScreen extends StatefulWidget {
  const PaymentCalendarScreen({super.key});

  @override
  State<PaymentCalendarScreen> createState() => _PaymentCalendarScreenState();
}

class _PaymentCalendarScreenState extends State<PaymentCalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<PaymentEvent>> _events = {};

  // Rango dinámico del calendario (desde 2024 hasta 2026)
  final DateTime _firstDay = DateTime(2024, 1, 1);
  final DateTime _lastDay = DateTime(2026, 12, 31);

  // Lista de pagos de ejemplo
  final List<PaymentEvent> _payments = [
    PaymentEvent(
      id: '1',
      title: 'Pago Proveedor Insumos',
      amount: 12500.00,
      dueDate: DateTime(2025, 5, 15),
      status: PaymentStatus.overdue,
      client: 'Agroinsumos S.A.',
    ),
    PaymentEvent(
      id: '2',
      title: 'Servicios Públicos',
      amount: 3500.00,
      dueDate: DateTime(2025, 5, 20),
      status: PaymentStatus.pending,
      client: 'CFE / AySA',
    ),
    PaymentEvent(
      id: '3',
      title: 'Alquiler Local',
      amount: 15000.00,
      dueDate: DateTime(2025, 5, 25),
      status: PaymentStatus.pending,
      client: 'Inmobiliaria Central',
    ),
    PaymentEvent(
      id: '4',
      title: 'Factura #ORD-9421',
      amount: 1240.00,
      dueDate: DateTime(2025, 5, 10),
      status: PaymentStatus.paid,
      client: 'Carlos Méndez',
    ),
    PaymentEvent(
      id: '5',
      title: 'Seguro Agrícola',
      amount: 8500.00,
      dueDate: DateTime(2025, 4, 28),
      status: PaymentStatus.overdue,
      client: 'Seguros Rurales',
    ),
    PaymentEvent(
      id: '6',
      title: 'Factura #ORD-9418',
      amount: 842.00,
      dueDate: DateTime(2025, 5, 5),
      status: PaymentStatus.paid,
      client: 'Sofía Rivas',
    ),
    // Agregar pagos para 2026
    PaymentEvent(
      id: '7',
      title: 'Mantenimiento Equipos',
      amount: 3200.00,
      dueDate: DateTime(2026, 6, 10),
      status: PaymentStatus.pending,
      client: 'Servicios Agrícolas',
    ),
    PaymentEvent(
      id: '8',
      title: 'Compra de Insumos',
      amount: 18750.00,
      dueDate: DateTime(2026, 6, 15),
      status: PaymentStatus.pending,
      client: 'AgroInsumos S.A.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Asegurar que el focusedDay esté dentro del rango
    if (_focusedDay.isBefore(_firstDay)) {
      _focusedDay = _firstDay;
    } else if (_focusedDay.isAfter(_lastDay)) {
      _focusedDay = _lastDay;
    }
    _loadEvents();
  }

  void _loadEvents() {
    _events = {};
    for (var payment in _payments) {
      final date = DateTime(payment.dueDate.year, payment.dueDate.month, payment.dueDate.day);
      if (_events[date] == null) {
        _events[date] = [];
      }
      _events[date]!.add(payment);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: CustomTopAppBar(
        title: 'Calendario de pagos',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildLegend(),
                  const SizedBox(height: AppTheme.spacingLg),
                  _buildCalendar(),
                  const SizedBox(height: AppTheme.spacingLg),
                  _buildPaymentsForSelectedDay(),
                  const SizedBox(height: AppTheme.spacingXl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: AppTheme.outlineVariant),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildLegendItem(
            label: 'Vencidas',
            color: AppTheme.error,
            icon: FontAwesomeIcons.circleExclamation,
          ),
          _buildLegendItem(
            label: 'Próximas',
            color: AppTheme.warning,
            icon: FontAwesomeIcons.clock,
          ),
          _buildLegendItem(
            label: 'Pagadas',
            color: AppTheme.secondary,
            icon: FontAwesomeIcons.circleCheck,
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({
    required String label,
    required Color color,
    required FaIconData icon,
  }) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        FaIcon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: TableCalendar(
        firstDay: _firstDay,
        lastDay: _lastDay,
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        calendarFormat: _calendarFormat,
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        onPageChanged: (focusedDay) {
          setState(() {
            _focusedDay = focusedDay;
          });
        },
        eventLoader: (day) {
          return _events[DateTime(day.year, day.month, day.day)] ?? [];
        },
        calendarStyle: CalendarStyle(
          defaultDecoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
          ),
          weekendDecoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
          ),
          selectedDecoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.primary,
          ),
          todayDecoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.primaryContainer,
          ),
          markerDecoration: const BoxDecoration(
            color: Colors.transparent,
          ),
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            if (events.isNotEmpty) {
              final paymentEvents = events.whereType<PaymentEvent>().toList();
              if (paymentEvents.isEmpty) return null;
              Color markerColor = _getMarkerColor(paymentEvents);
              return Positioned(
                bottom: 2,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: markerColor,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }
            return null;
          },
          // CORREGIDO: Mostrar nombres de días de la semana
          dowBuilder: (context, day) {
            // Lista de días de la semana en español
            const weekDays = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
            final index = day.weekday - 1; // weekday: 1=Lunes, 7=Domingo
            final text = weekDays[index];
            return Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
            );
          },
        ),
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: true,
          formatButtonShowsNext: false,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.onSurface,
          ),
          leftChevronIcon: FaIcon(
            FontAwesomeIcons.chevronLeft,
            size: 20,
            color: AppTheme.primary,
          ),
          rightChevronIcon: FaIcon(
            FontAwesomeIcons.chevronRight,
            size: 20,
            color: AppTheme.primary,
          ),
        ),
        availableGestures: AvailableGestures.all,
      ),
    );
  }

  Color _getMarkerColor(List<PaymentEvent> events) {
    if (events.any((e) => e.status == PaymentStatus.overdue)) {
      return AppTheme.error;
    }
    if (events.any((e) => e.status == PaymentStatus.pending)) {
      return AppTheme.warning;
    }
    if (events.any((e) => e.status == PaymentStatus.paid)) {
      return AppTheme.secondary;
    }
    return Colors.grey;
  }

  Widget _buildPaymentsForSelectedDay() {
    if (_selectedDay == null) {
      return Container(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
          border: Border.all(color: AppTheme.outlineVariant),
        ),
        child: const Center(
          child: Text('Selecciona una fecha para ver los pagos'),
        ),
      );
    }

    final payments = _events[_selectedDay!] ?? [];

    if (payments.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
          border: Border.all(color: AppTheme.outlineVariant),
        ),
        child: Column(
          children: [
            FaIcon(
              FontAwesomeIcons.calendarDay,
              size: 48,
              color: AppTheme.outline,
            ),
            const SizedBox(height: AppTheme.spacingLg),
            const Text('No hay pagos programados para esta fecha'),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            'Pagos del día',
            style: TextStyle(
              fontSize: AppTheme.fontSizeLabel,
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurface,
            ),
          ),
        ),
        const SizedBox(height: AppTheme.spacingSm),
        ...payments.map((payment) => Padding(
          padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
          child: _buildPaymentCard(payment),
        )),
      ],
    );
  }

  Widget _buildPaymentCard(PaymentEvent payment) {
    final isOverdue = payment.status == PaymentStatus.overdue;
    final isPaid = payment.status == PaymentStatus.paid;
    final isPending = payment.status == PaymentStatus.pending;

    Color cardColor;
    Color statusColor;
    String statusText;
    FaIconData statusIcon;

    if (isOverdue) {
      cardColor = AppTheme.errorContainer.withValues(alpha: 0.2);
      statusColor = AppTheme.error;
      statusText = 'Vencida';
      statusIcon = FontAwesomeIcons.circleExclamation;
    } else if (isPaid) {
      cardColor = AppTheme.secondaryContainer.withValues(alpha: 0.2);
      statusColor = AppTheme.secondary;
      statusText = 'Pagada';
      statusIcon = FontAwesomeIcons.circleCheck;
    } else {
      cardColor = AppTheme.errorContainer.withValues(alpha: 0.05);
      statusColor = AppTheme.warning;
      statusText = 'Pendiente';
      statusIcon = FontAwesomeIcons.clock;
    }

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      payment.title,
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeBody,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      payment.client,
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeSmall,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingSm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(statusIcon, size: 12, color: statusColor),
                    const SizedBox(width: 4),
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.calendar,
                    size: 14,
                    color: AppTheme.outline,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(payment.dueDate),
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeSmall,
                      color: AppTheme.outline,
                    ),
                  ),
                ],
              ),
              Text(
                '\$${payment.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeTitle,
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                ),
              ),
            ],
          ),
          if (isOverdue) ...[
            const SizedBox(height: AppTheme.spacingSm),
            Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.clock,
                  size: 12,
                  color: AppTheme.error,
                ),
                const SizedBox(width: 4),
                Text(
                  'Vencido hace ${DateTime.now().difference(payment.dueDate).inDays} días',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.error,
                  ),
                ),
              ],
            ),
          ],
          if (isPending && !isOverdue) ...[
            const SizedBox(height: AppTheme.spacingSm),
            Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.bell,
                  size: 12,
                  color: AppTheme.warning,
                ),
                const SizedBox(width: 4),
                Text(
                  'Próximo a vencer',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.warning,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}