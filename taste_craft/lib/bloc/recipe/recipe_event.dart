import 'package:equatable/equatable.dart';

abstract class RecipeEvent extends Equatable {
  const RecipeEvent();

  @override
  List<Object?> get props => [];
}

class LoadRecipes extends RecipeEvent {
  final int page;
  final int perPage;
  final String? search;
  final String? category;
  final String sort;
  final bool isRefresh;

  const LoadRecipes({
    this.page = 1,
    this.perPage = 10,
    this.search,
    this.category,
    this.sort = 'newest',
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [page, perPage, search, category, sort, isRefresh];
}

class LoadTrendingRecipes extends RecipeEvent {}

class LoadFavoriteRecipes extends RecipeEvent {}

class SearchRecipes extends RecipeEvent {
  final String query;

  const SearchRecipes(this.query);

  @override
  List<Object> get props => [query];
}

class FilterRecipesByCategory extends RecipeEvent {
  final String category;

  const FilterRecipesByCategory(this.category);

  @override
  List<Object> get props => [category];
}

class RefreshRecipes extends RecipeEvent {
  const RefreshRecipes();
}

class LoadMoreRecipes extends RecipeEvent {}

class UpdateBookmarkStatus extends RecipeEvent {
  const UpdateBookmarkStatus();
}
