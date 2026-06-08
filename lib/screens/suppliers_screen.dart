import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/screens/modals/confirmation_modal.dart';
import 'package:pedidos/models/supplier_model.dart';
import 'package:pedidos/screens/supplier_detail_screen.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';
import 'package:pedidos/widgets/custom_chips.dart';
import 'package:pedidos/widgets/custom_text_field.dart';

class SuppliersScreen extends StatefulWidget {
  const SuppliersScreen({super.key});

  @override
  State<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends State<SuppliersScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'Todos';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filters = ['Todos', 'Activos', 'Inactivos', 'Con Deuda'];

  final List<Supplier> _suppliers = [
    Supplier(
      id: 'SUP-001',
      name: 'Agroinsumos S.A.',
      contact: 'Carlos Rodríguez',
      phone: '+52 555 123 4567',
      email: 'ventas@agroinsumos.com',
      address: 'Av. Principal #123, Col. Centro',
      category: 'Insumos Agrícolas',
      outstandingBalance: 12500.00,
      isActive: true,
      paymentDays: 30,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBv_6iZ29fNDT9qzWxDsmKL2dSfXzmNo85liJ-wV1CW46883sjJQuX3X8aGsUhAVXzWS5AYwbj34abpIVpbyp5eCmgHyMy6pBNZE6AQq5GVxBaKg3fCyVan7njjhkxfr--2xeOca6agoJ0C4TZtG5gjs2nOuw0PO1_miNOOt2H6piXw5LcfRZCcZjCAn6LgE2UjCVwBS9q58jPHjko4L9MEZJZLlYpZIbKSpfzomNeKBL-xaV4AAvCxceRExeU_xnc8m0arrCqrhdsX',
    ),
    Supplier(
      id: 'SUP-002',
      name: 'Semillas Premium',
      contact: 'Ana Martínez',
      phone: '+52 555 234 5678',
      email: 'contacto@semillasp.com',
      address: 'Calle de las Flores #45, Col. Jardín',
      category: 'Semillas',
      outstandingBalance: 0.00,
      isActive: true,
      paymentDays: 15,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCuTfLijgdv3y_ASh_ny-oqq0US1GtMSJ-zKJFzFlCLNBQgDfc7Al23Uz7jkounjYEs4fGq-a8KzukkhwYEGF506dmaH6QxMxcJYseBRgPb0R5gGE3oD3yD8iQXmuQXKkjpbj8eN-XpepJELzGQk-DnMtofcq8MWbQa9RzJAwQI8hPIHLafRNyCBCNTeSpMB8OGKQf2XoDBDxqsfoz-mG_tKLanjktsaMpFqq-P8hVbLvjUh2Qt3rLBmHy-CUfKtgRbKhfnBoHpvptR',
    ),
    Supplier(
      id: 'SUP-003',
      name: 'Herramientas Agrícolas',
      contact: 'Roberto Gómez',
      phone: '+52 555 345 6789',
      email: 'ventas@herramientasagr.com',
      address: 'Industrial Sur #789, Parque Industrial',
      category: 'Herramientas',
      outstandingBalance: 3450.00,
      isActive: true,
      paymentDays: 45,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBp8eCTQhRBL6AsodvBFOqfA9p-gQ6g_VUPqMQq9M81mEZV2fvjZuM3Xy1clmeRPCR5hYxswlSkdZtsS2L1n59B3yZOUvcFo8ffBofopRrtkR2Mp8jJHjxETbVtkATqGApiEL3cOgdel1w6_pP9R6bjPZB16x6hY-QEmB23PkhfKQczE_RoY1LdkJQBSA0UtSKnmQ4W3UW2Bxxq-Py5UM1IQobx3mEqH8NGqdjF_9CuirsLfSVYw_X7n8Girn5MUKeQX1IVkqOWuFNa',
    ),
    Supplier(
      id: 'SUP-004',
      name: 'Fertilizantes del Valle',
      contact: 'Laura Fernández',
      phone: '+52 555 456 7890',
      email: 'laura@fertivalle.com',
      address: 'Km 12 Carretera a México',
      category: 'Fertilizantes',
      outstandingBalance: 0.00,
      isActive: false,
      paymentDays: 30,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDOGDZ5MwC5WBi4nK9r4tyMgiqkFY5o7yiJ2fWpZN9kb1k2P1aNFLexio9_F1oIOw4J6AOCPcHP8h907PWMB4bCKWmcm3rWPkDt4kmnpMzs_xGzYlhD2jqiuF8D2XRrjQSaT1z298YvHdiBakdLmXjFy95h6FfB2uEocn1Lo_U3yil93SyWFzkIgl5Evbbec8XiWNDmyKPyhWQ8z7EUGqze6pNI0VcxMseDIqRM_MW42882ywJ_JGwtVenViBMxfb4E3uU-bWAkuST0',
    ),
  ];

