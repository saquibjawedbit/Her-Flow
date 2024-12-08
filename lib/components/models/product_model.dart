class ProductModel {
  final String? id;
  final String name;
  final String imageUrl;
  final double price;
  final int stock;
  final String description;
  final int discount;

  const ProductModel({
    this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.stock,
    required this.description,
    required this.discount,
  });

  // Convert ProductModel to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'stock': stock,
      'description': description,
      'discount': discount,
    };
  }

  // Factory constructor to create ProductModel from JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String?,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      price: (json['price'] as num).toDouble(),
      stock: json['stock'] as int,
      description: json['description'] as String,
      discount: (json['discount'] as num).toInt(),
    );
  }
}

const List<ProductModel> items = [
  ProductModel(
    imageUrl: "https://picsum.photos/200/300",
    name: "Item 1",
    price: 100,
    description: "small desc",
    stock: 20,
    discount: 20,
  ),
  ProductModel(
    imageUrl: "https://picsum.photos/200/300",
    name: "Item 1",
    price: 100,
    description: "small desc",
    stock: 20,
    discount: 50,
  ),
];
