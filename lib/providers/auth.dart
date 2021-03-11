import 'dart:async';

import 'package:flutter/widgets.dart';
import '../models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String authType) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$authType?key=AIzaSyALmlmcnlsQT0QaFBEYHL3zoZyONUpIAc4";
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseBody = json.decode(response.body);
      if (responseBody.containsKey('error') && responseBody['error'] != null) {
        throw HttpException(responseBody['error']['message']);
      }
      _token = responseBody['idToken'];
      _userId = responseBody['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseBody['expiresIn']),
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

<<<<<<< HEAD
  Future<void> login(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
=======
  Future<void> signup(String email, String password) async{
    const url = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=[API KEY]";
    final response = await http.post(url, body: json.encode({
      'email': email,
      'password': password,
      'returnSecureToken': true,
    }));
    print(json.decode(response.body));
>>>>>>> 4ed4757d3cbd8ea1d172b71d0079df29eaf9ac60
  }
}
