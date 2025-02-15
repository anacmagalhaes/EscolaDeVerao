import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageCacheService {
  static final ImageCacheService _instance = ImageCacheService._internal();
  factory ImageCacheService() => _instance;
  ImageCacheService._internal();

  final DefaultCacheManager _cacheManager = DefaultCacheManager();

  Future<String?> getCachedImagePath(String imageUrl) async {
    try {
      final fileInfo = await _cacheManager.getFileFromCache(imageUrl);
      if (fileInfo != null) {
        return imageUrl;
      }

      // If not in cache, download and cache
      final file = await _cacheManager.downloadFile(imageUrl);
      return file.file.path;
    } catch (e) {
      print('Error caching image: $e');
      return null;
    }
  }

  Future<void> cacheUserImage(String userId, String imageUrl) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_${userId}_image', imageUrl);
      await getCachedImagePath(imageUrl);
    } catch (e) {
      print('Error saving user image: $e');
    }
  }

  Future<String?> getCachedUserImage(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('user_${userId}_image');
    } catch (e) {
      print('Error getting cached user image: $e');
      return null;
    }
  }

  Future<void> clearCache() async {
    await _cacheManager.emptyCache();
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs
        .getKeys()
        .where((key) => key.startsWith('user_') && key.endsWith('_image'));
    for (var key in keys) {
      await prefs.remove(key);
    }
  }
}
