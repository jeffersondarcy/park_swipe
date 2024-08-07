import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

import 'models/parking_lot.dart';
import 'parking_lot_card.dart';

class ParkingLotSwiper extends StatelessWidget {
  const ParkingLotSwiper({
    super.key,
    required this.parkingLots,
    this.onEnd,
  });

  final List<ParkingLot> parkingLots;
  final CardSwiperOnEnd? onEnd;

  @override
  Widget build(BuildContext context) {
    return CardSwiper(
      allowedSwipeDirection:
          const AllowedSwipeDirection.symmetric(horizontal: true),
      numberOfCardsDisplayed: 1,
      maxAngle: 10,
      isLoop: false,
      cardsCount: parkingLots.length,
      onEnd: onEnd,
      cardBuilder: (context, index, percentThresholdX, percentThresholdY) =>
          ParkingLotCard(parkingLot: parkingLots[index]),
    );
  }
}
