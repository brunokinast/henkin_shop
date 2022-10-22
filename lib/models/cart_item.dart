import 'package:henkin_shop/providers/product_provider.dart';

class CartItem {
  final String id;
  final ProductProvider product;
  final String title;
  final double price;
  final int quantity;

  const CartItem({
    required this.id,
    required this.product,
    required this.title,
    required this.price,
    this.quantity = 1,
  });

  CartItem.fromJson(this.id, Map<String, dynamic> map)
      : product = ProductProvider.fromJson(
            null, map['product'] as Map<String, dynamic>),
        title = map['title'] as String,
        price = map['price'] as double,
        quantity = map['quantity'] as int;

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'title': title,
      'price': price,
      'quantity': quantity,
    };
  }
}
