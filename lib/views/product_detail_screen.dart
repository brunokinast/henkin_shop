import 'package:flutter/material.dart';
import 'package:henkin_shop/providers/product_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProductProvider product =
        ModalRoute.of(context)!.settings.arguments as ProductProvider;
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
              height: 300,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                product.title,
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
            ),
            Chip(
              backgroundColor: Theme.of(context).primaryColor,
              label: Text(
                'R\$ ${product.price.toStringAsFixed(2)}',
                style: Theme.of(context).primaryTextTheme.headline5,
              ),
            ),
            Card(
              margin: const EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Descrição:',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Text(product.description),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
