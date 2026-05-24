import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/screens/modals/confirmation_modal.dart';
import 'package:pedidos/enums/invoice_status_enum.dart';
import 'package:pedidos/models/invoice_model.dart';

class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({super.key});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  String _selectedFilter = 'Todas';
  final List<String> _filters = ['Todas', 'Pagadas', 'Pendientes', 'Vencidas'];
  String _searchQuery = '';

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

    switch (_selectedFilter) {
      case 'Pagadas':
        filtered = filtered.where((i) => i.status == InvoiceStatus.paid).toList();
        break;
      case 'Pendientes':
        filtered = filtered.where((i) => i.status == InvoiceStatus.pending).toList();
        break;
      case 'Vencidas':
        filtered = filtered.where((i) => i.status == InvoiceStatus.overdue).toList();
        break;
      default:
        break;
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((i) =>
      i.client.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          i.number.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          i.id.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    return filtered;
  }

  double get _totalPending => _invoices
      .where((i) => i.status == InvoiceStatus.pending)
      .fold(0, (sum, i) => sum + i.total);

  double get _totalOverdue => _invoices
      .where((i) => i.status == InvoiceStatus.overdue)
      .fold(0, (sum, i) => sum + i.total);

  double get _totalPaid => _invoices
      .where((i) => i.status == InvoiceStatus.paid)
      .fold(0, (sum, i) => sum + i.total);

  void _markAsPaid(Invoice invoice) {
    ConfirmationModal.show(
      context,
      title: 'Registrar Pago',
      message: '¿Deseas marcar la factura ${invoice.number} como pagada?\n\nMonto: \$${invoice.total.toStringAsFixed(2)}',
      confirmText: 'Registrar Pago',
      cancelText: 'Cancelar',
      type: ConfirmationType.success,
      customIcon: FontAwesomeIcons.moneyBill,
      onConfirm: () {
        setState(() {
          invoice.status = InvoiceStatus.paid;
          invoice.paymentDate = DateTime.now();
          invoice.paymentMethod = 'Efectivo';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Factura ${invoice.number} marcada como pagada'),
            backgroundColor: AppTheme.secondary,
          ),
        );
      },
    );
  }

  void _viewInvoiceDetails(Invoice invoice) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.borderRadiusXl)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.5,
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
                          FontAwesomeIcons.fileInvoice,
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
                            invoice.number,
                            style: TextStyle(
                              fontSize: AppTheme.fontSizeTitle,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            invoice.client,
                            style: TextStyle(
                              fontSize: AppTheme.fontSizeBody,
                              color: AppTheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusChip(invoice.status),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingXl),
                const Divider(),
                const SizedBox(height: AppTheme.spacingLg),
                _buildDetailRow('Número de factura', invoice.id, FontAwesomeIcons.barcode),
                _buildDetailRow('Fecha de emisión', _formatDate(invoice.issueDate), FontAwesomeIcons.calendar),
                _buildDetailRow('Fecha de vencimiento', _formatDate(invoice.dueDate), FontAwesomeIcons.clock),
                _buildDetailRow('Items', '${invoice.items} productos', FontAwesomeIcons.box),
                const SizedBox(height: AppTheme.spacingMd),
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingMd),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
                  ),
                  child: Column(
                    children: [
                      _buildAmountRow('Subtotal', invoice.amount),
                      _buildAmountRow('IVA (16%)', invoice.tax),
                      const Divider(),
                      _buildAmountRow('Total', invoice.total, isBold: true),
                    ],
                  ),
                ),
                const SizedBox(height: AppTheme.spacingLg),
                if (invoice.status == InvoiceStatus.paid && invoice.paymentDate != null) ...[
                  _buildDetailRow('Fecha de pago', _formatDate(invoice.paymentDate!), FontAwesomeIcons.calendarCheck),
                  _buildDetailRow('Método de pago', invoice.paymentMethod ?? 'N/A', FontAwesomeIcons.creditCard),
                ],
                const SizedBox(height: AppTheme.spacingXl),
                if (invoice.status != InvoiceStatus.paid)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _markAsPaid(invoice);
                      },
                      icon: const FaIcon(FontAwesomeIcons.moneyBill, size: 18),
                      label: const Text('Registrar Pago'),
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
            width: 100,
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

  Widget _buildAmountRow(String label, double amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: AppTheme.fontSizeBody,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: isBold ? AppTheme.onSurface : AppTheme.onSurfaceVariant,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: AppTheme.fontSizeBody,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              color: isBold ? AppTheme.primary : AppTheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(InvoiceStatus status) {
    Color color;
    String text;

    switch (status) {
      case InvoiceStatus.paid:
        color = AppTheme.secondary;
        text = 'Pagada';
        break;
      case InvoiceStatus.pending:
        color = AppTheme.warning;
        text = 'Pendiente';
        break;
      case InvoiceStatus.overdue:
        color = AppTheme.error;
        text = 'Vencida';
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
    return '${date.day}/${date.month}/${date.year}';
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
                  _buildSummaryCards(),
                  const SizedBox(height: AppTheme.spacingLg),
                  _buildSearchAndFilters(),
                  const SizedBox(height: AppTheme.spacingLg),
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
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(shape: BoxShape.circle),
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
            const Text(
              'Facturas',
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
                  FontAwesomeIcons.fileExport,
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

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            title: 'Por Cobrar',
            value: '\$${_totalPending.toStringAsFixed(2)}',
            icon: FontAwesomeIcons.clock,
            color: AppTheme.warning,
          ),
        ),
        const SizedBox(width: AppTheme.spacingLg),
        Expanded(
          child: _buildSummaryCard(
            title: 'Vencidas',
            value: '\$${_totalOverdue.toStringAsFixed(2)}',
            icon: FontAwesomeIcons.circleExclamation,
            color: AppTheme.error,
          ),
        ),
        const SizedBox(width: AppTheme.spacingLg),
        Expanded(
          child: _buildSummaryCard(
            title: 'Pagadas',
            value: '\$${_totalPaid.toStringAsFixed(2)}',
            icon: FontAwesomeIcons.checkCircle,
            color: AppTheme.secondary,
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
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
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
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppTheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: AppTheme.onSurfaceVariant,
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
              hintText: 'Buscar por cliente, factura o número...',
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
            FaIcon(FontAwesomeIcons.fileInvoice, size: 64, color: AppTheme.outline.withValues(alpha: 0.5)),
            const SizedBox(height: AppTheme.spacingLg),
            const Text('No hay facturas', style: TextStyle(fontSize: AppTheme.fontSizeBody, color: AppTheme.onSurfaceVariant)),
          ],
        ),
      );
    }

    return Column(
      children: _filteredInvoices.map((invoice) => Padding(
        padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
        child: _buildInvoiceCard(invoice),
      )).toList(),
    );
  }

  Widget _buildInvoiceCard(Invoice invoice) {
    final isUrgent = invoice.status == InvoiceStatus.pending &&
        invoice.dueDate.isBefore(DateTime.now().add(const Duration(days: 3)));

    return GestureDetector(
      onTap: () => _viewInvoiceDetails(invoice),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
          border: Border.all(
            color: isUrgent ? AppTheme.error.withValues(alpha: 0.5) : AppTheme.outlineVariant,
            width: isUrgent ? 2 : 1,
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
                              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingSm, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.errorContainer,
                                borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                              ),
                              child: const Text(
                                'URGENTE',
                                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppTheme.error),
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
                _buildStatusChip(invoice.status),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Row(
              children: [
                FaIcon(FontAwesomeIcons.calendar, size: 12, color: AppTheme.outline),
                const SizedBox(width: 4),
                Text(
                  'Vence: ${_formatDate(invoice.dueDate)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: invoice.status == InvoiceStatus.pending && invoice.dueDate.isBefore(DateTime.now())
                        ? AppTheme.error
                        : AppTheme.outline,
                  ),
                ),
                const Spacer(),
                Text(
                  '\$${invoice.total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeTitle,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Row(
              children: [
                FaIcon(FontAwesomeIcons.box, size: 12, color: AppTheme.outline),
                const SizedBox(width: 4),
                Text('${invoice.items} items', style: const TextStyle(fontSize: 12, color: AppTheme.outline)),
              ],
            ),
            const SizedBox(height: AppTheme.spacingLg),
            if (invoice.status != InvoiceStatus.paid)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _viewInvoiceDetails(invoice),
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
                      onPressed: () => _markAsPaid(invoice),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
                        ),
                      ),
                      child: const Text('Pagar'),
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