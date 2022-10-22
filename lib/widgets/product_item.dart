import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:henkin_shop/providers/cart_provider.dart';
import 'package:henkin_shop/providers/product_provider.dart';
import 'package:henkin_shop/utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    final ProductProvider product =
        Provider.of<ProductProvider>(context, listen: false);
    final CartProvider cart = Provider.of<CartProvider>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<ProductProvider>(
            builder: (context, product, _) => IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              color: Theme.of(context).colorScheme.secondary,
              onPressed: () async {
                try {
                  await product.toggleFavorite();
                } catch (e) {
                  scaffold.removeCurrentSnackBar();
                  scaffold.showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.shopping_cart),
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              cart.addItem(product);
              scaffold.removeCurrentSnackBar();
              scaffold.showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 2),
                  content: const Text('Produto adicionado ao carrinho!'),
                  action: SnackBarAction(
                    label: 'DESFAZER',
                    onPressed: () => cart.removeSingleItem(product),
                  ),
                ),
              );
            },
          ),
        ),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
            AppRoutes.productDetails,
            arguments: product,
          ),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