  List<Supplier> get _filteredSuppliers {
    List<Supplier> filtered = _suppliers;

    // Aplicar filtro por categoría
    if (_selectedFilter != 'Todos') {
      filtered = filtered.where((supplier) {
        if (_selectedFilter == 'Activos') return supplier.isActive;
        if (_selectedFilter == 'Inactivos') return !supplier.isActive;
        if (_selectedFilter == 'Con Deuda') return supplier.outstandingBalance > 0;
        return true;
      }).toList();
    }

    // Aplicar búsqueda
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((supplier) {
        return supplier.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            supplier.contact.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            supplier.email.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    return filtered;
  }

  void _addSupplier() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SupplierDetailScreen()),
    );
  }

  void _editSupplier(Supplier supplier) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SupplierDetailScreen(supplier: supplier)),
    );
  }

  void _deleteSupplier(Supplier supplier) {
    ConfirmationModal.show(
      context,
      title: 'Eliminar Proveedor',
      message: '¿Estás seguro de que deseas eliminar a "${supplier.name}"?\n\nEsta acción no se puede deshacer.',
      confirmText: 'Eliminar',
      cancelText: 'Cancelar',
      type: ConfirmationType.warning,
      customIcon: FontAwesomeIcons.trashCan,
      onConfirm: () {
        setState(() {
          _suppliers.remove(supplier);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Proveedor ${supplier.name} eliminado'),
            backgroundColor: AppTheme.error,
          ),
        );
      },
    );
  }

  void _showSupplierOptions(Supplier supplier) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.borderRadiusXl)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.penToSquare, size: 20),
              title: const Text('Editar Proveedor'),
              onTap: () {
                Navigator.pop(context);
                _editSupplier(supplier);
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.fileInvoice, size: 20),
              title: const Text('Ver Facturas'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Facturas de ${supplier.name}'),
                    backgroundColor: AppTheme.primary,
                  ),
                );
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.moneyBill, size: 20),
              title: const Text('Registrar Pago'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Registrar pago a ${supplier.name}'),
                    backgroundColor: AppTheme.primary,
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.trashCan, size: 20, color: AppTheme.error),
              title: Text('Eliminar', style: TextStyle(color: AppTheme.error)),
              onTap: () {
                Navigator.pop(context);
                _deleteSupplier(supplier);
              },
            ),
            const SizedBox(height: AppTheme.spacingMd),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: CustomTopAppBar(
        title: 'Proveedores',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingXl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: AppTheme.spacingLg),
                  _buildFilters(),
                  const SizedBox(height: AppTheme.spacingLg),
                  _buildSuppliersList(),
                  const SizedBox(height: AppTheme.spacingXl),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSupplier,
        backgroundColor: AppTheme.loginButtonColor,
        elevation: 4,
        heroTag: 'suppliers_fab',
        shape: const CircleBorder(),
        child: const FaIcon(
          FontAwesomeIcons.plus,
          size: 24,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildSearchBar() {
    return CustomTextField(
      controller: _searchController, // Necesitas crear este controller
      label: '', // Si no quieres label, puedes pasar una cadena vacía
      hint: 'Buscar proveedor por nombre, contacto o email...',
      icon: FontAwesomeIcons.magnifyingGlass,
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      borderRadius: AppTheme.borderRadiusXXl,
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

  Widget _buildSuppliersList() {
    if (_filteredSuppliers.isEmpty) {
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
              FontAwesomeIcons.boxOpen,
              size: 64,
              color: AppTheme.outline.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppTheme.spacingLg),
            Text(
              'No se encontraron proveedores',
              style: TextStyle(
                fontSize: AppTheme.fontSizeBody,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            TextButton(
              onPressed: _addSupplier,
              child: const Text('Agregar proveedor'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        for (var supplier in _filteredSuppliers) ...[
          _buildSupplierCard(supplier),
          const SizedBox(height: AppTheme.spacingLg),
        ],
      ],
    );
  }

  Widget _buildSupplierCard(Supplier supplier) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(
          color: supplier.outstandingBalance > 0
              ? AppTheme.warning.withValues(alpha: 0.5)
              : AppTheme.outlineVariant,
          width: supplier.outstandingBalance > 0 ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con imagen y nombre
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryContainer,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
                    child: Image.network(
                      supplier.imageUrl,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppTheme.primaryContainer,
                          child: const Center(
                            child: FaIcon(
                              FontAwesomeIcons.building,
                              size: 28,
                              color: AppTheme.primary,
                            ),
                          ),
                        );
                      },
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
                              supplier.name,
                              style: TextStyle(
                                fontSize: AppTheme.fontSizeTitle,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.onSurface,
                              ),
                            ),
                          ),
                          if (!supplier.isActive)
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
                                'Inactivo',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.error,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        supplier.category,
                        style: TextStyle(
                          fontSize: AppTheme.fontSizeSmall,
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Botón de menú
                GestureDetector(
                  onTap: () => _showSupplierOptions(supplier),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.surfaceContainer,
                    ),
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.ellipsisVertical,
                        size: 16,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0, color: AppTheme.outlineVariant),
          // Información de contacto
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            child: Column(
              children: [
                _buildContactRow(
                  icon: FontAwesomeIcons.user,
                  text: supplier.contact,
                ),
                const SizedBox(height: AppTheme.spacingMd),
                _buildContactRow(
                  icon: FontAwesomeIcons.phone,
                  text: supplier.phone,
                ),
                const SizedBox(height: AppTheme.spacingMd),
                _buildContactRow(
                  icon: FontAwesomeIcons.envelope,
                  text: supplier.email,
                ),
                const SizedBox(height: AppTheme.spacingMd),
                _buildContactRow(
                  icon: FontAwesomeIcons.locationDot,
                  text: supplier.address,
                ),
              ],
            ),
          ),
          const Divider(height: 0, color: AppTheme.outlineVariant),
          // Footer con deuda y días de pago
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Saldo Pendiente',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeSmall,
                        color: AppTheme.outline,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '\$${supplier.outstandingBalance.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeTitle,
                        fontWeight: FontWeight.w700,
                        color: supplier.outstandingBalance > 0
                            ? AppTheme.error
                            : AppTheme.secondary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingMd,
                    vertical: AppTheme.spacingSm,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryContainer.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                  ),
                  child: Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.calendar,
                        size: 12,
                        color: AppTheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Pago a ${supplier.paymentDays} días',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow({
    required FaIconData icon,
    required String text,
  }) {
    return Row(
      children: [
        FaIcon(
          icon,
          size: 14,
          color: AppTheme.outline,
        ),
        const SizedBox(width: AppTheme.spacingMd),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: AppTheme.fontSizeBody,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}