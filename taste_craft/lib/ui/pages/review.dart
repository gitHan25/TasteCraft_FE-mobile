import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ReviewPage(),
    );
  }
}

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final TextEditingController _commentController = TextEditingController();

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

  // Variable to track selected bottom navigation bar item
  int _selectedIndex = 0;

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
                color: Colors.brown[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/burger.jpg', // Add your burger image here
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Product Info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Chicken Burger',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: const [
                          Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber,
                          ),
                          Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber,
                          ),
                          Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber,
                          ),
                          Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber,
                          ),
                          Icon(
                            Icons.star_border,
                            size: 16,
                            color: Colors.amber,
                          ),
                          SizedBox(width: 4),
                          Text("(45 Reviews)"),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '@Andrew-Mari | Andrew Martinez-Chef',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      // Add Review action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Add Review'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Comments Section
            Expanded(
              child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(comments[index]['username']!),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(comments[index]['comment']!),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 16, color: Colors.amber),
                            const Icon(Icons.star, size: 16, color: Colors.amber),
                            const Icon(Icons.star, size: 16, color: Colors.amber),
                            const Icon(Icons.star_border, size: 16, color: Colors.amber),
                            const Icon(Icons.star_border, size: 16, color: Colors.amber),
                          ],
                        ),
                        Text(
                          comments[index]['time']!,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Add Comment Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      // Submit the comment
                      setState(() {
                        comments.insert(0, {
                          "username": "@new_user",
                          "comment": _commentController.text,
                          "time": "Just Now",
                        });
                      });
                      _commentController.clear();
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
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
