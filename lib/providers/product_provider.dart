import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:henkin_shop/exceptions/http_exception.dart';
import 'package:henkin_shop/utils/constants.dart';

class ProductProvider with ChangeNotifier {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  ProductProvider({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  ProductProvider.fromJson(this.id, Map<String, dynamic> json)
      : title = json['title'] as String,
        description = json['description'] as String,
        price = json['price'] as double,
        imageUrl = json['imageUrl'] as String,
        isFavorite = json['isFavorite'] as bool;

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'isFavorite': isFavorite,
      };

  Future<void> toggleFavorite() async {
    isFavorite = !isFavorite;
    notifyListeners();
    final response = await http.patch(
      Uri.parse('${Constants.productsUrl}/$id.json'),
      body: json.encode({'isFavorite': isFavorite}),
    );
    if (response.statusCode >= 400) {
      isFavorite = !isFavorite;
      notifyListeners();
      throw const HttpException('Ocorreu um erro ao favoritar o produto.');
    }
  }
}
