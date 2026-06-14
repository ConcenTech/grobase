import 'dart:convert';

import 'package:flutter/services.dart';

class City {
  City(this.name, this.latitude, this.longitude)
    : searchName = name.toLowerCase();

  final String name;
  final String searchName;
  final double latitude;
  final double longitude;

  City.fromJson(List<dynamic> json)
    : name = json[0],
      searchName = json[0].toLowerCase(),
      latitude = json[1],
      longitude = json[2];
}

class Cities {
  final List<City> _cities;

  static Cities? _instance;

  Cities._(List<City> cities) : _cities = cities;

  static Future<Cities> load() async {
    if (_instance != null) {
      return _instance!;
    }

    final json =
        await jsonDecode(await rootBundle.loadString('assets/cities.json'))
            as List<dynamic>;

    final cities =
        json.map((json) => City.fromJson(List<dynamic>.from(json))).toList()
          ..sort((a, b) => a.searchName.compareTo(b.searchName));

    _instance = Cities._(cities);
    return _instance!;
  }

  String _nextPrefix(String s) {
    return '$s￿';
  }

  int _lowerBound(List<City> cities, String prefix) {
    int low = 0;
    int high = cities.length;

    while (low < high) {
      final mid = (low + high) >> 1;

      if (cities[mid].searchName.compareTo(prefix) < 0) {
        low = mid + 1;
      } else {
        high = mid;
      }
    }

    return low;
  }

  int _upperBound(List<City> cities, String prefixEnd) {
    int low = 0;
    int high = cities.length;

    while (low < high) {
      final mid = (low + high) >> 1;

      if (cities[mid].searchName.compareTo(prefixEnd) < 0) {
        low = mid + 1;
      } else {
        high = mid;
      }
    }

    return low;
  }

  /// Returns a list of cities whose names start with the given query.
  ///
  /// The search is case-insensitive and returns at most [limit] results.
  List<City> search(String query, {int limit = 20}) {
    if (query.isEmpty) return [];

    final prefix = query.toLowerCase();
    final end = _nextPrefix(prefix);

    final start = _lowerBound(_cities, prefix);
    final finish = _upperBound(_cities, end);

    final endIndex = (finish < start + limit) ? finish : start + limit;

    return _cities.sublist(start, endIndex);
  }
}
