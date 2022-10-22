import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:henkin_shop/providers/orders_provider.dart';

class OrderItem extends StatelessWidget {
  final Order order;

  const OrderItem(this.order);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(
          'R\$ ${order.total.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          DateFormat('dd/MM/y HH:mm').format(order.date),
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: order.items.map((i) {
              return Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  bottom: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      i.title,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Text(
                      '${i.quantity} x R\$ ${i.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
