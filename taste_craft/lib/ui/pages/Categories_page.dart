import 'package:flutter/material.dart';
import 'package:taste_craft/shared/theme.dart';
import 'package:taste_craft/ui/widgets/categories_card.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // White background color
        elevation: 0, // Remove shadow for flat design
        leading: IconButton(
          icon: Image.asset('assets/back-arrow.png'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the title
          children: [
            Text(
              'Categories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFCA7100), // Dark text color
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: orangeColor),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.search, color: orangeColor),
            onPressed: () {},
          ),
        ],
      ),
      body: const CategoriesGrid(),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        decoration: BoxDecoration(
          color: Color(0xFFCA7100),
          borderRadius: BorderRadius.circular(30),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.6),
          backgroundColor: Colors.transparent,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 30),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message, size: 30), // Custom icon for Search
              label: 'Message',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category, size: 30), // Custom icon for Search
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle,
                  size: 30), // Custom icon for Profile
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class CategoriesGrid extends StatelessWidget {
  const CategoriesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          CategoryCard(
            image: 'assets/Food1.png',
            categoryName: 'Seafood',
            onTap: () {},
          ),
          CategoryCard(
            image: 'assets/Food1.png',
            categoryName: 'Lunch',
            onTap: () {},
          ),
          CategoryCard(
            image: 'assets/Food1.png',
            categoryName: 'Breakfast',
            onTap: () {},
          ),
          CategoryCard(
            image: 'assets/Food1.png',
            categoryName: 'Dinner',
            onTap: () {},
          ),
          CategoryCard(
            image: 'assets/Food1.png',
            categoryName: 'Vegan',
            onTap: () {},
          ),
          CategoryCard(
            image: 'assets/Food1.png',
            categoryName: 'Dessert',
            onTap: () {},
          ),
          CategoryCard(
            image: 'assets/Food1.png',
            categoryName: 'Drinks',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
