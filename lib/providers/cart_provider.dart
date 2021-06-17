import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    this.quantity = 1,
    @required this.price,
  });

  void incrementQuantity() {
    quantity += 1;
  }
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _cartItems;

  Map<String, CartItem> get getItems {
    return {
      ..._cartItems,
    };
  }

  void addCartItem(String id, String title, double price) {
    if (_cartItems.containsKey(id)) {
      _cartItems[id].incrementQuantity();
    } else {
      _cartItems.putIfAbsent(
          id,
          () => CartItem(
              id: DateTime.now().toString(), title: title, price: price));
    }
  }
}
