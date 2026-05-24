import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/screens/modals/confirmation_modal.dart';
import 'package:pedidos/models/employe_model.dart';
import 'package:pedidos/enums/employee_status_enum.dart';
import 'package:pedidos/screens/employee_detail_screen.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'Todos';
  final List<String> _filters = ['Todos', 'Activos', 'Inactivos', 'Administradores'];

  final List<Employee> _employees = [
    Employee(
      id: 'EMP-001',
      name: 'Ana García',
      email: 'ana.garcia@verdant.com',
      phone: '+52 555 123 4567',
      role: 'Administrador',
      department: 'Administración',
      status: EmployeeStatus.active,
      joinDate: DateTime(2024, 1, 15),
      lastActive: DateTime.now().subtract(const Duration(minutes: 5)),
      avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBv_6iZ29fNDT9qzWxDsmKL2dSfXzmNo85liJ-wV1CW46883sjJQuX3X8aGsUhAVXzWS5AYwbj34abpIVpbyp5eCmgHyMy6pBNZE6AQq5GVxBaKg3fCyVan7njjhkxfr--2xeOca6agoJ0C4TZtG5gjs2nOuw0PO1_miNOOt2H6piXw5LcfRZCcZjCAn6LgE2UjCVwBS9q58jPHjko4L9MEZJZLlYpZIbKSpfzomNeKBL-xaV4AAvCxceRExeU_xnc8m0arrCqrhdsX',
    ),
    Employee(
      id: 'EMP-002',
      name: 'Carlos Mendoza',
      email: 'carlos.mendoza@verdant.com',
      phone: '+52 555 234 5678',
      role: 'Vendedor',
      department: 'Ventas',
      status: EmployeeStatus.active,
      joinDate: DateTime(2024, 2, 10),
      lastActive: DateTime.now().subtract(const Duration(hours: 2)),
      avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBv_6iZ29fNDT9qzWxDsmKL2dSfXzmNo85liJ-wV1CW46883sjJQuX3X8aGsUhAVXzWS5AYwbj34abpIVpbyp5eCmgHyMy6pBNZE6AQq5GVxBaKg3fCyVan7njjhkxfr--2xeOca6agoJ0C4TZtG5gjs2nOuw0PO1_miNOOt2H6piXw5LcfRZCcZjCAn6LgE2UjCVwBS9q58jPHjko4L9MEZJZLlYpZIbKSpfzomNeKBL-xaV4AAvCxceRExeU_xnc8m0arrCqrhdsX',
    ),
    Employee(
      id: 'EMP-003',
      name: 'Laura Fernández',
      email: 'laura.fernandez@verdant.com',
      phone: '+52 555 345 6789',
      role: 'Almacenista',
      department: 'Logística',
      status: EmployeeStatus.active,
      joinDate: DateTime(2024, 3, 5),
      lastActive: DateTime.now().subtract(const Duration(days: 1)),
      avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBv_6iZ29fNDT9qzWxDsmKL2dSfXzmNo85liJ-wV1CW46883sjJQuX3X8aGsUhAVXzWS5AYwbj34abpIVpbyp5eCmgHyMy6pBNZE6AQq5GVxBaKg3fCyVan7njjhkxfr--2xeOca6agoJ0C4TZtG5gjs2nOuw0PO1_miNOOt2H6piXw5LcfRZCcZjCAn6LgE2UjCVwBS9q58jPHjko4L9MEZJZLlYpZIbKSpfzomNeKBL-xaV4AAvCxceRExeU_xnc8m0arrCqrhdsX',
    ),
    Employee(
      id: 'EMP-004',
      name: 'Roberto Gómez',
      email: 'roberto.gomez@verdant.com',
      phone: '+52 555 456 7890',
      role: 'Contador',
      department: 'Finanzas',
      status: EmployeeStatus.inactive,
      joinDate: DateTime(2024, 1, 20),
      lastActive: DateTime.now().subtract(const Duration(days: 15)),
      avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBv_6iZ29fNDT9qzWxDsmKL2dSfXzmNo85liJ-wV1CW46883sjJQuX3X8aGsUhAVXzWS5AYwbj34abpIVpbyp5eCmgHyMy6pBNZE6AQq5GVxBaKg3fCyVan7njjhkxfr--2xeOca6agoJ0C4TZtG5gjs2nOuw0PO1_miNOOt2H6piXw5LcfRZCcZjCAn6LgE2UjCVwBS9q58jPHjko4L9MEZJZLlYpZIbKSpfzomNeKBL-xaV4AAvCxceRExeU_xnc8m0arrCqrhdsX',
    ),
  ];

  List<Employee> get _filteredEmployees {
    List<Employee> filtered = _employees;

    switch (_selectedFilter) {
      case 'Activos':
        filtered = filtered.where((e) => e.status == EmployeeStatus.active).toList();
        break;
      case 'Inactivos':
        filtered = filtered.where((e) => e.status == EmployeeStatus.inactive).toList();
        break;
      case 'Administradores':
        filtered = filtered.where((e) => e.role == 'Administrador').toList();
        break;
      default:
        break;
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((e) =>
      e.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          e.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          e.role.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    return filtered;
  }

  void _addEmployee() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EmployeeDetailScreen()),
    );
  }

  void _editEmployee(Employee employee) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EmployeeDetailScreen(employee: employee)),
    );
  }

  void _deactivateEmployee(Employee employee) {
    ConfirmationModal.show(
      context,
      title: 'Desactivar empleado',
      message: '¿Estás seguro de que deseas desactivar a "${employee.name}"?\n\nNo podrá acceder a la plataforma.',
      confirmText: 'Desactivar',
      cancelText: 'Cancelar',
      type: ConfirmationType.warning,
      customIcon: FontAwesomeIcons.userSlash,
      onConfirm: () {
        setState(() {
          employee.status = EmployeeStatus.inactive;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${employee.name} ha sido desactivado'),
            backgroundColor: AppTheme.warning,
          ),
        );
      },
    );
  }

  void _activateEmployee(Employee employee) {
    setState(() {
      employee.status = EmployeeStatus.active;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${employee.name} ha sido activado'),
        backgroundColor: AppTheme.primary,
      ),
    );
  }

  void _deleteEmployee(Employee employee) {
    ConfirmationModal.show(
      context,
      title: 'Eliminar empleado',
      message: '¿Estás seguro de que deseas eliminar a "${employee.name}"?\n\nEsta acción no se puede deshacer.',
      confirmText: 'Eliminar',
      cancelText: 'Cancelar',
      type: ConfirmationType.warning,
      customIcon: FontAwesomeIcons.trashCan,
      onConfirm: () {
        setState(() {
          _employees.remove(employee);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${employee.name} ha sido eliminado'),
            backgroundColor: AppTheme.error,
          ),
        );
      },
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
                  // Resumen de empleados
                  _buildSummaryCards(),
                  const SizedBox(height: AppTheme.spacingLg),
                  // Búsqueda y filtros
                  _buildSearchAndFilters(),
                  const SizedBox(height: AppTheme.spacingLg),
                  // Lista de empleados
                  _buildEmployeesList(),
                  const SizedBox(height: AppTheme.spacingXl),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEmployee,
        backgroundColor: AppTheme.primary,
        heroTag: 'employees_fab',
        shape: const CircleBorder(),
        child: const FaIcon(FontAwesomeIcons.plus, size: 24, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXl, vertical: AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.background,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
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
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: const Center(child: FaIcon(FontAwesomeIcons.arrowLeft, size: 20, color: AppTheme.primary)),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingLg),
                Text('Empleados', style: TextStyle(fontSize: AppTheme.fontSizeTitle, fontWeight: FontWeight.w700, color: AppTheme.primary)),
              ],
            ),
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: IconButton(
                icon: FaIcon(FontAwesomeIcons.fileExport, size: 20, color: AppTheme.primary),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    final activeCount = _employees.where((e) => e.status == EmployeeStatus.active).length;
    final inactiveCount = _employees.where((e) => e.status == EmployeeStatus.inactive).length;
    final adminCount = _employees.where((e) => e.role == 'Administrador').length;

    return Row(
      children: [
        Expanded(child: _buildSummaryCard(title: 'Activos', value: activeCount.toString(), color: AppTheme.secondary, icon: FontAwesomeIcons.userCheck)),
        const SizedBox(width: AppTheme.spacingLg),
        Expanded(child: _buildSummaryCard(title: 'Inactivos', value: inactiveCount.toString(), color: AppTheme.warning, icon: FontAwesomeIcons.userSlash)),
        const SizedBox(width: AppTheme.spacingLg),
        Expanded(child: _buildSummaryCard(title: 'Administradores', value: adminCount.toString(), color: AppTheme.primary, icon: FontAwesomeIcons.userGear)),
      ],
    );
  }

  Widget _buildSummaryCard({required String title, required String value, required Color color, required FaIconData icon}) {
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
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppTheme.onSurface)),
          Text(title, style: TextStyle(fontSize: 10, color: AppTheme.onSurfaceVariant), textAlign: TextAlign.center),
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
              hintText: 'Buscar por nombre, email o rol...',
              hintStyle: TextStyle(color: AppTheme.outline),
              prefixIcon: Padding(padding: const EdgeInsets.all(AppTheme.spacingMd), child: FaIcon(FontAwesomeIcons.magnifyingGlass, size: 20, color: AppTheme.outline)),
              suffixIcon: _searchQuery.isNotEmpty ? IconButton(icon: FaIcon(FontAwesomeIcons.times, size: 16, color: AppTheme.outline), onPressed: () => setState(() => _searchQuery = '')) : null,
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
                  child: Center(child: Text(filter, style: TextStyle(fontSize: AppTheme.fontSizeLabel, fontWeight: FontWeight.w600, color: isSelected ? AppTheme.onPrimary : AppTheme.onSurfaceVariant))),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmployeesList() {
    if (_filteredEmployees.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        decoration: BoxDecoration(color: AppTheme.surfaceContainerLowest, borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl), border: Border.all(color: AppTheme.outlineVariant)),
        child: Column(children: [
          FaIcon(FontAwesomeIcons.users, size: 64, color: AppTheme.outline.withValues(alpha: 0.5)),
          const SizedBox(height: AppTheme.spacingLg),
          Text('No se encontraron empleados', style: TextStyle(fontSize: AppTheme.fontSizeBody, color: AppTheme.onSurfaceVariant)),
        ]),
      );
    }

    return Column(children: _filteredEmployees.map((e) => Padding(padding: const EdgeInsets.only(bottom: AppTheme.spacingLg), child: _buildEmployeeCard(e))).toList());
  }

  Widget _buildEmployeeCard(Employee employee) {
    final isActive = employee.status == EmployeeStatus.active;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: isActive ? AppTheme.outlineVariant : AppTheme.errorContainer),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppTheme.primary, width: 2)),
                  child: ClipOval(
                    child: Image.network(employee.avatarUrl, width: 56, height: 56, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: AppTheme.primaryContainer, child: const Center(child: FaIcon(FontAwesomeIcons.user, size: 28, color: Colors.white)))),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingLg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(child: Text(employee.name, style: TextStyle(fontSize: AppTheme.fontSizeTitle, fontWeight: FontWeight.w700, color: AppTheme.onSurface))),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingSm, vertical: 4),
                          decoration: BoxDecoration(color: isActive ? AppTheme.secondaryContainer : AppTheme.errorContainer, borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull)),
                          child: Text(isActive ? 'Activo' : 'Inactivo', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: isActive ? AppTheme.secondary : AppTheme.error)),
                        ),
                      ]),
                      const SizedBox(height: 4),
                      Text(employee.role, style: TextStyle(fontSize: AppTheme.fontSizeSmall, color: AppTheme.primary, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                PopupMenuButton(
                  icon: FaIcon(FontAwesomeIcons.ellipsisVertical, size: 20, color: AppTheme.outline),
                  itemBuilder: (context) => [
                    PopupMenuItem(child: ListTile(leading: FaIcon(FontAwesomeIcons.pen, size: 16), title: const Text('Editar'), onTap: () => _editEmployee(employee))),
                    if (isActive) PopupMenuItem(child: ListTile(leading: FaIcon(FontAwesomeIcons.userSlash, size: 16, color: AppTheme.warning), title: Text('Desactivar', style: TextStyle(color: AppTheme.warning)), onTap: () => _deactivateEmployee(employee))),
                    if (!isActive) PopupMenuItem(child: ListTile(leading: FaIcon(FontAwesomeIcons.userCheck, size: 16, color: AppTheme.secondary), title: Text('Activar', style: TextStyle(color: AppTheme.secondary)), onTap: () => _activateEmployee(employee))),
                    PopupMenuItem(child: ListTile(leading: FaIcon(FontAwesomeIcons.trashCan, size: 16, color: AppTheme.error), title: Text('Eliminar', style: TextStyle(color: AppTheme.error)), onTap: () => _deleteEmployee(employee))),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            const Divider(),
            const SizedBox(height: AppTheme.spacingMd),
            Row(children: [
              FaIcon(FontAwesomeIcons.envelope, size: 14, color: AppTheme.outline), const SizedBox(width: 8), Expanded(child: Text(employee.email, style: TextStyle(fontSize: AppTheme.fontSizeSmall, color: AppTheme.onSurfaceVariant))),
            ]),
            const SizedBox(height: AppTheme.spacingSm),
            Row(children: [
              FaIcon(FontAwesomeIcons.phone, size: 14, color: AppTheme.outline), const SizedBox(width: 8), Expanded(child: Text(employee.phone, style: TextStyle(fontSize: AppTheme.fontSizeSmall, color: AppTheme.onSurfaceVariant))),
            ]),
            const SizedBox(height: AppTheme.spacingSm),
            Row(children: [
              FaIcon(FontAwesomeIcons.building, size: 14, color: AppTheme.outline), const SizedBox(width: 8), Expanded(child: Text(employee.department, style: TextStyle(fontSize: AppTheme.fontSizeSmall, color: AppTheme.onSurfaceVariant))),
            ]),
          ],
        ),
      ),
    );
  }
}
