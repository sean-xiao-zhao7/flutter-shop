import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/providers/cart_provider.dart';
import 'package:shop/screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);

    return GridTile(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductDetailsScreen.routeName, arguments: product.id);
        },
        child: Image.network(
          product.imageUrl,
          fit: BoxFit.cover,
        ),
      ),
      footer: GridTileBar(
        leading: IconButton(
          icon: Icon(product.isFav ? Icons.favorite : Icons.favorite_border),
          onPressed: () {
            product.toggleFav();
          },
          color: Theme.of(context).accentColor,
        ),
        backgroundColor: Colors.black45,
        title: Text(
          product.title,
          textAlign: TextAlign.center,
          style:
              TextStyle(fontFamily: 'Cantarell', fontWeight: FontWeight.bold),
        ),
        trailing: IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () {
            cart.addCartItem(product.id, product.title, product.price);
          },
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}
