import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taste_craft/shared/theme.dart';
import 'package:taste_craft/service/recipe_service.dart';
import 'package:taste_craft/bloc/bookmark/bookmark_bloc.dart';
import 'package:taste_craft/bloc/bookmark/bookmark_event.dart';
import 'package:taste_craft/ui/widgets/modern_recipe_card.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AllRecipesPage extends StatefulWidget {
  const AllRecipesPage({super.key});

  @override
  State<AllRecipesPage> createState() => _AllRecipesPageState();
}

class _AllRecipesPageState extends State<AllRecipesPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final RecipeService _recipeService = RecipeService();

  List<Map<String, dynamic>> recipes = [];
  Map<String, dynamic>? pagination;
  bool isLoading = false;
  bool isLoadingMore = false;
  String? error;

  // Filter and sort options
  String selectedCategory = 'All';
  String selectedSort = 'newest';
  int currentPage = 1;

  final List<String> categories = [
    'All',
    'Main Course',
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snack',
    'Dessert',
    'Drinks',
    'Vegan',
    'Seafood'
  ];

  final List<Map<String, String>> sortOptions = [
    {'value': 'newest', 'label': 'Newest'},
    {'value': 'popular', 'label': 'Most Popular'},
  ];

  @override
  void initState() {
    super.initState();
    _loadRecipes();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !isLoadingMore &&
        pagination != null &&
        pagination!['current_page'] < pagination!['last_page']) {
      _loadMoreRecipes();
    }
  }

  Future<void> _loadRecipes({bool isRefresh = false}) async {
    if (isRefresh) {
      setState(() {
        currentPage = 1;
        recipes.clear();
      });
    }

    setState(() {
      isLoading = !isRefresh;
      error = null;
    });

    try {
      final response = await RecipeService.getAllRecipes(
        page: currentPage,
        search: _searchController.text.trim(),
        category: selectedCategory == 'All' ? null : selectedCategory,
        sortBy: selectedSort,
      );

      if (response['success'] == true) {
        setState(() {
          if (isRefresh) {
            recipes = List<Map<String, dynamic>>.from(response['data'] ?? []);
          } else {
            recipes.addAll(
                List<Map<String, dynamic>>.from(response['data'] ?? []));
          }
          pagination = response['pagination'];
          isLoading = false;
        });
      } else {
        setState(() {
          error = response['message'] ?? 'Failed to load recipes';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        if (e.toString().contains('No authentication token')) {
          error = 'Please login to view recipes';
        } else {
          error = 'Error loading recipes: $e';
        }
        isLoading = false;
      });
    }
  }

  Future<void> _loadMoreRecipes() async {
    if (isLoadingMore) return;

    setState(() {
      isLoadingMore = true;
    });

    currentPage++;

    try {
      final response = await RecipeService.getAllRecipes(
        page: currentPage,
        search: _searchController.text.trim(),
        category: selectedCategory == 'All' ? null : selectedCategory,
        sortBy: selectedSort,
      );

      if (response['success'] == true) {
        setState(() {
          recipes
              .addAll(List<Map<String, dynamic>>.from(response['data'] ?? []));
          pagination = response['pagination'];
          isLoadingMore = false;
        });
      } else {
        setState(() {
          isLoadingMore = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  void _onFilterChanged() {
    currentPage = 1;
    _loadRecipes(isRefresh: true);
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildFilterBottomSheet(),
    );
  }

  Widget _buildFilterBottomSheet() {
    return StatefulBuilder(
      builder: (context, setBottomSheetState) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                'Filter & Sort',
                style: darkBrownTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),

              // Category filter
              Text(
                'Category',
                style: darkBrownTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((category) {
                  final isSelected = selectedCategory == category;
                  return GestureDetector(
                    onTap: () {
                      setBottomSheetState(() {
                        selectedCategory = category;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? orangeColor : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              isSelected ? orangeColor : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color:
                              isSelected ? Colors.white : Colors.grey.shade700,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Sort filter
              Text(
                'Sort By',
                style: darkBrownTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ...sortOptions.map((option) {
                final isSelected = selectedSort == option['value'];
                return RadioListTile<String>(
                  value: option['value']!,
                  groupValue: selectedSort,
                  onChanged: (value) {
                    setBottomSheetState(() {
                      selectedSort = value!;
                    });
                  },
                  title: Text(option['label']!),
                  activeColor: orangeColor,
                  contentPadding: EdgeInsets.zero,
                );
              }).toList(),
              const SizedBox(height: 24),

              // Apply button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _onFilterChanged();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orangeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    'Apply Filters',
                    style: whiteTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgWhiteColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'All Recipes',
          style: darkBrownTextStyle.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: orangeColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.tune_rounded, color: orangeColor),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onSubmitted: (_) => _onFilterChanged(),
              decoration: InputDecoration(
                hintText: "Search recipes...",
                hintStyle: TextStyle(color: Colors.grey.shade500),
                prefixIcon: Icon(Icons.search_rounded, color: orangeColor),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey.shade500),
                        onPressed: () {
                          _searchController.clear();
                          _onFilterChanged();
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),

          // Results info
          if (pagination != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Showing ${pagination!['from']} - ${pagination!['to']} of ${pagination!['total']} recipes',
                    style: darkBrownTextStyle.copyWith(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  if (selectedCategory != 'All' ||
                      _searchController.text.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedCategory = 'All';
                          _searchController.clear();
                        });
                        _onFilterChanged();
                      },
                      child: Text(
                        'Clear filters',
                        style: orangeTextStyle.copyWith(fontSize: 14),
                      ),
                    ),
                ],
              ),
            ),

          // Recipes grid
          Expanded(
            child: isLoading && recipes.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : error != null && recipes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline,
                                size: 64, color: Colors.red.shade400),
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
                              error!,
                              style: darkBrownTextStyle.copyWith(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => _loadRecipes(isRefresh: true),
                              child: const Text('Try Again'),
                            ),
                          ],
                        ),
                      )
                    : recipes.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.restaurant_menu,
                                    size: 64, color: Colors.grey.shade400),
                                const SizedBox(height: 16),
                                Text(
                                  'No recipes found',
                                  style: darkBrownTextStyle.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Try adjusting your filters or search terms',
                                  style: darkBrownTextStyle.copyWith(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () => _loadRecipes(isRefresh: true),
                            child: GridView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.all(16),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                              itemCount:
                                  recipes.length + (isLoadingMore ? 2 : 0),
                              itemBuilder: (context, index) {
                                if (index >= recipes.length) {
                                  // Loading more indicator
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                final recipe = recipes[index];
                                return _buildRecipeCard(recipe);
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeCard(Map<String, dynamic> recipe) {
    final bookmarks = recipe['bookmarks'] as List? ?? [];
    final comments = recipe['comments'] as List? ?? [];

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/recipe-detail',
          arguments: {'recipeId': recipe['id']},
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Image
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: recipe['image_url'] != null &&
                            recipe['image_url'].startsWith('assets/')
                        ? Image.asset(
                            recipe['image_url'],
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : CachedNetworkImage(
                            imageUrl:
                                _recipeService.getImageUrl(recipe['image_url']),
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
                  ),

                  // Category badge
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: orangeColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        recipe['category'] ?? '',
                        style: whiteTextStyle.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  // Bookmark button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        // Handle bookmark
                        context.read<BookmarkBloc>().add(
                              AddBookmark(recipe['id']),
                            );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.bookmark_border_rounded,
                          color: orangeColor,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Recipe Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe['title'] ?? '',
                      style: darkBrownTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      recipe['description'] ?? '',
                      style: darkBrownTextStyle.copyWith(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded,
                            color: Colors.grey.shade500, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          '${recipe['cooking_time']} min',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Icon(Icons.bookmark_rounded,
                                color: Colors.grey.shade500, size: 12),
                            const SizedBox(width: 2),
                            Text(
                              '${bookmarks.length}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.comment_rounded,
                                color: Colors.grey.shade500, size: 12),
                            const SizedBox(width: 2),
                            Text(
                              '${comments.length}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
