import 'package:flutter/material.dart';
import 'package:taste_craft/shared/theme.dart';
import 'package:taste_craft/ui/widgets/button.dart';

class OnBoarding2 extends StatelessWidget {
  const OnBoarding2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgWhiteColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Padding(
            padding: const EdgeInsets.all(0),
            child: Image.asset(
              'assets/back-arrow.png',
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        toolbarHeight: 30,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 0,
          ),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            crossAxisSpacing: 24,
            mainAxisSpacing: 5,
            padding: const EdgeInsets.all(20),
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/Logo.png',
                    width: 170,
                    height: 167,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/Logo.png',
                    width: 170,
                    height: 167,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/Logo.png',
                    width: 170,
                    height: 167,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/Logo.png',
                    width: 170,
                    height: 167,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/Logo.png',
                    width: 170,
                    height: 167,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/Logo.png',
                    width: 170,
                    height: 167,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                Text(
                  'Welcome',
                  style: darkBrownTextStyle.copyWith(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Find the best recipes that the world can provide you also with every step that you can learn to increase your cooking skills.',
                  style: darkBrownTextStyle.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                Center(
                  child: Row(
                    children: [
                      CustomFilledButton(
                        title: 'Login',
                        width: 160,
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                      ),
                      const Spacer(),
                      CustomFilledButton(
                          title: 'Register',
                          width: 160,
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          }),
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
