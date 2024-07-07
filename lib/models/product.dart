class Product {
  final String id;
  final String name;
  final String category;
  final String description;
  final List<dynamic> materials;
  final int stock;
  final int createdAt;
  final int editedAt;
  final int price;

  Product(
      {required this.id,
      required this.name,
      required this.category,
      required this.description,
      required this.materials,
      required this.stock,
      required this.createdAt,
      required this.editedAt,
      required this.price});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      materials: json['materials'],
      category: json['category'],
      description: json['description'],
      stock: json['stock'],
      createdAt: json['createdAt'],
      editedAt: json['editedAt'],
      price: json['price'],
    );
  }
}
