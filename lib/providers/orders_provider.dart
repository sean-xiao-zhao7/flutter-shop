import 'package:flutter/foundation.dart';
import 'package:shop/providers/cart_provider.dart';

class Order {
  final String id;
  final double amount;
  final List<CartItem> cartItems;
  final DateTime orderTime;

  Order({
    @required this.id,
    @required this.amount,
    @required this.cartItems,
    @required this.orderTime,
  });
}

class Orders with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get getOrders {
    return [..._orders];
  }

  void addOrders(List<CartItem> cartItems, double total) {
    _orders.insert(
      0,
      Order(
          id: DateTime.now().toString(),
          amount: total,
          orderTime: DateTime.now(),
          cartItems: cartItems),
    );
    notifyListeners();
  }
}
