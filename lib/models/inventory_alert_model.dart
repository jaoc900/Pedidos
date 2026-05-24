class InventoryAlert {
  final String product;
  final int stock;
  final bool critical;

  InventoryAlert({
    required this.product,
    required this.stock,
    required this.critical,
  });
}