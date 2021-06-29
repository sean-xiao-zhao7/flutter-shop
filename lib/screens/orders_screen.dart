import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/orders_provider.dart';
import 'package:shop/widgets/main_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Orders>(context, listen: false).getOrdersFromWeb();
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);

    return Scaffold(
        appBar: AppBar(title: Text('Orders')),
        drawer: MainDrawer(),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: orders.getOrders.length,
                itemBuilder: (ctx, index) => orders.getOrders[index],
              ));
  }
}
