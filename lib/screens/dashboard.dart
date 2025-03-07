import 'package:cyberapp/screens/advance_level.dart';
import 'package:cyberapp/screens/beginner_level.dart';
import 'package:cyberapp/screens/inter_level.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'leaderboard.dart';
import 'settings_screen.dart';
import 'trophies.dart';
import 'user_global_vars.dart'; // Import the file where AppUser is defined
import 'dart:async';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _supabase = Supabase.instance.client;
  Timer? _rateUsTimer;
  bool _hasRated = false;
  int _selectedIndex = 0;
  String _selectedContent = 'home';

  // Declare _pages as a late variable
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    // Initialize _pages in the constructor body
    _pages = [
      HomeScreen(onSelectContent: _selectContent),
      Trophies(),
      Leaderboard(),
      SettingsScreen(),
    ];

    _checkIfUserHasRated();
    _rateUsTimer = Timer(Duration(seconds: 10), () {
      if (!_hasRated) {
        _showRateUsPopup(context);
      }
    });
  }

  @override
  void dispose() {
    _rateUsTimer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  // Function to check if the user has already rated
  Future<void> _checkIfUserHasRated() async {
    final userId = AppUser.getUserId(); // Get the current user ID
    final result = await _supabase
        .from('rating')
        .select('rating')
        .eq('user_id', userId as Object)
        .maybeSingle();
    if (result != null && result.isNotEmpty) {
      setState(() {
        _hasRated = true; // User has already rated
      });
    }
  }

  // Function to handle tab selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Reset selected content to 'home' when switching tabs
      _selectedContent = 'home';
    });
  }

  // Function to handle content selection (e.g., Beginner, Intermediate, Advanced)
  void _selectContent(String content) {
    setState(() {
      _selectedContent = content;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Scaffold containing the body and bottom navigation bar
        Scaffold(
          body: _selectedIndex == 0
              ? (_selectedContent == 'home'
              ? HomeScreen(onSelectContent: _selectContent)
              : _getContent(_selectedContent))
              : _pages[_selectedIndex],
          bottomNavigationBar: Padding(
            padding: EdgeInsets.all(16.0),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.purpleAccent,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.white,
              items: [
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'lib/assets/images/homeIcon.png',
                    width: 40,
                    height: 40,
                  ),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'lib/assets/images/trophyIcon.png',
                    width: 40,
                    height: 40,
                  ),
                  label: 'Trophies',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'lib/assets/images/leadIcon.png',
                    width: 40,
                    height: 40,
                  ),
                  label: 'Leaderboard',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'lib/assets/images/settingsIcon.png',
                    width: 40,
                    height: 40,
                  ),
                  label: 'Settings',
                ),
              ],
            ),
          ),
        ),
        // Double-line frame around the whole screen (including bottom navigation bar)
        IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 5,
                style: BorderStyle.solid,
              ),
            ),
            child: Container(
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Function to get the corresponding content based on the selected level
  Widget _getContent(String content) {
    switch (content) {
      case 'beginner':
        return BeginnerLevel();
      case 'intermediate':
        return IntermediateLevel();
      case 'advanced':
        return AdvancedLevel();
      default:
        return HomeScreen(onSelectContent: _selectContent);
    }
  }

  // Function to show the Rate Us popup
  void _showRateUsPopup(BuildContext context) {
    int _rating = 0; // Variable to store the selected rating
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.purpleAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Text(
                "Rate Us",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "How would you rate your experience?",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < _rating ? Icons.star : Icons.star_border,
                          color: index < _rating ? Colors.yellow : Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _rating = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the popup
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Color(0xFF00FF9D),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    // Get the user ID
                    final userId = AppUser.getUserId();

                    // Save the rating to Supabase
                    await _supabase.from('rating').insert([
                      {
                        'user_id': userId,
                        'rating': _rating,
                      }
                    ]);

                    setState(() {
                      _hasRated = true; // Mark the user as having rated
                    });

                    Navigator.pop(context); // Close the popup
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Thank you for your rating!"),
                      ),
                    );
                  },
                  child: Text(
                    "Rate",
                    style: TextStyle(
                      color: Color(0xFF00FF9D),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// HomeScreen Widget with content selection callback
class HomeScreen extends StatelessWidget {
  final Function(String) onSelectContent;

  HomeScreen({required this.onSelectContent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
          ),
          SizedBox(height: 20),
          // Beginner Level Bubble
          _buildBubble(
            context,
            "Beginner Level",
            onTap: () {
              onSelectContent('beginner'); // Trigger content selection
            },
            color: Colors.blue, // Different color for Beginner Level
          ),
          SizedBox(height: 16), // Spacing between bubbles
          // Intermediate Level Bubble
          _buildBubble(
            context,
            "Intermediate Level",
            onTap: () {
              onSelectContent('intermediate'); // Trigger content selection
            },
            color: Colors.green, // Different color for Intermediate Level
          ),
          SizedBox(height: 16), // Spacing between bubbles
          // Advanced Level Bubble
          _buildBubble(
            context,
            "Advanced Level",
            onTap: () {
              onSelectContent('advanced'); // Trigger content selection
            },
            color: Colors.orange, // Different color for Advanced Level
          ),
          Spacer(), // Spacing between bubbles and bottom image
          // Image at the bottom
          Image.asset(
            'lib/assets/images/splash2.jpg', // Path to the bottom image
            width: 420,
            height: 200,
          ),
        ],
      ),
    );
  }

  // Helper method to build a bubble with a label and background color
  Widget _buildBubble(BuildContext context, String label, {required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap, // Use the provided onTap callback
      child: Container(
        width: double.infinity, // Make the button stretch horizontally
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Internal padding
        padding: EdgeInsets.all(16.0), // Internal padding
        decoration: BoxDecoration(
          color: color, // Background color for the bubble
          borderRadius: BorderRadius.circular(8), // Rounded corners
          border: Border.all(
            color: Colors.black, // Black border
            width: 2, // Border width
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically inside bubble
          children: [
            // Level label
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}