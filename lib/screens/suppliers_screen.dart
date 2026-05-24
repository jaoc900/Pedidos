import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/screens/modals/confirmation_modal.dart';

class SuppliersScreen extends StatefulWidget {
  const SuppliersScreen({super.key});

  @override
  State<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends State<SuppliersScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'Todos';

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
      body: Column(
        children: [
          _buildTopAppBar(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingXl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchAndFilters(),
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
                  'Proveedores',
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
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.primary, width: 2),
              ),
              child: ClipOval(
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuBv_6iZ29fNDT9qzWxDsmKL2dSfXzmNo85liJ-wV1CW46883sjJQuX3X8aGsUhAVXzWS5AYwbj34abpIVpbyp5eCmgHyMy6pBNZE6AQq5GVxBaKg3fCyVan7njjhkxfr--2xeOca6agoJ0C4TZtG5gjs2nOuw0PO1_miNOOt2H6piXw5LcfRZCcZjCAn6LgE2UjCVwBS9q58jPHjko4L9MEZJZLlYpZIbKSpfzomNeKBL-xaV4AAvCxceRExeU_xnc8m0arrCqrhdsX',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppTheme.primaryContainer,
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.user,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
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
              hintText: 'Buscar proveedor por nombre, contacto o email...',
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
        // Filtros horizontales
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

// Pantalla de detalle del proveedor
class SupplierDetailScreen extends StatefulWidget {
  final Supplier? supplier;

  const SupplierDetailScreen({super.key, this.supplier});

  @override
  State<SupplierDetailScreen> createState() => _SupplierDetailScreenState();
}

class _SupplierDetailScreenState extends State<SupplierDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _contactController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _categoryController;
  late TextEditingController _paymentDaysController;

  bool _isActive = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.supplier?.name ?? '');
    _contactController = TextEditingController(text: widget.supplier?.contact ?? '');
    _phoneController = TextEditingController(text: widget.supplier?.phone ?? '');
    _emailController = TextEditingController(text: widget.supplier?.email ?? '');
    _addressController = TextEditingController(text: widget.supplier?.address ?? '');
    _categoryController = TextEditingController(text: widget.supplier?.category ?? '');
    _paymentDaysController = TextEditingController(
      text: widget.supplier?.paymentDays.toString() ?? '30',
    );
    _isActive = widget.supplier?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _categoryController.dispose();
    _paymentDaysController.dispose();
    super.dispose();
  }

  void _saveSupplier() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.supplier == null
                ? 'Proveedor creado exitosamente'
                : 'Proveedor actualizado exitosamente',
          ),
          backgroundColor: AppTheme.primary,
        ),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft, color: AppTheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.supplier == null ? 'Nuevo Proveedor' : 'Editar Proveedor',
          style: const TextStyle(
            fontSize: AppTheme.fontSizeTitle,
            fontWeight: FontWeight.w700,
            color: AppTheme.primary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveSupplier,
            child: _isLoading
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
              ),
            )
                : const Text(
              'Guardar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.primary,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                controller: _nameController,
                label: 'Nombre del Proveedor',
                hint: 'Ej. Agroinsumos S.A.',
                icon: FontAwesomeIcons.building,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppTheme.spacingLg),
              _buildTextField(
                controller: _contactController,
                label: 'Persona de Contacto',
                hint: 'Ej. Juan Pérez',
                icon: FontAwesomeIcons.user,
              ),
              const SizedBox(height: AppTheme.spacingLg),
              _buildTextField(
                controller: _phoneController,
                label: 'Teléfono',
                hint: '+52 555 123 4567',
                icon: FontAwesomeIcons.phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: AppTheme.spacingLg),
              _buildTextField(
                controller: _emailController,
                label: 'Correo Electrónico',
                hint: 'ventas@proveedor.com',
                icon: FontAwesomeIcons.envelope,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final emailRegex = RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    );
                    if (!emailRegex.hasMatch(value)) {
                      return 'Ingresa un correo válido';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppTheme.spacingLg),
              _buildTextField(
                controller: _addressController,
                label: 'Dirección',
                hint: 'Calle, Número, Ciudad...',
                icon: FontAwesomeIcons.locationDot,
                maxLines: 2,
              ),
              const SizedBox(height: AppTheme.spacingLg),
              _buildTextField(
                controller: _categoryController,
                label: 'Categoría',
                hint: 'Ej. Insumos, Herramientas, Semillas',
                icon: FontAwesomeIcons.tag,
              ),
              const SizedBox(height: AppTheme.spacingLg),
              _buildTextField(
                controller: _paymentDaysController,
                label: 'Días de Pago',
                hint: '30',
                icon: FontAwesomeIcons.calendar,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppTheme.spacingLg),
              SwitchListTile(
                title: const Text('Proveedor Activo'),
                subtitle: const Text('Permite realizar compras a este proveedor'),
                value: _isActive,
                onChanged: (value) {
                  setState(() {
                    _isActive = value;
                  });
                },
                activeColor: AppTheme.primary,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: AppTheme.spacingXl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required FaIconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FaIcon(
              icon,
              size: 14,
              color: AppTheme.primary,
            ),
            const SizedBox(width: AppTheme.spacingSm),
            Text(
              label,
              style: TextStyle(
                fontSize: AppTheme.fontSizeLabel,
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingSm),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppTheme.outlineVariant,
              fontSize: AppTheme.fontSizeBody,
            ),
            filled: true,
            fillColor: Colors.white,
            border: _buildInputBorder(),
            enabledBorder: _buildInputBorder(),
            focusedBorder: _buildFocusedBorder(),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingLg,
              vertical: AppTheme.spacingLg,
            ),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _buildInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
      borderSide: BorderSide(color: AppTheme.outlineVariant, width: 1),
    );
  }

  OutlineInputBorder _buildFocusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
      borderSide: const BorderSide(color: AppTheme.primary, width: 2),
    );
  }
}

// Modelo de datos del proveedor
class Supplier {
  final String id;
  final String name;
  final String contact;
  final String phone;
  final String email;
  final String address;
  final String category;
  final double outstandingBalance;
  final bool isActive;
  final int paymentDays;
  final String imageUrl;

  Supplier({
    required this.id,
    required this.name,
    required this.contact,
    required this.phone,
    required this.email,
    required this.address,
    required this.category,
    required this.outstandingBalance,
    required this.isActive,
    required this.paymentDays,
    required this.imageUrl,
  });
}