import 'package:park_swipe/types.dart';

import 'models/parking_lot.dart';

List<ParkingLot> _removeUnratedEntries(
    List<ParkingLot> parkingLots, Map<String, Rating> userRatings) {
  return parkingLots.where((parkingLot) {
    return userRatings.containsKey(parkingLot.id);
  }).toList();
}

List<ParkingLot> _filterParkingLotsByRating(List<ParkingLot> parkingLots,
    Map<String, Rating> userRatings, FilterSettings filterSettings) {
  if (filterSettings.includeGoodRating && filterSettings.includeBadRating) {
    return parkingLots;
  }

  if (!filterSettings.includeGoodRating && !filterSettings.includeBadRating) {
    return [];
  }

  List<ParkingLot> filteredParkingLots = [];

  for (var parkingLot in parkingLots) {
    Rating? rating = userRatings[parkingLot.id];
    if (rating != null) {
      if ((rating == Rating.good && filterSettings.includeGoodRating) ||
          (rating == Rating.bad && filterSettings.includeBadRating)) {
        filteredParkingLots.add(parkingLot);
      }
    }
  }

  return filteredParkingLots;
}

List<ParkingLot> groupByRating(
    List<ParkingLot> parkingLots, Map<String, Rating> userRatings) {
  List<ParkingLot> goodRatings = [];
  List<ParkingLot> badRatings = [];

  for (var parkingLot in parkingLots) {
    Rating? rating = userRatings[parkingLot.id];
    if (rating != null) {
      if (rating == Rating.good) {
        goodRatings.add(parkingLot);
      } else if (rating == Rating.bad) {
        badRatings.add(parkingLot);
      }
    }
  }

  return [...goodRatings, ...badRatings];
}

List<ParkingLot> _sortParkingLotsByName(
    List<ParkingLot> parkingLots, Map<String, Rating> userRatings) {
  List<ParkingLot> sortedList = List.from(parkingLots);
  sortedList.sort((a, b) => a.name.compareTo(b.name));

  return sortedList;
}

List<ParkingLot> applyAllFilters(List<ParkingLot> parkingLots,
    Map<String, Rating> userRatings, FilterSettings filterSettings) {
  List<ParkingLot> filteredParkingLots =
      _removeUnratedEntries(parkingLots, userRatings);
  filteredParkingLots = _filterParkingLotsByRating(
      filteredParkingLots, userRatings, filterSettings);

  if (filterSettings.groupByRating) {
    filteredParkingLots =
        _filterParkingLotsByRating(parkingLots, userRatings, filterSettings);
  }

  if (filterSettings.sortByName) {
    filteredParkingLots =
        _sortParkingLotsByName(filteredParkingLots, userRatings);
  }

  if (filterSettings.groupByRating) {
    filteredParkingLots = groupByRating(filteredParkingLots, userRatings);
  }

  return filteredParkingLots;
}
