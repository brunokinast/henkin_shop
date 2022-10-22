import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:henkin_shop/providers/product_provider.dart';
import 'package:henkin_shop/providers/products_provider.dart';
import 'package:henkin_shop/utils/app_routes.dart';

class ProductEditItem extends StatelessWidget {
  final ProductProvider product;

  const ProductEditItem(this.product);

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    final ProductsProvider products = Provider.of<ProductsProvider>(context);
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(product.imageUrl),
            radius: 25,
          ),
          title: Text(product.title),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () => Navigator.of(context).pushNamed(
                        AppRoutes.productForm,
                        arguments: product,
                      )),
              IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).errorColor,
                  ),
                  onPressed: () {
                    showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Excluir produto'),
                        content: const Text(
                            'Tem certeza que deseja excluir o produto?'),
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
                    ).then((value) async {
                      try {
                        if (value ?? false)
                          await products.removeProduct(product);
                      } catch (e) {
                        scaffold.removeCurrentSnackBar();
                        scaffold.showSnackBar(
                            SnackBar(content: Text(e.toString())));
                      }
                    });
                  }),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
