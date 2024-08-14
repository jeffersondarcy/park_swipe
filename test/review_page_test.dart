import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:park_swipe/filters.dart';
import 'package:park_swipe/models/parking_lot.dart';
import 'package:park_swipe/review_page.dart';

import 'test_data/parking_lots_data.dart';
import 'test_data/user_ratings.dart';

void main() {
  testWidgets('ReviewPage renders correctly', (WidgetTester tester) async {
    final parkingLots =
        parkingLotsData.map((data) => ParkingLot.fromJson(data)).toList();
    final userRatings = parkingLotsUserRatings;

    await tester.pumpWidget(MaterialApp(
      home: ReviewPage(
        parkingLots: parkingLots,
        userRatings: userRatings,
        listItemBuilder: noImageListItemBuilder,
      ),
    ));

    // Verify that the first parking lot is rendered correctly without an image
    expect(find.text('Lot Munich 1'), findsOneWidget);
    expect(
        find.text('ID: b943f055-9a62-4b4c-85fd-80d418bebe9b'), findsOneWidget);
    expect(find.byIcon(Icons.thumb_up), findsNWidgets(4));
    expect(find.byIcon(Icons.thumb_down), findsNWidgets(3));
  });

  testWidgets('ReviewPage displays correct number of list items',
      (WidgetTester tester) async {
    final parkingLots =
        parkingLotsData.map((data) => ParkingLot.fromJson(data)).toList();
    final userRatings = parkingLotsUserRatings; // Assuming this is defined

    await tester.pumpWidget(MaterialApp(
      home: ReviewPage(
        parkingLots: parkingLots,
        userRatings: userRatings,
        listItemBuilder: noImageListItemBuilder,
      ),
    ));

    await tester.pumpAndSettle();
    expect(find.byType(ListTile), findsNWidgets(7));
  });

  testWidgets('ReviewPage filters out bad ratings',
      (WidgetTester tester) async {
    final parkingLots =
        parkingLotsData.map((data) => ParkingLot.fromJson(data)).toList();
    final userRatings = parkingLotsUserRatings;

    await tester.pumpWidget(MaterialApp(
      home: ReviewPage(
        parkingLots: parkingLots,
        userRatings: userRatings,
        listItemBuilder: noImageListItemBuilder,
      ),
    ));

    // Open filters dialog
    await tester.tap(find.byIcon(Icons.filter_list));
    await tester.pumpAndSettle();

    // disable bad ratings
    await tester
        .tap(find.byKey(const Key(Filters.includeBadRatingCheckboxKey)));
    await tester.pumpAndSettle();

    // Close the dialog
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();

    // Verify the number of ListTile widgets for bad ratings
    expect(find.byType(ListTile), findsNWidgets(4));
    expect(find.byIcon(Icons.thumb_up), findsNWidgets(4));
    expect(find.byIcon(Icons.thumb_down), findsNWidgets(0));
  });

  testWidgets('ReviewPage filters out good ratings',
      (WidgetTester tester) async {
    final parkingLots =
        parkingLotsData.map((data) => ParkingLot.fromJson(data)).toList();
    final userRatings = parkingLotsUserRatings;

    await tester.pumpWidget(MaterialApp(
      home: ReviewPage(
        parkingLots: parkingLots,
        userRatings: userRatings,
        listItemBuilder: noImageListItemBuilder,
      ),
    ));

    // Open filters dialog
    await tester.tap(find.byIcon(Icons.filter_list));
    await tester.pumpAndSettle();

    // disable bad ratings
    await tester
        .tap(find.byKey(const Key(Filters.includeGoodRatingCheckboxKey)));
    await tester.pumpAndSettle();

    // Close the dialog
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();

    // Verify the number of ListTile widgets for bad ratings
    expect(find.byType(ListTile), findsNWidgets(3));
    expect(find.byIcon(Icons.thumb_up), findsNWidgets(0));
    expect(find.byIcon(Icons.thumb_down), findsNWidgets(3));
  });
}
