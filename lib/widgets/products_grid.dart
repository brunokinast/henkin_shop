import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:henkin_shop/providers/product_provider.dart';
import 'package:henkin_shop/providers/products_provider.dart';
import 'package:henkin_shop/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showOnlyFavorites;

  const ProductsGrid(this.showOnlyFavorites);

  @override
  Widget build(BuildContext context) {
    final List<ProductProvider> loadedProducts = showOnlyFavorites
        ? Provider.of<ProductsProvider>(context).favoriteItems
        : Provider.of<ProductsProvider>(context).items;
    return loadedProducts.isEmpty
        ? const Center(child: Text('Nenhum produto cadastrado!'))
        : GridView.builder(
            padding: const EdgeInsets.all(5),
            itemCount: loadedProducts.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 345,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: loadedProducts[i],
              child: ProductItem(),
            ),
          );
  }
}
