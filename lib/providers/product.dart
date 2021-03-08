import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavStatus(bool newStatus) {
    isFavorite = newStatus;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = 'YOUR REST API ENPOINT URL /products/$id.json';

    final response = await http.patch(
      url,
      body: json.encode(
        {
          'isFavorite': isFavorite,
        },
      ),
    );
    if (response.statusCode >= 400) {
      _setFavStatus(oldStatus);
      throw HttpException("Could not toggle the favorite status");
    }
  }
}
