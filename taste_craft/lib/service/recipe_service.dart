import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:taste_craft/service/api_config.dart';
import 'package:taste_craft/service/auth_service.dart';

class RecipeService {
  static Future<Map<String, dynamic>> getRecipe({
    int page = 1,
    int perPage = 10,
    String? search,
    String? category,
    String sort = 'newest',
  }) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        // Return mock data if no token (for development/testing)
        return _getMockRecipeData(page, perPage, search, category, sort);
      }

      final queryParams = {
        'page': page.toString(),
        'per_page': perPage.toString(),
        'sort': sort,
      };

      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (category != null && category.isNotEmpty)
        queryParams['category'] = category;

      final uri = Uri.parse('${ApiConfig.baseUrl}/recipes')
          .replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: ApiConfig.authHeaders(token),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        // Fallback to mock data if API fails
        return _getMockRecipeData(page, perPage, search, category, sort);
      }
    } catch (e) {
      // Fallback to mock data if there's an error
      return _getMockRecipeData(page, perPage, search, category, sort);
    }
  }

  String getImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return ''; // or return a default image URL
    }

    const String baseUrl = 'http://192.168.1.15:8000/storage';

    return '$baseUrl/$imagePath';
  }

  static Map<String, dynamic> _getMockRecipeData(
    int page,
    int perPage,
    String? search,
    String? category,
    String sort,
  ) {
    final List<Map<String, dynamic>> allMockRecipes = [
      {
        'id': '550e8400-e29b-41d4-a716-446655440001',
        'title': 'Salami & Cheese Pizza',
        'description':
            'A perfect blend of savory salami and melted cheese with a crispy crust that will make your taste buds dance.',
        'image_url': 'assets/Food1.png',
        'video_url': null,
        'cooking_time': '30 min',
        'category': 'Dinner',
        'user_id': '550e8400-e29b-41d4-a716-446655440010',
        'created_at': '2024-01-15T10:30:00Z',
        'updated_at': '2024-01-15T10:30:00Z',
        'rating': 4.8,
        'is_trending': true,
        'is_bookmarked': true,
        'bookmarks_count': 156,
        'comments_count': 23,
        'ingredients': [
          {
            'id': '650e8400-e29b-41d4-a716-446655440001',
            'recipe_id': '550e8400-e29b-41d4-a716-446655440001',
            'name': 'Pizza dough',
            'amount': '1',
            'unit': 'piece'
          },
          {
            'id': '650e8400-e29b-41d4-a716-446655440002',
            'recipe_id': '550e8400-e29b-41d4-a716-446655440001',
            'name': 'Salami',
            'amount': '100',
            'unit': 'grams'
          },
          {
            'id': '650e8400-e29b-41d4-a716-446655440003',
            'recipe_id': '550e8400-e29b-41d4-a716-446655440001',
            'name': 'Mozzarella cheese',
            'amount': '200',
            'unit': 'grams'
          }
        ],
        'steps': [
          {
            'id': '750e8400-e29b-41d4-a716-446655440001',
            'recipe_id': '550e8400-e29b-41d4-a716-446655440001',
            'step_number': 1,
            'instruction': 'Preheat oven to 200°C and prepare the pizza dough'
          },
          {
            'id': '750e8400-e29b-41d4-a716-446655440002',
            'recipe_id': '550e8400-e29b-41d4-a716-446655440001',
            'step_number': 2,
            'instruction': 'Spread tomato sauce evenly on the dough'
          },
          {
            'id': '750e8400-e29b-41d4-a716-446655440003',
            'recipe_id': '550e8400-e29b-41d4-a716-446655440001',
            'step_number': 3,
            'instruction': 'Add cheese and salami, then bake for 15 minutes'
          }
        ],
        'user': {
          'id': '550e8400-e29b-41d4-a716-446655440010',
          'name': 'Chef Marco',
          'email': 'marco@tastecraft.com',
          'profile_image_url': null
        }
      },
      {
        'id': '550e8400-e29b-41d4-a716-446655440002',
        'title': 'Cheese Burger',
        'description':
            'Juicy beef patty with melted cheese, fresh lettuce, and our secret sauce.',
        'image_url': 'assets/Food-2.png',
        'video_url': null,
        'cooking_time': '15 min',
        'category': 'Lunch',
        'user_id': '550e8400-e29b-41d4-a716-446655440011',
        'created_at': '2024-01-14T14:20:00Z',
        'updated_at': '2024-01-14T14:20:00Z',
        'rating': 4.9,
        'is_trending': true,
        'is_bookmarked': false,
        'bookmarks_count': 89,
        'comments_count': 45,
        'ingredients': [
          {
            'id': '650e8400-e29b-41d4-a716-446655440011',
            'recipe_id': '550e8400-e29b-41d4-a716-446655440002',
            'name': 'Beef patty',
            'amount': '1',
            'unit': 'piece'
          },
          {
            'id': '650e8400-e29b-41d4-a716-446655440012',
            'recipe_id': '550e8400-e29b-41d4-a716-446655440002',
            'name': 'Cheddar cheese',
            'amount': '2',
            'unit': 'slices'
          }
        ],
        'user': {
          'id': '550e8400-e29b-41d4-a716-446655440011',
          'name': 'Chef Sarah',
          'email': 'sarah@tastecraft.com'
        }
      },
      {
        'id': '550e8400-e29b-41d4-a716-446655440003',
        'title': 'Tiramisu',
        'description':
            'Classic Italian dessert with coffee-soaked ladyfingers and mascarpone cream.',
        'image_url': 'assets/Food-3.png',
        'video_url': null,
        'cooking_time': '45 min',
        'category': 'Dessert',
        'user_id': '550e8400-e29b-41d4-a716-446655440012',
        'created_at': '2024-01-13T16:45:00Z',
        'updated_at': '2024-01-13T16:45:00Z',
        'rating': 4.7,
        'is_trending': false,
        'is_bookmarked': true,
        'bookmarks_count': 234,
        'comments_count': 67,
        'user': {
          'id': '550e8400-e29b-41d4-a716-446655440012',
          'name': 'Chef Antonio',
          'email': 'antonio@tastecraft.com'
        }
      },
      {
        'id': '550e8400-e29b-41d4-a716-446655440004',
        'title': 'Seafood Paella',
        'description':
            'Traditional Spanish rice dish with fresh seafood and aromatic saffron.',
        'image_url': 'assets/Food-2.png',
        'video_url': null,
        'cooking_time': '35 min',
        'category': 'Seafood',
        'user_id': '550e8400-e29b-41d4-a716-446655440013',
        'created_at': '2024-01-12T12:00:00Z',
        'updated_at': '2024-01-12T12:00:00Z',
        'rating': 4.6,
        'is_trending': false,
        'is_bookmarked': false,
        'bookmarks_count': 45,
        'comments_count': 12,
        'user': {
          'id': '550e8400-e29b-41d4-a716-446655440013',
          'name': 'Chef Carlos',
          'email': 'carlos@tastecraft.com'
        }
      },
      {
        'id': '550e8400-e29b-41d4-a716-446655440005',
        'title': 'Fluffy Pancakes',
        'description':
            'Light and fluffy breakfast pancakes served with maple syrup and butter.',
        'image_url': 'assets/Food1.png',
        'video_url': null,
        'cooking_time': '10 min',
        'category': 'Breakfast',
        'user_id': '550e8400-e29b-41d4-a716-446655440014',
        'created_at': '2024-01-11T08:30:00Z',
        'updated_at': '2024-01-11T08:30:00Z',
        'rating': 4.5,
        'is_trending': true,
        'is_bookmarked': false,
        'bookmarks_count': 78,
        'comments_count': 34,
        'user': {
          'id': '550e8400-e29b-41d4-a716-446655440014',
          'name': 'Chef Emma',
          'email': 'emma@tastecraft.com'
        }
      },
      {
        'id': '550e8400-e29b-41d4-a716-446655440006',
        'title': 'Salmon Sushi Roll',
        'description':
            'Fresh salmon and avocado sushi roll with perfect sushi rice.',
        'image_url': 'assets/Food-3.png',
        'video_url': null,
        'cooking_time': '20 min',
        'category': 'Seafood',
        'user_id': '550e8400-e29b-41d4-a716-446655440015',
        'created_at': '2024-01-10T19:15:00Z',
        'updated_at': '2024-01-10T19:15:00Z',
        'rating': 4.8,
        'is_trending': true,
        'is_bookmarked': true,
        'bookmarks_count': 167,
        'comments_count': 89,
        'user': {
          'id': '550e8400-e29b-41d4-a716-446655440015',
          'name': 'Chef Hiroshi',
          'email': 'hiroshi@tastecraft.com'
        }
      },
    ];

    // Filter by search
    List<Map<String, dynamic>> filteredRecipes = allMockRecipes;

    if (search != null && search.isNotEmpty) {
      filteredRecipes = filteredRecipes
          .where((recipe) =>
              recipe['title']
                  .toString()
                  .toLowerCase()
                  .contains(search.toLowerCase()) ||
              recipe['description']
                  .toString()
                  .toLowerCase()
                  .contains(search.toLowerCase()))
          .toList();
    }

    // Filter by category
    if (category != null && category.isNotEmpty) {
      filteredRecipes = filteredRecipes
          .where((recipe) =>
              recipe['category'].toString().toLowerCase() ==
              category.toLowerCase())
          .toList();
    }

    // Sort recipes
    switch (sort) {
      case 'favorites':
        filteredRecipes =
            filteredRecipes.where((r) => r['is_bookmarked'] == true).toList();
        break;

      case 'newest':
      default:
        filteredRecipes.sort((a, b) => DateTime.parse(b['created_at'])
            .compareTo(DateTime.parse(a['created_at'])));
        break;
    }

    // Implement pagination
    final startIndex = (page - 1) * perPage;
    final endIndex = startIndex + perPage;
    final paginatedRecipes =
        filteredRecipes.skip(startIndex).take(perPage).toList();

    return {
      'data': paginatedRecipes,
      'meta': {
        'current_page': page,
        'per_page': perPage,
        'total': filteredRecipes.length,
        'last_page': (filteredRecipes.length / perPage).ceil(),
      }
    };
  }

  static Future<Map<String, dynamic>> getRecipeDetail(String recipeId) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/recipes/$recipeId'),
        headers: ApiConfig.authHeaders(token),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Recipe not found');
      }
    } catch (e) {
      throw Exception('Error loading recipe: $e');
    }
  }
}
