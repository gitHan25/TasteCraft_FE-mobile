import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:taste_craft/shared/theme.dart';
import 'package:taste_craft/ui/widgets/recipeCard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    if (index == 3) {
      Navigator.pushNamed(context, '/profile');
    } else if (index == 1) {
      Navigator.pushNamed(context, '/categories');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/review-page');
    } else if (index == 0) {
      Navigator.pushNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgWhiteColor,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        selectedLabelStyle: whiteTextStyle.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: darkBrownTextStyle2.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
        backgroundColor: bgButtonColor,
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Image.asset(
                'assets/home-icon.png',
                width: 20,
                color: Colors.blue,
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Image.asset(
                'assets/Community.png',
                width: 20,
              ),
            ),
            label: 'Categories',
            backgroundColor: bgWhiteColor,
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: Icon(
                Icons.reviews,
                color: bgWhiteColor,
                size: 20,
              ),
            ),
            label: 'Review',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Icon(
                Icons.person,
                color: bgWhiteColor,
                size: 20,
              ),
            ),
            label: 'Profile',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        children: [
          topSection(),
          const SizedBox(
            height: 30,
          ),
          tabSection(),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Today Recipe',
            style: orangeTextStyle.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.asset(
                    'assets/Food1.png', // Gambar pizza
                    width: 358,
                    height: 143,
                    fit: BoxFit.contain,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Salami and cheese pizza',
                            style: darkBrownTextStyle.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Salami and Cheese, a Perfect Match in Every Bite',
                            style: darkBrownTextStyle.copyWith(
                                fontSize: 10, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      // Heart Icon
                      IconButton(
                        icon: Icon(
                          Icons.bookmark,
                          color: orangeColor,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.access_time, color: Colors.grey, size: 18),
                          SizedBox(width: 5),
                          Text(
                            '30min',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      // Rating
                    ],
                  ),
                ),
              ],
            ),
          ),
          buildFavReceipt(),
          buildSeafoodReceipt(),
          buildBreakfastReceipt(),
        ],
      ),
    );
  }

  Widget topSection() {
    return Container(
      margin: const EdgeInsets.only(
        top: 40,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi! Farhan',
                style: orangeTextStyle.copyWith(
                  fontSize: 25.31,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'What are you cooking today?',
                style: darkBrownTextStyle.copyWith(
                  fontSize: 13.45,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/search-page');
            },
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: const DecorationImage(
                  image: AssetImage('assets/search-icon.png'),
                ),
                color: bgInputColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget tabSection() {
    return DefaultTabController(
      length: 8,
      child: Align(
        alignment: Alignment.centerLeft,
        child: TabBar(
          isScrollable: true,
          indicatorSize: TabBarIndicatorSize.tab,
          labelPadding: const EdgeInsets.only(left: 20, right: 20),
          unselectedLabelColor: orangeColor,
          labelStyle: whiteTextStyle.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: darkBrownTextStyle2.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          indicator: BoxDecoration(
            color: greenColor,
            borderRadius: BorderRadius.circular(20),
          ),
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Seafood'),
            Tab(text: 'Breakfast'),
            Tab(text: 'Lunch'),
            Tab(text: 'Dinner'),
            Tab(text: 'Vegan'),
            Tab(text: 'Dessert'),
            Tab(text: 'Drink'),
          ],
        ),
      ),
    );
  }

  Widget buildFavReceipt() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: greenColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 10),
            child: Text(
              'Your Favorite Recipe',
              style: whiteTextStyle.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Card pertama
              Recipecard(
                image: 'assets/Food-2.png',
                title: 'Cheese Burger',
                time: '15min',
              ),

              Recipecard(
                image: 'assets/Food-3.png',
                title: 'Tiramisu',
                time: '15min',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSeafoodReceipt() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: greenColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 16, top: 10), // Geser ke kanan dengan padding
            child: Text(
              'Seafood Recipe',
              style: whiteTextStyle.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Row untuk menampilkan dua kartu berdampingan
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Recipecard(
                  image: 'assets/Food-2.png',
                  title: 'Cheese Burger',
                  time: '15min',
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/receipt-detail',
                  ),
                ),
                Recipecard(
                  image: 'assets/Food-3.png',
                  title: 'Tiramisu',
                  time: '15min',
                ),
                Recipecard(
                    image: 'assets/Food-3.png', title: 'sushi', time: '20 min'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBreakfastReceipt() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: greenColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 10),
            child: Text(
              'Breakfast Recipe',
              style: whiteTextStyle.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Recipecard(
                  image: 'assets/Food-2.png',
                  title: 'Cheese Burger',
                  time: '15min',
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/receipt-detail',
                  ),
                ),
                Recipecard(
                  image: 'assets/Food-3.png',
                  title: 'Tiramisu',
                  time: '15min',
                ),
                Recipecard(
                    image: 'assets/Food-3.png', title: 'sushi', time: '20 min'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
