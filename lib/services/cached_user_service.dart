class CachedUserService {
  static List<dynamic>? _cachedEvents;

  static Future<void> saveCachedEvents(List<dynamic> events) async {
    _cachedEvents = events;
  }

  static Future<List<dynamic>?> getCachedEvents() async {
    return _cachedEvents;
  }
}
