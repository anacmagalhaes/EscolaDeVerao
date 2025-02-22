// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class CachedImageManager {
//   static final CachedImageManager _instance = CachedImageManager._internal();
//   factory CachedImageManager() => _instance;
//   CachedImageManager._internal();

//   static const String _imageKey = 'user_profile_image';
//   final _cacheManager = DefaultCacheManager();
//   String? _cachedImageBytes;

//   Future<void> cacheUserImage(String imageUrl) async {
//     try {
//       final file = await _cacheManager.downloadFile(
//         imageUrl,
//       );

//       if (file.file.existsSync()) {
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString(_imageKey, file.file.path);
//       }
//     } catch (e) {
//       print('Error caching image: $e');
//     }
//   }

//   Future<String?> getCachedImagePath() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       return prefs.getString(_imageKey);
//     } catch (e) {
//       print('Error getting cached image path: $e');
//       return null;
//     }
//   }
// }
