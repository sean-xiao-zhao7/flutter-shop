import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const firebaseURL =
    'https://flutter-553e7-default-rtdb.firebaseio.com/products.json';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFav;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFav = false,
  });

  void toggleFav() async {
    final oldStatus = isFav;
    isFav = !isFav;
    notifyListeners();

    final url =
        firebaseURL.substring(0, firebaseURL.lastIndexOf('.')) + '/${id}.json';
    try {
      await http.patch(Uri.parse(url), body: json.encode({'isFav': isFav}));
    } catch (e) {
      isFav = oldStatus;
    }
  }
}
