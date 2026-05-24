import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/screens/modals/confirmation_modal.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeliveriesScreen extends StatefulWidget {
  const DeliveriesScreen({super.key});

  @override
  State<DeliveriesScreen> createState() => _DeliveriesScreenState();
}

class _DeliveriesScreenState extends State<DeliveriesScreen> {
  String _selectedFilter = 'Todas';
  final List<String> _filters = ['Todas', 'Pendientes', 'En Ruta', 'Entregadas'];
  String _searchQuery = '';

  final List<Delivery> _deliveries = [
    Delivery(
      id: 'DEL-001',
      orderId: '#ORD-5842',
      client: 'Jardines del Prado',
      address: 'Calle Mayor 123, Col. Centro',
      status: DeliveryStatus.inRoute,
      estimatedTime: DateTime.now().add(const Duration(hours: 1, minutes: 30)),
      amount: 1240.00,
      items: 12,
      contactPhone: '+52 555 123 4567',
      notes: 'Entregar en recepción',
      lat: 19.4326,
      lng: -99.1332,
    ),
    Delivery(
      id: 'DEL-002',
      orderId: '#ORD-5841',
      client: 'Vivero San Pedro',
      address: 'Av. Libertad 240, Col. Jardín',
      status: DeliveryStatus.pending,
      estimatedTime: DateTime.now().add(const Duration(hours: 3)),
      amount: 850.50,
      items: 5,
      contactPhone: '+52 555 234 5678',
      notes: 'Llamar al llegar',
      lat: 19.4426,
      lng: -99.1432,
    ),
    Delivery(
      id: 'DEL-003',
      orderId: '#ORD-5838',
      client: 'EcoHogar Paisajismo',
      address: 'Av. Universidad 1234, Col. Universidad',
      status: DeliveryStatus.pending,
      estimatedTime: DateTime.now().add(const Duration(hours: 4, minutes: 30)),
      amount: 2890.75,
      items: 28,
      contactPhone: '+52 555 345 6789',
      notes: 'Entregar en almacén',
      lat: 19.4226,
      lng: -99.1232,
    ),
    Delivery(
      id: 'DEL-004',
      orderId: '#ORD-5835',
      client: 'Agroinsumos S.A.',
      address: 'Carretera México - Toluca Km 23',
      status: DeliveryStatus.delivered,
      estimatedTime: DateTime.now().subtract(const Duration(hours: 2)),
      amount: 5600.00,
      items: 45,
      contactPhone: '+52 555 456 7890',
      notes: 'Firma de recibido requerida',
      deliveredAt: DateTime.now().subtract(const Duration(hours: 2)),
      lat: 19.4026,
      lng: -99.1532,
    ),
  ];

