import 'package:equatable/equatable.dart';

abstract class BookmarkEvent extends Equatable {
  const BookmarkEvent();

  @override
  List<Object?> get props => [];
}

class LoadBookmarks extends BookmarkEvent {
  const LoadBookmarks();
}

class AddBookmark extends BookmarkEvent {
  final String recipeId;

  const AddBookmark(this.recipeId);

  @override
  List<Object?> get props => [recipeId];
}

class RemoveBookmark extends BookmarkEvent {
  final String bookmarkId;

  const RemoveBookmark(this.bookmarkId);

  @override
  List<Object?> get props => [bookmarkId];
}

class RemoveBookmarkByRecipeId extends BookmarkEvent {
  final String recipeId;

  const RemoveBookmarkByRecipeId(this.recipeId);

  @override
  List<Object?> get props => [recipeId];
}

class RefreshBookmarks extends BookmarkEvent {
  const RefreshBookmarks();
}
