import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static const String _userProfileKey = 'cached_user_profile';

  // Cache expiration times (in minutes)
  static const int _userProfileExpiry = 60; // 1 hour

  // Save data with timestamp
  static Future<void> _saveWithTimestamp(
      String key, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheData = {
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    await prefs.setString(key, jsonEncode(cacheData));
  }

  // Get data if not expired
  static Future<Map<String, dynamic>?> _getIfValid(
      String key, int expiryMinutes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedString = prefs.getString(key);

      if (cachedString == null) return null;

      final cacheData = jsonDecode(cachedString);
      final timestamp = cacheData['timestamp'] as int;
      final now = DateTime.now().millisecondsSinceEpoch;
      final expiryTime = timestamp + (expiryMinutes * 60 * 1000);

      // Check if cache is still valid
      if (now < expiryTime) {
        return cacheData['data'] as Map<String, dynamic>;
      }

      // Cache expired, remove it
      await prefs.remove(key);
      return null;
    } catch (e) {
      return null;
    }
  }

  // User Profile Caching
  static Future<void> cacheUserProfile(Map<String, dynamic> profileData) async {
    await _saveWithTimestamp(_userProfileKey, profileData);
  }

  static Future<Map<String, dynamic>?> getCachedUserProfile() async {
    return await _getIfValid(_userProfileKey, _userProfileExpiry);
  }

  // Cache Invalidation
  static Future<void> invalidateUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userProfileKey);
  }

  static Future<void> invalidateAllCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userProfileKey);
  }

  // Check if cache exists and is valid
  static Future<bool> isCacheValid(String key, int expiryMinutes) async {
    final data = await _getIfValid(key, expiryMinutes);
    return data != null;
  }
}
