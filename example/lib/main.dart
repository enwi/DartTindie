import 'package:darttindie/darttindie.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tindie Order Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final tindie = Tindie(
    apikey: 'enter your api key',
    username: 'enter your username',
  );
  bool _all = true;
  bool _shipped = false;
  Future<List<Order>> _future = Future.value([]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tindie Order Demo'),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              const Text('Fetch all orders?'),
              Switch(
                  value: _all,
                  onChanged: (value) => setState(() {
                        _all = value;
                      })),
            ],
          ),
          Row(
            children: [
              const Text('Only fetch shipped orders'),
              Switch(
                  value: _shipped,
                  onChanged: (value) => setState(() {
                        _all = false;
                        _shipped = value;
                      })),
            ],
          ),
          MaterialButton(
            onPressed: () => setState(() {
              _future = _all
                  ? tindie.getOrders()
                  : tindie.getOrders(shipped: _shipped);
            }),
            textColor: Colors.white,
            color: Colors.blue,
            child: const Text('Request'),
          ),
          Expanded(
            child: FutureBuilder<List<Order>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var order = snapshot.data![index];
                      return ListTile(
                        title: Text(order.items.fold(
                            '',
                            (value, element) => value == ''
                                ? '${element.quantity}x ${element.product}'
                                : '$value, ${element.quantity}x ${element.product}')),
                        subtitle: Text('#${order.number}'),
                        trailing: Icon(order.dateShipped == null
                            ? Icons.warning
                            : Icons.local_shipping_rounded),
                      );
                    },
                  );
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('There was an error fetching orders'),
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
          )
        ],
      ),
    );
  }
}
