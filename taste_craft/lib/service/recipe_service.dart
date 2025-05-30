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
      if (token == null) {
        return _getMockRecipeDetail(recipeId);
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/recipes/$recipeId'),
        headers: ApiConfig.authHeaders(token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data['data'] ?? data['recipe'] ?? data,
        };
      } else {
        return _getMockRecipeDetail(recipeId);
      }
    } catch (e) {
      return _getMockRecipeDetail(recipeId);
    }
  }

  static Map<String, dynamic> _getMockRecipeDetail(String recipeId) {
    final mockRecipe = {
      'id': recipeId,
      'title': 'Delicious Mock Recipe',
      'description':
          'A wonderfully crafted recipe with amazing flavors and easy-to-follow steps.',
      'cooking_time': '25',
      'category': 'Main Course',
      'image_url': 'assets/Food-2.png',
      'video_url': 'https://www.youtube.com/watch?v=example',
      'user_id': 1,
      'created_at': '2024-01-15T10:30:00.000000Z',
      'updated_at': '2024-01-15T12:45:00.000000Z',
      'is_trending': true,
      'comments_count': 73,
      'ingredients': [
        {
          'id': '650e8400-e29b-41d4-a716-446655440001',
          'recipe_id': recipeId,
          'name': 'Fresh tomatoes',
          'quantity': '3',
          'unit': 'pieces'
        },
        {
          'id': '650e8400-e29b-41d4-a716-446655440002',
          'recipe_id': recipeId,
          'name': 'Olive oil',
          'quantity': '2',
          'unit': 'tablespoons'
        },
        {
          'id': '650e8400-e29b-41d4-a716-446655440003',
          'recipe_id': recipeId,
          'name': 'Garlic cloves',
          'quantity': '3',
          'unit': 'pieces'
        },
        {
          'id': '650e8400-e29b-41d4-a716-446655440004',
          'recipe_id': recipeId,
          'name': 'Basil leaves',
          'quantity': '10',
          'unit': 'pieces'
        },
      ],
      'steps': [
        {
          'id': 1,
          'recipe_id': recipeId,
          'step_number': 1,
          'instruction':
              'Wash and dice the fresh tomatoes into small cubes. Set aside in a bowl.'
        },
        {
          'id': 2,
          'recipe_id': recipeId,
          'step_number': 2,
          'instruction': 'Heat olive oil in a large pan over medium heat.'
        },
        {
          'id': 3,
          'recipe_id': recipeId,
          'step_number': 3,
          'instruction':
              'Add minced garlic to the pan and sauté until fragrant, about 1-2 minutes.'
        },
        {
          'id': 4,
          'recipe_id': recipeId,
          'step_number': 4,
          'instruction':
              'Add the diced tomatoes and cook for 8-10 minutes until they start to break down.'
        },
        {
          'id': 5,
          'recipe_id': recipeId,
          'step_number': 5,
          'instruction':
              'Season with salt and pepper to taste, then add fresh basil leaves.'
        },
        {
          'id': 6,
          'recipe_id': recipeId,
          'step_number': 6,
          'instruction': 'Serve hot and enjoy your delicious meal!'
        },
      ],
      'user': {
        'id': 1,
        'first_name': 'Chef',
        'last_name': 'Master',
        'profile_image': 'chef_avatar.png',
        'email': 'chef@tastecraft.com'
      }
    };

    return {
      'success': true,
      'data': {'recipe': mockRecipe}
    };
  }

  static Map<String, dynamic>? parseRecipeDetail(
      Map<String, dynamic> response) {
    try {
      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];
        return data['recipe'] ?? data;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Utility method to get ingredients list from recipe detail
  static List<Map<String, dynamic>> getIngredients(
      Map<String, dynamic>? recipe) {
    if (recipe == null) return [];
    final ingredients = recipe['ingredients'];
    if (ingredients is List) {
      return List<Map<String, dynamic>>.from(ingredients);
    }
    return [];
  }

  // Utility method to get cooking steps from recipe detail
  static List<Map<String, dynamic>> getCookingSteps(
      Map<String, dynamic>? recipe) {
    if (recipe == null) return [];
    final steps = recipe['steps'];
    if (steps is List) {
      List<Map<String, dynamic>> stepsList =
          List<Map<String, dynamic>>.from(steps);

      stepsList.sort(
          (a, b) => (a['step_number'] ?? 0).compareTo(b['step_number'] ?? 0));
      return stepsList;
    }
    return [];
  }

  // Utility method to get recipe author information
  static Map<String, dynamic>? getRecipeAuthor(Map<String, dynamic>? recipe) {
    if (recipe == null) return null;
    return recipe['user'];
  }

  static Map<String, dynamic>? getUser(Map<String, dynamic>? recipe) {
    if (recipe == null) return null;
    return recipe['user'];
  }

  static Future<Map<String, dynamic>> getAllRecipes({
    int page = 1,
    int perPage = 12,
    String? search,
    String? category,
    String? sortBy = 'newest',
  }) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        throw Exception('No authentication token available');
      }

      final queryParams = {
        'page': page.toString(),
        'per_page': perPage.toString(),
      };

      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (category != null && category.isNotEmpty)
        queryParams['category'] = category;
      if (sortBy != null && sortBy.isNotEmpty) queryParams['sort_by'] = sortBy;

      // Use the same endpoint as getRecipe method
      final uri = Uri.parse('${ApiConfig.baseUrl}/recipes')
          .replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: ApiConfig.authHeaders(token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data['data'] ?? [],
          'pagination': data['pagination'] ?? {},
        };
      } else {
        throw Exception(
            'API request failed with status ${response.statusCode}');
      }
    } catch (e) {
      // Only return mock data as last resort
      return _getMockAllRecipesData(page, perPage, search, category, sortBy);
    }
  }

  static Map<String, dynamic> _getMockAllRecipesData(
    int page,
    int perPage,
    String? search,
    String? category,
    String? sortBy,
  ) {
    final List<Map<String, dynamic>> allMockRecipes = [
      {
        'id': '01971d1c-6c79-7076-a554-cd48c5f444cf',
        'title': 'Sate Padang',
        'description': 'Sate padang buatan padang yang enak dan lezat',
        'cooking_time': '30',
        'category': 'Main Course',
        'image_url': 'assets/Food1.png',
        'video_url': 'https://www.youtube.com/watch?v=LWRIBEBRwuM',
        'user_id': 1,
        'created_at': '2025-05-29T17:34:51.000000Z',
        'ingredients': [
          {
            'id': '01971d20-8059-71cb-8356-0207e49d3376',
            'recipe_id': '01971d1c-6c79-7076-a554-cd48c5f444cf',
            'name': 'Daging sapi',
            'quantity': '500'
          },
          {
            'id': '01971d20-805c-714d-9d06-64cf0e1f83ea',
            'recipe_id': '01971d1c-6c79-7076-a554-cd48c5f444cf',
            'name': 'Kuah kacang',
            'quantity': '200'
          }
        ],
        'steps': [
          {
            'id': 83,
            'recipe_id': '01971d1c-6c79-7076-a554-cd48c5f444cf',
            'step_number': 1,
            'instruction': 'Cuci bersih daging'
          }
        ],
        'user': {'id': 1, 'first_name': 'Chef', 'last_name': 'Ahmad'},
        'bookmarks': [
          {
            'id': 36,
            'recipe_id': '01971d1c-6c79-7076-a554-cd48c5f444cf',
            'user_id': 3
          }
        ],
        'comments': [
          {
            'id': '01972259-b22b-73cf-b4a3-ed2f08801056',
            'recipe_id': '01971d1c-6c79-7076-a554-cd48c5f444cf',
            'user_id': 3
          }
        ]
      },
      {
        'id': '01970955-9853-73d1-8534-631572adb25b',
        'title': 'Kentang Goreng',
        'description': 'Kentang goreng crispy yang enak dan renyah',
        'cooking_time': '10',
        'category': 'Snack',
        'image_url': 'assets/Food-2.png',
        'video_url': 'https://www.youtube.com/watch?v=HSGGGSOebh0',
        'user_id': 1,
        'created_at': '2025-05-25T14:24:53.000000Z',
        'ingredients': [
          {
            'id': '01970955-985c-7170-be53-09f356aab05b',
            'recipe_id': '01970955-9853-73d1-8534-631572adb25b',
            'name': 'Kentang',
            'quantity': '3'
          }
        ],
        'steps': [
          {
            'id': 79,
            'recipe_id': '01970955-9853-73d1-8534-631572adb25b',
            'step_number': 1,
            'instruction': 'Kupas dan potong kentang'
          }
        ],
        'user': {'id': 1, 'first_name': 'Chef', 'last_name': 'Ahmad'},
        'bookmarks': [
          {
            'id': 12,
            'recipe_id': '01970955-9853-73d1-8534-631572adb25b',
            'user_id': 1
          }
        ],
        'comments': []
      },
      {
        'id': '019708e4-0201-7374-8513-53bbd9944600',
        'title': 'Nasi Goreng Spesial',
        'description': 'Nasi goreng dengan bumbu rahasia yang lezat',
        'cooking_time': '20',
        'category': 'Main Course',
        'image_url': 'assets/Food-3.png',
        'video_url': 'https://www.youtube.com/watch?v=Js9FXCkn798',
        'user_id': 1,
        'created_at': '2025-05-25T12:20:49.000000Z',
        'ingredients': [
          {
            'id': '019708e4-0206-70ca-a6f0-5adb22b72bdb',
            'recipe_id': '019708e4-0201-7374-8513-53bbd9944600',
            'name': 'Telur',
            'quantity': '2'
          }
        ],
        'steps': [
          {
            'id': 78,
            'recipe_id': '019708e4-0201-7374-8513-53bbd9944600',
            'step_number': 1,
            'instruction': 'Siapkan semua bahan'
          }
        ],
        'user': {'id': 1, 'first_name': 'Chef', 'last_name': 'Ahmad'},
        'bookmarks': [
          {
            'id': 11,
            'recipe_id': '019708e4-0201-7374-8513-53bbd9944600',
            'user_id': 1
          }
        ],
        'comments': []
      },
      {
        'id': '019708c9-7c6a-707c-9b83-a50762510171',
        'title': 'Nasi Goreng Kampung',
        'description': 'Nasi goreng dengan cita rasa kampung yang autentik',
        'cooking_time': '20',
        'category': 'Breakfast',
        'image_url': 'assets/Food1.png',
        'video_url': 'https://www.youtube.com/watch?v=Js9FXCkn798',
        'user_id': 1,
        'created_at': '2025-05-25T11:51:51.000000Z',
        'ingredients': [
          {
            'id': '019708da-dc7f-7362-a077-d4cabe30b101',
            'recipe_id': '019708c9-7c6a-707c-9b83-a50762510171',
            'name': 'Telur',
            'quantity': '1'
          }
        ],
        'steps': [
          {
            'id': 77,
            'recipe_id': '019708c9-7c6a-707c-9b83-a50762510171',
            'step_number': 1,
            'instruction': 'Siapkan semua bahan'
          }
        ],
        'user': {'id': 1, 'first_name': 'Chef', 'last_name': 'Ahmad'},
        'bookmarks': [
          {
            'id': 9,
            'recipe_id': '019708c9-7c6a-707c-9b83-a50762510171',
            'user_id': 1
          },
          {
            'id': 10,
            'recipe_id': '019708c9-7c6a-707c-9b83-a50762510171',
            'user_id': 2
          }
        ],
        'comments': [
          {
            'id': '019708de-9fb4-7048-a32b-8a868e20e6ed',
            'recipe_id': '019708c9-7c6a-707c-9b83-a50762510171',
            'user_id': 2
          },
          {
            'id': '019708f2-930b-70e3-8b2e-f1fad6c74d90',
            'recipe_id': '019708c9-7c6a-707c-9b83-a50762510171',
            'user_id': 2
          }
        ]
      },
    ];

    // Apply filtering and sorting logic similar to getRecipe method
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

    if (category != null && category.isNotEmpty) {
      filteredRecipes = filteredRecipes
          .where((recipe) =>
              recipe['category'].toString().toLowerCase() ==
              category.toLowerCase())
          .toList();
    }

    // Sort recipes
    switch (sortBy) {
      case 'popular':
        filteredRecipes.sort((a, b) => (b['bookmarks']?.length ?? 0)
            .compareTo(a['bookmarks']?.length ?? 0));
        break;
      case 'newest':
      default:
        filteredRecipes.sort((a, b) => DateTime.parse(b['created_at'])
            .compareTo(DateTime.parse(a['created_at'])));
        break;
    }

    // Implement pagination
    final startIndex = (page - 1) * perPage;
    final paginatedRecipes =
        filteredRecipes.skip(startIndex).take(perPage).toList();

    return {
      'success': true,
      'data': paginatedRecipes,
      'pagination': {
        'current_page': page,
        'per_page': perPage,
        'total': filteredRecipes.length,
        'last_page': (filteredRecipes.length / perPage).ceil(),
        'from': startIndex + 1,
        'to': startIndex + paginatedRecipes.length,
      }
    };
  }
}
