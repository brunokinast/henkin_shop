import 'package:flutter/cupertino.dart';
import 'package:henkin_shop/models/cart_item.dart';
import 'package:henkin_shop/providers/orders_provider.dart';
import 'package:henkin_shop/providers/product_provider.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {}; //{'productId': CartItem}

  Map<String, CartItem> get items => {..._items};
  List<CartItem> get itemsCart => _items.values.toList();
  int get productsCount => _items.length;
  int get quantityCount => itemsCart.fold(0, (t, item) => t += item.quantity);
  double get totalPrice =>
      _items.values.fold(0.0, (t, item) => t += item.price * item.quantity);

  void addItem(ProductProvider product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id!,
        (oldCart) => changeQuantity(oldCart, oldCart.quantity + 1),
      );
    } else {
      _items.putIfAbsent(
        product.id!,
        () => CartItem(
          id: UniqueKey().toString(),
          product: product,
          title: product.title,
          price: product.price,
        ),
      );
    }
    notifyListeners();
  }

  void removeSingleItem(ProductProvider product) {
    if (_items.containsKey(product.id)) {
      if (_items[product.id]!.quantity == 1)
        removeItem(_items[product.id]!);
      else {
        _items.update(
          product.id!,
          (oldCart) => changeQuantity(oldCart, oldCart.quantity - 1),
        );
      }
    }
  }

  Order toOrder() {
    return Order(
      id: null,
      items: itemsCart,
      total: itemsCart.fold(0.0, (t, item) => t += item.price * item.quantity),
      date: DateTime.now(),
    );
  }

  CartItem changeQuantity(CartItem oldCart, int quantity) => CartItem(
        id: oldCart.id,
        product: oldCart.product,
        title: oldCart.title,
        price: oldCart.price,
        quantity: quantity,
      );

  void removeItem(CartItem item) {
    _items.remove(item.product.id);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
