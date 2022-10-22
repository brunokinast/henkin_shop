import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:henkin_shop/exceptions/http_exception.dart';
import 'package:henkin_shop/providers/product_provider.dart';
import 'package:henkin_shop/utils/constants.dart';

class ProductsProvider with ChangeNotifier {
  final List<ProductProvider> _items = [];

  List<ProductProvider> get items => [..._items];
  int get itemsCount => _items.length;
  List<ProductProvider> get favoriteItems =>
      _items.where((prod) => prod.isFavorite).toList();

  Future<void> loadProducts() async {
    _items.clear();
    final response = await http.get(Uri.parse('${Constants.productsUrl}.json'));
    final Map<String, dynamic>? map =
        json.decode(response.body) as Map<String, dynamic>?;
    map?.forEach((id, json) =>
        _items.add(ProductProvider.fromJson(id, json as Map<String, dynamic>)));
    notifyListeners();
  }

  Future<void> addProduct(ProductProvider product) async {
    final response = await http.post(
      Uri.parse('${Constants.productsUrl}.json'),
      body: json.encode(product.toJson()),
    );
    if (response.statusCode >= 400) {
      throw const HttpException('Ocorreu um erro ao adicionar o produto.');
    } else {
      _items.add(ProductProvider(
        id: json.decode(response.body)['name'] as String?,
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      ));
      notifyListeners();
    }
  }

  Future<void> updateProduct(ProductProvider product) async {
    final i = _items.indexWhere((prod) => prod.id == product.id);
    if (i >= 0) {
      final oldProd = _items[i];
      _items[i] = product;
      notifyListeners();
      final response = await http.patch(
        Uri.parse('${Constants.productsUrl}/${product.id}.json'),
        body: json.encode(product.toJson()),
      );
      if (response.statusCode >= 400) {
        _items[i] = oldProd;
        notifyListeners();
        throw const HttpException('Ocorreu um erro ao atualizar o produto.');
      }
    }
  }

  Future<void> removeProduct(ProductProvider product) async {
    final index = _items.indexOf(product);
    _items.remove(product);
    notifyListeners();
    final response = await http
        .delete(Uri.parse('${Constants.productsUrl}/${product.id}.json'));
    if (response.statusCode >= 400) {
      _items.insert(index, product);
      notifyListeners();
      throw const HttpException('Ocorreu um erro ao remover o produto.');
    }
  }
}
