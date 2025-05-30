import 'package:equatable/equatable.dart';
import 'package:taste_craft/bloc/recipe/recipe_state.dart';

abstract class BookmarkState extends Equatable {
  const BookmarkState();

  @override
  List<Object?> get props => [];
}

class BookmarkInitial extends BookmarkState {}

class BookmarkLoading extends BookmarkState {}

class BookmarkLoaded extends BookmarkState {
  final List<Recipe> bookmarkedRecipes;

  const BookmarkLoaded({
    required this.bookmarkedRecipes,
  });

  @override
  List<Object?> get props => [bookmarkedRecipes];

  BookmarkLoaded copyWith({
    List<Recipe>? bookmarkedRecipes,
  }) {
    return BookmarkLoaded(
      bookmarkedRecipes: bookmarkedRecipes ?? this.bookmarkedRecipes,
    );
  }
}

class BookmarkError extends BookmarkState {
  final String message;

  const BookmarkError(this.message);

  @override
  List<Object> get props => [message];
}

class BookmarkActionSuccess extends BookmarkState {
  final String message;

  const BookmarkActionSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class BookmarkEmpty extends BookmarkState {
  final String message;

  const BookmarkEmpty(this.message);

  @override
  List<Object> get props => [message];
}
