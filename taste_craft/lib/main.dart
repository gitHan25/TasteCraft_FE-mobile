import 'package:flutter/material.dart';
import 'package:taste_craft/ui/pages/login_page.dart';
import 'package:taste_craft/ui/pages/on_boarding2.dart';
import 'package:taste_craft/ui/pages/splash_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashPage(),
        '/on-boarding2': (context) => const OnBoarding2(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}
