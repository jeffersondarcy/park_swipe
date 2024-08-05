const String getAllParkingLotsQuery = r'''
query GetAllParkingLots($limit: Int!, $offset: Int!) {
  getAllParkingLots(limit: $limit, offset: $offset) {
    address
    id
    image
    live_date
    name
    size
    status
    type
  }
}
''';
