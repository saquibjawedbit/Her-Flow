class CartItemModel {
  final String productId;
  final int quantity;

  const CartItemModel({required this.productId, required this.quantity});

  // Convert CartItemModel to Map
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'quantity': quantity,
    };
  }

  // Factory constructor to create CartItemModel from JSON
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'] as String,
      quantity: json['quantity'] as int,
    );
  }
}
