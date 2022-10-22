import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:henkin_shop/exceptions/http_exception.dart';
import 'package:henkin_shop/models/cart_item.dart';
import 'package:henkin_shop/utils/constants.dart';

class Order {
  final String? id;
  final List<CartItem> items;
  final double total;
  final DateTime date;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.date,
  });

  Order.fromJson(this.id, Map<String, dynamic> map)
      : items = (map['items'] as List<dynamic>)
            .map((e) => CartItem.fromJson(
                UniqueKey().toString(), e as Map<String, dynamic>))
            .toList(),
        total = map['total'] as double,
        date = DateTime.parse(map['date'] as String);

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'items': items.map((i) => i.toJson()).toList(),
      'total': double.parse((items.fold<double>(
              0.0, (t, item) => t += item.price * item.quantity))
          .toStringAsFixed(2)),
    };
  }
}

class OrdersProvider with ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => [..._orders];
  int get itemCount => _orders.length;

  Future<void> loadOrders() async {
    _orders.clear();
    final List<Order> loadedOrders = [];
    final response = await http.get(Uri.parse('${Constants.ordersUrl}.json'));
    if (response.statusCode >= 400) {
      throw const HttpException('Ocorreu um erro ao carregar os pedidos.');
    } else {
      final Map<String, dynamic>? map =
          json.decode(response.body) as Map<String, dynamic>?;
      map?.forEach((orderId, order) {
        loadedOrders
            .add(Order.fromJson(orderId, order as Map<String, dynamic>));
      });
    }
    _orders.addAll(loadedOrders.reversed);
  }

  Future<void> addOrder(Order order) async {
    final response = await http.post(Uri.parse('${Constants.ordersUrl}.json'),
        body: json.encode(order.toJson()));
    if (response.statusCode >= 400) {
      throw const HttpException('Ocorreu um erro ao finalizar o pedido.');
    } else {
      _orders.add(Order(
        id: json.decode(response.body)['name'] as String,
        items: order.items,
        total: order.total,
        date: order.date,
      ));
    }
  }
}
