import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:taste_craft/shared/theme.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  int currentIndex = 0;
  CarouselSliderController carouselController = CarouselSliderController();

  List<String> title = [
    'Get Inspired',
    'Get an increase your skills',
  ];

  List<String> sub = [
    'Get inspired with our recipe recommendations.',
    'Learn essential cooking techniques at your own pace.',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgWhiteColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CarouselSlider(
              items: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/Onboarding_1.png'), // Gambar pertama
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage('assets/Onboarding_2.png'), // Gambar kedua
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
              options: CarouselOptions(
                height: 550,
                viewportFraction: 1,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
              carouselController: carouselController,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title[currentIndex],
                    style: brownTextStyle.copyWith(
                        fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    sub[currentIndex],
                    style: brownTextStyle.copyWith(
                        fontSize: 13, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        margin: const EdgeInsets.only(
                          right: 10,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentIndex == 0 ? bgButtonColor : greyColor,
                        ),
                      ),
                      Container(
                        width: 12,
                        height: 12,
                        margin: const EdgeInsets.only(
                          right: 10,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentIndex == 1 ? bgButtonColor : greyColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () {
                      carouselController.nextPage();
                      if (currentIndex == 1) {
                        Navigator.pushNamed(context, '/on-boarding2');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: bgInputColor,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Continue',
                      style: buttonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
