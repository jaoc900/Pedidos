import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';

class MembershipHistoryScreen extends StatefulWidget {
  const MembershipHistoryScreen({super.key});

  @override
  State<MembershipHistoryScreen> createState() => _MembershipHistoryScreenState();
}

class _MembershipHistoryScreenState extends State<MembershipHistoryScreen> {
  String _selectedFilter = 'Todos';
  final List<String> _filters = ['Todos', 'Pagados', 'Pendientes', 'Fallidos'];
  String _searchQuery = '';
  int _selectedYear = 2025;
  final List<int> _years = [2023, 2024, 2025];

  final List<MembershipTransaction> _transactions = [
    MembershipTransaction(
      id: 'INV-2025-009',
      date: DateTime(2025, 5, 15),
      amount: 299.00,
      plan: 'Plan Growth Pro',
      status: TransactionStatus.paid,
      paymentMethod: 'Tarjeta de Crédito',
      invoiceUrl: '#',
    ),
    MembershipTransaction(
      id: 'INV-2025-008',
      date: DateTime(2025, 4, 15),
      amount: 299.00,
      plan: 'Plan Growth Pro',
      status: TransactionStatus.paid,
      paymentMethod: 'Tarjeta de Crédito',
      invoiceUrl: '#',
    ),
    MembershipTransaction(
      id: 'INV-2025-007',
      date: DateTime(2025, 3, 15),
      amount: 299.00,
      plan: 'Plan Growth Pro',
      status: TransactionStatus.paid,
      paymentMethod: 'PayPal',
      invoiceUrl: '#',
    ),
    MembershipTransaction(
      id: 'INV-2025-006',
      date: DateTime(2025, 2, 15),
      amount: 299.00,
      plan: 'Plan Growth Pro',
      status: TransactionStatus.paid,
      paymentMethod: 'Tarjeta de Crédito',
      invoiceUrl: '#',
    ),
    MembershipTransaction(
      id: 'INV-2025-005',
      date: DateTime(2025, 1, 15),
      amount: 299.00,
      plan: 'Plan Basic',
      status: TransactionStatus.paid,
      paymentMethod: 'Transferencia',
      invoiceUrl: '#',
    ),
    MembershipTransaction(
      id: 'INV-2024-012',
      date: DateTime(2024, 12, 15),
      amount: 99.00,
      plan: 'Plan Basic',
      status: TransactionStatus.paid,
      paymentMethod: 'Tarjeta de Crédito',
      invoiceUrl: '#',
    ),
    MembershipTransaction(
      id: 'INV-2024-011',
      date: DateTime(2024, 11, 15),
      amount: 99.00,
      plan: 'Plan Basic',
      status: TransactionStatus.paid,
      paymentMethod: 'Tarjeta de Crédito',
      invoiceUrl: '#',
    ),
  ];

