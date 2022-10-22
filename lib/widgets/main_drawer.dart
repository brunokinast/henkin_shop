import 'package:flutter/material.dart';
import 'package:henkin_shop/utils/app_routes.dart';

class MainDrawer extends StatelessWidget {
  Widget _createOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String route,
    bool divider = true,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon),
          title: Text(title),
          onTap: () => Navigator.of(context).pushReplacementNamed(route),
        ),
        if (divider) const Divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            centerTitle: true,
            title: const Text('Bem-vindo a loja'),
            automaticallyImplyLeading: false,
          ),
          _createOption(
            context: context,
            icon: Icons.store,
            title: 'Loja',
            route: AppRoutes.home,
          ),
          _createOption(
            context: context,
            icon: Icons.shopping_bag,
            title: 'Pedidos',
            route: AppRoutes.orders,
          ),
          _createOption(
            context: context,
            icon: Icons.edit,
            title: 'Gerenciar produtos',
            route: AppRoutes.productsEdit,
          ),
          const Spacer(),
          const Divider(),
          //Parte inferior
          _createOption(
            context: context,
            icon: Icons.settings,
            title: 'Configurações',
            route: AppRoutes.settings,
            divider: false,
          ),
        ],
      ),
    );
  }
}
