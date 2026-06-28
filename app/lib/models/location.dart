import 'package:freezed_annotation/freezed_annotation.dart';

part 'location.freezed.dart';

@freezed
class Location with _$Location {
  const Location({
    required this.name,
    required this.latitude,
    required this.longitude,
    String? searchName,
  }) : searchName = searchName ?? name;

  @override
  final String name;
  @override
  final double latitude;
  @override
  final double longitude;

  @override
  final String searchName;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    name: json['name'] as String,
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'latitude': latitude,
    'longitude': longitude,
  };

  factory Location.fromJsonList(List<dynamic> json) => Location(
    name: json[0] as String,
    latitude: (json[1] as num).toDouble(),
    longitude: (json[2] as num).toDouble(),
  );
}
