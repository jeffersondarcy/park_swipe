// test/filters_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:park_swipe/filters.dart';
import 'package:park_swipe/types.dart';

FilterSettings defaultFilters = FilterSettings(
  includeGoodRating: true,
  includeBadRating: true,
  groupByRating: false,
  sortByName: false,
);

void main() {
  testWidgets('Filter dialog checkbox test', (WidgetTester tester) async {
    FilterSettings filterSettings = FilterSettings.from(defaultFilters);

    FilterSettings? newFilterSettings;

    void customOnFilterSettingsChanged(FilterSettings newSettings) {
      newFilterSettings = newSettings;
    }

    await tester.pumpWidget(MaterialApp(
      home: Filters(
        filterSettings: filterSettings,
        onFilterSettingsChanged: customOnFilterSettingsChanged,
      ),
    ));

    await tester
        .tap(find.byKey(const Key(Filters.includeGoodRatingCheckboxKey)));
    await tester.pumpAndSettle();
    expect(newFilterSettings?.includeGoodRating, isFalse);
    expect(newFilterSettings?.includeBadRating, isTrue);
    expect(newFilterSettings?.groupByRating, isFalse);
    expect(newFilterSettings?.sortByName, isFalse);

    await tester
        .tap(find.byKey(const Key(Filters.includeBadRatingCheckboxKey)));
    await tester.pumpAndSettle();
    expect(newFilterSettings?.includeGoodRating, isFalse);
    expect(newFilterSettings?.includeBadRating, isFalse);
    expect(newFilterSettings?.groupByRating, isFalse);
    expect(newFilterSettings?.sortByName, isFalse);

    await tester.tap(find.byKey(const Key(Filters.groupByRatingCheckboxKey)));
    await tester.pumpAndSettle();
    expect(newFilterSettings?.includeGoodRating, isFalse);
    expect(newFilterSettings?.includeBadRating, isFalse);
    expect(newFilterSettings?.groupByRating, isTrue);
    expect(newFilterSettings?.sortByName, isFalse);

    await tester.tap(find.byKey(const Key(Filters.sortByNameCheckboxKey)));
    await tester.pumpAndSettle();
    expect(newFilterSettings?.includeGoodRating, isFalse);
    expect(newFilterSettings?.includeBadRating, isFalse);
    expect(newFilterSettings?.groupByRating, isTrue);
    expect(newFilterSettings?.sortByName, isTrue);
  });
}
