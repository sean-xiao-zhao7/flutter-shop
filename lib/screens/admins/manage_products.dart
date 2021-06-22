import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/screens/admins/edit_product_screen.dart';
import 'package:shop/screens/admins/manage_product_item.dart';
import 'package:shop/widgets/main_drawer.dart';

class ManageProductsScreen extends StatelessWidget {
  static const routeName = '/manage-products';

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage your products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: products.products.length,
            itemBuilder: (_, index) {
              return Column(
                children: <Widget>[
                  ManageProductItem(products.products[index].title,
                      products.products[index].imageUrl),
                  Divider(),
                ],
              );
            },
          )),
    );
  }
}
