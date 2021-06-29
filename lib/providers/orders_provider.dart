import 'package:flutter/foundation.dart';
import 'package:shop/providers/cart_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop/widgets/order_item.dart';

const firebaseURL =
    'https://flutter-553e7-default-rtdb.firebaseio.com/orders.json';

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
  List<OrderItem> _orders = [];

  List<OrderItem> get getOrders {
    return [..._orders];
  }

  Future<void> getOrdersFromWeb() async {
    try {
      final res = await http.get(Uri.parse(firebaseURL));
      final data = json.decode(res.body) as Map<String, dynamic>;
      final List<OrderItem> loadedOrderItems = [];
      data.forEach((id, order) {
        final myOrder = Order(
          id: id,
          orderTime: DateTime.parse(order['orderTime']),
          amount: order['amount'],
          cartItems: (order['cartItems'] as List<dynamic>).map((e) {
            CartItem(
                id: e['id'],
                price: e['price'],
                quantity: e['quantity'],
                title: e['title']);
          }).toList(),
        );
        loadedOrderItems.add(OrderItem(myOrder));
      });
      _orders = loadedOrderItems;
      notifyListeners();
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  void addOrders(List<CartItem> cartItems, double total) async {
    var url = Uri.parse(firebaseURL);

    try {
      var orderTime = DateTime.now();
      final res = await http.post(url,
          body: json.encode({
            'amount': total,
            'orderTime': orderTime.toIso8601String(),
            'cartItems': cartItems
                .map((e) => {
                      'id': e.id,
                      'title': e.title,
                      'quantity': e.quantity,
                      'price': e.price,
                    })
                .toList(),
          }));

      _orders.insert(
        0,
        OrderItem(Order(
            id: json.decode(res.body)['name'],
            amount: total,
            orderTime: orderTime,
            cartItems: cartItems)),
      );
      notifyListeners();
    } catch (e) {
      print(e);
      throw (e);
    }
  }
}
