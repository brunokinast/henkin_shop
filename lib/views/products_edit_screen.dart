import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:henkin_shop/providers/products_provider.dart';
import 'package:henkin_shop/utils/app_routes.dart';
import 'package:henkin_shop/widgets/main_drawer.dart';
import 'package:henkin_shop/widgets/product_edit_item.dart';

class ProductsEditScreen extends StatelessWidget {
  Future<void> _refresh(BuildContext context) {
    return Provider.of<ProductsProvider>(context, listen: false).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: const Text('Gerenciar produtos'),
    );
    final ProductsProvider products = Provider.of<ProductsProvider>(context);
    return Scaffold(
      drawer: MainDrawer(),
      appBar: appBar,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.of(context).pushNamed(AppRoutes.productForm),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refresh(context),
        child: products.itemsCount == 0
            ? SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top,
                  child:
                      const Center(child: Text('Nenhum produto cadastrado!')),
                ),
              )
            : Column(
                children: [
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: products.itemsCount,
                      itemBuilder: (ctx, i) =>
                          ProductEditItem(products.items[i]),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
