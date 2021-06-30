import 'package:flutter/material.dart';
import 'package:shop/errors/http_exception.dart';
import 'package:shop/models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const firebaseURL =
    'https://flutter-553e7-default-rtdb.firebaseio.com/products.json';

class Products with ChangeNotifier {
  List<Product> _products = [];
  var _showFavoritesOnly = false;
  final String authToken;

  Products(this.authToken, this._products);

  List<Product> get products {
    if (_showFavoritesOnly) {
      return _products.where((element) => element.isFav).toList();
    }
    return [..._products];
  }

  Future<void> getProductsFromWeb() async {
    try {
      final res = await http.get(Uri.parse(firebaseURL + '?auth=$authToken'));
      final data = json.decode(res.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      data.forEach((id, product) {
        loadedProducts.add(Product(
          id: id,
          title: product['title'],
          description: product['description'],
          price: product['price'],
          imageUrl: product['imageUrl'],
          isFav: product['isFav'],
        ));
      });
      _products = loadedProducts;
      notifyListeners();
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Product findById(String id) {
    return _products.firstWhere((element) => element.id == id);
  }

  Future<void> removeById(String id) async {
    final url =
        firebaseURL.substring(0, firebaseURL.lastIndexOf('.')) + '/${id}.json';
    final existingProductIndex =
        _products.indexWhere((element) => element.id == id);
    var existingProduct = _products[existingProductIndex];
    _products.removeAt(existingProductIndex);
    notifyListeners();
    try {
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode >= 400) {
        throw HttpException('Error while removing product of ID $id.');
      }
      existingProduct = null;
    } catch (error) {
      _products.insert(existingProductIndex, existingProduct);
    }
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

  Future<void> updateProduct(Product newProduct) async {
    final index =
        _products.indexWhere((element) => element.id == newProduct.id);
    if (index < 0) {
      print('Error updating product.');
      return;
    } else {
      final url = firebaseURL.substring(0, firebaseURL.lastIndexOf('.')) +
          '/${newProduct.id}.json';
      http.patch(Uri.parse(url),
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
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
