import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taste_craft/shared/theme.dart';
import 'package:taste_craft/service/recipe_service.dart';
import 'package:taste_craft/service/comment_service.dart';
import 'package:taste_craft/bloc/auth/auth_bloc.dart';
import 'package:taste_craft/bloc/auth/auth_state.dart';
import 'package:taste_craft/ui/widgets/comment_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class RecipeDetail extends StatefulWidget {
  final String? recipeId;

  const RecipeDetail({super.key, this.recipeId});

  @override
  State<RecipeDetail> createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  Map<String, dynamic>? recipe;
  List<dynamic> comments = [];
  bool isLoading = true;
  bool isLoadingComments = false;
  bool isPostingComment = false;
  String? error;
  final RecipeService _recipeService = RecipeService();
  final TextEditingController _commentController = TextEditingController();
  YoutubePlayerController? _youtubeController;
  bool _supportsEmbeddedPlayer = true;
  bool _isCheckingDevice = true;

  @override
  void initState() {
    super.initState();
    _checkDeviceCapability();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _youtubeController?.dispose();
    super.dispose();
  }

  Future<void> _checkDeviceCapability() async {
    try {
      if (Platform.isAndroid) {
        final deviceInfo = DeviceInfoPlugin();
        final androidInfo = await deviceInfo.androidInfo;
        _supportsEmbeddedPlayer = androidInfo.version.sdkInt >= 20;
      } else {
        _supportsEmbeddedPlayer = true; // iOS always supports embedded player
      }
    } catch (e) {
      _supportsEmbeddedPlayer = true; // Default to embedded player on error
    }

    setState(() {
      _isCheckingDevice = false;
    });

    _loadRecipeDetail();
  }

  Future<void> _loadRecipeDetail() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      // Use the recipe ID from widget parameter or default
      final recipeId =
          widget.recipeId ?? '550e8400-e29b-41d4-a716-446655440001';

      final response = await RecipeService.getRecipeDetail(recipeId);
      final recipeData = RecipeService.parseRecipeDetail(response);

      setState(() {
        recipe = recipeData;
        isLoading = false;
      });

      // Initialize YouTube player if video URL exists and device supports it
      if (recipeData != null &&
          recipeData['video_url'] != null &&
          recipeData['video_url'].toString().isNotEmpty &&
          _isYouTubeUrl(recipeData['video_url']) &&
          _supportsEmbeddedPlayer) {
        _initializeYouTubePlayer(recipeData['video_url']);
      }

      // Load comments after recipe is loaded
      if (recipeData != null) {
        _loadComments();
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _loadComments() async {
    if (widget.recipeId == null) return;

    setState(() {
      isLoadingComments = true;
    });

    try {
      final response = await CommentService.getComments(widget.recipeId!);

      if (response['success'] == true) {
        setState(() {
          comments = response['data'] ?? [];
          isLoadingComments = false;
        });
      } else {
        setState(() {
          isLoadingComments = false;
        });
        _showSnackBar(
            response['message'] ?? 'Failed to load comments', Colors.red);
      }
    } catch (e) {
      setState(() {
        isLoadingComments = false;
      });
      _showSnackBar('Error loading comments: $e', Colors.red);
    }
  }

  Future<void> _postComment() async {
    if (_commentController.text.trim().isEmpty || widget.recipeId == null)
      return;

    setState(() {
      isPostingComment = true;
    });

    try {
      final response = await CommentService.addComment(
        recipeId: widget.recipeId!,
        content: _commentController.text.trim(),
      );

      if (response['success'] == true) {
        _commentController.clear();
        _showSnackBar('Comment posted successfully!', Colors.green);
        _loadComments(); // Reload comments
      } else {
        _showSnackBar(
            response['message'] ?? 'Failed to post comment', Colors.red);
      }
    } catch (e) {
      _showSnackBar('Error posting comment: $e', Colors.red);
    }

    setState(() {
      isPostingComment = false;
    });
  }

  Future<void> _deleteComment(String commentId) async {
    try {
      final response = await CommentService.deleteComment(commentId);

      if (response['success'] == true) {
        _showSnackBar('Comment deleted successfully!', Colors.green);
        _loadComments(); // Reload comments
      } else {
        _showSnackBar(
            response['message'] ?? 'Failed to delete comment', Colors.red);
      }
    } catch (e) {
      _showSnackBar('Error deleting comment: $e', Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgWhiteColor,
      body: _isCheckingDevice
          ? _buildLoadingState('Checking device compatibility...')
          : isLoading
              ? _buildLoadingState('Loading recipe...')
              : error != null
                  ? _buildErrorState()
                  : recipe != null
                      ? _buildRecipeContent()
                      : _buildNoDataState(),
    );
  }

  Widget _buildLoadingState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(message),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Error: $error'),
          ElevatedButton(
            onPressed: _loadRecipeDetail,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataState() {
    return const Center(child: Text('No recipe data available'));
  }

  Widget _buildRecipeContent() {
    final ingredients = RecipeService.getIngredients(recipe);
    final steps = RecipeService.getCookingSteps(recipe);
    final author = RecipeService.getRecipeAuthor(recipe);

    return CustomScrollView(
      slivers: [
        // Recipe Image Header
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          backgroundColor: orangeColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              child: recipe!['image_url'] != null &&
                      recipe!['image_url'].startsWith('assets/')
                  ? Image.asset(
                      recipe!['image_url'],
                      fit: BoxFit.cover,
                    )
                  : CachedNetworkImage(
                      imageUrl:
                          _recipeService.getImageUrl(recipe!['image_url']),
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[300],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.error, size: 50),
                      ),
                    ),
            ),
          ),
        ),

        // Video Section (if video_url exists)
        if (recipe!['video_url'] != null &&
            recipe!['video_url'].toString().isNotEmpty &&
            _isYouTubeUrl(recipe!['video_url']))
          SliverToBoxAdapter(child: _buildVideoSection()),

        // Recipe Content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recipe Title & Basic Info
                Text(
                  recipe!['title'] ?? 'Recipe Title',
                  style: darkBrownTextStyle.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  recipe!['description'] ?? 'Recipe description',
                  style: darkBrownTextStyle.copyWith(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 16),

                // Recipe Meta Info
                Row(
                  children: [
                    _buildInfoChip(
                      Icons.access_time_rounded,
                      '${recipe!['cooking_time']} min',
                      orangeColor,
                    ),
                    const SizedBox(width: 12),
                    _buildInfoChip(
                      Icons.category_rounded,
                      recipe!['category'] ?? 'Category',
                      greenColor,
                    ),
                    const SizedBox(width: 12),
                    if (recipe!['rating'] != null)
                      _buildInfoChip(
                        Icons.star_rounded,
                        recipe!['rating'].toString(),
                        Colors.amber,
                      ),
                  ],
                ),
                const SizedBox(height: 24),

                // Author Info
                if (author != null) ...[
                  Text(
                    'Recipe by',
                    style: darkBrownTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      author['profile_image'] != null
                          ? CircleAvatar(
                              radius: 25,
                              backgroundColor: orangeColor,
                              backgroundImage: CachedNetworkImageProvider(
                                _recipeService
                                    .getImageUrl(author['profile_image']),
                              ),
                            )
                          : CircleAvatar(
                              radius: 25,
                              backgroundColor: orangeColor,
                              child: Text(
                                '${author['first_name']?[0] ?? 'C'}${author['last_name']?[0] ?? 'U'}',
                                style: whiteTextStyle.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${author['first_name'] ?? 'Chef'} ${author['last_name'] ?? 'User'}',
                            style: darkBrownTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Recipe Creator',
                            style: darkBrownTextStyle.copyWith(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],

                // Ingredients Section
                Text(
                  'Ingredients',
                  style: darkBrownTextStyle.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                ...ingredients
                    .map((ingredient) => _buildIngredientItem(ingredient)),
                const SizedBox(height: 24),

                // Cooking Steps Section
                Text(
                  'Cooking Steps',
                  style: darkBrownTextStyle.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                ...steps
                    .asMap()
                    .entries
                    .map((entry) => _buildStepItem(entry.value, entry.key + 1)),
                const SizedBox(height: 32),

                // Start Cooking Button
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [orangeColor, orangeColor.withOpacity(0.8)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: orangeColor.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Implement start cooking functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Start cooking!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Start Cooking!',
                      style: whiteTextStyle.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Comments Section
                Text(
                  'Comments (${comments.length})',
                  style: darkBrownTextStyle.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),

                // Comment Input Field
                _buildCommentInput(),
                const SizedBox(height: 20),

                // Comments List
                if (isLoadingComments)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (comments.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(
                          Icons.comment_outlined,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No comments yet',
                          style: darkBrownTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Be the first to share your thoughts!',
                          style: darkBrownTextStyle.copyWith(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Column(
                    children: comments.map((comment) {
                      final authState = context.read<AuthBloc>().state;
                      final currentUserId = authState is AuthAuthenticated
                          ? authState.userData['id']?.toString()
                          : null;
                      final isCurrentUser = currentUserId != null &&
                          comment['user']['id'].toString() == currentUserId;

                      return CommentItem(
                        comment: comment,
                        isCurrentUser: isCurrentUser,
                        onDelete: isCurrentUser
                            ? () => _showDeleteDialog(comment['id'])
                            : null,
                      );
                    }).toList(),
                  ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientItem(Map<String, dynamic> ingredient) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: orangeColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              ingredient['name'] ?? 'Ingredient',
              style: darkBrownTextStyle.copyWith(fontSize: 16),
            ),
          ),
          Text(
            '${ingredient['quantity'] ?? ''} ',
            style: darkBrownTextStyle.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: orangeColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(Map<String, dynamic> step, int stepNumber) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: orangeColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                stepNumber.toString(),
                style: whiteTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(
                step['instruction'] ?? 'Step instruction',
                style: darkBrownTextStyle.copyWith(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Share your thoughts',
            style: darkBrownTextStyle.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _commentController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Write a comment...',
              hintStyle: TextStyle(color: Colors.grey.shade500),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: orangeColor, width: 2),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => _commentController.clear(),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: isPostingComment ? null : _postComment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: orangeColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isPostingComment
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Post',
                        style: whiteTextStyle.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(String commentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Delete Comment',
            style: darkBrownTextStyle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this comment?',
            style: darkBrownTextStyle.copyWith(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteComment(commentId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Delete',
                style: whiteTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  bool _isYouTubeUrl(String url) {
    return url.contains('youtube.com') || url.contains('youtu.be');
  }

  void _initializeYouTubePlayer(String videoUrl) {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    if (videoId != null) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          forceHD: false,
          disableDragSeek: false,
        ),
      );
    }
  }

  void _launchVideoExternally(String videoUrl) async {
    try {
      final uri = Uri.parse(videoUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showSnackBar('Could not launch video', Colors.red);
      }
    } catch (e) {
      _showSnackBar('Error launching video: $e', Colors.red);
    }
  }

  Widget _buildVideoSection() {
    return Container(
      margin: const EdgeInsets.all(24),
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [orangeColor, orangeColor.withOpacity(0.8)],
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Icon(Icons.play_circle_filled, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Recipe Video Tutorial',
                  style: whiteTextStyle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (!_supportsEmbeddedPlayer) ...[
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'External',
                      style: whiteTextStyle.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _supportsEmbeddedPlayer
                      ? 'Watch the step-by-step cooking process'
                      : 'Tap to open video in YouTube app',
                  style: darkBrownTextStyle.copyWith(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 12),
                if (_supportsEmbeddedPlayer && _youtubeController != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: YoutubePlayerBuilder(
                      player: YoutubePlayer(
                        controller: _youtubeController!,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: orangeColor,
                        progressColors: ProgressBarColors(
                          playedColor: orangeColor,
                          handleColor: orangeColor.withOpacity(0.8),
                          backgroundColor: Colors.grey.shade300,
                          bufferedColor: Colors.grey.shade200,
                        ),
                      ),
                      builder: (context, player) {
                        return player;
                      },
                    ),
                  ),
                ] else ...[
                  GestureDetector(
                    onTap: () => _launchVideoExternally(recipe!['video_url']),
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [
                            Colors.red.shade100,
                            Colors.red.shade50,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Stack(
                        children: [
                          // YouTube logo background
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.red.shade600,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),

                          // Info overlay
                          Positioned(
                            bottom: 12,
                            left: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.open_in_new,
                                      color: Colors.white, size: 16),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Opens in YouTube App',
                                      style: whiteTextStyle.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _supportsEmbeddedPlayer
                        ? Colors.red.shade50
                        : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: _supportsEmbeddedPlayer
                            ? Colors.red.shade200
                            : Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                          _supportsEmbeddedPlayer
                              ? Icons.video_library
                              : Icons.info_outline,
                          color: _supportsEmbeddedPlayer
                              ? Colors.red.shade400
                              : Colors.orange.shade600,
                          size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _supportsEmbeddedPlayer
                              ? 'YouTube Video Tutorial - Use controls to play'
                              : 'Your device will open this video in the YouTube app for the best experience',
                          style: TextStyle(
                            fontSize: 12,
                            color: _supportsEmbeddedPlayer
                                ? Colors.red.shade600
                                : Colors.orange.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
