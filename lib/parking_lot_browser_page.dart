import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:park_swipe/parking_lot_swiper.dart';
import 'package:park_swipe/review_page.dart';
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
  UniqueKey _key1 = UniqueKey();
  UniqueKey _key2 = UniqueKey();

  bool _isInitialized = false;

  void _reset() {
    setState(() {
      userRatings = {};
      offset = limit;
      newParkingLots = [...allParkingLots];
      _key1 = UniqueKey();
      _key2 = UniqueKey();
    });
  }

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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reset,
          ),
        ],
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
                  key: _key1,
                  parkingLots: newParkingLots,
                  onEnd: () => _fetchMore(fetchMore),
                  onSwipeLeft: _rateBad,
                  onSwipeRight: _rateGood),
              Positioned(
                bottom: 48.0, // Adjusted to sit higher
                right: 48.0, // Adjusted to not be in the corner
                child: SizedBox(
                  width: 150, // Increased width
                  height: 60, // Increased height
                  child: FloatingActionButton(
                    key: _key2,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewPage(
                            parkingLots: allParkingLots,
                            userRatings: userRatings,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Review Results',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16), // Increased text size
                    ),
                  ),
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
