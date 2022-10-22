import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:henkin_shop/providers/cart_provider.dart';
import 'package:henkin_shop/providers/orders_provider.dart';
import 'package:henkin_shop/providers/products_provider.dart';
import 'package:henkin_shop/providers/settings_provider.dart';
import 'package:henkin_shop/utils/app_routes.dart';
import 'package:henkin_shop/views/cart_overview_screen.dart';
import 'package:henkin_shop/views/orders_overview_screen.dart';
import 'package:henkin_shop/views/product_detail_screen.dart';
import 'package:henkin_shop/views/product_form_screen.dart';
import 'package:henkin_shop/views/products_edit_screen.dart';
import 'package:henkin_shop/views/products_overview_screen.dart';
import 'package:henkin_shop/views/settings_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: MaterialApp(
        title: 'Minha Loja',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
          ),
          fontFamily: 'Lato',
        ),
        routes: {
          AppRoutes.home: (_) => ProductsOverviewScreen(),
          AppRoutes.productDetails: (_) => ProductDetailScreen(),
          AppRoutes.cartOverview: (_) => CartOverviewScreen(),
          AppRoutes.orders: (_) => OrdersOverviewScreen(),
          AppRoutes.settings: (_) => SettingsScreen(),
          AppRoutes.productsEdit: (_) => ProductsEditScreen(),
          AppRoutes.productForm: (_) => ProductFormScreen(),
        },
      ),
    );
  }
}
