import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:taste_craft/service/api_config.dart';
import 'package:taste_craft/service/auth_service.dart';
import 'package:taste_craft/service/cache_service.dart';

class UserService {
  static Future<Map<String, dynamic>> updateProfile({
    String? firstName,
    String? lastName,
    String? email,
  }) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/user/profile'),
        headers: ApiConfig.authHeaders(token),
        body: jsonEncode({
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Invalidate user profile cache after successful update
        await CacheService.invalidateUserProfile();
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Update failed'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> updateProfileImage(
      XFile imageFile) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('Not authenticated');

      final bytes = await imageFile.readAsBytes();
      final base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';

      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/user/profile-image'),
        headers: ApiConfig.authHeaders(token),
        body: jsonEncode({
          'profile_image': base64Image,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Invalidate user profile cache after successful image update
        await CacheService.invalidateUserProfile();
        return {'success': true, 'message': data['message']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Upload failed'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error uploading image: $e'};
    }
  }

  static Future<String?> getProfileImageUrl() async {
    try {
      // Try to get from cache first
      final cachedProfile = await CacheService.getCachedUserProfile();
      if (cachedProfile != null && cachedProfile['profile_image_url'] != null) {
        final rawImageUrl = cachedProfile['profile_image_url'];
        return _constructImageUrl(rawImageUrl);
      }

      // If not in cache, fetch from API
      final token = await AuthService.getToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/user/profile-image'),
        headers: ApiConfig.authHeaders(token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final rawImageUrl = data['profile_image_url'];

        // Cache the profile image data
        await CacheService.cacheUserProfile({'profile_image_url': rawImageUrl});

        return _constructImageUrl(rawImageUrl);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static String _constructImageUrl(String? rawImageUrl) {
    if (rawImageUrl == null || rawImageUrl.isEmpty) {
      return '';
    }

    // If it's already a full URL, return it
    if (rawImageUrl.startsWith('http://') ||
        rawImageUrl.startsWith('https://')) {
      return rawImageUrl;
    }

    // The API returns /storage/filename.jpeg, so we just need to prepend the base URL
    const String baseUrl = 'http://192.168.1.15:8000';
    return '$baseUrl$rawImageUrl';
  }

  static Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      // Try to get from cache first
      final cachedProfile = await CacheService.getCachedUserProfile();
      if (cachedProfile != null) {
        return cachedProfile;
      }

      // If not in cache, fetch from API
      final token = await AuthService.getToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/user/profile'),
        headers: ApiConfig.authHeaders(token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final profileData = data['data'] ?? data;

        // Cache the profile data
        await CacheService.cacheUserProfile(profileData);

        return profileData;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
