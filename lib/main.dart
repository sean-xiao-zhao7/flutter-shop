import 'package:flutter/material.dart';
import 'package:shop/screens/products_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.cyanAccent,
        fontFamily: 'Cantarell',
      ),
      home: ProductsOverviewScreen(),
    );
  }
}
