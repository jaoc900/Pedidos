import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/screens/modals/confirmation_modal.dart';
import 'package:pedidos/screens/add_expense_category_screen.dart';
import 'package:pedidos/models/expense_category_model.dart';
import 'package:pedidos/utils/icon_helper.dart';

class ExpenseCategoriesScreen extends StatefulWidget {
  const ExpenseCategoriesScreen({super.key});

  @override
  State<ExpenseCategoriesScreen> createState() => _ExpenseCategoriesScreenState();
}

class _ExpenseCategoriesScreenState extends State<ExpenseCategoriesScreen> {
  final List<ExpenseCategory> _categories = [
    ExpenseCategory(
      id: '1',
      name: 'Suministros de Oficina',
      description: 'Papelería y consumibles',
      iconName: 'box',
      color: AppTheme.primary,
      expenseCount: 24,
      totalSpent: 1250.00,
    ),
    ExpenseCategory(
      id: '2',
      name: 'Servicios Públicos',
      description: 'Electricidad, agua e internet',
      iconName: 'lightbulb',
      color: AppTheme.secondary,
      expenseCount: 12,
      totalSpent: 3800.00,
    ),
    ExpenseCategory(
      id: '3',
      name: 'Logística y Transporte',
      description: 'Envíos y combustible',
      iconName: 'truck',
      color: AppTheme.tertiary,
      expenseCount: 18,
      totalSpent: 5200.00,
    ),
    ExpenseCategory(
      id: '4',
      name: 'Mantenimiento',
      description: 'Reparaciones y limpieza',
      iconName: 'wrench',
      color: AppTheme.warning,
      expenseCount: 8,
      totalSpent: 950.00,
    ),
    ExpenseCategory(
      id: '5',
      name: 'Marketing',
      description: 'Publicidad y promociones',
      iconName: 'megaphone',
      color: AppTheme.error,
      expenseCount: 6,
      totalSpent: 2800.00,
    ),
  ];

  void _addCategory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddExpenseCategoryScreen()),
    );
  }

  void _editCategory(ExpenseCategory category) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddExpenseCategoryScreen(category: category)),
    );
  }

  void _deleteCategory(ExpenseCategory category) {
    ConfirmationModal.show(
      context,
      title: 'Eliminar Categoría',
      message: '¿Estás seguro de que deseas eliminar la categoría "${category.name}"?\n\nEsta acción no se puede deshacer.',
      confirmText: 'Eliminar',
      cancelText: 'Cancelar',
      type: ConfirmationType.warning,
      customIcon: FontAwesomeIcons.trashCan,
      onConfirm: () {
        setState(() {
          _categories.remove(category);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Categoría "${category.name}" eliminada'),
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
                  // Visual Accent Card
                  _buildAccentCard(),
                  const SizedBox(height: AppTheme.spacingLg),
                  // Categories List
                  _buildCategoriesList(),
                  const SizedBox(height: AppTheme.spacingLg),
                  // Summary Insight Card
                  _buildSummaryCard(),
                  const SizedBox(height: AppTheme.spacingXl * 2),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCategory,
        backgroundColor: AppTheme.loginButtonColor,
        elevation: 4,
        heroTag: 'expense_category_fab',
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
        color: Colors.white,
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
                  'Categorías de Gastos',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeTitle,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccentCard() {
    return Container(
      width: double.infinity,
      height: 120,
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Administra tus Categorías',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeTitle,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Organiza y optimiza el flujo de tus gastos operativos.',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeBody,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          Positioned(
            right: -30,
            top: -30,
            child: FaIcon(
              FontAwesomeIcons.tags,
              size: 100,
              color: Colors.white.withValues(alpha: 0.15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesList() {
    if (_categories.isEmpty) {
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
              FontAwesomeIcons.tags,
              size: 64,
              color: AppTheme.outline.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppTheme.spacingLg),
            Text(
              'No hay categorías',
              style: TextStyle(
                fontSize: AppTheme.fontSizeBody,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            TextButton(
              onPressed: _addCategory,
              child: const Text('Agregar categoría'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: _categories.map((category) => Padding(
        padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
        child: _buildCategoryCard(category),
      )).toList(),
    );
  }

  Widget _buildCategoryCard(ExpenseCategory category) {
    return GestureDetector(
      onTap: () => _editCategory(category),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppTheme.spacingLg),
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
        child: Row(
          children: [
            // Icono
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: category.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
              ),
              child: Center(
                child: category.iconName.toIconOrDefault(size: 24, color: category.color),
              ),
            ),
            const SizedBox(width: AppTheme.spacingLg),
            // Información
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeBody,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    category.description,
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeSmall,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.receipt,
                        size: 10,
                        color: AppTheme.outline,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${category.expenseCount} gastos',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.outline,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingMd),
                      FaIcon(
                        FontAwesomeIcons.moneyBill,
                        size: 10,
                        color: AppTheme.outline,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '\$${category.totalSpent.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.outline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Menu
            PopupMenuButton<String>(
              icon: FaIcon(
                FontAwesomeIcons.ellipsisVertical,
                size: 20,
                color: AppTheme.outline,
              ),
              onSelected: (value) {
                if (value == 'edit') {
                  _editCategory(category);
                } else if (value == 'delete') {
                  _deleteCategory(category);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      FaIcon(FontAwesomeIcons.pen, size: 16),
                      SizedBox(width: 12),
                      Text('Editar'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      FaIcon(FontAwesomeIcons.trashCan, size: 16, color: AppTheme.error),
                      const SizedBox(width: 12),
                      Text('Eliminar', style: TextStyle(color: AppTheme.error)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    final totalCategories = _categories.length;
    final topCategory = _categories.isNotEmpty
        ? _categories.reduce((a, b) => a.totalSpent > b.totalSpent ? a : b)
        : null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.secondaryFixed.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: AppTheme.secondaryFixed.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Análisis Mensual',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeLabel,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSecondaryContainer,
                ),
              ),
              FaIcon(
                FontAwesomeIcons.chartLine,
                size: 20,
                color: AppTheme.onSecondaryContainer,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(AppTheme.spacingMd),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MAYOR GASTO',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          color: AppTheme.outline,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        topCategory?.name ?? 'N/A',
                        style: TextStyle(
                          fontSize: AppTheme.fontSizeBody,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacingLg),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(AppTheme.spacingMd),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TOTAL CATEGORÍAS',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          color: AppTheme.outline,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${totalCategories} Activas',
                        style: TextStyle(
                          fontSize: AppTheme.fontSizeBody,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

