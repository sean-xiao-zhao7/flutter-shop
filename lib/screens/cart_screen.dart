import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart_provider.dart';
import 'package:shop/providers/orders_provider.dart';
import 'package:shop/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final orders = Provider.of<Orders>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          title: Text('Cart'),
        ),
        body: Column(
          children: [
            Card(
                margin: EdgeInsets.all(15),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Total',
                        style: TextStyle(fontSize: 20),
                      ),
                      Spacer(),
                      Chip(
                        label: Text(
                          '\$ ${cart.totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      FlatButton(
                          onPressed: () {
                            orders.addOrders(cart.getItems.values.toList(),
                                cart.totalAmount);
                            cart.clear();
                          },
                          child: Text('Order now'))
                    ],
                  ),
                )),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: cart.itemCount,
                itemBuilder: (ctx, index) => CartItemWidget(
                    cart.getItems.values.toList()[index].id,
                    cart.getItems.keys.toList()[index],
                    cart.getItems.values.toList()[index].title,
                    cart.getItems.values.toList()[index].price,
                    cart.getItems.values.toList()[index].quantity),
              ),
            ),
          ],
        ));
  }
}
