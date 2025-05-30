import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taste_craft/bloc/bookmark/bookmark_bloc.dart';
import 'package:taste_craft/bloc/bookmark/bookmark_event.dart';
import 'package:taste_craft/bloc/bookmark/bookmark_state.dart';
import 'package:taste_craft/shared/theme.dart';
import 'package:taste_craft/ui/widgets/modern_recipe_card.dart';
import 'package:taste_craft/service/recipe_service.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  final RecipeService _recipeService = RecipeService();

  @override
  void initState() {
    super.initState();
    context.read<BookmarkBloc>().add(const LoadBookmarks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgWhiteColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Your Bookmarks',
          style: darkBrownTextStyle.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () =>
                context.read<BookmarkBloc>().add(const RefreshBookmarks()),
            icon: Icon(Icons.refresh_rounded, color: orangeColor),
          ),
        ],
      ),
      body: BlocBuilder<BookmarkBloc, BookmarkState>(
        builder: (context, state) {
          if (state is BookmarkLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BookmarkError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      size: 48, color: Colors.red.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'Oops! Something went wrong',
                    style: darkBrownTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: darkBrownTextStyle.copyWith(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context
                        .read<BookmarkBloc>()
                        .add(const RefreshBookmarks()),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          if (state is BookmarkEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border_rounded,
                      size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No Bookmarks Yet',
                    style: darkBrownTextStyle.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start saving your favorite recipes!',
                    style: darkBrownTextStyle.copyWith(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is BookmarkLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<BookmarkBloc>().add(const RefreshBookmarks());
                await Future.delayed(const Duration(seconds: 1));
              },
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: state.bookmarkedRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = state.bookmarkedRecipes[index];
                  return ModernRecipeCard(
                    image: recipe.imageUrl != null &&
                            recipe.imageUrl!.startsWith('assets/')
                        ? recipe.imageUrl!
                        : _recipeService.getImageUrl(recipe.imageUrl),
                    title: recipe.title,
                    description: recipe.description,
                    time: recipe.cookingTime,
                    isTrending: recipe.isTrending,
                    isBookmarked: true,
                    onTap: () => Navigator.pushNamed(context, '/recipe-detail',
                        arguments: {'recipeId': recipe.id}),
                    onBookmarkTap: () {
                      context
                          .read<BookmarkBloc>()
                          .add(RemoveBookmarkByRecipeId(recipe.id));
                    },
                  );
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
