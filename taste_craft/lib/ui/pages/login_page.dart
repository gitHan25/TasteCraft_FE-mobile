import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:taste_craft/bloc/auth/auth_bloc.dart';
import 'package:taste_craft/bloc/auth/auth_event.dart';
import 'package:taste_craft/bloc/auth/auth_state.dart';
import 'package:taste_craft/shared/theme.dart';
import 'package:taste_craft/ui/widgets/buttons.dart';
import 'package:taste_craft/ui/widgets/form.dart';
import 'package:taste_craft/utils/form_validators.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgWhiteColor,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
              (route) => false,
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              children: [
                Container(
                  width: 323,
                  height: 270,
                  margin: const EdgeInsets.only(top: 30, bottom: 10),
                  decoration: const BoxDecoration(
                    image:
                        DecorationImage(image: AssetImage('assets/Logo1.png')),
                  ),
                ),
                Text(
                  'Login',
                  style: headerTextStyle.copyWith(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: bgWhiteColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomFormField(
                        title: 'Email',
                        hintText: 'example@example.com',
                        controller: _emailController,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomFormField(
                        title: 'Password',
                        hintText: '********',
                        obscureText: true,
                        controller: _passwordController,
                      ),
                      const SizedBox(
                        height: 13,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Forgot Password?',
                          style: darkBrownTextStyle2.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: state is AuthLoading
                            ? const CircularProgressIndicator()
                            : CustomButton(
                                title: 'Login',
                                onPressed: () {
                                  String email = _emailController.text.trim();
                                  String password =
                                      _passwordController.text.trim();

                                  String? emailError =
                                      FormValidators.validateEmail(
                                          email, context);
                                  if (emailError != null) {
                                    FormValidators.showErrorSnackBar(
                                        context, emailError);
                                    return;
                                  }

                                  String? passwordError =
                                      FormValidators.validatePassword(
                                          password, context);
                                  if (passwordError != null) {
                                    FormValidators.showErrorSnackBar(
                                        context, passwordError);
                                    return;
                                  }

                                  context.read<AuthBloc>().add(
                                        AuthLoginRequested(
                                          email: email,
                                          password: password,
                                        ),
                                      );
                                },
                              ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Dont have an account?',
                            style: darkBrownTextStyle2.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: Text(
                              ' Register',
                              style: buttonTextStyle.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w200,
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
          );
        },
      ),
    );
  }
}
