import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:park_swipe/parking_lot_swiper.dart';

import 'graphql/queries.dart';
import 'models/parking_lot.dart';

class ParkingLotBrowserPage extends StatefulWidget {
  const ParkingLotBrowserPage({super.key});

  @override
  State<ParkingLotBrowserPage> createState() => _ParkingLotBrowserPageState();
}

class _ParkingLotBrowserPageState extends State<ParkingLotBrowserPage> {
  final int limit = 5;
  int offset = 0;
  List<ParkingLot> allParkingLots = [];
  List<ParkingLot> newParkingLots = [];

  void _fetchMore(FetchMore? fetchMore) {
    if (fetchMore != null) {
      fetchMore(FetchMoreOptions(
        variables: {
          'limit': limit,
          'offset': offset + limit,
        },
        updateQuery: (previousResultData, fetchMoreResultData) {
          final List<dynamic> newParkingLotsData =
              fetchMoreResultData?['getAllParkingLots'] ?? [];
          final List<dynamic> allParkingLotsData =
              List.from(previousResultData?['getAllParkingLots'] ?? [])
                ..addAll(newParkingLotsData);

          setState(() {
            offset += limit;
            newParkingLots = parkingLotsDataToList(newParkingLotsData);
            allParkingLots.addAll(newParkingLots);
          });

          return {
            'getAllParkingLots': allParkingLotsData,
          };
        },
      ));
    }
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

          newParkingLots =
              parkingLotsDataToList(result.data?['getAllParkingLots'] ?? []);

          allParkingLots.addAll(newParkingLots);

          return Stack(
            children: [
              ParkingLotSwiper(parkingLots: newParkingLots),
              Positioned(
                bottom: 16.0,
                right: 16.0,
                child: FloatingActionButton(
                  onPressed: () => _fetchMore(fetchMore),
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

List<ParkingLot> parkingLotsDataToList(List parkingLotsData) {
  return parkingLotsData.map<ParkingLot>((data) {
    return ParkingLot.fromJson(data);
  }).toList();
}