  List<MembershipTransaction> get _filteredTransactions {
    List<MembershipTransaction> filtered = _transactions;

    // Filtrar por año
    filtered = filtered.where((t) => t.date.year == _selectedYear).toList();

    // Filtrar por estado
    if (_selectedFilter != 'Todos') {
      filtered = filtered.where((t) {
        switch (_selectedFilter) {
          case 'Pagados':
            return t.status == TransactionStatus.paid;
          case 'Pendientes':
            return t.status == TransactionStatus.pending;
          case 'Fallidos':
            return t.status == TransactionStatus.failed;
          default:
            return true;
        }
      }).toList();
    }

    // Buscar
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((t) =>
      t.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          t.plan.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    return filtered;
  }

  double get _totalSpent => _filteredTransactions
      .where((t) => t.status == TransactionStatus.paid)
      .fold(0, (sum, t) => sum + t.amount);

  int get _totalTransactions => _filteredTransactions.length;

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
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      _buildHeader(),
                      const SizedBox(height: AppTheme.spacingXl),
                      // Resumen
                      _buildSummaryCards(),
                      const SizedBox(height: AppTheme.spacingXl),
                      // Filtros
                      _buildFilters(),
                      const SizedBox(height: AppTheme.spacingLg),
                      // Tabla de transacciones
                      _buildTransactionsTable(),
                      const SizedBox(height: AppTheme.spacingXl * 2),
                    ],
                  ),
                ),
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
        color: Colors.white.withValues(alpha: 0.95),
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
                  'Historial de Membresía',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeTitle,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.fileExport,
                    size: 20,
                    color: AppTheme.primary,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Exportando historial...'),
                        backgroundColor: AppTheme.primary,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Historial de Pagos',
          style: TextStyle(
            fontSize: AppTheme.fontSizeHeadline,
            fontWeight: FontWeight.w700,
            color: AppTheme.onSurface,
          ),
        ),
        const SizedBox(height: AppTheme.spacingSm),
        Text(
          'Consulta todas tus transacciones y facturas de membresía.',
          style: TextStyle(
            fontSize: AppTheme.fontSizeBody,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            title: 'Total Gastado',
            value: '\$${_totalSpent.toStringAsFixed(2)}',
            icon: FontAwesomeIcons.moneyBill,
            color: AppTheme.primary,
          ),
        ),
        const SizedBox(width: AppTheme.spacingLg),
        Expanded(
          child: _buildSummaryCard(
            title: 'Transacciones',
            value: '$_totalTransactions',
            icon: FontAwesomeIcons.receipt,
            color: AppTheme.secondary,
          ),
        ),
        const SizedBox(width: AppTheme.spacingLg),
        Expanded(
          child: _buildSummaryCard(
            title: 'Membresía Activa',
            value: 'Growth Pro',
            icon: FontAwesomeIcons.crown,
            color: AppTheme.tertiary,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: AppTheme.fontSizeSmall,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: AppTheme.fontSizeTitle,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.onSurface,
                ),
              ),
            ],
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: FaIcon(
                icon,
                size: 24,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        // Búsqueda
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
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
                hintText: 'Buscar por factura o plan...',
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
        ),
        const SizedBox(width: AppTheme.spacingLg),
        // Selector de año
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
            border: Border.all(color: AppTheme.outlineVariant),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: _selectedYear,
              icon: FaIcon(FontAwesomeIcons.chevronDown, size: 14, color: AppTheme.primary),
              items: _years.map((year) {
                return DropdownMenuItem<int>(
                  value: year,
                  child: Text(year.toString()),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedYear = newValue;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionsTable() {
    if (_filteredTransactions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
          border: Border.all(color: AppTheme.outlineVariant),
        ),
        child: Column(
          children: [
            FaIcon(FontAwesomeIcons.receipt, size: 64, color: AppTheme.outline.withValues(alpha: 0.5)),
            const SizedBox(height: AppTheme.spacingLg),
            Text(
              'No hay transacciones',
              style: TextStyle(
                fontSize: AppTheme.fontSizeBody,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              'No se encontraron pagos para este período',
              style: TextStyle(
                fontSize: AppTheme.fontSizeSmall,
                color: AppTheme.outline,
              ),
            ),
          ],
        ),
      );
    }

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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 32,
          headingRowColor: WidgetStateProperty.resolveWith(
                (states) => AppTheme.surfaceContainerLow,
          ),
          columns: const [
            DataColumn(label: Text('Factura', style: TextStyle(fontWeight: FontWeight.w600))),
            DataColumn(label: Text('Fecha', style: TextStyle(fontWeight: FontWeight.w600))),
            DataColumn(label: Text('Plan', style: TextStyle(fontWeight: FontWeight.w600))),
            DataColumn(label: Text('Monto', style: TextStyle(fontWeight: FontWeight.w600))),
            DataColumn(label: Text('Método', style: TextStyle(fontWeight: FontWeight.w600))),
            DataColumn(label: Text('Estado', style: TextStyle(fontWeight: FontWeight.w600))),
            DataColumn(label: Text('', style: TextStyle(fontWeight: FontWeight.w600))),
          ],
          rows: _filteredTransactions.map((transaction) {
            return DataRow(
              cells: [
                DataCell(
                  Text(
                    transaction.id,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                DataCell(Text(_formatDate(transaction.date))),
                DataCell(Text(transaction.plan)),
                DataCell(
                  Text(
                    '\$${transaction.amount.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                DataCell(Text(transaction.paymentMethod)),
                DataCell(_buildStatusChip(transaction.status)),
                DataCell(
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.filePdf,
                      size: 18,
                      color: AppTheme.primary,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Descargando factura ${transaction.id}'),
                          backgroundColor: AppTheme.primary,
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStatusChip(TransactionStatus status) {
    Color color;
    String text;

    switch (status) {
      case TransactionStatus.paid:
        color = AppTheme.secondary;
        text = 'Pagado';
        break;
      case TransactionStatus.pending:
        color = AppTheme.warning;
        text = 'Pendiente';
        break;
      case TransactionStatus.failed:
        color = AppTheme.error;
        text = 'Fallido';
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
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

enum TransactionStatus { paid, pending, failed }

class MembershipTransaction {
  final String id;
  final DateTime date;
  final double amount;
  final String plan;
  final TransactionStatus status;
  final String paymentMethod;
  final String invoiceUrl;

  MembershipTransaction({
    required this.id,
    required this.date,
    required this.amount,
    required this.plan,
    required this.status,
    required this.paymentMethod,
    required this.invoiceUrl,
  });
}