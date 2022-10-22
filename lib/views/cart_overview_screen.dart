import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:henkin_shop/providers/cart_provider.dart';
import 'package:henkin_shop/widgets/cart_buy_button.dart';
import 'package:henkin_shop/widgets/cart_item_widget.dart';

class CartOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CartProvider cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Text(
                    'Total:',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Chip(
                      backgroundColor: Theme.of(context).primaryColor,
                      label: Text(
                        'R\$ ${cart.totalPrice.toStringAsFixed(2)}',
                        style: Theme.of(context).primaryTextTheme.subtitle1,
                      ),
                    ),
                  ),
                  const Spacer(),
                  CartBuyButton(cart: cart),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.productsCount,
              itemBuilder: (ctx, i) =>
                  CartItemWidget(cart.items.values.toList()[i]),
            ),
          ),
        ],
      ),
    );
  }
}
