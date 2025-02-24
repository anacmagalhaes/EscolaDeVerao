import 'package:shared_preferences/shared_preferences.dart';

class CachedUserService {
  static List<dynamic>? _cachedEvents;

  static Future<void> saveCachedEvents(List<dynamic> events) async {
    _cachedEvents = events;
  }

  static Future<List<dynamic>?> getCachedEvents() async {
    return _cachedEvents;
  }

  static Future<void> clearCachedEvents() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cached_events');
  }
}
