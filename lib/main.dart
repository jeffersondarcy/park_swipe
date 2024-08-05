import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:park_swipe/parking_lot_browser_page.dart';

import 'graphql/service.dart';

void main() async {
  await initHiveForFlutter();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
        client: GraphQLService().client,
        child: MaterialApp(
          title: 'Parking Lot Swipe',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const ParkingLotBrowserPage(),
        ));
  }
}
