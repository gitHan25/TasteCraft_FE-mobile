import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taste_craft/bloc/bookmark/bookmark_event.dart';
import 'package:taste_craft/bloc/bookmark/bookmark_state.dart';
import 'package:taste_craft/bloc/recipe/recipe_state.dart';
import 'package:taste_craft/service/bookmark_service.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  BookmarkBloc() : super(BookmarkInitial()) {
    on<LoadBookmarks>(_onLoadBookmarks);
    on<AddBookmark>(_onAddBookmark);
    on<RemoveBookmark>(_onRemoveBookmark);
    on<RemoveBookmarkByRecipeId>(_onRemoveBookmarkByRecipeId);
    on<RefreshBookmarks>(_onRefreshBookmarks);
  }

  Future<void> _onLoadBookmarks(
    LoadBookmarks event,
    Emitter<BookmarkState> emit,
  ) async {
    try {
      emit(BookmarkLoading());
      final bookmarks = await BookmarkService.getBookmarks();

      if (bookmarks.isEmpty) {
        emit(const BookmarkEmpty('No bookmarked recipes found'));
        return;
      }

      final bookmarkedRecipes = bookmarks.map((bookmark) {
        return Recipe.fromJson(bookmark['recipe']);
      }).toList();

      emit(BookmarkLoaded(bookmarkedRecipes: bookmarkedRecipes));
    } catch (e) {
      emit(BookmarkError(e.toString()));
    }
  }

  Future<void> _onAddBookmark(
    AddBookmark event,
    Emitter<BookmarkState> emit,
  ) async {
    try {
      final result = await BookmarkService.addBookmark(event.recipeId);

      if (result['success']) {
        emit(BookmarkActionSuccess(result['message']));
        // Don't automatically reload - let the UI handle it
      } else {
        emit(BookmarkError(result['message']));
      }
    } catch (e) {
      emit(BookmarkError(e.toString()));
    }
  }

  Future<void> _onRemoveBookmark(
    RemoveBookmark event,
    Emitter<BookmarkState> emit,
  ) async {
    try {
      final result = await BookmarkService.removeBookmark(event.bookmarkId);

      if (result['success']) {
        emit(BookmarkActionSuccess(result['message']));
        // Don't automatically reload - let the UI handle it
      } else {
        emit(BookmarkError(result['message']));
      }
    } catch (e) {
      emit(BookmarkError(e.toString()));
    }
  }

  Future<void> _onRemoveBookmarkByRecipeId(
    RemoveBookmarkByRecipeId event,
    Emitter<BookmarkState> emit,
  ) async {
    try {
      final result =
          await BookmarkService.removeBookmarkByRecipeId(event.recipeId);

      if (result['success']) {
        emit(BookmarkActionSuccess(result['message']));
        // Don't automatically reload - let the UI handle it
      } else {
        emit(BookmarkError(result['message']));
      }
    } catch (e) {
      emit(BookmarkError(e.toString()));
    }
  }

  Future<void> _onRefreshBookmarks(
    RefreshBookmarks event,
    Emitter<BookmarkState> emit,
  ) async {
    try {
      final bookmarks = await BookmarkService.getBookmarks();

      if (bookmarks.isEmpty) {
        emit(const BookmarkEmpty('No bookmarked recipes found'));
        return;
      }

      final bookmarkedRecipes = bookmarks.map((bookmark) {
        return Recipe.fromJson(bookmark['recipe']);
      }).toList();

      emit(BookmarkLoaded(bookmarkedRecipes: bookmarkedRecipes));
    } catch (e) {
      emit(BookmarkError(e.toString()));
    }
  }
}
