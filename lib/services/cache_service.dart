import 'dart:async';

class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  final Map<String, dynamic> _cache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  final Duration _cacheExpiry = const Duration(minutes: 5);

  T? get<T>(String key) {
    final timestamp = _cacheTimestamps[key];
    if (timestamp != null && DateTime.now().difference(timestamp) < _cacheExpiry) {
      return _cache[key] as T?;
    }
    return null;
  }

  void set<T>(String key, T value) {
    _cache[key] = value;
    _cacheTimestamps[key] = DateTime.now();
  }

  void clear() {
    _cache.clear();
    _cacheTimestamps.clear();
  }

  void remove(String key) {
    _cache.remove(key);
    _cacheTimestamps.remove(key);
  }
}