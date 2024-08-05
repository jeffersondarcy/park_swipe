import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLService {
  GraphQLService._internal();

  static final GraphQLService _instance = GraphQLService._internal();

  factory GraphQLService() {
    return _instance;
  }

  final ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: HttpLink('https://interview-apixx07.dev.park-depot.de'),
      cache: GraphQLCache(store: HiveStore()),
    ),
  );
}
