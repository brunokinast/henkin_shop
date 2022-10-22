import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:henkin_shop/providers/cart_provider.dart';
import 'package:henkin_shop/providers/orders_provider.dart';

class CartBuyButton extends StatefulWidget {
  final CartProvider cart;

  const CartBuyButton({
    required this.cart,
  });

  @override
  CartBuyButtonState createState() => CartBuyButtonState();
}

class CartBuyButtonState extends State<CartBuyButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Padding(
            padding: EdgeInsets.only(right: 40),
            child: CircularProgressIndicator(),
          )
        : ElevatedButton(
            //style from secondary color
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
            ),
            onPressed: widget.cart.productsCount == 0
                ? null
                : () async {
                    setState(() => _isLoading = true);
                    final scaffold = ScaffoldMessenger.of(context);
                    try {
                      await Provider.of<OrdersProvider>(context, listen: false)
                          .addOrder(widget.cart.toOrder());
                      widget.cart.clearCart();
                      scaffold
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                            const SnackBar(content: Text('Pedido realizado!')));
                    } catch (e) {
                      scaffold
                        ..removeCurrentSnackBar()
                        ..showSnackBar(SnackBar(content: Text(e.toString())));
                    } finally {
                      setState(() => _isLoading = false);
                    }
                  },
            child: Text(
              'COMPRAR',
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
            ),
          );
  }
}
