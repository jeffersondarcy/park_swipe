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
  final int limit = 5;
  int offset = 0;
  List<ParkingLot> parkingLots = [];

  void _loadMoreResults() {
    setState(() {
      offset += limit;
    });
  }

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
          List<ParkingLot> newParkingLots =
              parkingLotsData.map<ParkingLot>((data) {
            return ParkingLot.fromJson(data);
          }).toList();

          parkingLots.addAll(newParkingLots);

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
      floatingActionButton: FloatingActionButton(
        onPressed: _loadMoreResults,
        child: const Icon(Icons.add),
      ),
    );
  }
}
