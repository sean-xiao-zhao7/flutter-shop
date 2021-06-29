import 'dart:convert';
import 'package:flutter/widgets.dart';
import '../info/info.dart';
import 'package:http/http.dart' as http;

var url = 'https://identitytoolkit.googleapis.com/v1/accounts:mode?key=$fbak';

class AuthProvider with ChangeNotifier {
  String _authToken;
  DateTime _tokenExpiry;
  String _authId;

  Future<void> register(
    String username,
    String password,
  ) async {
    try {
      final res = await http.post(
        Uri.parse(url.replaceAll(RegExp(r'mode'), 'signUp')),
        body: json.encode({
          'email': username,
          'password': password,
          'returnSecureToken': true,
        }),
      );
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> login(
    String username,
    String password,
  ) async {
    try {
      final res = await http.post(
        Uri.parse(url.replaceAll(RegExp(r'mode'), 'signIn')),
        body: json.encode({
          'email': username,
          'password': password,
          'returnSecureToken': true,
        }),
      );
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
