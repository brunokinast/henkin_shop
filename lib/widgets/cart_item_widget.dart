import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:henkin_shop/models/cart_item.dart';
import 'package:henkin_shop/providers/cart_provider.dart';
import 'package:henkin_shop/providers/settings_provider.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;

  const CartItemWidget(this.item);

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    return Dismissible(
      confirmDismiss: settings.showCartRemoveConfirm
          ? (_) => showDialog(
                builder: (ctx) => AlertDialog(
                  title: const Text('Tem certeza?'),
                  content: const Text(
                      'Tem certeza que deseja remover o produto do carrinho?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Não'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Sim'),
                    ),
                  ],
                ),
                context: context,
              )
          : null,
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) =>
          Provider.of<CartProvider>(context, listen: false).removeItem(item),
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        child: const Padding(
          padding: EdgeInsets.only(right: 15),
          child: Icon(
            Icons.delete,
            size: 40,
            color: Colors.white,
          ),
        ),
      ),
      child: Card(
        margin: const EdgeInsets.only(
          left: 15,
          right: 15,
          bottom: 5,
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(item.product.imageUrl),
          ),
          title: Text(item.title),
          subtitle: Text(
              'Total: R\$ ${(item.price * item.quantity).toStringAsFixed(2)}'),
          trailing: Text(
            '${item.quantity}x',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
      ),
    );
  }
}
