import 'package:flutter/material.dart';
import 'package:taste_craft/shared/theme.dart';
import 'package:taste_craft/ui/widgets/categories_card.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
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
