import 'package:flutter/material.dart';
import 'package:park_swipe/types.dart';

import 'models/parking_lot.dart';

class ReviewPage extends StatelessWidget {
  final List<ParkingLot> parkingLots;
  final Map<String, Rating> userRatings;

  const ReviewPage(
      {super.key, required this.parkingLots, required this.userRatings});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Page'),
      ),
      body: ListView.builder(
        itemCount: parkingLots.length,
        itemBuilder: (context, index) {
          Rating? userRating = userRatings[parkingLots[index].id];
          if (userRating != null) {
            return ParkingLotItem(
                parkingLot: parkingLots[index], userRating: userRating);
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

  const ParkingLotItem(
      {super.key, required this.parkingLot, required this.userRating});

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
        trailing: Text('Rating: $userRating'),
      ),
    );
  }
}
