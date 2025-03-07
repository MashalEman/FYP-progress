import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'user_global_vars.dart';

class UsernameScreen extends StatefulWidget {
  @override
  _UsernameScreenState createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final TextEditingController _controller = TextEditingController();
  FlutterTts flutterTts = FlutterTts();

// Function to check if the username exists and navigate to the dashboard
  Future<void> _navigateToDashboard() async {
    String username = _controller.text.toLowerCase().trim();

    if (username.isNotEmpty) {
      // Check if the user is already logged in
      if (AppUser.isLoggedIn()) {
        // If the user is already logged in, directly navigate to the dashboard
        int? userId = AppUser.getUserId();
        if (userId != null) {
          Navigator.pushReplacementNamed(
            context,
            '/dashboard',
            arguments: {'username': AppUser.getUsername(), 'userId': userId},
          );
          await flutterTts.speak('Welcome back, ${AppUser.getUsername()}, to Cybersecurity quiz App.');
          return;
        }
      }

      // Check if the username already exists in the database
      final existingUserResponse = await Supabase.instance.client
          .from('users') // 'users' table
          .select('id')  // Select only the 'id' column
          .eq('username', username); // Filter by username

      // If the response contains data (not empty), retrieve the user ID
      if (existingUserResponse.isNotEmpty) {
        // If the user exists, retrieve the user ID
        int userId = existingUserResponse[0]['id'];  // Extract ID from the first item in the list

        // Set the userId and username globally using the AppUser class
        AppUser.setUserId(userId, name: username);

        // Navigate to the Dashboard screen with the userId and username as arguments
        Navigator.pushReplacementNamed(
          context,
          '/dashboard',
          arguments: {'username': username, 'userId': userId},
        );

        // Play the welcome message using flutter_tts
        await flutterTts.speak('Welcome back, $username, to CyberQuest App.');
        await Future.delayed(Duration(seconds: 3)); // Adjust as needed
        return;
      }

      // If the username doesn't exist, insert it into the database
      final insertResponse = await Supabase.instance.client
          .from('users') // Assuming the table name is 'users'
          .insert({'username': username})
          .select('id') // After inserting, retrieve the user ID
          .single(); // Insert a new user and return a single record

      // Get the user ID from the response
      int userId = insertResponse['id']; // Access the 'id' from the single inserted row

      // Set the userId and username globally using the AppUser class
      AppUser.setUserId(userId, name: username);

      // Navigate to the Dashboard screen with the userId and username as arguments
      Navigator.pushReplacementNamed(
        context,
        '/dashboard',
        arguments: {'username': username, 'userId': userId},
      );

      // Play the welcome message using flutter_tts
      await flutterTts.speak('Welcome, $username, to CyberQuest App.');
      await Future.delayed(Duration(seconds: 3)); // Adjust as needed
    } else {
      // Show a message if no username is entered
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a username')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Remove the AppBar from the Scaffold and handle it inside the Stack
      body: Stack(
        children: [
          // Main content of the screen
          Column(
            children: [
              // Custom AppBar
              Container(
                color: Colors.transparent, // Make the AppBar transparent
                padding: EdgeInsets.only(top: 16.0, left: 10.0),
              ),
              // Body content with gradient background
              Expanded(
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.all(26.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // Logo
                        Image.asset(
                          'lib/assets/images/splash.jpg',
                          width: 420,
                          height: 300,
                        ),
                        SizedBox(height: 20),
                        // Input Prompt
                        Text(
                          'Please enter your username:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Neon green
                          ),
                        ),
                        SizedBox(height: 20),
                        // Username Input Field
                        TextField(
                          controller: _controller,
                          style: TextStyle(color: Colors.black), // White text inside input
                          decoration: InputDecoration(
                            hintText: 'Enter your username',
                            hintStyle: TextStyle(color: Colors.black), // Light grey
                            filled: true,
                            fillColor: Colors.white60, // Input field background
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black54, width: 2), // Neon green focus
                            ),
                            prefixIcon: Icon(Icons.person, color: Colors.black), // Neon green icon
                          ),
                          textInputAction: TextInputAction.done,
                        ),
                        SizedBox(height: 20),
                        // Start Button
                        ElevatedButton(
                          onPressed: _navigateToDashboard,
                          child: Text('Start'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black, // Text color
                            backgroundColor: Colors.blue, // Cyber blue button
                            padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        Image.asset(
                          'lib/assets/images/splash2.jpg',
                          width: 400,
                          height: 300,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Double-line frame around the screen (including AppBar)
          IgnorePointer( // Disable interactions with the border frame
            child: Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black, // Outer border color
                    width: 5, // Outer border width
                    style: BorderStyle.solid,
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.all(5), // Space between the two borders
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black, // Inner border color
                      width: 2, // Inner border width
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
