import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'graphql/queries.dart';
import 'models/parking_lot.dart';
import 'parking_lot_card.dart';

class ParkingLotBrowserPage extends StatefulWidget {
  const ParkingLotBrowserPage({super.key});

  @override
  State<ParkingLotBrowserPage> createState() => _ParkingLotBrowserPageState();
}

class _ParkingLotBrowserPageState extends State<ParkingLotBrowserPage> {
  final int limit = 3;
  int offset = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking Lot Browser'),
      ),
      body: Query(
        options: QueryOptions(
          document: gql(getAllParkingLotsQuery),
          variables: {
            'limit': limit,
            'offset': offset,
          },
        ),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            return Center(
              child: Text(result.exception.toString()),
            );
          }

          if (result.isLoading && result.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List parkingLotsData = result.data?['getAllParkingLots'] ?? [];
          List<ParkingLot> parkingLots = parkingLotsData.map((data) {
            return ParkingLot(
              address: data['address'],
              id: data['id'],
              image: data['image'],
              liveDate: data['live_date'],
              name: data['name'],
              size: data['size'],
              status: data['status'],
              type: data['type'],
            );
          }).toList();

          return ListView.builder(
            itemCount: parkingLots.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ParkingLotCard(parkingLot: parkingLots[index]),
              );
            },
          );
        },
      ),
    );
  }
}
