import 'package:flutter/material.dart';
import 'package:park_swipe/filters.dart';
import 'package:park_swipe/types.dart';

import 'filter_functions.dart';
import 'models/parking_lot.dart';

Widget _defaultListItemBuilder(ParkingLot parkingLot, Rating userRating) {
  return ParkingLotItem(
    parkingLot: parkingLot,
    userRating: userRating,
  );
}

// workaround for tests, to avoid using Image.network
Widget noImageListItemBuilder(ParkingLot parkingLot, Rating userRating) {
  return Card(
    child: ListTile(
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

class ReviewPage extends StatefulWidget {
  final List<ParkingLot> parkingLots;
  final Map<String, Rating> userRatings;
  final Widget Function(ParkingLot, Rating) listItemBuilder;

  const ReviewPage({
    super.key,
    required this.parkingLots,
    required this.userRatings,
    this.listItemBuilder = noImageListItemBuilder,
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
      ),
      body: Stack(children: [
        ListView.builder(
          itemCount: _parkingLots.length,
          itemBuilder: (context, index) {
            Rating? userRating = widget.userRatings[_parkingLots[index].id];
            if (userRating != null) {
              return widget.listItemBuilder(
                _parkingLots[index],
                userRating,
              );
            }
            return null;
          },
        ),
        Positioned(
          bottom: 48.0, // Adjusted to sit higher
          right: 48.0, // Adjusted to not be in the corner
          child: FloatingActionButton(
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
            child: const Icon(Icons.filter_list),
          ),
        ),
      ]),
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
