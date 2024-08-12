import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:park_swipe/models/parking_lot.dart';
import 'package:park_swipe/review_page.dart';
import 'package:park_swipe/types.dart';

class MockParkingLotItem extends Mock implements ParkingLotItem {
  @override
  final ParkingLot parkingLot;
  @override
  final Rating userRating;

  MockParkingLotItem(this.parkingLot, this.userRating);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.local_parking), // Replace image with an icon
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
