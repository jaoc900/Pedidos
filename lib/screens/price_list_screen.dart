import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/models/price_list_model.dart';
import 'package:pedidos/enums/price_list_enum.dart';
import 'package:pedidos/screens/price_list_detail_screen.dart';
import 'package:pedidos/models/product_price_model.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';
import 'package:pedidos/widgets/custom_text_field.dart';

class PriceListScreen extends StatefulWidget {
  const PriceListScreen({super.key});

  @override
  State<PriceListScreen> createState() => _PriceListScreenState();
}

class _PriceListScreenState extends State<PriceListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<PriceList> _priceLists = [
    PriceList(
      id: '1',
      name: 'Minorista',
      description: 'Precios para clientes finales y tiendas locales.',
      icon: FontAwesomeIcons.store,
      iconColor: AppTheme.primary,
      borderColor: AppTheme.primary,
      status: PriceListStatus.active,
      items: 1240,
      margin: 15.0,
    ),
    PriceList(
      id: '2',
      name: 'Mayorista',
      description: 'Acuerdos de volumen medio para socios comerciales.',
      icon: FontAwesomeIcons.building,
      iconColor: AppTheme.secondary,
      borderColor: AppTheme.secondary,
      status: PriceListStatus.active,
      items: 850,
      margin: 10.5,
    ),
    PriceList(
      id: '3',
      name: 'Distribuidor',
      description: 'Precios de fábrica para distribuidores nacionales.',
      icon: FontAwesomeIcons.truck,
      iconColor: AppTheme.outline,
      borderColor: AppTheme.outline,
      status: PriceListStatus.inactive,
      items: 430,
      margin: 6.2,
    ),
    PriceList(
      id: '4',
      name: 'Exportación',
      description: 'Precios en moneda extranjera y logística global.',
      icon: FontAwesomeIcons.globe,
      iconColor: AppTheme.tertiary,
      borderColor: AppTheme.tertiary,
      status: PriceListStatus.active,
      items: 2100,
      margin: 22.0,
    ),
  ];

  List<PriceList> get _filteredLists {
    if (_searchQuery.isEmpty) return _priceLists;
    return _priceLists.where((list) =>
    list.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        list.description.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  int get _totalItems => _filteredLists.fold(0, (sum, list) => sum + list.items);
  double get _averageMargin => _filteredLists.fold(0.0, (sum, list) => sum + list.margin) / _filteredLists.length;
  int get _updatesToday => 154;

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
                  _buildSearchBar(),
                  const SizedBox(height: AppTheme.spacingLg),
                  _buildSectionTitle(),
                  const SizedBox(height: AppTheme.spacingLg),
                  _buildPriceListsGrid(),
                  // Espacio reducido y dinámico
                  const SizedBox(height: AppTheme.spacingMd), // Reducido de spacingXl a spacingMd
                  _buildPerformanceSummary(),
                  const SizedBox(height: AppTheme.spacingXl),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PriceListDetailScreen(listName: 'Mayorista'),
            ),
          );
        },
        backgroundColor: AppTheme.loginButtonColor,
        foregroundColor: AppTheme.onTertiaryFixed,
        elevation: 4,
        heroTag: 'price_list_fab',
        shape: const CircleBorder(),
        child: const FaIcon(FontAwesomeIcons.plus, size: 24, color: Colors.white,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildTopAppBar(BuildContext context) {
    return CustomTopAppBar(
      title: 'Lista de precios',
      showBackButton: true,
      onBackPressed: () => Navigator.pop(context),
      actions: [
        AppBarButton(
            icon: FontAwesomeIcons.save,
            onPressed: () => {})
      ],
    );
  }

  Widget _buildSearchBar() {
    return CustomTextField(
      controller: _searchController, // Necesitas crear este controller
      label: '', // Si no quieres label, puedes pasar una cadena vacía
      hint: 'Buscar por número o cliente...',
      icon: FontAwesomeIcons.magnifyingGlass,
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      borderRadius: AppTheme.borderRadiusXXl,
    );
  }

  Widget _buildSectionTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Listas de Precios',
          style: TextStyle(
            fontSize: AppTheme.fontSizeTitle,
            fontWeight: FontWeight.w700,
            color: AppTheme.onSurface,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingMd,
            vertical: AppTheme.spacingSm,
          ),
          decoration: BoxDecoration(
            color: AppTheme.secondaryContainer,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
          ),
          child: Text(
            '${_filteredLists.length} Totales',
            style: TextStyle(
              fontSize: AppTheme.fontSizeSmall,
              fontWeight: FontWeight.w700,
              color: AppTheme.onSecondaryContainer,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceListsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 800;
        final crossAxisCount = isDesktop ? 2 : 1;

        // Calcular cuántas filas hay
        final rowCount = (_filteredLists.length / crossAxisCount).ceil();
        final cardHeight = 300.0;
        final gridHeight = rowCount * (cardHeight + AppTheme.spacingLg);

        return SizedBox(
          height: gridHeight,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: AppTheme.spacingLg,
              mainAxisSpacing: AppTheme.spacingLg,
              mainAxisExtent: cardHeight,
            ),
            itemCount: _filteredLists.length,
            itemBuilder: (context, index) {
              final priceList = _filteredLists[index];
              return _buildPriceListCard(priceList);
            },
          ),
        );
      },
    );
  }

  Widget _buildPriceListCard(PriceList priceList) {
    final isActive = priceList.status == PriceListStatus.active;

    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
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
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 4,
              decoration: BoxDecoration(
                color: priceList.borderColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppTheme.borderRadiusXl),
                  bottomLeft: Radius.circular(AppTheme.borderRadiusXl),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: priceList.iconColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
                          ),
                          child: Center(
                            child: FaIcon(
                              priceList.icon,
                              size: 22,
                              color: priceList.iconColor,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacingSm,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppTheme.tertiaryFixed
                                : AppTheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                          ),
                          child: Text(
                            isActive ? 'Activa' : 'Inactiva',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isActive
                                  ? AppTheme.onTertiaryFixed
                                  : AppTheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingMd),
                    Text(
                      priceList.name,
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeTitle,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      priceList.description,
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeSmall,
                        color: AppTheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppTheme.spacingMd),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Artículos',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppTheme.outline,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${priceList.items}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Margen Sug.',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppTheme.outline,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '+${priceList.margin.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: priceList.margin >= 15
                                      ? AppTheme.secondary
                                      : AppTheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  height: 38,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PriceListDetailScreen(listName: 'Mayorista'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isActive
                          ? AppTheme.primary
                          : AppTheme.surfaceContainerHigh,
                      foregroundColor: isActive
                          ? AppTheme.onPrimary
                          : AppTheme.onSurface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Ver Detalles',
                          style: TextStyle(fontSize: 13),
                        ),
                        const SizedBox(width: AppTheme.spacingSm),
                        FaIcon(
                          FontAwesomeIcons.arrowRight,
                          size: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceSummary() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg), // Reducido de spacingXl a spacingLg
      decoration: BoxDecoration(
        color: AppTheme.inverseSurface,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumen de Performance',
            style: TextStyle(
              fontSize: AppTheme.fontSizeTitle,
              fontWeight: FontWeight.w700,
              color: AppTheme.onInverseSurface,
            ),
          ),
          const SizedBox(height: AppTheme.spacingMd), // Reducido de Lg a Md
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Actualizaciones Hoy',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeSmall,
                        color: AppTheme.onInverseSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$_updatesToday',
                      style: TextStyle(
                        fontSize: 28, // Reducido de 32 a 28
                        fontWeight: FontWeight.w800,
                        color: AppTheme.onInverseSurface,
                      ),
                    ),
                  ],
                ),
              ),
              FaIcon(
                FontAwesomeIcons.chartLine,
                size: 28, // Reducido de 32 a 28
                color: AppTheme.tertiaryFixed,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.1),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Margen Promedio Global',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeSmall,
                        color: AppTheme.onInverseSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_averageMargin.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 28, // Reducido de 32 a 28
                        fontWeight: FontWeight.w800,
                        color: AppTheme.onInverseSurface,
                      ),
                    ),
                  ],
                ),
              ),
              FaIcon(
                FontAwesomeIcons.chartSimple,
                size: 28, // Reducido de 32 a 28
                color: AppTheme.secondaryFixed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}