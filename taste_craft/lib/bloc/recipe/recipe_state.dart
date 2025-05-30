import 'package:equatable/equatable.dart';

class Recipe {
  final String id; // UUID from Laravel
  final String title;
  final String description;
  final String cookingTime;
  final String category;
  final String? imageUrl;
  final String? videoUrl;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Computed/derived fields (not from database directly)
  final double? rating; // Calculated from comments/reviews
  final bool isTrending; // Computed based on views/bookmarks
  final int bookmarksCount;
  final int commentsCount;

  // Related data (loaded when needed)
  final List<Ingredient> ingredients;
  final List<RecipeStep> steps;
  final List<Comment> comments;
  final User? user; // Recipe author

  const Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.cookingTime,
    required this.category,
    this.imageUrl,
    this.videoUrl,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.rating,
    this.isTrending = false,
    this.bookmarksCount = 0,
    this.commentsCount = 0,
    this.ingredients = const [],
    this.steps = const [],
    this.comments = const [],
    this.user,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      cookingTime: json['cooking_time']?.toString() ?? '30 min',
      category: json['category']?.toString() ?? '',
      imageUrl: json['image_url']?.toString(),
      videoUrl: json['video_url']?.toString(),
      userId: json['user_id']?.toString() ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at']) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at']) ?? DateTime.now()
          : DateTime.now(),
      rating:
          json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      isTrending: json['is_trending'] ?? false,
      bookmarksCount: json['bookmarks_count'] ?? 0,
      commentsCount: json['comments_count'] ?? 0,
      ingredients: json['ingredients'] != null
          ? (json['ingredients'] as List)
              .map((i) => Ingredient.fromJson(i))
              .toList()
          : [],
      steps: json['steps'] != null
          ? (json['steps'] as List).map((s) => RecipeStep.fromJson(s)).toList()
          : [],
      comments: json['comments'] != null
          ? (json['comments'] as List).map((c) => Comment.fromJson(c)).toList()
          : [],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'cooking_time': cookingTime,
      'category': category,
      'image_url': imageUrl,
      'video_url': videoUrl,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'rating': rating,
      'is_trending': isTrending,
      'bookmarks_count': bookmarksCount,
      'comments_count': commentsCount,
      'ingredients': ingredients.map((i) => i.toJson()).toList(),
      'steps': steps.map((s) => s.toJson()).toList(),
      'comments': comments.map((c) => c.toJson()).toList(),
      'user': user?.toJson(),
    };
  }

  Recipe copyWith({
    String? id,
    String? title,
    String? description,
    String? cookingTime,
    String? category,
    String? imageUrl,
    String? videoUrl,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? rating,
    bool? isTrending,
    int? bookmarksCount,
    int? commentsCount,
    List<Ingredient>? ingredients,
    List<RecipeStep>? steps,
    List<Comment>? comments,
    User? user,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      cookingTime: cookingTime ?? this.cookingTime,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rating: rating ?? this.rating,
      isTrending: isTrending ?? this.isTrending,
      bookmarksCount: bookmarksCount ?? this.bookmarksCount,
      commentsCount: commentsCount ?? this.commentsCount,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      comments: comments ?? this.comments,
      user: user ?? this.user,
    );
  }
}

// Related models based on your Laravel structure
class Ingredient {
  final String id;
  final String recipeId;
  final String name;
  final String amount;
  final String? unit;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Ingredient({
    required this.id,
    required this.recipeId,
    required this.name,
    required this.amount,
    this.unit,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id']?.toString() ?? '',
      recipeId: json['recipe_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      amount: json['amount']?.toString() ?? '',
      unit: json['unit']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at']) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipe_id': recipeId,
      'name': name,
      'amount': amount,
      'unit': unit,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class RecipeStep {
  final String id;
  final String recipeId;
  final int stepNumber;
  final String instruction;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RecipeStep({
    required this.id,
    required this.recipeId,
    required this.stepNumber,
    required this.instruction,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RecipeStep.fromJson(Map<String, dynamic> json) {
    return RecipeStep(
      id: json['id']?.toString() ?? '',
      recipeId: json['recipe_id']?.toString() ?? '',
      stepNumber: json['step_number'] ?? 1,
      instruction: json['instruction']?.toString() ?? '',
      imageUrl: json['image_url']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at']) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipe_id': recipeId,
      'step_number': stepNumber,
      'instruction': instruction,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class Comment {
  final String id;
  final String recipeId;
  final String userId;
  final String comment;
  final double? rating;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User? user;

  const Comment({
    required this.id,
    required this.recipeId,
    required this.userId,
    required this.comment,
    this.rating,
    required this.createdAt,
    required this.updatedAt,
    this.user,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id']?.toString() ?? '',
      recipeId: json['recipe_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      comment: json['comment']?.toString() ?? '',
      rating:
          json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at']) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at']) ?? DateTime.now()
          : DateTime.now(),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipe_id': recipeId,
      'user_id': userId,
      'comment': comment,
      'rating': rating,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user': user?.toJson(),
    };
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      profileImageUrl: json['profile_image_url']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at']) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profile_image_url': profileImageUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

abstract class RecipeState extends Equatable {
  const RecipeState();

  @override
  List<Object?> get props => [];
}

class RecipeInitial extends RecipeState {}

class RecipeLoading extends RecipeState {}

class RecipeLoaded extends RecipeState {
  final List<Recipe> recipes;
  final List<Recipe> trendingRecipes;
  final List<Recipe> favoriteRecipes;
  final List<String> bookmarkedRecipeIds; // List of bookmarked recipe IDs
  final Recipe? featuredRecipe;
  final bool hasReachedMax;
  final int currentPage;
  final String? currentCategory;
  final String? currentSearch;

  const RecipeLoaded({
    this.recipes = const [],
    this.trendingRecipes = const [],
    this.favoriteRecipes = const [],
    this.bookmarkedRecipeIds = const [],
    this.featuredRecipe,
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.currentCategory,
    this.currentSearch,
  });

  // Helper method to check if a recipe is bookmarked
  bool isRecipeBookmarked(String recipeId) {
    return bookmarkedRecipeIds.contains(recipeId);
  }

  RecipeLoaded copyWith({
    List<Recipe>? recipes,
    List<Recipe>? trendingRecipes,
    List<Recipe>? favoriteRecipes,
    List<String>? bookmarkedRecipeIds,
    Recipe? featuredRecipe,
    bool? hasReachedMax,
    int? currentPage,
    String? currentCategory,
    String? currentSearch,
  }) {
    return RecipeLoaded(
      recipes: recipes ?? this.recipes,
      trendingRecipes: trendingRecipes ?? this.trendingRecipes,
      favoriteRecipes: favoriteRecipes ?? this.favoriteRecipes,
      bookmarkedRecipeIds: bookmarkedRecipeIds ?? this.bookmarkedRecipeIds,
      featuredRecipe: featuredRecipe ?? this.featuredRecipe,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      currentCategory: currentCategory ?? this.currentCategory,
      currentSearch: currentSearch ?? this.currentSearch,
    );
  }

  @override
  List<Object?> get props => [
        recipes,
        trendingRecipes,
        favoriteRecipes,
        bookmarkedRecipeIds,
        featuredRecipe,
        hasReachedMax,
        currentPage,
        currentCategory,
        currentSearch,
      ];
}

class RecipeError extends RecipeState {
  final String message;

  const RecipeError(this.message);

  @override
  List<Object> get props => [message];
}

class RecipeEmpty extends RecipeState {
  final String message;

  const RecipeEmpty(this.message);

  @override
  List<Object> get props => [message];
}
