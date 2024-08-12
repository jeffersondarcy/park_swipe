// test/filters_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:park_swipe/models/parking_lot.dart';
import 'package:park_swipe/review_page.dart';

import 'mocks/mock_parking_lot_item.dart';
import 'test_data/parking_lots_data.dart';
import 'test_data/user_ratings.dart';

void main() {
  testWidgets('Review page filter test', (WidgetTester tester) async {
    final parkingLots =
        parkingLotsData.map((data) => ParkingLot.fromJson(data)).toList();
    final userRatings = parkingLotsUserRatings;

    await tester.pumpWidget(MaterialApp(
      home: ReviewPage(parkingLots: parkingLots, userRatings: userRatings),
    ));

    // Mock the ParkingLotItem
    final mockParkingLotItem = MockParkingLotItem();
    when(mockParkingLotItem.build(any))
        .thenReturn(Text('Mocked Parking Lot Item'));

    await tester.tap(find.byIcon(Icons.filter_list));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Include entries with rating good'));
    await tester.pumpAndSettle();

    expect(find.text('Mocked Parking Lot Item'), findsOneWidget);
    expect(find.text('Lot 2'), findsNothing);
  });
}
