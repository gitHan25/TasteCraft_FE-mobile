import 'package:flutter/material.dart';
import 'package:taste_craft/shared/theme.dart';

class RecipeDetail extends StatefulWidget {
  const RecipeDetail({super.key});

  @override
  _RecipeDetailState createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgWhiteColor,
        elevation: 0, // Remove shadow for flat design
        leading: IconButton(
          icon: Image.asset('assets/back-arrow.png'),
          onPressed: () {
            Navigator.pop(context, '/home'); // Navigate back to home
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the title
          children: const [
            Text(
              'Detail Recipes',
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
            icon: const Icon(Icons.notifications,
                color: Colors.orange), // Notification icon
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.orange), // Search icon
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Recipe Image Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recipe Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/Food1.png', // Replace with your image
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Play Button Overlay
                  Positioned(
                    bottom: 10,
                    left: 20,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle video play
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Colors
                            .orange, // Background color for the play button
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        size: 36,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Recipe Title and Additional Info
            const Text(
              'Salmon And Cheese Pizza',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.person, size: 16),
                SizedBox(width: 4),
                Text('Admin', style: TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Details: 30 min\nThis is a quick overview of the ingredients you\'ll need for this Salmon Pizza recipe. Specific measurements and full recipe instructions are in the printable recipe card below.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            // Ingredients Section
            const Text(
              'Ingredients',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text('• 1 pre-made pizza dough (store-bought or homemade)',
                style: TextStyle(fontSize: 14)),
            const Text('• 1/2 cup pizza sauce', style: TextStyle(fontSize: 14)),
            const Text('• 1/2 cups shredded mozzarella cheese',
                style: TextStyle(fontSize: 14)),
            const Text('• 1/4 cup sliced salami',
                style: TextStyle(fontSize: 14)),
            const Text('• 1/4 cup olives (optional)',
                style: TextStyle(fontSize: 14)),
            const SizedBox(height: 16),
            // Bottom Navigation Bar
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              decoration: BoxDecoration(
                color: Color(0xFFCA7100),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
