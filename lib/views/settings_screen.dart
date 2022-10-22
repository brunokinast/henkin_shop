import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:henkin_shop/providers/settings_provider.dart';
import 'package:henkin_shop/widgets/main_drawer.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: ListView(
        children: [
          SwitchListTile.adaptive(
            title: const Text('Mostrar total de items'),
            subtitle: const Text(
                'Exibe o total de items invés do total de produtos no ícone do carrinho'),
            value: settings.showQuantityCount,
            onChanged: (value) => settings.showQuantityCount = value,
          ),
          SwitchListTile.adaptive(
            title: const Text('Confirmar remoção do carrinho'),
            subtitle: const Text(
                'Exige uma confirmação ao tentar remover um produto do carrinho'),
            value: settings.showCartRemoveConfirm,
            onChanged: (value) => settings.showCartRemoveConfirm = value,
          )
        ],
      ),
    );
  }
}
