import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/screens/modals/confirmation_modal.dart';
import 'package:pedidos/screens/customer_detail_screen.dart';
import 'package:pedidos/models/customer_model.dart';
import 'package:pedidos/enums/customer_type_enum.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';
import 'package:pedidos/widgets/custom_text_field.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<Customer> _customers = [
    Customer(
      id: '1',
      name: 'Eleanor Thorne',
      email: 'eleanor.t@domain.com',
      phone: '+1 (555) 234-8901',
      address: '822 Oakwood Dr, Seattle, WA',
      type: CustomerType.vip,
      isActive: true,
    ),
    Customer(
      id: '2',
      name: 'Marcus Aris',
      email: 'marcus.a@business.co',
      phone: '+1 (555) 890-1122',
      address: '441 Pinecrest St, Portland, OR',
      type: CustomerType.newLead,
      isActive: true,
    ),
    Customer(
      id: '3',
      name: 'Julianne Webb',
      email: 'j.webb@webmail.org',
      phone: '+1 (555) 341-6782',
      address: '12 North Ave, Vancouver, BC',
      type: CustomerType.archived,
      isActive: false,
    ),
  ];

  List<Customer> get _filteredCustomers {
    if (_searchQuery.isEmpty) {
      return _customers;
    }
    return _customers.where((customer) {
      return customer.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          customer.email.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  void _deleteCustomer(Customer customer) {
    ConfirmationModal.show(
      context,
      title: 'Eliminar Cliente',
      message: '¿Estás seguro de que deseas eliminar a "${customer
          .name}"?\n\nEsta acción no se puede deshacer.',
      confirmText: 'Eliminar',
      cancelText: 'Cancelar',
      type: ConfirmationType.warning,
      customIcon: FontAwesomeIcons.userMinus,
      onConfirm: () {
        setState(() {
          _customers.remove(customer);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cliente ${customer.name} eliminado'),
            backgroundColor: AppTheme.error,
          ),
        );
      },
    );
  }

  void _showCustomerOptions(Customer customer) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppTheme.borderRadiusXl)),
      ),
      builder: (context) =>
          SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.penToSquare, size: 20),
                  title: const Text('Editar Cliente'),
                  onTap: () {
                    Navigator.pop(context);
                    _editCustomer(customer);
                  },
                ),
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.message, size: 20),
                  title: const Text('Enviar Mensaje'),
                  onTap: () {
                    Navigator.pop(context);
                    _sendMessage(customer);
                  },
                ),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.trashCan, size: 20,
                      color: AppTheme.error),
                  title: Text(
                      'Eliminar', style: TextStyle(color: AppTheme.error)),
                  onTap: () {
                    Navigator.pop(context);
                    _deleteCustomer(customer);
                  },
                ),
                const SizedBox(height: AppTheme.spacingMd),
              ],
            ),
          ),
    );
  }

  void _editCustomer(Customer customer) {
    // Aquí iría la navegación a la pantalla de edición
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerDetailScreen(customer: customer),
      ),
    );
  }

  void _sendMessage(Customer customer) {
    // Aquí iría la lógica para enviar mensaje
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Enviar mensaje a: ${customer.name}'),
        backgroundColor: AppTheme.primary,
      ),
    );
  }

  void _addNewCustomer() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CustomerDetailScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.background,
        body: Stack(
          children: [
            Column(
              children: [
                // TopAppBar
                _buildTopAppBar(),
                // Contenido principal
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppTheme.spacingXl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search & Filter Bar
                        _buildSearchBar(),
                        const SizedBox(height: AppTheme.spacingLg),
                        // Customer List
                        _buildCustomerList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _addNewCustomer();
          },
          backgroundColor: AppTheme.loginButtonColor,
          elevation: 4,
          shape: const CircleBorder(),
          heroTag: 'new_customer_fab',
          child: const FaIcon(
            FontAwesomeIcons.plus,
            size: 24,
            color: Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildTopAppBar() {
    return CustomTopAppBar(
      title: 'Clientes',
      showBackButton: false,
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        // Campo de búsqueda
        Expanded(
          child: CustomTextField(
            controller: _searchController,
            label: '',
            hint: 'Buscar por nombre o email...',
            icon: FontAwesomeIcons.magnifyingGlass,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            borderRadius: AppTheme.borderRadiusXXl,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerList() {
    if (_filteredCustomers.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        for (var customer in _filteredCustomers) ...[
          _buildCustomerCard(customer),
          const SizedBox(height: AppTheme.spacingLg),
        ],
      ],
    );
  }

  Widget _buildCustomerCard(Customer customer) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingXl),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar, nombre y badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getAvatarColor(customer.type),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: FaIcon(
                    FontAwesomeIcons.user,
                    size: 24,
                    color: _getAvatarIconColor(customer.type),
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacingLg),
              // Nombre y badge
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name,
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeTitle,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingSm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getBadgeColor(customer.type).withValues(
                            alpha: 0.2),
                        borderRadius: BorderRadius.circular(
                            AppTheme.borderRadiusFull),
                      ),
                      child: Text(
                        _getBadgeText(customer.type),
                        style: TextStyle(
                          fontSize: AppTheme.fontSizeSmall,
                          fontWeight: FontWeight.w500,
                          color: _getBadgeColor(customer.type),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Menu button
              GestureDetector(
                onTap: () => _showCustomerOptions(customer),
                child: Container(
                  padding: const EdgeInsets.all(AppTheme.spacingSm),
                  child: FaIcon(
                    FontAwesomeIcons.ellipsisVertical,
                    size: 20,
                    color: AppTheme.outline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          // Información de contacto
          Column(
            children: [
              _buildContactInfo(
                icon: FontAwesomeIcons.phone,
                text: customer.phone,
              ),
              const SizedBox(height: AppTheme.spacingMd),
              _buildContactInfo(
                icon: FontAwesomeIcons.envelope,
                text: customer.email,
              ),
              const SizedBox(height: AppTheme.spacingMd),
              _buildContactInfo(
                icon: FontAwesomeIcons.locationDot,
                text: customer.address,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo({
    required FaIconData icon,
    required String text,
  }) {
    return Row(
      children: [
        FaIcon(
          icon,
          size: 16,
          color: AppTheme.onSurfaceVariant,
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

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.only(top: AppTheme.spacingXxl),
      child: Column(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainer,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.userPlus,
                size: 40,
                color: AppTheme.outline,
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Text(
            'Grow your network',
            style: TextStyle(
              fontSize: AppTheme.fontSizeTitle,
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurface,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            'Keep track of all your professional\nrelationships in one place.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppTheme.fontSizeBody,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required FaIconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary.withValues(alpha: 0.1) : Colors
              .transparent,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              icon,
              size: 22,
              color: isSelected ? AppTheme.loginButtonColor : Colors.grey
                  .shade500,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppTheme.loginButtonColor : Colors.grey
                    .shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  Color _getAvatarColor(CustomerType type) {
    switch (type) {
      case CustomerType.vip:
        return AppTheme.secondaryContainer;
      case CustomerType.newLead:
        return AppTheme.primaryFixed;
      case CustomerType.archived:
        return AppTheme.surfaceVariant;
    }
  }

  Color _getAvatarIconColor(CustomerType type) {
    switch (type) {
      case CustomerType.vip:
        return AppTheme.onSecondaryContainer;
      case CustomerType.newLead:
        return AppTheme.onPrimaryFixed;
      case CustomerType.archived:
        return AppTheme.onSurfaceVariant;
    }
  }

  String _getBadgeText(CustomerType type) {
    switch (type) {
      case CustomerType.vip:
        return 'VIP Member';
      case CustomerType.newLead:
        return 'New Lead';
      case CustomerType.archived:
        return 'Archived';
    }
  }

  Color _getBadgeColor(CustomerType type) {
    switch (type) {
      case CustomerType.vip:
        return AppTheme.tertiary;
      case CustomerType.newLead:
        return AppTheme.onSecondaryFixedVariant;
      case CustomerType.archived:
        return AppTheme.outline;
    }
  }
}

