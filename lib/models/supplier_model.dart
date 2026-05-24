class Supplier {
  final String id;
  final String name;
  final String contact;
  final String phone;
  final String email;
  final String address;
  final String category;
  final double outstandingBalance;
  final bool isActive;
  final int paymentDays;
  final String imageUrl;

  Supplier({
    required this.id,
    required this.name,
    required this.contact,
    required this.phone,
    required this.email,
    required this.address,
    required this.category,
    required this.outstandingBalance,
    required this.isActive,
    required this.paymentDays,
    required this.imageUrl,
  });
}