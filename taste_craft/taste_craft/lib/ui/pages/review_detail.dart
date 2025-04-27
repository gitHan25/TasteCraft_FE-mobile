import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LeaveReviewPage(), // Use LeaveReviewPage as home
      routes: {
        '/home': (context) => const HomePage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Center(child: Text('Welcome to Home Page!')),
    );
  }
}

class LeaveReviewPage extends StatefulWidget {
  const LeaveReviewPage({super.key});

  @override
  _LeaveReviewPageState createState() => _LeaveReviewPageState();
}

class _LeaveReviewPageState extends State<LeaveReviewPage> {
  int _rating = 0; // Track the rating
  bool _recommended = false; // Track if the user recommends the recipe
  final TextEditingController _reviewController = TextEditingController();

  // Function to show Thank You dialog after submitting the review
  void _showThankYouDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thank You For Your Review!'),
          content: const Text(
            'Your feedback is appreciated. We will take it into account.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigate to home or reset the form
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: const Text('Go To Home'),
            ),
          ],
        );
      },
    );
  }

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
              'Trending Recipes',
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
            // Product Image Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.brown[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/burger.jpg', // Your burger image
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Chicken Burger',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Rating Section
            const Text('Your overall rating', style: TextStyle(fontSize: 18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 30,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1; // Update rating based on user click
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 16),

            // Review Text Area
            const Text('Leave us Review', style: TextStyle(fontSize: 18)),
            TextField(
              controller: _reviewController,
              decoration: InputDecoration(
                hintText: 'Write your review here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),

            // Add Photo Section
            Row(
              children: [
                Checkbox(
                  value: false, // Replace with actual photo logic if needed
                  onChanged: (bool? value) {
                    // Handle photo upload action
                  },
                ),
                const Text('Add Photo'),
              ],
            ),
            const SizedBox(height: 16),

            // Recommendation Section
            const Text('Do you recommend this recipe?', style: TextStyle(fontSize: 18)),
            Row(
              children: [
                Row(
                  children: [
                    const Text('No'),
                    Radio<bool>(
                      value: false,
                      groupValue: _recommended,
                      onChanged: (bool? value) {
                        setState(() {
                          _recommended = value!;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Yes'),
                    Radio<bool>(
                      value: true,
                      groupValue: _recommended,
                      onChanged: (bool? value) {
                        setState(() {
                          _recommended = value!;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Action Buttons (Cancel & Submit)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle cancel action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Call function to show thank you message
                    _showThankYouDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Submit'),
                ),
              ],
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
          currentIndex: 0, // Set default selected index
          onTap: (index) {
            // Handle bottom navigation tap
          },
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.6),
          backgroundColor: Colors.transparent,
          showUnselectedLabels: true,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
