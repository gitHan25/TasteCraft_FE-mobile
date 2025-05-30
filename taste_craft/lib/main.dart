import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taste_craft/bloc/auth/auth_bloc.dart';
import 'package:taste_craft/bloc/recipe/recipe.dart';
import 'package:taste_craft/bloc/bookmark/bookmark_bloc.dart';
import 'package:taste_craft/ui/pages/Categories_page.dart';
import 'package:taste_craft/ui/pages/home_page.dart';
import 'package:taste_craft/ui/pages/login_page.dart';
import 'package:taste_craft/ui/pages/on_boarding2.dart';
import 'package:taste_craft/ui/pages/profile.dart';
import 'package:taste_craft/ui/pages/recipe_detail.dart';
import 'package:taste_craft/ui/pages/register_page.dart';
import 'package:taste_craft/ui/pages/review_detail.dart';
import 'package:taste_craft/ui/pages/review_page.dart';
import 'package:taste_craft/ui/pages/splash_page.dart';
import 'package:taste_craft/ui/pages/bookmarks_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(),
        ),
        BlocProvider<RecipeBloc>(
          create: (context) => RecipeBloc(),
        ),
        BlocProvider<BookmarkBloc>(
          create: (context) => BookmarkBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashPage(),
          '/on-boarding2': (context) => const OnBoarding2(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/home': (context) => const HomePage(),
          '/receipt-detail': (context) => const RecipeDetail(),
          '/categories': (context) => const CategoriesPage(),
          '/review-page': (context) => const ReviewPage(),
          '/leave-review': (context) => const LeaveReviewPage(),
          '/profile': (context) => const ProfilePage(),
          '/bookmarks': (context) => const BookmarksPage(),
        },
      ),
    );
  }
}
