import 'package:flutter/material.dart';
import 'package:park_swipe/filters.dart';
import 'package:park_swipe/types.dart';

import 'filter_functions.dart';
import 'models/parking_lot.dart';

class ReviewPage extends StatefulWidget {
  final List<ParkingLot> parkingLots;
  final Map<String, Rating> userRatings;

  const ReviewPage({
    super.key,
    required this.parkingLots,
    required this.userRatings,
  });

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late List<ParkingLot> _parkingLots;
  late FilterSettings _filterSettings;

  @override
  void initState() {
    super.initState();
    _filterSettings = FilterSettings();
    _parkingLots = applyAllFilters(
        widget.parkingLots, widget.userRatings, _filterSettings);
  }

  void _updateFilterSettings(FilterSettings newSettings) {
    setState(() {
      _filterSettings = newSettings;
      _parkingLots = applyAllFilters(
          widget.parkingLots, widget.userRatings, _filterSettings);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Filters(
                    filterSettings: _filterSettings,
                    onFilterSettingsChanged: _updateFilterSettings,
                  );
                },
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _parkingLots.length,
        itemBuilder: (context, index) {
          Rating? userRating = widget.userRatings[_parkingLots[index].id];
          if (userRating != null) {
            return ParkingLotItem(
              parkingLot: _parkingLots[index],
              userRating: userRating,
            );
          }
          return null;
        },
      ),
    );
  }
}

class ParkingLotItem extends StatelessWidget {
  final ParkingLot parkingLot;
  final Rating userRating;

  const ParkingLotItem({
    super.key,
    required this.parkingLot,
    required this.userRating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(
          parkingLot.image,
          fit: BoxFit.scaleDown,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(parkingLot.name),
            Text('ID: ${parkingLot.id}', style: const TextStyle(fontSize: 12)),
          ],
        ),
        subtitle: Text(parkingLot.address),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Rating: '),
            _getRatingIcon(userRating),
          ],
        ),
      ),
    );
  }
}

Icon _getRatingIcon(Rating rating) {
  if (rating == Rating.good) {
    return const Icon(Icons.thumb_up, color: Colors.green);
  } else {
    return const Icon(Icons.thumb_down, color: Colors.red);
  }
}
