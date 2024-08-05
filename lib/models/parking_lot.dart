class ParkingLot {
  final String address;
  final String id;
  final String image;
  final String liveDate;
  final String name;
  final int size;
  final String status;
  final String type;

  ParkingLot({
    required this.address,
    required this.id,
    required this.image,
    required this.liveDate,
    required this.name,
    required this.size,
    required this.status,
    required this.type,
  });

  // Deserialize from JSON
  factory ParkingLot.fromJson(Map<String, dynamic> json) {
    return ParkingLot(
      address: json['address'],
      id: json['id'],
      image: json['image'],
      liveDate: json['live_date'],
      name: json['name'],
      size: json['size'],
      status: json['status'],
      type: json['type'],
    );
  }

  // Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'id': id,
      'image': image,
      'live_date': liveDate,
      'name': name,
      'size': size,
      'status': status,
      'type': type,
    };
  }
}
