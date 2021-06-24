import 'package:flutter/material.dart';
import 'package:shop/providers/cart_provider.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/widgets/badge.dart';
import 'package:shop/widgets/main_drawer.dart';
import 'package:shop/widgets/product_item.dart';
import 'package:provider/provider.dart';

enum FavoriteOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  @override
  void initState() {
    //Provider.of<Products>(context).getProductsFromWeb();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shop',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(
              Icons.more_vert_sharp,
              color: Colors.white,
            ),
            itemBuilder: (_) {
              return [
                PopupMenuItem(
                    child: Text('Only favorites'),
                    value: FavoriteOptions.Favorites),
                PopupMenuItem(
                    child: Text('Show all'), value: FavoriteOptions.All),
              ];
            },
            onSelected: (FavoriteOptions v) {
              if (v == FavoriteOptions.Favorites) {
                productsProvider.showFavoritesOnly();
              } else {
                productsProvider.showAll();
              }
            },
          ),
          Consumer<Cart>(
            builder: (_, cartData, child) => Badge(
              child: child,
              value: cartData.itemCount.toString(),
              color: Theme.of(context).primaryColor,
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_bag),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: MyGridView(),
    );
  }
}

class MyGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = productsData.products;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          value: products[index],
          child: ProductItem(),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
    );
  }
}
