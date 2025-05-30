import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taste_craft/shared/theme.dart';
import 'package:taste_craft/ui/pages/on_boarding.dart';
import 'package:taste_craft/bloc/auth/auth.dart';
import 'package:taste_craft/service/auth_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _hasNavigated = false;
  bool _authCheckTriggered = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  void _initializeApp() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final isLoggedIn = await AuthService.isLoggedInOffline();

    if (isLoggedIn) {
      _authCheckTriggered = true;
      context.read<AuthBloc>().add(AuthCheckStatus());
    } else {
      // User not logged in - navigate directly
      _navigateToAuth();
    }
  }

  void _navigateToAuth() async {
    if (_hasNavigated) return;
    _hasNavigated = true;

    final hasSeenOnboarding = await AuthService.hasCompletedOnboarding();

    if (hasSeenOnboarding) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnBoarding()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (_authCheckTriggered && !_hasNavigated) {
            if (state is AuthAuthenticated) {
              _hasNavigated = true;
              Navigator.pushReplacementNamed(context, '/home');
            } else if (state is AuthUnauthenticated) {
              _navigateToAuth();
            }
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 300,
                height: 300,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/Logo.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
