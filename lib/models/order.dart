class Order {
  final String id;
  final String product;
  final int qty;
  final int price;

  Order(
      {required this.id,
      required this.product,
      required this.qty,
      required this.price});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      product: json['product'],
      qty: json['qty'],
      price: json['price'],
    );
  }
}
