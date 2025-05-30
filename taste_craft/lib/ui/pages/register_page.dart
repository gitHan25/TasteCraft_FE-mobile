import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taste_craft/bloc/auth/auth_bloc.dart';
import 'package:taste_craft/bloc/auth/auth_event.dart';
import 'package:taste_craft/bloc/auth/auth_state.dart';
import 'package:taste_craft/shared/theme.dart';
import 'package:taste_craft/ui/widgets/button.dart';
import 'package:taste_craft/ui/widgets/buttons.dart';
import 'package:taste_craft/ui/widgets/form.dart';
import 'package:taste_craft/utils/form_validators.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    // Validate using the utility class
    String? firstNameError =
        FormValidators.validateName(firstName, context, 'First name');
    if (firstNameError != null) {
      FormValidators.showErrorSnackBar(context, firstNameError);
      return;
    }

    String? lastNameError =
        FormValidators.validateName(lastName, context, 'Last name');
    if (lastNameError != null) {
      FormValidators.showErrorSnackBar(context, lastNameError);
      return;
    }

    String? emailError = FormValidators.validateEmail(email, context);
    if (emailError != null) {
      FormValidators.showErrorSnackBar(context, emailError);
      return;
    }

    String? passwordError = FormValidators.validatePassword(password, context);
    if (passwordError != null) {
      FormValidators.showErrorSnackBar(context, passwordError);
      return;
    }

    String? confirmPasswordError = FormValidators.validateConfirmPassword(
        confirmPassword, password, context);
    if (confirmPasswordError != null) {
      FormValidators.showErrorSnackBar(context, confirmPasswordError);
      return;
    }

    // If all validations pass, proceed with registration
    context.read<AuthBloc>().add(
          AuthRegisterRequested(
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgWhiteColor,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            // Show success dialog
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                backgroundColor: bgWhiteColor,
                title: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: bgInputColor,
                      radius: 30,
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Sign Up Successful!',
                      textAlign: TextAlign.center,
                      style: hintTextStyle.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                content: Text(
                  'Successfully registered.\nYou can now Log In and start exploring delicious recipes!',
                  textAlign: TextAlign.center,
                  style: hintTextStyle.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                actions: [
                  CustomFilledButton(
                    title: 'Continue',
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
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
                vertical: 40,
              ),
              children: [
                Text(
                  'Sign Up',
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
                        title: 'First Name',
                        hintText: 'John',
                        icon: const Icon(Icons.person),
                        controller: _firstNameController,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomFormField(
                        title: 'Last Name',
                        hintText: 'Doe',
                        icon: const Icon(Icons.person),
                        controller: _lastNameController,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomFormField(
                        title: 'Email',
                        hintText: 'example@gmail.com',
                        icon: const Icon(Icons.email),
                        controller: _emailController,
                      ),
                      const SizedBox(
                        height: 13,
                      ),
                      CustomFormField(
                        title: 'Password',
                        hintText: '********',
                        obscureText: !_isPasswordVisible,
                        controller: _passwordController,
                        icon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 13,
                      ),
                      CustomFormField(
                        title: 'Confirm Password',
                        hintText: '********',
                        obscureText: !_isConfirmPasswordVisible,
                        controller: _confirmPasswordController,
                        icon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: darkBrownTextStyle2.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w200,
                            ),
                            children: [
                              const TextSpan(
                                  text: 'By continuing, you agree to\n'),
                              TextSpan(
                                text: 'Terms of Use',
                                style: darkBrownTextStyle2.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: darkBrownTextStyle2.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(text: '.'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Center(
                        child: state is AuthLoading
                            ? const CircularProgressIndicator()
                            : CustomButton(
                                title: 'Sign Up',
                                onPressed: () {
                                  _handleSignUp();
                                },
                              ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: darkBrownTextStyle2.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: Text(
                              ' Log In',
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
