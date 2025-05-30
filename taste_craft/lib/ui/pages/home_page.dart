import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taste_craft/bloc/auth/auth.dart';
import 'package:taste_craft/bloc/recipe/recipe.dart';
import 'package:taste_craft/bloc/bookmark/bookmark.dart';
import 'package:taste_craft/shared/theme.dart';
import 'package:taste_craft/service/recipe_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:taste_craft/ui/widgets/modern_recipe_card.dart';
import 'package:taste_craft/ui/widgets/quick_action_card.dart';
import 'package:taste_craft/ui/widgets/modern_category_card.dart';
import 'package:taste_craft/ui/widgets/favorite_recipe_card.dart';
import 'package:taste_craft/ui/widgets/info_chip.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final RecipeService _recipeService = RecipeService();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    // Load initial recipe data
    context.read<RecipeBloc>().add(const LoadRecipes());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    if (index == 3) {
      Navigator.pushNamed(context, '/profile');
    } else if (index == 1) {
      Navigator.pushNamed(context, '/categories');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/bookmarks');
    } else if (index == 0) {
      Navigator.pushNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgWhiteColor,
      bottomNavigationBar: modernBottomNavBar(),
      body: BlocBuilder<RecipeBloc, RecipeState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<RecipeBloc>().add(RefreshRecipes());
              await Future.delayed(const Duration(seconds: 1));
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        modernHeader(),
                        quickActionsSection(),
                        if (state is RecipeLoading && state is! RecipeLoaded)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(50),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else if (state is RecipeError)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
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
                                        .read<RecipeBloc>()
                                        .add(RefreshRecipes()),
                                    child: const Text('Try Again'),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else ...[
                          heroRecipeSection(state),
                          categoriesSection(),
                          trendingRecipesSection(state),
                          favoriteRecipesSection(state),
                          recentRecipesSection(state),
                          const SizedBox(
                              height: 100), // Bottom padding for nav bar
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget modernBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [bgButtonColor, Colors.brown.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedLabelStyle: whiteTextStyle.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: whiteTextStyle.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: Colors.white.withOpacity(0.6),
        ),
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: selectedIndex == 0
                  ? BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    )
                  : null,
              child: Icon(
                Icons.home_rounded,
                color: selectedIndex == 0
                    ? Colors.white
                    : Colors.white.withOpacity(0.6),
                size: 24,
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: selectedIndex == 1
                  ? BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    )
                  : null,
              child: Icon(
                Icons.grid_view_rounded,
                color: selectedIndex == 1
                    ? Colors.white
                    : Colors.white.withOpacity(0.6),
                size: 24,
              ),
            ),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: selectedIndex == 2
                  ? BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    )
                  : null,
              child: Icon(
                Icons.bookmark_rounded,
                color: selectedIndex == 2
                    ? Colors.white
                    : Colors.white.withOpacity(0.6),
                size: 24,
              ),
            ),
            label: 'Bookmarks',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: selectedIndex == 3
                  ? BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    )
                  : null,
              child: Icon(
                Icons.person_rounded,
                color: selectedIndex == 3
                    ? Colors.white
                    : Colors.white.withOpacity(0.6),
                size: 24,
              ),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget modernHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [orangeColor.withOpacity(0.1), Colors.transparent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good ${_getTimeOfDay()}!',
                  style: darkBrownTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${context.read<AuthBloc>().state.firstName ?? 'Chef'} 👨‍🍳',
                  style: orangeTextStyle.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'What delicious meal shall we create today?',
                  style: darkBrownTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              Icons.notifications_rounded,
              color: orangeColor,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget quickActionsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          QuickActionCard(
            icon: Icons.bookmark_rounded,
            title: "Bookmarks",
            color: Colors.red.shade400,
            onTap: () {},
          ),
          QuickActionCard(
            icon: Icons.schedule_rounded,
            title: "Meal Plan",
            color: greenColor,
            onTap: () {},
          ),
          QuickActionCard(
            icon: Icons.local_fire_department_rounded,
            title: "Trending",
            color: Colors.orange.shade400,
            onTap: () => Navigator.pushNamed(context, '/all-recipes'),
          ),
        ],
      ),
    );
  }

  Widget heroRecipeSection(RecipeState state) {
    if (state is RecipeLoaded && state.recipes.isNotEmpty) {
      final recipe = state.recipes[0];
      final isBookmarked = state.isRecipeBookmarked(recipe.id);

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Stack(
            children: [
              recipe.imageUrl != null && recipe.imageUrl!.startsWith('assets/')
                  ? Image.asset(
                      recipe.imageUrl!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : CachedNetworkImage(
                      imageUrl: _recipeService.getImageUrl(recipe.imageUrl),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.error),
                      ),
                    ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                      Colors.black.withOpacity(0.5),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: orangeColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Today Recipe',
                            style: whiteTextStyle.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (isBookmarked) {
                              context
                                  .read<BookmarkBloc>()
                                  .add(RemoveBookmarkByRecipeId(recipe.id));
                            } else {
                              context
                                  .read<BookmarkBloc>()
                                  .add(AddBookmark(recipe.id));
                            }
                            // Wait a moment then update recipe state
                            await Future.delayed(
                                const Duration(milliseconds: 500));
                            context
                                .read<RecipeBloc>()
                                .add(const UpdateBookmarkStatus());
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isBookmarked
                                  ? orangeColor
                                  : Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isBookmarked
                                  ? Icons.bookmark_rounded
                                  : Icons.bookmark_border_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            recipe.title,
                            style: whiteTextStyle.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            recipe.description,
                            style: whiteTextStyle.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withOpacity(0.9),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              InfoChip(
                                  icon: Icons.access_time_rounded,
                                  text: recipe.cookingTime + " Minutes"),
                              const SizedBox(width: 15),
                              const Spacer(),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/recipe-detail',
                                      arguments: {'recipeId': recipe.id});
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: orangeColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                ),
                                child: Text(
                                  'Cook Now',
                                  style: whiteTextStyle.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container();
  }

  Widget categoriesSection() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Categories',
                  style: darkBrownTextStyle.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/categories'),
                  child: Text(
                    'See All',
                    style: orangeTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                ModernCategoryCard(
                  emoji: '🍤',
                  title: 'Seafood',
                  bgColor: Colors.blue.shade100,
                  textColor: Colors.blue.shade400,
                  onTap: () => context
                      .read<RecipeBloc>()
                      .add(const FilterRecipesByCategory('Seafood')),
                ),
                ModernCategoryCard(
                  emoji: '🥞',
                  title: 'Breakfast',
                  bgColor: Colors.orange.shade100,
                  textColor: Colors.orange.shade400,
                  onTap: () => context
                      .read<RecipeBloc>()
                      .add(const FilterRecipesByCategory('Breakfast')),
                ),
                ModernCategoryCard(
                  emoji: '🥗',
                  title: 'Lunch',
                  bgColor: Colors.green.shade100,
                  textColor: Colors.green.shade400,
                  onTap: () => context
                      .read<RecipeBloc>()
                      .add(const FilterRecipesByCategory('Lunch')),
                ),
                ModernCategoryCard(
                  emoji: '🍝',
                  title: 'Dinner',
                  bgColor: Colors.purple.shade100,
                  textColor: Colors.purple.shade400,
                  onTap: () => context
                      .read<RecipeBloc>()
                      .add(const FilterRecipesByCategory('Dinner')),
                ),
                ModernCategoryCard(
                  emoji: '🌱',
                  title: 'Vegan',
                  bgColor: Colors.green.shade100,
                  textColor: Colors.green.shade600,
                  onTap: () => context
                      .read<RecipeBloc>()
                      .add(const FilterRecipesByCategory('Vegan')),
                ),
                ModernCategoryCard(
                  emoji: '🍰',
                  title: 'Dessert',
                  bgColor: Colors.pink.shade100,
                  textColor: Colors.pink.shade400,
                  onTap: () => context
                      .read<RecipeBloc>()
                      .add(const FilterRecipesByCategory('Dessert')),
                ),
                ModernCategoryCard(
                  emoji: '🧃',
                  title: 'Drinks',
                  bgColor: Colors.cyan.shade100,
                  textColor: Colors.cyan.shade400,
                  onTap: () => context
                      .read<RecipeBloc>()
                      .add(const FilterRecipesByCategory('Drinks')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget trendingRecipesSection(RecipeState state) {
    if (state is RecipeLoaded) {
      final recipes = state.recipes.sublist(1);
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.local_fire_department_rounded,
                          color: orangeColor, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'Trending Now',
                        style: darkBrownTextStyle.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/all-recipes'),
                    child: Text(
                      'See All',
                      style: orangeTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  return ModernRecipeCard(
                    image: recipe.imageUrl != null &&
                            recipe.imageUrl!.startsWith('assets/')
                        ? recipe.imageUrl!
                        : _recipeService.getImageUrl(recipe.imageUrl),
                    title: recipe.title,
                    description: recipe.description,
                    time: recipe.cookingTime,
                    isTrending: true,
                    isBookmarked: state.isRecipeBookmarked(recipe.id),
                    onTap: () => Navigator.pushNamed(context, '/recipe-detail',
                        arguments: {'recipeId': recipe.id}),
                    onBookmarkTap: () async {
                      if (state.isRecipeBookmarked(recipe.id)) {
                        context
                            .read<BookmarkBloc>()
                            .add(RemoveBookmarkByRecipeId(recipe.id));
                      } else {
                        context
                            .read<BookmarkBloc>()
                            .add(AddBookmark(recipe.id));
                      }
                      // Wait a moment then update recipe state
                      await Future.delayed(const Duration(milliseconds: 500));
                      context
                          .read<RecipeBloc>()
                          .add(const UpdateBookmarkStatus());
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }

  Widget favoriteRecipesSection(RecipeState state) {
    if (state is RecipeLoaded) {
      final recipes = state.recipes.sublist(1);
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [greenColor, greenColor.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: greenColor.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.bookmark_rounded,
                        color: Colors.white, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Your Bookmarks',
                      style: whiteTextStyle.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/bookmarks');
                  },
                  child: Text(
                    'View All',
                    style: whiteTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 160, // Fixed height for favorite cards
              child: Row(
                children: [
                  Expanded(
                    child: FavoriteRecipeCard(
                      image: recipes.isNotEmpty
                          ? (recipes[0].imageUrl != null &&
                                  recipes[0].imageUrl!.startsWith('assets/')
                              ? recipes[0].imageUrl!
                              : _recipeService.getImageUrl(recipes[0].imageUrl))
                          : 'assets/Food-2.png',
                      title: recipes.isNotEmpty
                          ? recipes[0].title
                          : 'Sample Recipe',
                      time: recipes.isNotEmpty
                          ? recipes[0].cookingTime
                          : '15 min',
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: FavoriteRecipeCard(
                      image: recipes.length > 1
                          ? (recipes[1].imageUrl != null &&
                                  recipes[1].imageUrl!.startsWith('assets/')
                              ? recipes[1].imageUrl!
                              : _recipeService.getImageUrl(recipes[1].imageUrl))
                          : 'assets/Food-3.png',
                      title: recipes.length > 1
                          ? recipes[1].title
                          : 'Sample Recipe 2',
                      time: recipes.length > 1
                          ? recipes[1].cookingTime
                          : '20 min',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }

  Widget recentRecipesSection(RecipeState state) {
    if (state is RecipeLoaded) {
      final recipes = state.recipes.sublist(1);
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.restaurant_menu_rounded,
                          color: orangeColor, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'View Recipes',
                        style: darkBrownTextStyle.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/all-recipes'),
                    child: Text(
                      'View All',
                      style: orangeTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 220, // Fixed height for the horizontal list
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: recipes.take(3).length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  return ModernRecipeCard(
                    image: recipe.imageUrl != null &&
                            recipe.imageUrl!.startsWith('assets/')
                        ? recipe.imageUrl!
                        : _recipeService.getImageUrl(recipe.imageUrl),
                    title: recipe.title,
                    description: recipe.description,
                    time: recipe.cookingTime,
                    isTrending: true,
                    isBookmarked: state.isRecipeBookmarked(recipe.id),
                    onTap: () => Navigator.pushNamed(context, '/recipe-detail',
                        arguments: {'recipeId': recipe.id}),
                    onBookmarkTap: () async {
                      if (state.isRecipeBookmarked(recipe.id)) {
                        context
                            .read<BookmarkBloc>()
                            .add(RemoveBookmarkByRecipeId(recipe.id));
                      } else {
                        context
                            .read<BookmarkBloc>()
                            .add(AddBookmark(recipe.id));
                      }
                      // Wait a moment then update recipe state
                      await Future.delayed(const Duration(milliseconds: 500));
                      context
                          .read<RecipeBloc>()
                          .add(const UpdateBookmarkStatus());
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }

  String _getTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }
}
