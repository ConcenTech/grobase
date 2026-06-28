import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/location.dart';

final citiesProvider = FutureProvider.autoDispose<CityService>((ref) async {
  return await CityService.load();
});

class CityService {
  final List<Location> _cities;

  static CityService? _instance;

  CityService._(List<Location> cities) : _cities = cities;

  static Future<CityService> load() async {
    if (_instance != null) {
      return _instance!;
    }

    final json =
        await jsonDecode(await rootBundle.loadString('assets/cities.json'))
            as List<dynamic>;

    final cities =
        json
            .map((json) => Location.fromJsonList(List<dynamic>.from(json)))
            .toList()
          ..sort((a, b) => a.searchName.compareTo(b.searchName));

    _instance = CityService._(cities);
    return _instance!;
  }

  String _nextPrefix(String s) {
    return '$s￿';
  }

  int _lowerBound(List<Location> cities, String prefix) {
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

  int _upperBound(List<Location> cities, String prefixEnd) {
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
  List<Location> search(String query, {int limit = 20}) {
    if (query.isEmpty) return [];

    final prefix = query.toLowerCase();
    final end = _nextPrefix(prefix);

    final start = _lowerBound(_cities, prefix);
    final finish = _upperBound(_cities, end);

    final endIndex = (finish < start + limit) ? finish : start + limit;

    return _cities.sublist(start, endIndex);
  }
}
