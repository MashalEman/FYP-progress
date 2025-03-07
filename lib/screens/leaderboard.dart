import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';  // Import Supabase
import 'user_global_vars.dart';  // Import the User class to access userId

class Leaderboard extends StatelessWidget {
  // Assuming userId is globally available and accessible
  final int? userId = AppUser.getUserId();  // Example userId. Replace with the actual globally accessible userId

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _fetchLeaderboardData(),  // Fetch progress of all users from Supabase
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data found.'));
          }

          final progress = snapshot.data!;  // All users' progress data

          // Find the index of the logged-in user in the list
          final loggedInIndex = progress.indexWhere((user) => user['id'] == userId);

          if (loggedInIndex != -1) {
            // Move the logged-in user to the top of the list
            final loggedInData = progress.removeAt(loggedInIndex);
            progress.insert(0, loggedInData);
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0), // Add padding from left and right
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align the title to the left
              children: [
                // Title: Leaderboard
                Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 10.0), // Add some space around the title
                  child: Text(
                    'Leaderboard',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Change the color as needed
                    ),
                  ),
                ),
                // ListView Builder
                Expanded(
                  child: ListView.builder(
                    itemCount: progress.length,
                    itemBuilder: (context, index) {
                      final user = progress[index];
                      Color userColor;

                      // Assign gold, silver, bronze, and white colors based on rank
                      if (index == 0) {
                        userColor = Color(0xFFFFD700); // Gold color for top user
                      } else if (index == 1) {
                        userColor = Color(0xFFC0C0C0); // Silver color for 2nd place
                      } else if (index == 2) {
                        userColor = Color(0xFFCD7F32); // Bronze color for 3rd place
                      } else {
                        userColor = Colors.white; // White color for others
                      }

                      // Wrap ListTile in a Container with the gradient background
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12), // Rounded corners
                          gradient: LinearGradient(
                            colors: [
                              Colors.purple, // Dark purple (background)
                              Colors.purpleAccent, // Slightly lighter purple (surface)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            color: Colors.black, // Add black border
                            width: 2, // Border width
                          ),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 1.0), // Padding inside the ListTile
                          leading: Text("${index + 1}.", style: TextStyle(color: userColor)),
                          title: Text(
                            user['username'],
                            style: TextStyle(color: userColor),
                            textAlign: TextAlign.center, // To center the username
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Levels: ${user['earned'] ? 'Completed' : 'Not Completed'}',
                                style: TextStyle(fontSize: 9), // Smaller font size for subtitle
                              ),
                            ],
                          ),
                          trailing: Icon(
                            user['earned'] ? Icons.check_circle : Icons.cancel,
                            color: user['earned'] ? Color(0xFF00FF9D) : Color(0xFFFF4D4D),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Method to fetch the earned status for a user from beginner, intermediate, and advanced tables
  Future<Map<String, bool>> _fetchTopicProgress(int userId) async {
    try {
      // Fetch earned status from the 'beginner' table
      final beginnerResponse = await Supabase.instance.client
          .from('beginner')  // Assuming 'beginner' table has an 'earned' column
          .select('earned')  // Fetch the 'earned' status
          .eq('user_id', userId)
          .maybeSingle();

      // Fetch earned status from the 'intermediate' table
      final intermediateResponse = await Supabase.instance.client
          .from('intermediate')  // Assuming 'intermediate' table has an 'earned' column
          .select('earned')  // Fetch the 'earned' status
          .eq('user_id', userId)
          .maybeSingle();

      // Fetch earned status from the 'advanced' table
      final advancedResponse = await Supabase.instance.client
          .from('advanced')  // Assuming 'advanced' table has an 'earned' column
          .select('earned')  // Fetch the 'earned' status
          .eq('user_id', userId)
          .maybeSingle();

      // Return a map with the earned status from each table
      return {
        'beginner': beginnerResponse?['earned'] == true,  // Convert to boolean
        'intermediate': intermediateResponse?['earned'] == true,  // Convert to boolean
        'advanced': advancedResponse?['earned'] == true,  // Convert to boolean
      };
    } catch (e) {
      print('Error fetching topic progress: $e');
      throw Exception('Failed to fetch topic progress.');
    }
  }

  // Method to fetch leaderboard data from Supabase
  Future<List<Map<String, dynamic>>> _fetchLeaderboardData() async {
    try {
      // Fetch all users data from the 'users' table
      final response = await Supabase.instance.client
          .from('users')  // Assuming 'users' table stores basic user info like id, username, and created_at
          .select('id, username, created_at'); // Select the necessary columns from the 'users' table

      final usersData = List<Map<String, dynamic>>.from(response);

      // Fetch earned status from the beginner, intermediate, and advanced tables
      final leaderboard = await Future.wait(
        usersData.map((user) async {
          final progress = await _fetchTopicProgress(user['id']);

          // Check if the user has earned in all three levels
          bool earned = progress['beginner']! && progress['intermediate']! && progress['advanced']!;

          return {
            'id': user['id'],
            'username': user['username'],
            'earned': earned,
            'created_at': user['created_at'],
          };
        }),
      );

      // Sort leaderboard: First by 'earned' status, then by 'created_at' (timestamp)
      leaderboard.sort((a, b) {
        if (a['earned'] == b['earned']) {
          return b['created_at'].compareTo(a['created_at']);  // Sort by most recent registration
        }
        return a['earned'] ? -1 : 1;  // Place users who have completed all courses at the top
      });

      return leaderboard;
    } catch (e) {
      print('Error fetching leaderboard data: $e');
      throw Exception('Failed to fetch leaderboard data.');
    }
  }
}