enum Rating {
  good,
  bad,
}

class FilterSettings {
  bool includeGoodRating = true;
  bool includeBadRating = true;
  bool groupByRating = false;
  bool sortByName = false;
}
