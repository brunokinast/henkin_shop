import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:henkin_shop/providers/cart_provider.dart';
import 'package:henkin_shop/providers/products_provider.dart';
import 'package:henkin_shop/providers/settings_provider.dart';
import 'package:henkin_shop/utils/app_routes.dart';
import 'package:henkin_shop/widgets/main_drawer.dart';
import 'package:henkin_shop/widgets/products_grid.dart';

enum FilterOptions {
  all,
  favorite,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  ProductsOverviewScreenState createState() => ProductsOverviewScreenState();
}

class ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavorites = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refresh(context);
  }

  Future<void> _refresh(BuildContext context) {
    return Provider.of<ProductsProvider>(context, listen: false)
        .loadProducts()
        .then((_) => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: const Text('Minha loja'),
        actions: [
          PopupMenuButton(
            onSelected: (value) => setState(
                () => _showOnlyFavorites = value == FilterOptions.favorite),
            icon: const Icon(Icons.filter_list),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.all,
                child: Text('Todos'),
              ),
              const PopupMenuItem(
                value: FilterOptions.favorite,
                child: Text('Somente favoritos'),
              ),
            ],
          ),
          Consumer2<CartProvider, SettingsProvider>(
            builder: (context, cart, settings, _) => Badge(
              animationType: BadgeAnimationType.slide,
              badgeColor: Theme.of(context).colorScheme.secondary,
              badgeContent: Text(
                settings.showQuantityCount
                    ? cart.quantityCount.toString()
                    : cart.productsCount.toString(),
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
              ),
              position: BadgePosition.topEnd(top: 3, end: 3),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.cartOverview),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () => _refresh(context),
              child: ProductsGrid(_showOnlyFavorites)),
    );
  }
}
