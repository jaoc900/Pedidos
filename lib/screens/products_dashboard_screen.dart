import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/models/kpi_model.dart';
import 'package:pedidos/models/size_dashboard_model.dart';
import 'package:pedidos/models/top_product_model.dart';
import 'package:pedidos/screens/painters/donut_chart_painter.dart';
import 'package:pedidos/models/low_rotation_model.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';

class ProductsDashboardScreen extends StatelessWidget {
  const ProductsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: CustomTopAppBar(
        title: 'Análisis de productos',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          // Contenido principal
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Section
                  _buildTitleSection(),
                  const SizedBox(height: AppTheme.spacingLg),
                  // KPIs Section
                  _buildKPIsSection(),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Top Selling Products
                  _buildTopSellingProducts(),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Size Preferences Chart
                  _buildSizePreferences(),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Customer Distribution
                  _buildCustomerDistribution(),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Low Rotation Products
                  _buildLowRotationProducts(),
                  const SizedBox(height: AppTheme.spacingXl * 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Análisis',
          style: TextStyle(
            fontSize: AppTheme.fontSizeHeadline,
            fontWeight: FontWeight.w700,
            color: AppTheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Resumen de rendimiento de productos',
          style: TextStyle(
            fontSize: AppTheme.fontSizeBody,
            color: AppTheme.outline,
          ),
        ),
      ],
    );
  }

  Widget _buildKPIsSection() {
    final kpis = [
      KPIData(
        title: 'Stock Total',
        value: '42,850',
        unit: 'u.',
        color: AppTheme.primary,
        icon: FontAwesomeIcons.boxes,
      ),
      KPIData(
        title: 'Valor Inventario',
        value: '€128k',
        unit: '',
        color: AppTheme.secondary,
        icon: FontAwesomeIcons.moneyBill,
      ),
      KPIData(
        title: 'Rotación',
        value: '85%',
        unit: '',
        color: AppTheme.tertiary,
        icon: FontAwesomeIcons.arrowsRotate,
      ),
    ];

    return Row(
      children: [
        for (int i = 0; i < kpis.length; i++) ...[
          Expanded(child: _buildKPIItem(kpis[i])),
          if (i < kpis.length - 1) SizedBox(width: AppTheme.spacingMd),
        ]
      ],
    );
  }

  Widget _buildKPIItem(KPIData kpi) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border(left: BorderSide(color: kpi.color, width: 4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                kpi.title,
                style: TextStyle(
                  fontSize: AppTheme.fontSizeSmall,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                  color: AppTheme.outline,
                ),
              ),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: kpi.value,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.onSurface,
                      ),
                    ),
                    if ((kpi.unit?? '').isNotEmpty)
                      TextSpan(
                        text: ' ${kpi.unit}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.outline,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingSm),
            decoration: BoxDecoration(
              color: kpi.color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
            ),
            child: FaIcon(
              kpi.icon,
              size: 28,
              color: kpi.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSellingProducts() {
    final products = [
      TopProduct(name: 'Fertilizante Orgánico N-P-K', units: 12400, percentage: 95),
      TopProduct(name: 'Semillas de Maíz Híbrido', units: 9850, percentage: 78),
      TopProduct(name: 'Sustrato Universal Premium', units: 7200, percentage: 60),
      TopProduct(name: 'Fungicida Sistémico 1L', units: 5400, percentage: 45),
      TopProduct(name: 'Herramienta Podadora Pro', units: 3900, percentage: 32),
    ];

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top 5 Ventas',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeTitle,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurface,
                ),
              ),
              IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.arrowRight,
                  size: 20,
                  color: AppTheme.primary,
                ),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          ...products.map((product) => Padding(
            padding: const EdgeInsets.only(bottom: AppTheme.spacingLg),
            child: _buildProductBar(product),
          )),
        ],
      ),
    );
  }

  Widget _buildProductBar(TopProduct product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                product.name,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.onSurfaceVariant,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              '${product.units} u.',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppTheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
          child: LinearProgressIndicator(
            value: product.percentage / 100,
            backgroundColor: AppTheme.surfaceContainerHigh,
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildSizePreferences() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
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
          Text(
            'Tamaños Preferidos',
            style: TextStyle(
              fontSize: AppTheme.fontSizeTitle,
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurface,
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          _buildDonutChart(),
          const SizedBox(height: AppTheme.spacingLg),
          _buildSizeLegend(),
        ],
      ),
    );
  }

  Widget _buildDonutChart() {
    return Center(
      child: SizedBox(
        width: 160,
        height: 160,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Anillo exterior (L - 52%)
            CustomPaint(
              size: const Size(160, 160),
              painter: DonutChartPainter.single(
                percentage: 52,
                color: AppTheme.primary,
                strokeWidth: 12,
              ),
            ),
            // Anillo medio (M - 30%)
            CustomPaint(
              size: const Size(120, 120),
              painter: DonutChartPainter.single(
                percentage: 30,
                color: AppTheme.secondary,
                strokeWidth: 10,
              ),
            ),
            // Anillo interior (S - 18%)
            CustomPaint(
              size: const Size(80, 80),
              painter: DonutChartPainter.single(
                percentage: 18,
                color: AppTheme.tertiary,
                strokeWidth: 8,
              ),
            ),
            // Centro
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.scaleBalanced,
                  size: 24,
                  color: AppTheme.outline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeLegend() {
    final sizes = [
      SizeData(size: 'L (25kg)', percentage: '52%', color: AppTheme.primary),
      SizeData(size: 'M (10kg)', percentage: '30%', color: AppTheme.secondary),
      SizeData(size: 'S (5kg)', percentage: '18%', color: AppTheme.tertiary),
    ];

    return Column(
      children: sizes.map((size) => Padding(
        padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerLow,
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
                      color: size.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingSm),
                  Text(
                    size.size,
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeLabel,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.onSurface,
                    ),
                  ),
                ],
              ),
              Text(
                size.percentage,
                style: TextStyle(
                  fontSize: AppTheme.fontSizeLabel,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildCustomerDistribution() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
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
          Text(
            'Segmentos de Cliente',
            style: TextStyle(
              fontSize: AppTheme.fontSizeTitle,
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Categorías por tipo de perfil',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.outline,
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          // Grandes Productores
          _buildSegmentBar(
            title: 'Grandes Productores',
            values: [65, 20, 15],
            colors: [AppTheme.primary, AppTheme.secondary, AppTheme.tertiary],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          // Minoristas
          _buildSegmentBar(
            title: 'Minoristas',
            values: [30, 40, 30],
            colors: [AppTheme.primary, AppTheme.secondary, AppTheme.tertiary],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          // Consumidores Finales
          _buildSegmentBar(
            title: 'Consumidores Finales',
            values: [15, 15, 70],
            colors: [AppTheme.primary, AppTheme.secondary, AppTheme.tertiary],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          // Leyenda
          Wrap(
            spacing: AppTheme.spacingLg,
            runSpacing: AppTheme.spacingSm,
            children: [
              _buildLegendDot('Insumos', AppTheme.primary),
              _buildLegendDot('Maquinaria', AppTheme.secondary),
              _buildLegendDot('Semillas', AppTheme.tertiary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentBar({
    required String title,
    required List<int> values,
    required List<Color> colors,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: AppTheme.fontSizeLabel,
            fontWeight: FontWeight.w700,
            color: AppTheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
            border: Border.all(color: AppTheme.outlineVariant),
          ),
          child: Row(
            children: List.generate(values.length, (index) {
              return Expanded(
                flex: values[index],
                child: Container(
                  decoration: BoxDecoration(
                    color: colors[index],
                    borderRadius: index == 0
                        ? const BorderRadius.horizontal(left: Radius.circular(8))
                        : index == values.length - 1
                        ? const BorderRadius.horizontal(right: Radius.circular(8))
                        : BorderRadius.zero,
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendDot(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppTheme.outline,
          ),
        ),
      ],
    );
  }

  Widget _buildLowRotationProducts() {
    final products = [
      LowRotationData(name: 'Azada Forjada Pro', stock: 142, days: 120, isCritical: true),
      LowRotationData(name: 'Abono Cítricos 5kg', stock: 85, days: 95, isCritical: true),
      LowRotationData(name: 'Aspersor G3', stock: 320, days: 75, isCritical: false),
    ];

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
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
          Text(
            'Baja Rotación',
            style: TextStyle(
              fontSize: AppTheme.fontSizeTitle,
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurface,
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          ...products.map((product) => Padding(
            padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
            child: _buildLowRotationItem(product),
          )),
        ],
      ),
    );
  }

  Widget _buildLowRotationItem(LowRotationData product) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
        border: Border.all(color: AppTheme.surfaceContainerHigh),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
                ),
                child: const Center(
                  child: FaIcon(
                    FontAwesomeIcons.leaf,
                    size: 20,
                    color: AppTheme.outline,
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeLabel,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Stock: ${product.stock}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.outline,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingSm,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: product.isCritical
                  ? AppTheme.errorContainer
                  : AppTheme.secondaryContainer,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
            ),
            child: Text(
              '${product.days}+ días',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: product.isCritical
                    ? AppTheme.error
                    : AppTheme.onSecondaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}