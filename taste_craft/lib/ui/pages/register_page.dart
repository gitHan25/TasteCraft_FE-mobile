import 'package:flutter/material.dart';
import 'package:taste_craft/shared/theme.dart';
import 'package:taste_craft/ui/widgets/button.dart';
import 'package:taste_craft/ui/widgets/buttons.dart';
import 'package:taste_craft/ui/widgets/form.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgWhiteColor,
      body: ListView(
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
                  title: 'Full Name',
                  hintText: 'John Doe',
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomFormField(
                  title: 'Email',
                  hintText: 'example@gmail.com',
                ),
                const SizedBox(
                  height: 13,
                ),
                CustomFormField(
                  title: 'Mobile Number',
                  hintText: '+6288888888',
                ),
                const SizedBox(
                  height: 13,
                ),
                CustomFormField(
                  title: 'Date Of Birth',
                  hintText: 'DD/MM/YYYY',
                ),
                const SizedBox(
                  height: 13,
                ),
                CustomFormField(
                  title: 'Password',
                  hintText: '********',
                  obscureText: true,
                ),
                const SizedBox(
                  height: 13,
                ),
                CustomFormField(
                  title: 'Confirm Password',
                  hintText: '********',
                  obscureText: true,
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
                        const TextSpan(text: 'By continuing, you agree to\n'),
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
                  child: CustomButton(
                    title: 'Sign Up',
                    onPressed: () => showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: Colors.white,
                        title: Column(
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  Color(0xFFFE9B3D), // Orange color
                              radius: 30,
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Sign Up Successful!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        content: const Text(
                          'Successfully registered.\nYou can now Log In and start exploring delicious recipes!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
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
                              }),
                        ],
                      ),
                    ),
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
  }
}
