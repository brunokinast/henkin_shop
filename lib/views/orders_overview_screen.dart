import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:henkin_shop/providers/orders_provider.dart';
import 'package:henkin_shop/widgets/main_drawer.dart';
import 'package:henkin_shop/widgets/order_item.dart';

final appBar = AppBar(
  title: const Text('Meus pedidos'),
);

class OrdersOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: appBar,
      body: BodyWidget(context),
    );
  }
}

class BodyWidget extends StatefulWidget {
  final BuildContext ctx;

  const BodyWidget(this.ctx);

  @override
  BodyWidgetState createState() => BodyWidgetState();
}

class BodyWidgetState extends State<BodyWidget> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() {
    return Provider.of<OrdersProvider>(context, listen: false)
        .loadOrders()
        .catchError((e) => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString()))))
        .then((_) => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    final OrdersProvider orders = Provider.of<OrdersProvider>(context);
    return RefreshIndicator(
      onRefresh: _refresh,
      child: Container(
        child: orders.itemCount == 0 || _isLoading
            ? SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  width: MediaQuery.of(widget.ctx).size.width,
                  height: MediaQuery.of(widget.ctx).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(widget.ctx).padding.top,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Center(child: Text('Nenhum pedido realizado!')),
                ),
              )
            : ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: orders.itemCount,
                itemBuilder: (ctx, i) => OrderItem(orders.orders[i]),
              ),
      ),
    );
  }
}
