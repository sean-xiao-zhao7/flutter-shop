import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const firebaseURL =
    'https://flutter-553e7-default-rtdb.firebaseio.com/products.json';

class Products with ChangeNotifier {
  final List<Product> _products = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];
  var _showFavoritesOnly = false;

  List<Product> get products {
    if (_showFavoritesOnly) {
      return _products.where((element) => element.isFav).toList();
    }
    return [..._products];
  }

  Future<void> getProductsFromWeb() async {
    try {
      final res = await http.get(Uri.parse(firebaseURL));
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Product findById(String id) {
    return _products.firstWhere((element) => element.id == id);
  }

  void removeById(String id) {
    _products.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    var url = Uri.parse(firebaseURL);

    try {
      final res = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFav': product.isFav,
          }));

      final newProduct = Product(
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
          id: json.decode(res.body)['name']);
      _products.add(newProduct);
      notifyListeners();
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  void updateProduct(Product newProduct) {
    final index =
        _products.indexWhere((element) => element.id == newProduct.id);
    if (index < 0) {
      print('Error updating product.');
      return;
    } else {
      _products[index] = newProduct;
      notifyListeners();
    }
  }

  void showFavoritesOnly() {
    _showFavoritesOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavoritesOnly = false;
    notifyListeners();
  }
}
