import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/screens/modals/confirmation_modal.dart';
import 'package:pedidos/screens/add_expense_category_screen.dart';
import 'package:pedidos/models/expense_category_model.dart';
import 'package:pedidos/utils/icon_helper.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';
import 'package:pedidos/widgets/custom_text_field.dart';
import 'package:pedidos/widgets/primary_button.dart';
import 'package:pedidos/widgets/custom_outlined_button.dart';
import 'package:pedidos/core/network/http_client.dart';
import 'package:pedidos/core/network/api_client.dart';
import 'package:pedidos/core/network/exceptions/network_exceptions.dart';

class ExpenseCategoriesScreen extends StatefulWidget {
  const ExpenseCategoriesScreen({super.key});

  @override
  State<ExpenseCategoriesScreen> createState() => _ExpenseCategoriesScreenState();
}

class _ExpenseCategoriesScreenState extends State<ExpenseCategoriesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<ExpenseCategory> _categories = [];
  bool _isLoading = true;
  String? _errorMessage;

  late ApiClient _apiClient;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final httpClient = HttpClient();
      _apiClient = ApiClient(httpClient);
      await _loadCategories();
    } catch (e) {
      print('Error en inicialización: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al cargar las categorías';
      });
    }
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _apiClient.getExpenseCategories();
      print('Respuesta completa: $response');

      List<ExpenseCategory> categories = [];

      if (response is List) {
        categories = response.map((item) => ExpenseCategory.fromJson(item)).toList();
      } else if (response is Map<String, dynamic>) {
        if (response.containsKey('data')) {
          final data = response['data'];
          if (data is List) {
            categories = data.map((item) => ExpenseCategory.fromJson(item)).toList();
          }
        }
      }

      print('Categorías procesadas: ${categories.length}');

      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      print('Error cargando categorías: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = _getErrorMessage(e);
      });
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error is NetworkExceptions) {
      return error.message;
    }
    return 'Error al cargar las categorías';
  }

  List<ExpenseCategory> get _filteredCategories {
    if (_searchQuery.isEmpty) return _categories;
    return _categories.where((category) =>
        category.name.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  Future<void> _addCategory() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddExpenseCategoryScreen()),
    );

    if (result == true) {
      await _loadCategories();
    }
  }

  Future<void> _editCategory(ExpenseCategory category) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddExpenseCategoryScreen(category: category),
      ),
    );

    if (result == true) {
      await _loadCategories();
    }
  }

  Future<void> _deleteCategory(ExpenseCategory category) async {
    await ConfirmationModal.show(
      context,
      title: 'Eliminar Categoría',
      message: '¿Estás seguro de que deseas eliminar la categoría "${category.name}"?\n\nEsta acción no se puede deshacer.',
      confirmText: 'Eliminar',
      cancelText: 'Cancelar',
      type: ConfirmationType.warning,
      customIcon: FontAwesomeIcons.trashCan,
      onConfirm: () async {
        await _executeDeleteCategory(category);
      },
    );
  }

  Future<void> _executeDeleteCategory(ExpenseCategory category) async {
    try {
      setState(() {
        _isLoading = true;
      });

      await _apiClient.deleteExpenseCategory(category.id.toString());

      setState(() {
        _categories.removeWhere((c) => c.id == category.id);
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Categoría "${category.name}" eliminada'),
          backgroundColor: AppTheme.error,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showError('Error al eliminar la categoría');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: CustomTopAppBar(
        title: 'Categorías de gastos',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
        actions: [],
      ),
      body: _buildBody(),
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

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.circleExclamation,
              size: 48,
              color: AppTheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Reintentar',
              icon: FontAwesomeIcons.rotateLeft,
              onPressed: _loadCategories,
              borderRadius: AppTheme.borderRadiusXXl,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingXl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSearchBar(),
                const SizedBox(height: AppTheme.spacingLg),
                _buildCategoriesList(),
                const SizedBox(height: AppTheme.spacingXl),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return CustomTextField(
      controller: _searchController,
      label: '',
      hint: 'Buscar categorías...',
      icon: FontAwesomeIcons.magnifyingGlass,
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      borderRadius: AppTheme.borderRadiusXXl,
    );
  }

  Widget _buildCategoriesList() {
    if (_filteredCategories.isEmpty) {
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
              _searchQuery.isEmpty
                  ? 'No hay categorías configuradas'
                  : 'No se encontraron categorías',
              style: TextStyle(
                fontSize: AppTheme.fontSizeBody,
                color: AppTheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingLg),
            PrimaryButton(
              text: 'Agregar categoría',
              icon: FontAwesomeIcons.plus,
              onPressed: _addCategory,
              borderRadius: AppTheme.borderRadiusXXl,
            ),
          ],
        ),
      );
    }

    return Column(
      children: _filteredCategories.map((category) => Padding(
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
          border: Border.all(color: AppTheme.surfaceContainerHighest),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icono - con el color de la categoría
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: category.color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: category.iconName.toIconOrDefault(size: 20, color: category.color),
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
                      fontWeight: FontWeight.w600,
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
                ],
              ),
            ),
            // Botón de eliminar
            IconButton(
              icon: FaIcon(
                FontAwesomeIcons.trashCan,
                size: 20,
                color: AppTheme.error,
              ),
              onPressed: () => _deleteCategory(category),
              tooltip: 'Eliminar categoría',
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}