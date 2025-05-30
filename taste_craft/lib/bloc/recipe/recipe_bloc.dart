import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taste_craft/service/recipe_service.dart';
import 'recipe_event.dart';
import 'recipe_state.dart';
import 'package:taste_craft/service/bookmark_service.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  RecipeBloc() : super(RecipeInitial()) {
    on<LoadRecipes>(_onLoadRecipes);
    on<LoadTrendingRecipes>(_onLoadTrendingRecipes);
    on<LoadFavoriteRecipes>(_onLoadFavoriteRecipes);
    on<SearchRecipes>(_onSearchRecipes);
    on<FilterRecipesByCategory>(_onFilterRecipesByCategory);
    on<RefreshRecipes>(_onRefreshRecipes);
    on<LoadMoreRecipes>(_onLoadMoreRecipes);
    on<UpdateBookmarkStatus>(_onUpdateBookmarkStatus);
  }

  Future<void> _onLoadRecipes(
    LoadRecipes event,
    Emitter<RecipeState> emit,
  ) async {
    try {
      emit(RecipeLoading());

      // Load recipes and bookmarks in parallel
      final results = await Future.wait([
        RecipeService.getRecipe(
          page: event.page,
          perPage: event.perPage,
          search: event.search,
          category: event.category,
          sort: event.sort,
        ),
        BookmarkService.getBookmarkedRecipeIds(),
      ]);

      final recipeData = results[0] as Map<String, dynamic>;
      final bookmarkedRecipeIds = results[1] as List<String>;

      final recipesData = recipeData['data'] as List<dynamic>? ?? [];
      final recipes = recipesData.map((json) => Recipe.fromJson(json)).toList();

      // Get featured recipe (first recipe or random)
      final featuredRecipe = recipes.isNotEmpty ? recipes.first : null;

      // Separate trending and favorite recipes
      final trendingRecipes = recipes.where((r) => r.isTrending).toList();

      if (state is RecipeLoaded && !event.isRefresh) {
        final currentState = state as RecipeLoaded;
        final updatedRecipes = [...currentState.recipes, ...recipes];

        emit(RecipeLoaded(
          recipes: updatedRecipes,
          trendingRecipes: [
            ...currentState.trendingRecipes,
            ...trendingRecipes
          ],
          favoriteRecipes: [
            ...currentState.favoriteRecipes,
          ],
          featuredRecipe: featuredRecipe ?? currentState.featuredRecipe,
          hasReachedMax: recipes.length < event.perPage,
          currentPage: event.page,
          currentCategory: event.category,
          currentSearch: event.search,
          bookmarkedRecipeIds: bookmarkedRecipeIds,
        ));
      } else {
        emit(RecipeLoaded(
          recipes: recipes,
          trendingRecipes: trendingRecipes,
          featuredRecipe: featuredRecipe,
          hasReachedMax: recipes.length < event.perPage,
          currentPage: event.page,
          currentCategory: event.category,
          currentSearch: event.search,
          bookmarkedRecipeIds: bookmarkedRecipeIds,
        ));
      }
    } catch (e) {
      emit(RecipeError('Failed to load recipes: ${e.toString()}'));
    }
  }

  Future<void> _onLoadTrendingRecipes(
    LoadTrendingRecipes event,
    Emitter<RecipeState> emit,
  ) async {
    try {
      final response = await RecipeService.getRecipe(
        page: 1,
        perPage: 10,
        sort: 'trending',
      );

      final recipesData = response['data'] as List<dynamic>? ?? [];
      final trendingRecipes = recipesData
          .map((json) => Recipe.fromJson(json))
          .where((recipe) => recipe.isTrending)
          .toList();

      if (state is RecipeLoaded) {
        final currentState = state as RecipeLoaded;
        emit(currentState.copyWith(trendingRecipes: trendingRecipes));
      } else {
        emit(RecipeLoaded(trendingRecipes: trendingRecipes));
      }
    } catch (e) {
      emit(RecipeError('Failed to load trending recipes: ${e.toString()}'));
    }
  }

  Future<void> _onLoadFavoriteRecipes(
    LoadFavoriteRecipes event,
    Emitter<RecipeState> emit,
  ) async {
    try {
      final response = await RecipeService.getRecipe(
        page: 1,
        perPage: 10,
        sort: 'favorites',
      );

      final recipesData = response['data'] as List<dynamic>? ?? [];
      final favoriteRecipes =
          recipesData.map((json) => Recipe.fromJson(json)).toList();

      if (state is RecipeLoaded) {
        final currentState = state as RecipeLoaded;
        emit(currentState.copyWith(favoriteRecipes: favoriteRecipes));
      } else {
        emit(RecipeLoaded(favoriteRecipes: favoriteRecipes));
      }
    } catch (e) {
      emit(RecipeError('Failed to load favorite recipes: ${e.toString()}'));
    }
  }

  Future<void> _onSearchRecipes(
    SearchRecipes event,
    Emitter<RecipeState> emit,
  ) async {
    try {
      emit(RecipeLoading());

      final response = await RecipeService.getRecipe(
        page: 1,
        perPage: 20,
        search: event.query,
        sort: 'relevance',
      );

      final recipesData = response['data'] as List<dynamic>? ?? [];
      final recipes = recipesData.map((json) => Recipe.fromJson(json)).toList();

      if (recipes.isEmpty) {
        emit(RecipeEmpty('No recipes found for "${event.query}"'));
      } else {
        emit(RecipeLoaded(
          recipes: recipes,
          currentSearch: event.query,
          currentPage: 1,
        ));
      }
    } catch (e) {
      emit(RecipeError('Failed to search recipes: ${e.toString()}'));
    }
  }

  Future<void> _onFilterRecipesByCategory(
    FilterRecipesByCategory event,
    Emitter<RecipeState> emit,
  ) async {
    try {
      emit(RecipeLoading());

      final response = await RecipeService.getRecipe(
        page: 1,
        perPage: 20,
        category: event.category,
        sort: 'newest',
      );

      final recipesData = response['data'] as List<dynamic>? ?? [];
      final recipes = recipesData.map((json) => Recipe.fromJson(json)).toList();

      if (recipes.isEmpty) {
        emit(RecipeEmpty('No recipes found in "${event.category}" category'));
      } else {
        emit(RecipeLoaded(
          recipes: recipes,
          currentCategory: event.category,
          currentPage: 1,
        ));
      }
    } catch (e) {
      emit(RecipeError('Failed to filter recipes: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshRecipes(
    RefreshRecipes event,
    Emitter<RecipeState> emit,
  ) async {
    try {
      // Load recipes and bookmarks in parallel
      final results = await Future.wait([
        RecipeService.getRecipe(),
        BookmarkService.getBookmarkedRecipeIds(),
      ]);

      final recipeData = results[0] as Map<String, dynamic>;
      final bookmarkedRecipeIds = results[1] as List<String>;

      final recipesData = recipeData['data'] as List<dynamic>? ?? [];
      final recipes = recipesData.map((json) => Recipe.fromJson(json)).toList();

      if (recipes.isEmpty) {
        emit(const RecipeEmpty('No recipes found'));
        return;
      }

      emit(RecipeLoaded(
        recipes: recipes,
        bookmarkedRecipeIds: bookmarkedRecipeIds,
      ));
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
  }

  Future<void> _onLoadMoreRecipes(
    LoadMoreRecipes event,
    Emitter<RecipeState> emit,
  ) async {
    if (state is RecipeLoaded) {
      final currentState = state as RecipeLoaded;

      if (!currentState.hasReachedMax) {
        add(LoadRecipes(
          page: currentState.currentPage + 1,
          perPage: 10,
          search: currentState.currentSearch,
          category: currentState.currentCategory,
        ));
      }
    }
  }

  Future<void> _onUpdateBookmarkStatus(
    UpdateBookmarkStatus event,
    Emitter<RecipeState> emit,
  ) async {
    if (state is RecipeLoaded) {
      try {
        final bookmarkedRecipeIds =
            await BookmarkService.getBookmarkedRecipeIds();

        emit((state as RecipeLoaded).copyWith(
          bookmarkedRecipeIds: bookmarkedRecipeIds,
        ));
      } catch (e) {
        // If failed to load bookmarks, keep current state
      }
    }
  }
}
