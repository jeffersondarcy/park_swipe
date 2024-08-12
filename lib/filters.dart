import 'package:flutter/material.dart';
import 'package:park_swipe/types.dart';

class Filters extends StatefulWidget {
  static const includeGoodRatingCheckboxKey = 'includeGoodRatingCheckbox';
  static const includeBadRatingCheckboxKey = 'includeBadRatingCheckbox';
  static const groupByRatingCheckboxKey = 'groupByRatingCheckbox';
  static const sortByNameCheckboxKey = 'sortByNameCheckbox';

  final FilterSettings filterSettings;
  final Function(FilterSettings) onFilterSettingsChanged;

  const Filters({
    super.key,
    required this.filterSettings,
    required this.onFilterSettingsChanged,
  });

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  late FilterSettings _filterSettings;

  @override
  void initState() {
    super.initState();
    _filterSettings = widget.filterSettings;
  }

  void _updateFilterSettings() {
    widget.onFilterSettingsChanged(_filterSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Filter Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              key: const Key(Filters.includeGoodRatingCheckboxKey),
              title: const Text('Include entries with rating good'),
              value: _filterSettings.includeGoodRating,
              onChanged: (bool? value) {
                setState(() {
                  _filterSettings.includeGoodRating = value ?? true;
                });
                _updateFilterSettings();
              },
            ),
            CheckboxListTile(
              key: const Key(Filters.includeBadRatingCheckboxKey),
              title: const Text('Include entries with rating bad'),
              value: _filterSettings.includeBadRating,
              onChanged: (bool? value) {
                setState(() {
                  _filterSettings.includeBadRating = value ?? true;
                });
                _updateFilterSettings();
              },
            ),
            CheckboxListTile(
              key: const Key(Filters.groupByRatingCheckboxKey),
              title: const Text('Group by rating'),
              value: _filterSettings.groupByRating,
              onChanged: (bool? value) {
                setState(() {
                  _filterSettings.groupByRating = value ?? false;
                });
                _updateFilterSettings();
              },
            ),
            CheckboxListTile(
              key: const Key(Filters.sortByNameCheckboxKey),
              title: const Text('Sort by name'),
              value: _filterSettings.sortByName,
              onChanged: (bool? value) {
                setState(() {
                  _filterSettings.sortByName = value ?? false;
                });
                _updateFilterSettings();
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
