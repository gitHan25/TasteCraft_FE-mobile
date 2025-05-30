import 'dart:convert';

import 'package:taste_craft/service/api_config.dart';
import 'package:taste_craft/service/auth_service.dart';
import 'package:http/http.dart' as http;

class BookmarkService {
  static Future<List<dynamic>> getBookmarks() async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('Not Authenticated');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/bookmarks'),
        headers: ApiConfig.authHeaders(token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'] ?? [];
      } else {
        throw Exception('Failed to load bookmarks');
      }
    } catch (e) {
      throw Exception('Error fetching bookmarks: $e');
    }
  }

  static Future<List<String>> getBookmarkedRecipeIds() async {
    try {
      final bookmarks = await getBookmarks();
      return bookmarks
          .map((bookmark) => bookmark['recipe_id'].toString())
          .toList();
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>> addBookmark(String recipeId) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('Not Authenticated');

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/bookmarks'),
        headers: ApiConfig.authHeaders(token),
        body: jsonEncode({'recipe_id': recipeId}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Recipe added to bookmarks',
          'data': data
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to add bookmark',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network Error: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> removeBookmark(String bookmarkId) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('Not Authenticated');

      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/bookmarks/$bookmarkId'),
        headers: ApiConfig.authHeaders(token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return {
          'success': true,
          'message': data['message'] ?? 'Bookmark removed successfully',
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to remove bookmark',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network Error: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> removeBookmarkByRecipeId(
      String recipeId) async {
    try {
      final bookmarks = await getBookmarks();
      final bookmark = bookmarks.firstWhere(
        (b) => b['recipe_id'].toString() == recipeId,
        orElse: () => null,
      );

      if (bookmark != null) {
        return await removeBookmark(bookmark['id'].toString());
      } else {
        return {
          'success': false,
          'message': 'Bookmark not found',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error removing bookmark: $e',
      };
    }
  }
}
