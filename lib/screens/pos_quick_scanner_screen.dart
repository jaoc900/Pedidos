import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';
import 'package:pedidos/widgets/primary_button.dart';
import 'package:pedidos/enums/botton_status_enum.dart';
import 'package:pedidos/screens/modals/confirmation_modal.dart';

class QuickScannerScreen extends StatefulWidget {
  const QuickScannerScreen({super.key});

  @override
  State<QuickScannerScreen> createState() => _QuickScannerScreenState();
}

class _QuickScannerScreenState extends State<QuickScannerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanAnimationController;
  bool _isFlashlightOn = false;
  MobileScannerController? _scannerController;

  final List<ScannedItem> _scannedItems = [
    ScannedItem(
      id: '12',
      name: 'Organic Kale Elixir',
      price: 8.50,
      size: '500ml',
      imageUrl:
      'https://lh3.googleusercontent.com/aida-public/AB6AXuA2wxY9cOF6lbJq78CtqBbcCEddyLz9zPfuMQsphHUaj40wD6iegFltoLPLMNJh07VQpG1SMFjmjJxgsMX6GVQOIAn4jPCoUp_a79OKXGq_iSiyzWS4O2xXfWEFpLsMxME6VEk3l4gWyrX6vHHllX2AjeS5kV5zceihJQwcGuH_YazPYicdun72-DLfcr2FUwc6wv6aF2oZjb93Yv7aro32DcopSvSKcKdILLc2IXXozeGvLo_crza7N0rSXwV6SHl9LtF0KCxSGeMr',
      quantity: 2,
    ),
    ScannedItem(
      id: '13',
      name: 'Organic Green Juice',
      price: 6.50,
      size: '350ml',
      imageUrl:
      'https://lh3.googleusercontent.com/aida-public/AB6AXuA2wxY9cOF6lbJq78CtqBbcCEddyLz9zPfuMQsphHUaj40wD6iegFltoLPLMNJh07VQpG1SMFjmjJxgsMX6GVQOIAn4jPCoUp_a79OKXGq_iSiyzWS4O2xXfWEFpLsMxME6VEk3l4gWyrX6vHHllX2AjeS5kV5zceihJQwcGuH_YazPYicdun72-DLfcr2FUwc6wv6aF2oZjb93Yv7aro32DcopSvSKcKdILLc2IXXozeGvLo_crza7N0rSXwV6SHl9LtF0KCxSGeMr',
      quantity: 1,
    ),
  ];

  double get _orderTotal =>
      _scannedItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _scanAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _scannerController = MobileScannerController(
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  @override
  void dispose() {
    _scanAnimationController.dispose();
    _scannerController?.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  void _toggleFlashlight() {
    setState(() {
      _isFlashlightOn = !_isFlashlightOn;
    });
    _scannerController?.toggleTorch();
  }

  void _onScanComplete(BarcodeCapture capture) {
    final String? code = capture.barcodes.first.rawValue;
    if (code != null) {
      _simulateScanFromCode(code);
    }
  }

  void _simulateScanFromCode([String? code]) {
    final newItem = ScannedItem(
      id: '${_scannedItems.length + 1}',
      name: 'Producto Escaneado',
      price: 10.00,
      size: '1L',
      imageUrl: _scannedItems.isNotEmpty ? _scannedItems.first.imageUrl : '',
      quantity: 1,
    );
    setState(() {
      _scannedItems.add(newItem);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Producto escaneado: ${code ?? 'manual'}'),
        backgroundColor: AppTheme.primary,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _updateQuantity(int index, int newQuantity) {
    setState(() {
      _scannedItems[index].quantity = newQuantity.clamp(1, 99);
    });
  }

  void _removeItem(int index) {
    setState(() {
      _scannedItems.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Producto eliminado'),
        backgroundColor: AppTheme.error,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _checkout() {
    // Usar ConfirmationModal en lugar de AlertDialog
    context.showConfirmation(
      title: 'Proceder al pago',
      message: 'Total: \$${_orderTotal.toStringAsFixed(2)} con ${_scannedItems.length} items',
      confirmText: 'Confirmar',
      cancelText: 'Cancelar',
      type: ConfirmationType.info,
      customIcon: FontAwesomeIcons.shoppingCart,
      onConfirm: () {
        // Cerrar el modal y mostrar mensaje de procesamiento
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Procesando pago...'),
            backgroundColor: AppTheme.primary,
          ),
        );
      },
      onCancel: () {
        // Solo cerrar el modal (ya lo maneja el modal automáticamente)
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: CustomTopAppBar(
        title: 'Verdant POS',
        showBackButton: true,
        actions: [
          AppBarButton(
            icon: FontAwesomeIcons.barcode,
            onPressed: () => _simulateScanFromCode(),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 150,
            child: Stack(
              children: [
                MobileScanner(
                  controller: _scannerController,
                  onDetect: _onScanComplete,
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black54,
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black54,
                      ],
                      stops: [0.0, 0.1, 0.9, 1.0],
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: screenWidth,
                    height: 120,
                    child: Stack(
                      children: [
                        AnimatedBuilder(
                          animation: _scanAnimationController,
                          builder: (context, child) {
                            final scanPosition = 0.15 + (0.7 * _scanAnimationController.value);
                            final topPosition = scanPosition * 120;
                            return Positioned(
                              left: 0,
                              right: 0,
                              top: topPosition,
                              child: Container(
                                height: 2,
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryFixedDim,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primaryFixedDim,
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        _buildCornerAccent(Positioned(
                          top: 0,
                          left: 20,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: AppTheme.primaryFixedDim, width: 3),
                                left: BorderSide(color: AppTheme.primaryFixedDim, width: 3),
                              ),
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(12)),
                            ),
                          ),
                        )),
                        _buildCornerAccent(Positioned(
                          top: 0,
                          right: 20,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: AppTheme.primaryFixedDim, width: 3),
                                right: BorderSide(color: AppTheme.primaryFixedDim, width: 3),
                              ),
                              borderRadius: const BorderRadius.only(topRight: Radius.circular(12)),
                            ),
                          ),
                        )),
                        _buildCornerAccent(Positioned(
                          bottom: 0,
                          left: 20,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: AppTheme.primaryFixedDim, width: 3),
                                left: BorderSide(color: AppTheme.primaryFixedDim, width: 3),
                              ),
                              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12)),
                            ),
                          ),
                        )),
                        _buildCornerAccent(Positioned(
                          bottom: 0,
                          right: 20,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: AppTheme.primaryFixedDim, width: 3),
                                right: BorderSide(color: AppTheme.primaryFixedDim, width: 3),
                              ),
                              borderRadius: const BorderRadius.only(bottomRight: Radius.circular(12)),
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _toggleFlashlight,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: FaIcon(
                              _isFlashlightOn ? FontAwesomeIcons.solidLightbulb : FontAwesomeIcons.lightbulb,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Entrada manual activada'),
                              backgroundColor: AppTheme.primary,
                            ),
                          );
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: FaIcon(
                              FontAwesomeIcons.keyboard,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 4,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingMd,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                      ),
                      child: Text(
                        'Escanear código',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildScannedItemsList(),
          ),
          _buildPersistentCheckoutBar(),
        ],
      ),
    );
  }

  Widget _buildCornerAccent(Positioned positioned) {
    return positioned;
  }

  Widget _buildScannedItemsList() {
    if (_scannedItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.boxOpen,
              size: 48,
              color: AppTheme.outline.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              'No hay productos escaneados',
              style: TextStyle(
                fontSize: AppTheme.fontSizeBody,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              'Escanea un código de barras',
              style: TextStyle(
                fontSize: AppTheme.fontSizeSmall,
                color: AppTheme.outline,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        border: Border(
          top: BorderSide(color: AppTheme.outlineVariant),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppTheme.spacingLg,
              AppTheme.spacingSm,
              AppTheme.spacingLg,
              0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Productos Escaneados',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeLabel,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurfaceVariant,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  '${_scannedItems.length} items',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeSmall,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              itemCount: _scannedItems.length,
              itemBuilder: (context, index) {
                final item = _scannedItems[index];
                return _buildScannedItemCard(item, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScannedItemCard(ScannedItem item, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg, vertical: AppTheme.spacingSm),
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: AppTheme.surfaceContainerHigh),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainer,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: FaIcon(FontAwesomeIcons.image, size: 24),
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
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeLabel,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '\$${item.price.toStringAsFixed(2)}  ${item.size}',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeSmall,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainer,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => _updateQuantity(index, item.quantity - 1),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: FaIcon(FontAwesomeIcons.minus, size: 10),
                    ),
                  ),
                ),
                SizedBox(
                  width: 28,
                  child: Center(
                    child: Text(
                      '${item.quantity}',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeLabel,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.onSurface,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _updateQuantity(index, item.quantity + 1),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: FaIcon(FontAwesomeIcons.plus, size: 10, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppTheme.spacingSm),
          GestureDetector(
            onTap: () => _removeItem(index),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.errorContainer,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.trashCan,
                  size: 14,
                  color: AppTheme.error,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersistentCheckoutBar() {
    if (_scannedItems.isEmpty) return const SizedBox.shrink();

    return Container(
      padding:  const EdgeInsets.fromLTRB(
        AppTheme.spacingLg,
        AppTheme.spacingLg,
        AppTheme.spacingLg,
        AppTheme.spacingXxxl,
      ),
      decoration: BoxDecoration(
        color: AppTheme.inverseSurface,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total del Pedido',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeSmall,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                  letterSpacing: 1,
                ),
              ),
              Text(
                '\$${_orderTotal.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primaryFixedDim,
                ),
              ),
            ],
          ),
          PrimaryButton(
            text: 'Pagar',
            onPressed: _checkout,
            icon: FontAwesomeIcons.arrowRight,
            state: ButtonState.active,
            activeColor: AppTheme.primary,
            textColor: AppTheme.onPrimary,
            iconColor: AppTheme.onPrimary,
            borderRadius: AppTheme.borderRadiusXl,
            fontSize: AppTheme.fontSizeTitle,
            iconSize: 18,
            height: 48,
            fullWidth: false,
          ),
        ],
      ),
    );
  }
}

class ScannedItem {
  String id;
  final String name;
  final double price;
  final String size;
  final String imageUrl;
  int quantity;

  ScannedItem({
    required this.id,
    required this.name,
    required this.price,
    required this.size,
    required this.imageUrl,
    this.quantity = 1,
  });
}