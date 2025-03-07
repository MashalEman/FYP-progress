import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase
import 'user_global_vars.dart';  // Import the User class to access userId

class IntermediateLevel extends StatefulWidget {
  @override
  _IntermediateLevelState createState() => _IntermediateLevelState();
}

class _IntermediateLevelState extends State<IntermediateLevel> {
  // Map to hold the progress for each intermediate topic
  Map<String, bool> topicProgress = {
    'Cryptography': false,
    'Network Security': false,
    'Incident Response': false,
    'Access Control': false,
    'Security Testing': false,
  };

  final Map<String, String> columnMapping = {
    'Cryptography': 'cryptography',
    'Network Security': 'networksecurity',
    'Incident Response': 'incidentresponse',
    'Access Control': 'accesscontrol',
    'Security Testing': 'securitytesting',
  };

  @override
  void initState() {
    super.initState();
    _fetchTopicProgress();
  }

  // After fetching the topic progress, check if all topics are completed
  Future<void> _fetchTopicProgress() async {
    int? userId = AppUser.getUserId();

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not logged in. Please log in to view progress.')),
      );
      return;
    }

    print('Fetching progress for user ID: $userId'); // Debugging

    try {
      final response = await Supabase.instance.client
          .from('intermediate')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      print('Supabase response: $response'); // Debugging

      if (response != null) {
        setState(() {
          topicProgress.forEach((topic, _) {
            topicProgress[topic] = response[columnMapping[topic]] == true;
          });
        });

        // Check if all topics are completed
        bool allTopicsCompleted = topicProgress.values.every((value) => value == true);

        // If all topics are completed, update the 'earned' column to true
        if (allTopicsCompleted) {
          await Supabase.instance.client
              .from('intermediate')
              .update({'earned': true})
              .eq('user_id', userId);
        }
      } else {
        // No data found for the user, initialize default values
        setState(() {
          topicProgress.forEach((topic, _) {
            topicProgress[topic] = false;
          });
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No progress data found for user. Initializing default values.')),
        );

        // Optionally, insert a new row for the user in the beginner table
        await _initializeUserProgress(userId);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unexpected error occurred: $error')),
      );
    }
  }


  // Initialize user progress in the intermediate table
  Future<void> _initializeUserProgress(int userId) async {
    try {
      await Supabase.instance.client
          .from('intermediate')  // Use the correct table name
          .insert({
        'user_id': userId,
        'cryptography': false,
        'networksecurity': false,
        'incidentresponse': false,
        'accesscontrol': false,
        'securitytesting': false,
      });

      print('Initialized new user progress for user ID: $userId'); // Debugging
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to initialize user progress: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the number of completed topics
    int completedTopics = topicProgress.values.where((value) => value == true).length;
    int totalTopics = topicProgress.length;
    double progressPercentage = completedTopics / totalTopics;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 20), // Increase the height of the AppBar to accommodate padding
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 6.0), // Vertical padding for the entire AppBar
          child: AppBar(
            // Custom back button with PNG image
            leading: IconButton(
              icon: Image.asset(
                'lib/assets/images/back.png', // Path to your PNG image
                width: 30, // Adjust the width of the image
                height: 30, // Adjust the height of the image
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/dashboard'); // Navigate back when the button is pressed
              },
            ),
            backgroundColor: Colors.transparent, // Make the app bar transparent
            elevation: 0, // Remove the shadow
          ),
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Add a border around the "Advance Level" text with full width, light blue background, and centered text
              Container(
                margin: EdgeInsets.all(10), // Add margin around the container
                width: double.infinity, // Make the container take up the full width
                decoration: BoxDecoration(
                  color: Colors.lightBlue[400], // Light blue background color
                  border: Border.all(
                    color: Colors.black, // Border color
                    width: 2, // Border width
                  ),
                  borderRadius: BorderRadius.circular(8), // Optional: Rounded corners
                ),
                padding: EdgeInsets.all(16.0), // Space between the text and border
                alignment: Alignment.center, // Center the text horizontally and vertically
                child: Text(
                  'Intermediate Level',
                  style: TextStyle(
                    color: Colors.black, // Text color
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Progress Percentage Card
              _buildProgressCard(progressPercentage, completedTopics, totalTopics),
              SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: [
                    _buildTopicCard("Chapter 1 \nCryptography", Icons.lock_outline, '/topic/cryptography', topicProgress['Cryptography'], Colors.lightBlue[100]!, "Video + Reading"),
                    _buildTopicCard("Chapter 2 \nNetwork Security", Icons.network_wifi, '/topic/network_security', topicProgress['Network Security'], Colors.deepOrangeAccent, "Video + Reading"),
                    _buildTopicCard("Chapter 3 \nIncident Response", Icons.report_problem, '/topic/incident_response', topicProgress['Incident Response'], Colors.lightBlue[100]!, "Video + Reading"),
                    _buildTopicCard("Chapter 4 \nAccess Control", Icons.security, '/topic/access_control', topicProgress['Access Control'], Colors.deepOrangeAccent, "Video + Reading"),
                    _buildTopicCard("Chapter 5 \nSecurity Testing", Icons.vpn_lock, '/topic/security_testing', topicProgress['Security Testing'], Colors.lightBlue[100]!, "Video + Reading"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Helper method to build the progress card
  Widget _buildProgressCard(double progressPercentage, int completedTopics, int totalTopics) {
    return Card(
      color: progressPercentage == 1.0 ? Color(0xFF00FF9D) : Colors.purpleAccent[200], // Neon green if 100%, else navy blue
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${(progressPercentage * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: progressPercentage,
              backgroundColor: Colors.grey[800],
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00FF9D)), // Neon green progress bar
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.book,
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 5),
                Text(
                  '$completedTopics/5 Chapters Completed',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build the card for each topic
  Widget _buildTopicCard(String title, IconData icon, String route, bool? isCompleted, Color cardColor, String subtitle) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Card(
          elevation: 5,
          margin: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.black, width: 2), // Black border for the card
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: cardColor, // Different color for each card
            ),
            child: ListTile(
              leading: Icon(
                icon,
                color: isCompleted == true ? Color(0xFF00FF9D) : Colors.black,
              ),
              title: Text(title, style: TextStyle(fontSize: 18, color: Colors.black)),
              trailing: isCompleted == true
                  ? Icon(Icons.check_circle, color: Color(0xFF00FF9D))
                  : null,
              subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.black54),),
            ),
          ),
        ),
      ),
    );
  }
}
