import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/orders_provider.dart';
import 'package:shop/widgets/main_drawer.dart';
import 'package:shop/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);

    return Scaffold(
        appBar: AppBar(title: Text('Orders')),
        drawer: MainDrawer(),
        body: ListView.builder(
          itemCount: orders.getOrders.length,
          itemBuilder: (ctx, index) => OrderItem(orders.getOrders[index]),
        ));
  }
}
