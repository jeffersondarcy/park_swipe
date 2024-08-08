import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:park_swipe/parking_lot_swiper.dart';
import 'package:park_swipe/types.dart';

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
  Map<String, Rating> userRatings = {};
  bool _isInitialized = false;

  Future<void> _fetchMore(FetchMore? fetchMore) async {
    if (fetchMore == null) {
      return;
    }

    offset += limit;
    final QueryResult result = await fetchMore(FetchMoreOptions(
      variables: {
        'limit': limit,
        'offset': offset,
      },
      updateQuery: (previousResultData, fetchMoreResultData) {
        final List<dynamic> newParkingLotsData =
            fetchMoreResultData?['getAllParkingLots'] ?? [];

        return {
          'getAllParkingLots': newParkingLotsData,
        };
      },
    ));

    _setParkingLots(result);
  }

  void _rateParkingLot(String parkingLotId, Rating rating) {
    userRatings[parkingLotId] = rating;
  }

  void _rateGood(String parkingLotId) {
    _rateParkingLot(parkingLotId, Rating.Good);
  }

  void _rateBad(String parkingLotId) {
    _rateParkingLot(parkingLotId, Rating.Bad);
  }

  void _setParkingLots(QueryResult result) {
    setState(() {
      newParkingLots =
          parkingLotsDataToList(result.data?['getAllParkingLots'] ?? []);

      allParkingLots.addAll(newParkingLots);
    });
  }

  void _initParkingLots(QueryResult result) {
    if (!_isInitialized) {
      newParkingLots =
          parkingLotsDataToList(result.data?['getAllParkingLots'] ?? []);

      allParkingLots = [...newParkingLots];
      _isInitialized = true;
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

          _initParkingLots(result);

          return Stack(
            children: [
              ParkingLotSwiper(
                  parkingLots: newParkingLots,
                  onEnd: () => _fetchMore(fetchMore),
                  onSwipeLeft: _rateBad,
                  onSwipeRight: _rateGood),
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
