import 'package:flutter/material.dart';

import 'package:taste_craft/shared/theme.dart';
import 'package:taste_craft/ui/widgets/buttons.dart';
import 'package:taste_craft/ui/widgets/form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgWhiteColor,
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        children: [
          Container(
            width: 323,
            height: 270,
            margin: const EdgeInsets.only(top: 30, bottom: 10),
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/Logo1.png')),
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
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomFormField(
                  title: 'Password',
                  hintText: '********',
                  obscureText: true,
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
                  child: CustomButton(
                    title: 'Login',
                    onPressed: () {},
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
  }
}
