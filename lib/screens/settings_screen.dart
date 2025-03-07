import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'user_global_vars.dart'; // Import the file where AppUser is defined

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isNotificationsEnabled = true; // Track notification state
  int? _userRating; // Track the user's rating

  final _supabase = Supabase.instance.client; // Supabase client

  @override
  void initState() {
    super.initState();
    _fetchUserRating(); // Fetch the user's rating when the widget initializes
  }

  // Function to toggle notifications
  void _toggleNotifications(bool value) {
    setState(() {
      _isNotificationsEnabled = value;
    });
  }

  // Function to fetch the user's rating from Supabase
  Future<void> _fetchUserRating() async {
    final userId = AppUser.getUserId(); // Get the current user ID
    final result = await _supabase
        .from('rating')
        .select('rating')
        .eq('user_id', userId as Object)
        .single();

    if (result.isNotEmpty) {
      setState(() {
        _userRating = result['rating']; // Save the user's rating
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          // Notifications Setting
          SwitchListTile(
            title: Text('Notifications'),
            value: _isNotificationsEnabled,
            onChanged: _toggleNotifications,
            activeColor: Color(0xFF00FF9D),
            subtitle: Text('Enable notifications to stay updated.'),
          ),
          Divider(),

          // Language setting
          ListTile(
            title: Text('Language'),
            subtitle: Text('Change app language'),
            onTap: () {
              // Add language change functionality here
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Language English-US'),
                  content: Text('Language selected (en-Us).'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
          Divider(),

          // App Version
          ListTile(
            title: Text('App Version'),
            subtitle: Text('1.0.0'), // Static version number
            onTap: () {
              // App version logic
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('App Version'),
                  content: Text('CyberQuest - Version 1.0.0'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
          Divider(),

          ListTile(
            title: Text('Rate Us'),
            subtitle: Row(
              children: [
                Text(
                  _userRating != null ? 'Rated: $_userRating   ' : 'Not Rated Yet',
                ),
                if (_userRating != null)
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < _userRating! ? Icons.star : Icons.star_border,
                        color: Colors.yellow, // Yellow color for filled stars
                        size: 16, // Adjust the size of the stars
                      );
                    }),
                  ),
              ],
            ),
            onTap: () {
              // Show the user's rating in a dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Your Rating'),
                  content: Text(
                    _userRating != null
                        ? 'You have rated us $_userRating/5.'
                        : 'You have not rated us yet.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
          Divider(),

          // Logout button
          ListTile(
            title: Text(
              'Logout',
              style: TextStyle(color: Colors.white), // Neon green text
            ),
            tileColor: Colors.purpleAccent,
            onTap: () {
              // Add logout logic here
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    'Logout',
                    style: TextStyle(color: Colors.black),
                  ),
                  content: Text('Are you sure you want to log out?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Cancel logout
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Color(0xFF00FF9D)), // Neon green text
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to input_screen on logout
                        Navigator.pushReplacementNamed(context, '/input_screen');
                        // Implement actual logout logic here (e.g., clear user session, etc.)
                      },
                      child: Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
