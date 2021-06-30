import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:shop/errors/http_exception.dart';
import '../info/info.dart';
import 'package:http/http.dart' as http;

var url = 'https://identitytoolkit.googleapis.com/v1/accounts:mode?key=$fbak';

class AuthProvider with ChangeNotifier {
  String _authToken;
  DateTime _tokenExpiry;
  String _authId;

  bool get isAuth {
    return getAuthToken != null;
  }

  String get getAuthToken {
    if (_authToken != null &&
        _tokenExpiry != null &&
        _tokenExpiry.isAfter(DateTime.now())) {
      return _authToken;
    }

    return null;
  }

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
      final data = json.decode(res.body);

      if (data['error'] != null) {
        throw HttpException(data['error']['message']);
      }

      _authToken = data['idToken'];
      _authId = data['localId'];
      _tokenExpiry =
          DateTime.now().add(Duration(seconds: int.parse(data['expiresIn'])));
      notifyListeners();
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
        Uri.parse(url.replaceAll(RegExp(r'mode'), 'signInWithPassword')),
        body: json.encode({
          'email': username,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final data = json.decode(res.body);

      if (data['error'] != null) {
        throw HttpException(data['error']['message']);
      }
      _authToken = data['idToken'];
      _authId = data['localId'];
      _tokenExpiry =
          DateTime.now().add(Duration(seconds: int.parse(data['expiresIn'])));

      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