  List<Delivery> get _filteredDeliveries {
    List<Delivery> filtered = _deliveries;

    if (_selectedFilter != 'Todas') {
      filtered = filtered.where((d) {
        switch (_selectedFilter) {
          case 'Pendientes':
            return d.status == DeliveryStatus.pending;
          case 'En Ruta':
            return d.status == DeliveryStatus.inRoute;
          case 'Entregadas':
            return d.status == DeliveryStatus.delivered;
          default:
            return true;
        }
      }).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((d) =>
      d.client.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          d.orderId.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          d.address.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    return filtered;
  }

  int get _pendingCount => _deliveries.where((d) =>
  d.status == DeliveryStatus.pending || d.status == DeliveryStatus.inRoute
  ).length;

  void _startDelivery(Delivery delivery) {
    ConfirmationModal.show(
      context,
      title: 'Iniciar Entrega',
      message: '¿Deseas marcar esta entrega como "En Ruta"?',
      confirmText: 'Iniciar',
      cancelText: 'Cancelar',
      type: ConfirmationType.info,
      customIcon: FontAwesomeIcons.truck,
      onConfirm: () {
        setState(() {
          delivery.status = DeliveryStatus.inRoute;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Entrega iniciada'),
            backgroundColor: AppTheme.primary,
          ),
        );
      },
    );
  }

  void _completeDelivery(Delivery delivery) {
    ConfirmationModal.show(
      context,
      title: 'Completar Entrega',
      message: '¿Confirmas que la entrega ha sido realizada correctamente?',
      confirmText: 'Completar',
      cancelText: 'Cancelar',
      type: ConfirmationType.success,
      customIcon: FontAwesomeIcons.checkCircle,
      onConfirm: () {
        setState(() {
          delivery.status = DeliveryStatus.delivered;
          delivery.deliveredAt = DateTime.now();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Entrega ${delivery.orderId} completada'),
            backgroundColor: AppTheme.secondary,
          ),
        );
      },
    );
  }

  void _viewDeliveryDetails(Delivery delivery) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.borderRadiusXl)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingXl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingLg),
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryContainer.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.truck,
                          size: 28,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingLg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            delivery.orderId,
                            style: TextStyle(
                              fontSize: AppTheme.fontSizeTitle,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            delivery.client,
                            style: TextStyle(
                              fontSize: AppTheme.fontSizeBody,
                              color: AppTheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusChip(delivery.status),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingXl),
                const Divider(),
                const SizedBox(height: AppTheme.spacingLg),
                _buildDetailRow('Dirección', delivery.address, FontAwesomeIcons.locationDot),
                _buildDetailRow('Teléfono', delivery.contactPhone, FontAwesomeIcons.phone),
                _buildDetailRow('Items', '${delivery.items} productos', FontAwesomeIcons.box),
                _buildDetailRow('Monto', '\$${delivery.amount.toStringAsFixed(2)}', FontAwesomeIcons.moneyBill),
                if (delivery.notes.isNotEmpty)
                  _buildDetailRow('Notas', delivery.notes, FontAwesomeIcons.noteSticky),
                if (delivery.deliveredAt != null)
                  _buildDetailRow('Entregado', _formatDate(delivery.deliveredAt!), FontAwesomeIcons.calendarCheck),
                const SizedBox(height: AppTheme.spacingXl),
                if (delivery.status == DeliveryStatus.pending)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _startDelivery(delivery);
                      },
                      icon: const FaIcon(FontAwesomeIcons.truck, size: 18),
                      label: const Text('Iniciar Entrega'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingLg),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
                        ),
                      ),
                    ),
                  ),
                if (delivery.status == DeliveryStatus.inRoute)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _completeDelivery(delivery);
                      },
                      icon: const FaIcon(FontAwesomeIcons.checkCircle, size: 18),
                      label: const Text('Completar Entrega'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.secondary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingLg),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: AppTheme.spacingMd),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, FaIconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FaIcon(icon, size: 16, color: AppTheme.outline),
          const SizedBox(width: AppTheme.spacingMd),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: AppTheme.fontSizeSmall,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingMd),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: AppTheme.fontSizeSmall,
                fontWeight: FontWeight.w500,
                color: AppTheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(DeliveryStatus status) {
    Color color;
    String text;

    switch (status) {
      case DeliveryStatus.pending:
        color = AppTheme.warning;
        text = 'Pendiente';
        break;
      case DeliveryStatus.inRoute:
        color = AppTheme.primary;
        text = 'En Ruta';
        break;
      case DeliveryStatus.delivered:
        color = AppTheme.secondary;
        text = 'Entregada';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingSm, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatEstimatedTime(DateTime time) {
    final now = DateTime.now();
    final diff = time.difference(now);

    if (diff.inMinutes < 0) {
      return 'Vencida';
    } else if (diff.inHours < 1) {
      return 'En ${diff.inMinutes} min';
    } else if (diff.inHours < 24) {
      return 'En ${diff.inHours} h';
    } else {
      return 'Mañana';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          _buildTopAppBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingXl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSummaryCard(),
                  const SizedBox(height: AppTheme.spacingLg),
                  _buildSearchAndFilters(),
                  const SizedBox(height: AppTheme.spacingLg),
                  _buildDeliveriesList(),
                  const SizedBox(height: AppTheme.spacingXl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopAppBar() {
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
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            const SizedBox(width: AppTheme.spacingLg),
            const Text(
              'Entregas',
              style: TextStyle(
                fontSize: AppTheme.fontSizeTitle,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
            ),
            const Spacer(),
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.map,
                  size: 20,
                  color: AppTheme.primary,
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Entregas Pendientes',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeSmall,
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$_pendingCount',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.truck,
                size: 28,
                color: AppTheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
            border: Border.all(color: AppTheme.outlineVariant),
          ),
          child: TextField(
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Buscar por cliente, orden o dirección...',
              hintStyle: TextStyle(color: AppTheme.outline),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                child: FaIcon(FontAwesomeIcons.magnifyingGlass, size: 20, color: AppTheme.outline),
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                icon: FaIcon(FontAwesomeIcons.times, size: 16, color: AppTheme.outline),
                onPressed: () => setState(() => _searchQuery = ''),
              )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg, vertical: AppTheme.spacingLg),
            ),
          ),
        ),
        const SizedBox(height: AppTheme.spacingLg),
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppTheme.spacingMd),
            itemBuilder: (_, index) {
              final filter = _filters[index];
              final isSelected = _selectedFilter == filter;
              return GestureDetector(
                onTap: () => setState(() => _selectedFilter = filter),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXl, vertical: AppTheme.spacingSm),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primary : AppTheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                  ),
                  child: Center(
                    child: Text(
                      filter,
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeLabel,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? AppTheme.onPrimary : AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveriesList() {
    if (_filteredDeliveries.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
          border: Border.all(color: AppTheme.outlineVariant),
        ),
        child: Column(
          children: [
            FaIcon(FontAwesomeIcons.truck, size: 64, color: AppTheme.outline.withValues(alpha: 0.5)),
            const SizedBox(height: AppTheme.spacingLg),
            const Text('No hay entregas', style: TextStyle(fontSize: AppTheme.fontSizeBody, color: AppTheme.onSurfaceVariant)),
          ],
        ),
      );
    }

    return Column(
      children: _filteredDeliveries.map((delivery) => Padding(
        padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
        child: _buildDeliveryCard(delivery),
      )).toList(),
    );
  }

  Widget _buildDeliveryCard(Delivery delivery) {
    final isPending = delivery.status == DeliveryStatus.pending;
    final isInRoute = delivery.status == DeliveryStatus.inRoute;
    final isDelivered = delivery.status == DeliveryStatus.delivered;

    return GestureDetector(
      onTap: () => _viewDeliveryDetails(delivery),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
          border: Border.all(
            color: isInRoute ? AppTheme.primary.withValues(alpha: 0.3) : AppTheme.outlineVariant,
            width: isInRoute ? 2 : 1,
          ),
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
                        delivery.orderId,
                        style: TextStyle(
                          fontSize: AppTheme.fontSizeLabel,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        delivery.client,
                        style: TextStyle(
                          fontSize: AppTheme.fontSizeBody,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(delivery.status),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Row(
              children: [
                FaIcon(FontAwesomeIcons.locationDot, size: 12, color: AppTheme.outline),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    delivery.address,
                    style: TextStyle(fontSize: 12, color: AppTheme.onSurfaceVariant),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    FaIcon(FontAwesomeIcons.clock, size: 12, color: AppTheme.outline),
                    const SizedBox(width: 4),
                    Text(
                      isDelivered ? 'Entregado' : _formatEstimatedTime(delivery.estimatedTime),
                      style: TextStyle(
                        fontSize: 12,
                        color: isPending && delivery.estimatedTime.isBefore(DateTime.now())
                            ? AppTheme.error
                            : AppTheme.outline,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    FaIcon(FontAwesomeIcons.box, size: 12, color: AppTheme.outline),
                    const SizedBox(width: 4),
                    Text(
                      '${delivery.items} items',
                      style: const TextStyle(fontSize: 12, color: AppTheme.outline),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingLg),
            if (isPending || isInRoute)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _viewDeliveryDetails(delivery),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primary,
                        side: BorderSide(color: AppTheme.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
                        ),
                      ),
                      child: const Text('Ver detalles'),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingMd),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => isPending ? _startDelivery(delivery) : _completeDelivery(delivery),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isPending ? AppTheme.primary : AppTheme.secondary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
                        ),
                      ),
                      child: Text(isPending ? 'Iniciar' : 'Completar'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

enum DeliveryStatus { pending, inRoute, delivered }

class Delivery {
  final String id;
  final String orderId;
  final String client;
  final String address;
  DeliveryStatus status;
  final DateTime estimatedTime;
  final double amount;
  final int items;
  final String contactPhone;
  final String notes;
  final double lat;
  final double lng;
  DateTime? deliveredAt;

  Delivery({
    required this.id,
    required this.orderId,
    required this.client,
    required this.address,
    required this.status,
    required this.estimatedTime,
    required this.amount,
    required this.items,
    required this.contactPhone,
    required this.notes,
    required this.lat,
    required this.lng,
    this.deliveredAt,
  });
}