import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/screens/modals/confirmation_modal.dart';
import 'package:pedidos/enums/invoice_status_enum.dart';
import 'package:pedidos/models/invoice_model.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';
import 'package:pedidos/widgets/custom_text_field.dart';
import 'package:pedidos/widgets/custom_chips.dart';

class PendingInvoicesScreen extends StatefulWidget {
  const PendingInvoicesScreen({super.key});

  @override
  State<PendingInvoicesScreen> createState() => _PendingInvoicesScreenState();
}

class _PendingInvoicesScreenState extends State<PendingInvoicesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'Todas';
  final List<String> _filters = ['Todas', 'Próximas', 'Vencidas', 'Pagadas'];

  final List<Invoice> _invoices = [
    Invoice(
      id: 'INV-2025-001',
      number: 'FAC-001',
      client: 'Jardines del Prado',
      clientId: 'CLT-001',
      issueDate: DateTime(2025, 5, 1),
      dueDate: DateTime(2025, 5, 15),
      amount: 1240.00,
      tax: 198.40,
      total: 1438.40,
      status: InvoiceStatus.paid,
      items: 12,
      category: 'Jardinería', // ← Agregar categoría
      paymentDate: DateTime(2025, 5, 10),
      paymentMethod: 'Transferencia',
    ),
    Invoice(
      id: 'INV-2025-002',
      number: 'FAC-002',
      client: 'Vivero San Pedro',
      clientId: 'CLT-002',
      issueDate: DateTime(2025, 5, 5),
      dueDate: DateTime(2025, 5, 20),
      amount: 850.50,
      tax: 136.08,
      total: 986.58,
      status: InvoiceStatus.pending,
      items: 5,
      category: 'Viveros', // ← Agregar categoría
    ),
    Invoice(
      id: 'INV-2025-003',
      number: 'FAC-003',
      client: 'EcoHogar Paisajismo',
      clientId: 'CLT-003',
      issueDate: DateTime(2025, 4, 28),
      dueDate: DateTime(2025, 5, 10),
      amount: 2890.75,
      tax: 462.52,
      total: 3353.27,
      status: InvoiceStatus.overdue,
      items: 28,
      category: 'Paisajismo', // ← Agregar categoría
    ),
    Invoice(
      id: 'INV-2025-004',
      number: 'FAC-004',
      client: 'Agroinsumos S.A.',
      clientId: 'CLT-004',
      issueDate: DateTime(2025, 5, 10),
      dueDate: DateTime(2025, 5, 25),
      amount: 5600.00,
      tax: 896.00,
      total: 6496.00,
      status: InvoiceStatus.pending,
      items: 45,
      category: 'Insumos', // ← Agregar categoría
    ),
    Invoice(
      id: 'INV-2025-005',
      number: 'FAC-005',
      client: 'Semillas Premium',
      clientId: 'CLT-005',
      issueDate: DateTime(2025, 4, 20),
      dueDate: DateTime(2025, 5, 5),
      amount: 3200.00,
      tax: 512.00,
      total: 3712.00,
      status: InvoiceStatus.overdue,
      items: 18,
      category: 'Semillas', // ← Agregar categoría
    ),
    Invoice(
      id: 'INV-2025-006',
      number: 'FAC-006',
      client: 'Herramientas Agrícolas',
      clientId: 'CLT-006',
      issueDate: DateTime(2025, 5, 12),
      dueDate: DateTime(2025, 5, 27),
      amount: 1850.00,
      tax: 296.00,
      total: 2146.00,
      status: InvoiceStatus.pending,
      items: 8,
      category: 'Herramientas', // ← Agregar categoría
    ),
  ];

  List<Invoice> get _filteredInvoices {
    List<Invoice> filtered = _invoices;

    // Aplicar filtro por estado
    switch (_selectedFilter) {
      case 'Próximas':
        filtered = filtered.where((i) =>
        i.status == InvoiceStatus.pending && i.dueDate.isAfter(DateTime.now())
        ).toList();
        break;
      case 'Vencidas':
        filtered = filtered.where((i) => i.status == InvoiceStatus.overdue).toList();
        break;
      case 'Pagadas':
        filtered = filtered.where((i) => i.status == InvoiceStatus.paid).toList();
        break;
      default:
        break;
    }

    // Aplicar búsqueda
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((invoice) {
        return invoice.client.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            invoice.number.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    return filtered;
  }

  double get _totalPending => _invoices
      .where((i) => i.status == InvoiceStatus.pending || i.status == InvoiceStatus.overdue)
      .fold(0, (sum, item) => sum + item.amount);

  double get _totalOverdue => _invoices
      .where((i) => i.status == InvoiceStatus.overdue)
      .fold(0, (sum, item) => sum + item.amount);

  int get _pendingCount => _invoices
      .where((i) => i.status == InvoiceStatus.pending || i.status == InvoiceStatus.overdue)
      .length;

  void _viewInvoiceDetails(Invoice invoice) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.borderRadiusXl)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Column(
                children: [
                  const FaIcon(
                    FontAwesomeIcons.fileInvoice,
                    size: 48,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  Text(
                    invoice.number,
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeTitle,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.onSurface,
                    ),
                  ),
                  const Divider(),
                  _buildDetailRow('Proveedor', invoice.client),
                  _buildDetailRow('Categoría', invoice.category),
                  _buildDetailRow('Monto', '\$${invoice.amount.toStringAsFixed(2)}'),
                  _buildDetailRow('Fecha Emisión', _formatDate(invoice.issueDate)),
                  _buildDetailRow('Fecha Vencimiento', _formatDate(invoice.dueDate)),
                  _buildDetailRow(
                    'Estado',
                    invoice.status == InvoiceStatus.paid ? 'Pagada' :
                    invoice.status == InvoiceStatus.overdue ? 'Vencida' : 'Pendiente',
                    color: invoice.status == InvoiceStatus.paid ? AppTheme.secondary :
                    invoice.status == InvoiceStatus.overdue ? AppTheme.error : AppTheme.warning,
                  ),
                  const SizedBox(height: AppTheme.spacingXl),
                  if (invoice.status != InvoiceStatus.paid)
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _payInvoice(invoice);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
                          ),
                        ),
                        child: const Text('Registrar Pago'),
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

  Widget _buildDetailRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingSm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: AppTheme.fontSizeBody,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: AppTheme.fontSizeBody,
              fontWeight: FontWeight.w600,
              color: color ?? AppTheme.onSurface,
            ),
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
                  // Resumen de facturas
                  _buildSummaryCards(),
                  const SizedBox(height: AppTheme.spacingLg),
                  // Barra de búsqueda y filtros
                  _buildSearchBar(),
                  const SizedBox(height: AppTheme.spacingLg),
                  _buildFilters(),
                  const SizedBox(height: AppTheme.spacingLg),
                  // Lista de facturas
                  _buildInvoicesList(),
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
        title: 'Facturas pendientes',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
        actions:[
          AppBarButton(
              icon: FontAwesomeIcons.save,
              onPressed: () =>{})
        ]
    );
  }

  Widget _buildFilters() {
    final filters = [
      const FilterChipData(label: 'Todos', value: 'todos', icon: FontAwesomeIcons.list),
      const FilterChipData(label: 'Pendientes', value: 'pendientes', icon: FontAwesomeIcons.clock),
      const FilterChipData(label: 'Completados', value: 'completados', icon: FontAwesomeIcons.check),
      const FilterChipData(label: 'Cancelados', value: 'cancelados', icon: FontAwesomeIcons.times),
    ];

    return CustomFilterChipWithIcon(
      filters: filters,
      selectedFilter: _selectedFilter,
      onFilterSelected: (filter) {
        setState(() {
          _selectedFilter = filter;
        });
      },
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            title: 'Total Pendiente',
            value: '\$${_totalPending.toStringAsFixed(2)}',
            icon: FontAwesomeIcons.clock,
            color: AppTheme.warning,
            bgColor: AppTheme.warningContainer.withValues(alpha: 0.2),
          ),
        ),
        const SizedBox(width: AppTheme.spacingLg),
        Expanded(
          child: _buildSummaryCard(
            title: 'Vencidas',
            value: '\$${_totalOverdue.toStringAsFixed(2)}',
            icon: FontAwesomeIcons.circleExclamation,
            color: AppTheme.error,
            bgColor: AppTheme.errorContainer.withValues(alpha: 0.2),
          ),
        ),
        const SizedBox(width: AppTheme.spacingLg),
        Expanded(
          child: _buildSummaryCard(
            title: 'Facturas',
            value: '$_pendingCount',
            icon: FontAwesomeIcons.fileInvoice,
            color: AppTheme.primary,
            bgColor: AppTheme.primaryContainer.withValues(alpha: 0.2),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required FaIconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: AppTheme.fontSizeSmall,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
              FaIcon(
                icon,
                size: 20,
                color: color,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppTheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return CustomTextField(
      controller: _searchController, // Necesitas crear este controller
      label: '', // Si no quieres label, puedes pasar una cadena vacía
      hint: 'Buscar por proveedor, factura o categoría...',
      icon: FontAwesomeIcons.magnifyingGlass,
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      borderRadius: AppTheme.borderRadiusXXl,
    );
  }

  Widget _buildInvoicesList() {
    if (_filteredInvoices.isEmpty) {
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
              FontAwesomeIcons.fileInvoice,
              size: 64,
              color: AppTheme.outline.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppTheme.spacingLg),
            Text(
              'No hay facturas',
              style: TextStyle(
                fontSize: AppTheme.fontSizeBody,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        for (var invoice in _filteredInvoices) ...[
          _buildInvoiceCard(invoice),
          const SizedBox(height: AppTheme.spacingLg),
        ],
      ],
    );
  }

  Widget _buildInvoiceCard(Invoice invoice) {
    final isOverdue = invoice.status == InvoiceStatus.overdue;
    final isPaid = invoice.status == InvoiceStatus.paid;

    Color statusColor;
    String statusText;
    FaIconData statusIcon;

    if (isOverdue) {
      statusColor = AppTheme.error;
      statusText = 'Vencida';
      statusIcon = FontAwesomeIcons.circleExclamation;
    } else if (isPaid) {
      statusColor = AppTheme.secondary;
      statusText = 'Pagada';
      statusIcon = FontAwesomeIcons.circleCheck;
    } else {
      statusColor = AppTheme.warning;
      statusText = 'Pendiente';
      statusIcon = FontAwesomeIcons.clock;
    }

    final daysUntilDue = invoice.dueDate.difference(DateTime.now()).inDays;
    final isUrgent = daysUntilDue <= 3 && daysUntilDue >= 0 && !isPaid;

    return GestureDetector(
      onTap: () => _viewInvoiceDetails(invoice),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
          border: Border.all(
            color: isUrgent ? AppTheme.error.withValues(alpha: 0.5) : AppTheme.outlineVariant,
            width: isUrgent ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fila superior: Número de factura, proveedor y estado
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              invoice.number,
                              style: TextStyle(
                                fontSize: AppTheme.fontSizeLabel,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.onSurface,
                              ),
                            ),
                            if (isUrgent) ...[
                              const SizedBox(width: AppTheme.spacingSm),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppTheme.spacingSm,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.errorContainer,
                                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                                ),
                                child: Text(
                                  'URGENTE',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.error,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          invoice.client,
                          style: TextStyle(
                            fontSize: AppTheme.fontSizeBody,
                            fontWeight: FontWeight.w600,
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
                        FaIcon(statusIcon, size: 10, color: statusColor),
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
              // Fila media: Categoría y fecha
              Row(
                children: [
                  _buildInfoChip(
                    icon: FontAwesomeIcons.tag,
                    label: invoice.category,
                  ),
                  const SizedBox(width: AppTheme.spacingLg),
                  _buildInfoChip(
                    icon: FontAwesomeIcons.calendar,
                    label: _formatDate(invoice.dueDate),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingMd),
              // Fila inferior: Monto y botón pagar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Monto',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.outline,
                        ),
                      ),
                      Text(
                        '\$${invoice.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: AppTheme.fontSizeTitle,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  if (!isPaid)
                    SizedBox(
                      width: 90,
                      height: 38,
                      child: ElevatedButton(
                        onPressed: () => _payInvoice(invoice),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text('Pagar', style: TextStyle(fontSize: 13)),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required FaIconData icon,
    required String label,
  }) {
    return Row(
      children: [
        FaIcon(
          icon,
          size: 12,
          color: AppTheme.outline,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AppTheme.outline,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _payInvoice(Invoice invoice) {
    ConfirmationModal.show(
      context,
      title: 'Registrar Pago',
      message: '¿Deseas registrar el pago de la factura ${invoice.number} por \$${invoice.amount.toStringAsFixed(2)}?',
      confirmText: 'Registrar Pago',
      cancelText: 'Cancelar',
      type: ConfirmationType.success,
      customIcon: FontAwesomeIcons.moneyBill,
      onConfirm: () {
        setState(() {
          invoice.status = InvoiceStatus.paid;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pago registrado para ${invoice.client}'),
            backgroundColor: AppTheme.secondary,
          ),
        );
      },
    );
  }
}