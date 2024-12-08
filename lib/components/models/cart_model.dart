import 'package:her_flow/components/models/cart_item_model.dart';

class CartModel {
  final String? id;
  final List<CartItemModel> items;

  const CartModel({required this.id, required this.items});

  // Convert CartModel to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'items': items.map((item) => item.toMap()).toList(),
    };
  }

  // Factory constructor to create CartModel from JSON
  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'] as String?,
      items: (json['items'] as List)
          .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
