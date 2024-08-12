enum Rating {
  good,
  bad,
}

class FilterSettings {
  bool includeGoodRating;
  bool includeBadRating;
  bool groupByRating;
  bool sortByName;

  FilterSettings({
    this.includeGoodRating = true,
    this.includeBadRating = true,
    this.groupByRating = false,
    this.sortByName = false,
  });

  FilterSettings.from(FilterSettings other)
      : includeGoodRating = other.includeGoodRating,
        includeBadRating = other.includeBadRating,
        groupByRating = other.groupByRating,
        sortByName = other.sortByName;
}
