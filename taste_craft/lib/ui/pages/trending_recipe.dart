import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const TrendingRecipesPage(),
    );
  }
}

class TrendingRecipesPage extends StatefulWidget {
  const TrendingRecipesPage({super.key});

  @override
  _TrendingRecipesPageState createState() => _TrendingRecipesPageState();
}

class _TrendingRecipesPageState extends State<TrendingRecipesPage> {
  int _selectedIndex = 0;

  // Sample comments and reviews
  List<Map<String, String>> comments = [
    {
      "username": "@_joshua",
      "comment": "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
      "time": "15 Mins Ago",
    },
    {
      "username": "@josh-ryan",
      "comment": "Praesent fringilla la delifend purus vel dignissim.",
      "time": "40 Mins Ago",
    },
    {
      "username": "@sweet.sarah",
      "comment": "Praesent urna ante, auctor nec lorem ut, aliquet viverra.",
      "time": "1 Hr Ago",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // White background color
        elevation: 0, // Remove shadow for flat design
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFCA7100)), // Set color to '#CA7100'
          onPressed: () {
            // Add functionality for back button
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the title
          children: const [
            Text(
              'Reviews',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFCA7100), // Title color '#CA7100'
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.orange), // Bell icon for notifications
            onPressed: () {
              // Add functionality for notification icon
            },
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.orange), // Search icon for search
            onPressed: () {
              // Add search functionality here
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Product Review Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Most Viewed Today',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      // Handle navigation or action on recipe click
                    },
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/salmon_pizza.jpg', // Your image asset
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Salmon and Cheese Pizza',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'This is a quick overview of the ingredients...',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: const [
                                  Icon(Icons.access_time, size: 14),
                                  SizedBox(width: 4),
                                  Text('30 min'),
                                  SizedBox(width: 16),
                                  Icon(Icons.favorite_border, size: 14),
                                  SizedBox(width: 4),
                                  Text('5'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Other Recipes
            const Text(
              'Other Recipes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            RecipeCard(
              image: 'assets/chicken_curry.jpg',
              title: 'Chicken Curry',
              time: '40 min',
              chef: 'Chef Josh Ryan',
              difficulty: 'Easy',
            ),
            const SizedBox(height: 10),
            RecipeCard(
              image: 'assets/chicken_burger.jpg',
              title: 'Chicken Burger',
              time: '15 min',
              chef: 'Chef Andrew',
              difficulty: 'Medium',
            ),
            const SizedBox(height: 10),
            RecipeCard(
              image: 'assets/tiramisu.jpg',
              title: 'Tiramisu',
              time: '45 min',
              chef: 'Chef Anna',
              difficulty: 'Hard',
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20), // Add margin to float the bar
        decoration: BoxDecoration(
          color: Color(0xFFCA7100),
          borderRadius: BorderRadius.circular(30),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex, // Updates the selected index
          onTap: _onItemTapped,
          selectedItemColor: Colors.white, // White color for selected icon
          unselectedItemColor: Colors.white.withOpacity(0.6), // Slightly transparent for unselected
          backgroundColor: Colors.transparent, // Remove background color
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed, // Keep it fixed
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
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
              icon: Icon(Icons.account_circle, size: 30), // Custom icon for Profile
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  // Function to handle bottom navigation bar item selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class RecipeCard extends StatelessWidget {
  final String image;
  final String title;
  final String time;
  final String chef;
  final String difficulty;

  const RecipeCard({
    required this.image,
    required this.title,
    required this.time,
    required this.chef,
    required this.difficulty,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle recipe click
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                image,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'By $chef',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 14),
                      const SizedBox(width: 4),
                      Text(time),
                      const SizedBox(width: 16),
                      const Icon(Icons.star_border, size: 14),
                      const SizedBox(width: 4),
                      Text(difficulty),
                    ],
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
