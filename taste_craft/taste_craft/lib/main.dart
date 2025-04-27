import 'package:flutter/material.dart';
import 'package:taste_craft/ui/pages/login_page.dart';
import 'package:taste_craft/ui/pages/on_boarding2.dart';
import 'package:taste_craft/ui/pages/splash_page.dart';
import 'package:taste_craft/ui/pages/categories.dart';
import 'package:taste_craft/ui/pages/review.dart';
import 'package:taste_craft/ui/pages/review_detail.dart';
import 'package:taste_craft/ui/pages/recipe_detail.dart';
import 'package:taste_craft/ui/pages/trending_recipe.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/recipe', // Set initial route to CategoriesPage
      routes: {
        '/categories': (context) => const CategoriesPage(),  // Categories Page
        '/reviews': (context) => const ReviewPage(), // Review Page
        '/review-detail': (context) => const LeaveReviewPage(), // Review Detail Page
        '/recipe': (context) => const RecipeDetail(), // Recipe Detail Page
        '/trending': (context) => const TrendingRecipesPage(), // Trending Recipes Page
        '/on-boarding2': (context) => const OnBoarding2(), // Onboarding Page
        '/login': (context) => const LoginPage(), // Login Page
        '/splash': (context) => const SplashPage(), // Splash Page
      },
    );
  }
}
