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
  Map<String, CartItem> _cartItems = {};

  Map<String, CartItem> get getItems {
    return {
      ..._cartItems,
    };
  }

  int get itemCount {
    return _cartItems == null ? 0 : _cartItems.length;
  }

  double get totalAmount {
    var total = 0.0;
    _cartItems.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
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
    notifyListeners();
  }

  void removeCartItem(String id) {
    _cartItems.remove(id);
    notifyListeners();
  }

  void clear() {
    _cartItems = {};
    notifyListeners();
  }

  void removeOneCartItem(String id) {
    if (!_cartItems.containsKey(id)) {
      return;
    }
    if (_cartItems[id].quantity > 1) {
      _cartItems.update(
          id,
          (e) => CartItem(
              id: e.id,
              title: e.title,
              price: e.price,
              quantity: e.quantity - 1));
    } else {
      _cartItems.remove(id);
    }
    notifyListeners();
  }
}
