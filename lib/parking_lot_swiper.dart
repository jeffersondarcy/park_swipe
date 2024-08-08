import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

import 'models/parking_lot.dart';
import 'parking_lot_card.dart';

class ParkingLotSwiper extends StatelessWidget {
  const ParkingLotSwiper({
    super.key,
    required this.parkingLots,
    required this.onSwipeLeft,
    required this.onSwipeRight,
    this.onEnd,
  });

  final List<ParkingLot> parkingLots;
  final void Function(String) onSwipeLeft;
  final void Function(String) onSwipeRight;
  final CardSwiperOnEnd? onEnd;

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    String parkingLotId = parkingLots[previousIndex].id;
    if (direction == CardSwiperDirection.left) {
      onSwipeLeft(parkingLotId);
    } else if (direction == CardSwiperDirection.right) {
      onSwipeRight(parkingLotId);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return CardSwiper(
      allowedSwipeDirection:
          const AllowedSwipeDirection.symmetric(horizontal: true),
      numberOfCardsDisplayed: 1,
      onSwipe: _onSwipe,
      maxAngle: 10,
      isLoop: false,
      cardsCount: parkingLots.length,
      onEnd: onEnd,
      cardBuilder: (context, index, percentThresholdX, percentThresholdY) =>
          ParkingLotCard(parkingLot: parkingLots[index]),
    );
  }
}
