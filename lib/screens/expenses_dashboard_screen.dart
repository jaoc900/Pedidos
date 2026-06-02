import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/models/category_data_model.dart';
import 'package:pedidos/models/expense_data_model.dart';
import 'package:pedidos/screens/painters/donut_chart_painter.dart';
import 'package:pedidos/enums/chart_type_model.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';

class ExpensesDashboardScreen extends StatefulWidget {
  const ExpensesDashboardScreen({super.key});

  @override
  State<ExpensesDashboardScreen> createState() => _ExpensesDashboardScreenState();
}

class _ExpensesDashboardScreenState extends State<ExpensesDashboardScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // TopAppBar
          _buildTopAppBar(context),
          // Contenido principal
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingXl),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Section: Summary Card
                      _buildSummaryCard(),
                      const SizedBox(height: AppTheme.spacingXl),
                      // Middle Section: Visual Chart (Bento Layout)
                      _buildChartSection(),
                      const SizedBox(height: AppTheme.spacingXl),
                      // Bottom Section: Largest Expenses
                      _buildLargestExpensesSection(),
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
    return CustomTopAppBar(
      title: 'Gastos',
      showBackButton: true,
      onBackPressed: () => Navigator.pop(context),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 600;

          if (isDesktop) {
            return Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total del Mes',
                        style: TextStyle(
                          fontSize: AppTheme.fontSizeLabel,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '\$12,450.00',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.onSurface,
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingSm),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacingSm,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                            ),
                            child: Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.arrowUp,
                                  size: 12,
                                  color: AppTheme.primary,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '+5.2%',
                                  style: TextStyle(
                                    fontSize: AppTheme.fontSizeSmall,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Respecto al mes anterior (\$11,830.00)',
                        style: TextStyle(
                          fontSize: AppTheme.fontSizeBody,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
                      child: Stack(
                        children: [
                          Image.network(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuAMFJQl0sVr4EnoTbhJWpx881-A2uOTNcbwRpwL3zQqSiwVpekmp3I-TfF80jD0Jm_viYY5G2xx3lzkw3Go1ayVJKmdobzpEsweSkGPzi_Hpw9ZbJMWiUeM_U3bxLXmtRnE5q335LLW8qLxBRs7wG-OYwsGmHITyxd5V3Bg8-ySEngQNfDjxYgN1lQq_rIS_DF5J4rzCFXdzuItKqU_TVClamVV9tLXT705l-9fLS49bO-5AVW2OOFBOM6VQjVqqrnp8N0uah9ZG5FV',
                            width: double.infinity,
                            height: 100,
                            fit: BoxFit.cover,
                            opacity: const AlwaysStoppedAnimation(0.2),
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 100,
                                color: AppTheme.surfaceContainer,
                              );
                            },
                          ),
                          Center(
                            child: Text(
                              'Resumen Financiero',
                              style: TextStyle(
                                fontSize: AppTheme.fontSizeTitle,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primary.withValues(alpha: 0.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total del Mes',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeLabel,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '\$12,450.00',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.onSurface,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingSm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingSm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                      ),
                      child: Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.arrowUp,
                            size: 12,
                            color: AppTheme.primary,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '+5.2%',
                            style: TextStyle(
                              fontSize: AppTheme.fontSizeSmall,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Respecto al mes anterior (\$11,830.00)',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeBody,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildChartSection() {
    final categories = [
      CategoryData(name: 'Logística', amount: 4357.50, percentage: 35, color: const Color(0xFF289045)),
      CategoryData(name: 'Marketing', amount: 3112.50, percentage: 25, color: const Color(0xFF1B5E20)),
      CategoryData(name: 'Servicios Públicos', amount: 3112.50, percentage: 25, color: const Color(0xFFA3E14C)),
      CategoryData(name: 'Suministros', amount: 1867.50, percentage: 15, color: const Color(0xFFBECABB)),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 600;

        if (isDesktop) {
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Main Chart Card
                Expanded(
                  flex: 8,
                  child: Container(
                    padding: const EdgeInsets.all(AppTheme.spacingLg),
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Distribución por Categoría',
                                style: TextStyle(
                                  fontSize: AppTheme.fontSizeTitle,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: AppTheme.spacingLg),
                              ...categories.map((category) => Padding(
                                padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
                                child: _buildCategoryItem(category),
                              )),
                            ],
                          ),
                        ),
                        Expanded(
                          child: _buildDonutChart(categories),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingLg),
                // Side Card: Insights
                Expanded(
                  flex: 4,
                  child: _buildInsightsCard(),
                ),
              ],
            ),
          );
        } else {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingLg),
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
                child: Column(
                  children: [
                    Text(
                      'Distribución por Categoría',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeTitle,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingLg),
                    _buildDonutChart(categories),
                    const SizedBox(height: AppTheme.spacingLg),
                    ...categories.map((category) => Padding(
                      padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
                      child: _buildCategoryItem(category),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingLg),
              _buildInsightsCard(),
            ],
          );
        }
      },
    );
  }

  Widget _buildCategoryItem(CategoryData category) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingSm),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: category.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppTheme.spacingSm),
              Text(
                category.name,
                style: TextStyle(
                  fontSize: AppTheme.fontSizeLabel,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.onSurface,
                ),
              ),
            ],
          ),
          Text(
            '\$(${category.percentage}%)',
            style: TextStyle(
              fontSize: AppTheme.fontSizeLabel,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonutChart(List<CategoryData> categories) {
    // Construir el gradiente cónico para el donut
    return Center(
      child: SizedBox(
        width: 200,
        height: 200,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Donut chart usando CustomPaint
            CustomPaint(
              size: const Size(200, 200),
              painter: DonutChartPainter(
                percentages: [70, 20, 10],  // Lista de porcentajes
                colors: [AppTheme.primary, AppTheme.secondary, AppTheme.error], // Lista de colores
                chartType: ChartType.donut,
                strokeWidth: 12,
              ),
            ),
            // Centro del donut
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Categoría Top',
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeSmall,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Logística',
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeTitle,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
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

  Widget _buildInsightsCard() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.loginButtonColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        boxShadow: [
          BoxShadow(
            color: AppTheme.loginButtonColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Meta de Ahorro',
            style: TextStyle(
              fontSize: AppTheme.fontSizeTitle,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            'Has utilizado el 62% del presupuesto asignado para este trimestre.',
            style: TextStyle(
              fontSize: AppTheme.fontSizeBody,
              color: AppTheme.primaryFixed.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
            child: LinearProgressIndicator(
              value: 0.62,
              backgroundColor: AppTheme.onPrimaryFixedVariant,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.tertiaryFixed),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$12,450',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeSmall,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              Text(
                '\$20,000',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeSmall,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingXl),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.tertiaryFixed,
                foregroundColor: AppTheme.onTertiaryFixed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
                ),
                padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingLg),
              ),
              child: const Text('Ver Reporte Detallado'),
            ),
          ),
        ],
      ),
    );
  }

  // Tabla de Gastos Mayores
  Widget _buildLargestExpensesSection() {
    final expenses = [
      ExpenseData(
        title: 'Envío Continental Logística',
        category: 'Logística',
        date: '12 Oct 2023',
        amount: 2450.00,
        icon: FontAwesomeIcons.truck,
      ),
      ExpenseData(
        title: 'Campaña Digital Q4',
        category: 'Marketing',
        date: '08 Oct 2023',
        amount: 1800.00,
        icon: FontAwesomeIcons.bullhorn,
      ),
      ExpenseData(
        title: 'Suministro Eléctrico Planta 2',
        category: 'Servicios',
        date: '05 Oct 2023',
        amount: 1200.00,
        icon: FontAwesomeIcons.bolt,
      ),
      ExpenseData(
        title: 'Renovación Hardware Oficina',
        category: 'Suministros',
        date: '02 Oct 2023',
        amount: 950.00,
        icon: FontAwesomeIcons.desktop,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título y botón
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Gastos Mayores',
              style: TextStyle(
                fontSize: AppTheme.fontSizeHeadline,
                fontWeight: FontWeight.w700,
                color: AppTheme.onSurface,
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primary,
              ),
              child: const Row(
                children: [
                  Text('Ver todos'),
                  SizedBox(width: 4),
                  FaIcon(FontAwesomeIcons.chevronRight, size: 14),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingLg),

        // Tabla responsiva que ocupa todo el ancho
        LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = constraints.maxWidth < 600;

            if (isSmallScreen) {
              // Vista de tarjetas para móvil
              return Column(
                children: expenses.map((expense) => Container(
                  margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
                  padding: const EdgeInsets.all(AppTheme.spacingLg),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceContainer,
                              borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
                            ),
                            child: Center(
                              child: FaIcon(
                                expense.icon,
                                size: 20,
                                color: AppTheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingMd),
                          Expanded(
                            child: Text(
                              expense.title,
                              style: TextStyle(
                                fontSize: AppTheme.fontSizeBody,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingMd),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacingSm,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                            ),
                            child: Text(
                              expense.category,
                              style: TextStyle(
                                fontSize: AppTheme.fontSizeSmall,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.onSecondaryContainer,
                              ),
                            ),
                          ),
                          Text(
                            expense.date,
                            style: TextStyle(
                              fontSize: AppTheme.fontSizeSmall,
                              color: AppTheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingMd),
                      const Divider(),
                      const SizedBox(height: AppTheme.spacingMd),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Monto',
                            style: TextStyle(
                              fontSize: AppTheme.fontSizeSmall,
                              color: AppTheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            '\$${expense.amount.toStringAsFixed(2)}',
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
                )).toList(),
              );
            } else {
              // Tabla para desktop/tablet
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
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: constraints.maxWidth,
                    ),
                    child: DataTable(
                      columnSpacing: 32,
                      headingRowColor: WidgetStateProperty.resolveWith(
                            (states) => AppTheme.surfaceContainerLow,
                      ),
                      border: TableBorder(
                        horizontalInside: BorderSide(
                          color: AppTheme.outlineVariant.withValues(alpha: 0.5),
                          width: 0.5,
                        ),
                      ),
                      columns: const [
                        DataColumn(
                          label: Text(
                            'Gasto',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Categoría',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Fecha',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Monto',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                      rows: expenses.map((expense) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Row(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: AppTheme.surfaceContainer,
                                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
                                    ),
                                    child: Center(
                                      child: FaIcon(
                                        expense.icon,
                                        size: 18,
                                        color: AppTheme.primary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppTheme.spacingMd),
                                  Text(
                                    expense.title,
                                    style: TextStyle(
                                      fontSize: AppTheme.fontSizeBody,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppTheme.spacingSm,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.secondaryContainer,
                                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                                ),
                                child: Text(
                                  expense.category,
                                  style: TextStyle(
                                    fontSize: AppTheme.fontSizeSmall,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.onSecondaryContainer,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                expense.date,
                                style: TextStyle(
                                  fontSize: AppTheme.fontSizeBody,
                                  color: AppTheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                '\$${expense.amount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: AppTheme.fontSizeTitle,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}