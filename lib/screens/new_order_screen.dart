import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/screens/product_catalog_screen.dart';
import 'package:pedidos/models/order_data_model.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';
import 'package:pedidos/widgets/custom_text_field.dart';
import 'package:pedidos/widgets/custom_outlined_button.dart';

class NewOrderScreen extends StatefulWidget {
  const NewOrderScreen({super.key});

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  // Controladores para los campos de texto
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerPhoneController = TextEditingController();

  // Lista de productos en el pedido
  List<OrderItem> _items = [
    OrderItem(
      id: '1',
      name: 'Kale Orgánico (Manojo)',
      price: 45.00,
      quantity: 3,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDaUw1JNI3hCYgeOeiNzKSb8GHXggp63fsXCs7Ln2bAOPJR0UClub84Q-CXNSXMKnjwtIbF3_P-oAAA3HRTABiYvGA4VxbDHoXvi4ztRoIxNbv3VQz0mjbAF85Pyz_AKSe4mDinsmQq-yfO26UyOotOn6HY0v9akLwnrjqIs90tiNuyamRtZXPRtWGZ945CCiYwv3FlnO1-1oOMsKFIno7l3PP8PU5qiJbJi9d4e2Vj55Pie4I1qhNmHjzvvCFxoXN-IzH_HDVa0Imi',
    ),
    OrderItem(
      id: '2',
      name: 'Pimiento Naranja (kg)',
      price: 68.50,
      quantity: 1,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCh_iZ6o8dsJiBRPieZQe_ai6jML-cw5Lm5tmEj2wfOshJ-9-Pb2Y1ftlwZe1--Zm7XzcDAeY9RXsdhAn5D5HGzzyRCdpRkAuhuL-K2mmsw0khCvboNNFMT3oUm_3MHVhfiybk995FLZBgbyMGvJjg9e8K0cecIKn5ZjF0ag_DJITrV5GES2Ff_dNAd8zixgSUto5HmiNewMHKPgGZzaVYkRXS_V083pVqmfaJc1Ax3okMHjA3lLr3RgfvzkqwoXQJMMk9Lbj2eAF7u',
    ),
  ];

  double get _subtotal {
    return _items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  double get _iva {
    return _subtotal * 0.16;
  }

  double get _total {
    return _subtotal + _iva;
  }

  void _updateQuantity(String itemId, int delta) {
    setState(() {
      final index = _items.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        final newQuantity = _items[index].quantity + delta;
        if (newQuantity >= 1) {
          _items[index].quantity = newQuantity;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: CustomTopAppBar(
        title: 'Nueva Orden',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
        actions: [
          AppBarButton(
            icon: FontAwesomeIcons.solidFloppyDisk,
            onPressed: _saveOrder,
            color: AppTheme.primary,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppTheme.spacingXl),
            _buildCustomerSection(),
            const SizedBox(height: AppTheme.spacingXl),
            _buildItemsSection(),
            const SizedBox(height: AppTheme.spacingXl),
            _buildOrderSummary(),
            const SizedBox(height: AppTheme.spacingXl * 2),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FaIcon(
              FontAwesomeIcons.user,
              size: 20,
              color: AppTheme.primary,
            ),
            const SizedBox(width: AppTheme.spacingSm),
            Text(
              'Información del Cliente',
              style: TextStyle(
                fontSize: AppTheme.fontSizeTitle,
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingLg),

        // Nombre del Cliente
        CustomTextField(
          controller: _customerNameController,
          label: 'Nombre del Cliente',
          hint: 'Ej. Juan Pérez',
          icon: FontAwesomeIcons.user,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          borderRadius: AppTheme.borderRadiusXXl,
          showLabel: true,
        ),
        const SizedBox(height: AppTheme.spacingLg),

        // Teléfono
        CustomTextField(
          controller: _customerPhoneController,
          label: 'Teléfono',
          hint: '+52 000 000 0000',
          icon: FontAwesomeIcons.phone,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          borderRadius: AppTheme.borderRadiusXXl,
          showLabel: true,
        ),
      ],
    );
  }

  Widget _buildItemsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.basketShopping,
                  size: 20,
                  color: AppTheme.primary,
                ),
                const SizedBox(width: AppTheme.spacingSm),
                Text(
                  'Artículos',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeTitle,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
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
                color: AppTheme.primaryFixedDim.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
              ),
              child: Text(
                '${_items.length} Productos',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeLabel,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingLg),
        // Lista de productos
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _items.length,
          separatorBuilder: (context, index) => const SizedBox(height: AppTheme.spacingMd),
          itemBuilder: (context, index) {
            final item = _items[index];
            return _buildProductItem(item);
          },
        ),
        const SizedBox(height: AppTheme.spacingLg),
        // Botón para agregar artículo
        CustomOutlinedButton(
          text: 'Agregar Artículo',
          onPressed: _addNewItem,
          icon: FontAwesomeIcons.plusCircle,
          textColor: AppTheme.secondary,
          borderColor: AppTheme.outlineVariant,
          borderRadius: AppTheme.borderRadiusXXl,
        ),
      ],
    );
  }

  Widget _buildProductItem(OrderItem item) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: Colors.white,
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
        children: [
          // Imagen del producto
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
            child: Image.network(
              item.imageUrl,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 64,
                  height: 64,
                  color: AppTheme.primaryContainer,
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.image,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: AppTheme.spacingLg),
          // Información del producto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeLabel,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeBody,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),
          // Controles de cantidad
          Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainer,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
            ),
            child: Row(
              children: [
                // Botón restar
                GestureDetector(
                  onTap: () => _updateQuantity(item.id, -1),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.minus,
                        size: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                // Cantidad
                SizedBox(
                  width: 24,
                  child: Text(
                    '${item.quantity}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeLabel,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onSurface,
                    ),
                  ),
                ),
                // Botón sumar
                GestureDetector(
                  onTap: () => _updateQuantity(item.id, 1),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withValues(alpha: 0.3),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.plus,
                        size: 12,
                        color: Colors.white,
                      ),
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

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingXl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: AppTheme.surfaceContainerHighest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RESUMEN DEL PEDIDO',
            style: TextStyle(
              fontSize: AppTheme.fontSizeLabel,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              color: AppTheme.outline,
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          // Subtotal
          _buildSummaryRow('Subtotal', '\$${_subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: AppTheme.spacingMd),
          // IVA
          _buildSummaryRow('IVA (16%)', '\$${_iva.toStringAsFixed(2)}'),
          const SizedBox(height: AppTheme.spacingLg),
          const Divider(color: AppTheme.outlineVariant),
          const SizedBox(height: AppTheme.spacingLg),
          // Total
          _buildSummaryRow(
            'Total',
            '\$${_total.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? AppTheme.fontSizeTitle : AppTheme.fontSizeBody,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
            color: isTotal ? AppTheme.onSurface : AppTheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? AppTheme.fontSizeTitle : AppTheme.fontSizeBody,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
            color: isTotal ? AppTheme.primary : AppTheme.onSurface,
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _buildInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
      borderSide: BorderSide(color: AppTheme.outlineVariant, width: 1),
    );
  }

  OutlineInputBorder _buildFocusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
      borderSide: const BorderSide(color: AppTheme.primary, width: 2),
    );
  }

  void _saveOrder() {
    // Validar campos
    if (_customerNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingresa el nombre del cliente'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }

    // Aquí iría la lógica para guardar el pedido
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pedido guardado exitosamente'),
        backgroundColor: AppTheme.primary,
      ),
    );

    // Regresar a la pantalla anterior
    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.pop(context);
    });
  }

  void _addNewItem() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProductCatalogScreen()),
    );
  }
}