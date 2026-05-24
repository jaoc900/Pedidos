import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/screens/modals/confirmation_modal.dart';

class PendingInvoicesScreen extends StatefulWidget {
  const PendingInvoicesScreen({super.key});

  @override
  State<PendingInvoicesScreen> createState() => _PendingInvoicesScreenState();
}

class _PendingInvoicesScreenState extends State<PendingInvoicesScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'Todas';
  final List<String> _filters = ['Todas', 'Próximas', 'Vencidas', 'Pagadas'];

  final List<Invoice> _invoices = [
    Invoice(
      id: 'INV-2025-001',
      supplier: 'Agroinsumos S.A.',
      amount: 12500.00,
      issueDate: DateTime(2025, 5, 1),
      dueDate: DateTime(2025, 5, 15),
      status: InvoiceStatus.pending,
      category: 'Insumos',
      invoiceNumber: 'FAC-001',
    ),
    Invoice(
      id: 'INV-2025-002',
      supplier: 'Servicios Agrícolas',
      amount: 3500.00,
      issueDate: DateTime(2025, 5, 5),
      dueDate: DateTime(2025, 5, 20),
      status: InvoiceStatus.pending,
      category: 'Servicios',
      invoiceNumber: 'FAC-002',
    ),
    Invoice(
      id: 'INV-2025-003',
      supplier: 'Semillas Premium',
      amount: 8500.00,
      issueDate: DateTime(2025, 4, 28),
      dueDate: DateTime(2025, 5, 10),
      status: InvoiceStatus.overdue,
      category: 'Semillas',
      invoiceNumber: 'FAC-003',
    ),
    Invoice(
      id: 'INV-2025-004',
      supplier: 'Herramientas Agrícolas',
      amount: 3200.00,
      issueDate: DateTime(2025, 5, 10),
      dueDate: DateTime(2025, 5, 25),
      status: InvoiceStatus.pending,
      category: 'Herramientas',
      invoiceNumber: 'FAC-004',
    ),
    Invoice(
      id: 'INV-2025-005',
      supplier: 'Fertilizantes del Valle',
      amount: 12400.00,
      issueDate: DateTime(2025, 4, 15),
      dueDate: DateTime(2025, 5, 5),
      status: InvoiceStatus.overdue,
      category: 'Fertilizantes',
      invoiceNumber: 'FAC-005',
    ),
    Invoice(
      id: 'INV-2025-006',
      supplier: 'Logística Express',
      amount: 2800.00,
      issueDate: DateTime(2025, 5, 8),
      dueDate: DateTime(2025, 5, 22),
      status: InvoiceStatus.pending,
      category: 'Logística',
      invoiceNumber: 'FAC-006',
    ),
    Invoice(
      id: 'INV-2025-007',
      supplier: 'Servicios Contables',
      amount: 1500.00,
      issueDate: DateTime(2025, 5, 12),
      dueDate: DateTime(2025, 5, 26),
      status: InvoiceStatus.pending,
      category: 'Servicios',
      invoiceNumber: 'FAC-007',
    ),
    Invoice(
      id: 'INV-2025-008',
      supplier: 'Mantenimiento Agrícola',
      amount: 4200.00,
      issueDate: DateTime(2025, 4, 20),
      dueDate: DateTime(2025, 5, 4),
      status: InvoiceStatus.paid,
      category: 'Mantenimiento',
      invoiceNumber: 'FAC-008',
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
        return invoice.supplier.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            invoice.invoiceNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            invoice.category.toLowerCase().contains(_searchQuery.toLowerCase());
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
                    invoice.invoiceNumber,
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeTitle,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.onSurface,
                    ),
                  ),
                  const Divider(),
                  _buildDetailRow('Proveedor', invoice.supplier),
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
                  _buildSearchAndFilters(),
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
                  'Facturas Pendientes',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeTitle,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.fileExport,
                  size: 20,
                  color: AppTheme.primary,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Exportar facturas'),
                      backgroundColor: AppTheme.primary,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
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

  Widget _buildSearchAndFilters() {
    return Column(
      children: [
        // Barra de búsqueda
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
            border: Border.all(color: AppTheme.outlineVariant),
          ),
          child: TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Buscar por proveedor, factura o categoría...',
              hintStyle: TextStyle(
                color: AppTheme.outline,
                fontSize: AppTheme.fontSizeBody,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                child: FaIcon(
                  FontAwesomeIcons.magnifyingGlass,
                  size: 20,
                  color: AppTheme.outline,
                ),
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.times,
                  size: 16,
                  color: AppTheme.outline,
                ),
                onPressed: () {
                  setState(() {
                    _searchQuery = '';
                  });
                },
              )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingLg,
                vertical: AppTheme.spacingLg,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppTheme.spacingLg),
        // Filtros
        SizedBox(
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
        ),
      ],
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
                              invoice.invoiceNumber,
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
                          invoice.supplier,
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
      message: '¿Deseas registrar el pago de la factura ${invoice.invoiceNumber} por \$${invoice.amount.toStringAsFixed(2)}?',
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
            content: Text('Pago registrado para ${invoice.supplier}'),
            backgroundColor: AppTheme.secondary,
          ),
        );
      },
    );
  }

}

enum InvoiceStatus { pending, overdue, paid }

class Invoice {
  final String id;
  final String supplier;
  final double amount;
  final DateTime issueDate;
  final DateTime dueDate;
  InvoiceStatus status;
  final String category;
  final String invoiceNumber;

  Invoice({
    required this.id,
    required this.supplier,
    required this.amount,
    required this.issueDate,
    required this.dueDate,
    required this.status,
    required this.category,
    required this.invoiceNumber,
  });
}