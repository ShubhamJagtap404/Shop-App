import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // var _isLoading = false;
  //@override
  // void initState() {
  // Future.delayed(Duration.zero).then((_) async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  //   setState(() {
  //     _isLoading = false;
  //   });
  // });
  // super.initState();
  // }

    Future _orderFuture;

    Future _setOrderFuture(){
      return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
    }

    @override
    void initState() {
      _orderFuture = _setOrderFuture(); 
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future:
              _orderFuture,
          builder: (ctx, dataSnapshoot) {
            if (dataSnapshoot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapshoot.error != null) {
                return Center(
                  child: Text(
                      "Something went wrong. Please close and restart the app."),
                );
              } else {
                return Consumer<Orders>(
                  builder: (ctx, orderData, child) => ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                  ),
                );
              }
            }
          },
        ));
  }
}
