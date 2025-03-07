import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'user_global_vars.dart';

class Trophies extends StatefulWidget {
  @override
  _TrophiesState createState() => _TrophiesState();
}

class _TrophiesState extends State<Trophies> {
  // Assuming userId is globally available
  final int? userId = AppUser.getUserId();  // Replace this with your logic to fetch the userId

  Map<String, bool>? userProgress; // Map to store the user's progress on each trophy

  @override
  void initState() {
    super.initState();
    _getUserProgress();  // Fetch the user progress on initialization
  }

  // Fetch user progress from the database
  Future<void> _getUserProgress() async {
    try {
      // Fetch the user's progress from the Supabase database
      final beginnerResponse = await Supabase.instance.client
          .from('beginner')  // Replace with your actual table name for beginner trophies
          .select('earned')  // Replace with your actual column name
          .eq('user_id', userId as Object)
          .maybeSingle();

      final intermediateResponse = await Supabase.instance.client
          .from('intermediate')  // Replace with your actual table name for intermediate trophies
          .select('earned')
          .eq('user_id', userId as Object)
          .maybeSingle();

      final advancedResponse = await Supabase.instance.client
          .from('advanced')  // Replace with your actual table name for advanced trophies
          .select('earned')
          .eq('user_id', userId as Object)
          .maybeSingle();

      setState(() {
        // Store the user's progress in the userProgress map
        userProgress = {
          'beginner': beginnerResponse?['earned'] ?? false,
          'intermediate': intermediateResponse?['earned'] ?? false,
          'advanced': advancedResponse?['earned'] ?? false,
        };
      });
    } catch (e) {
      print('Error fetching user progress: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userProgress == null
          ? Center(child: CircularProgressIndicator())  // Show a loading spinner while fetching data
          : ListView(
        children: [
          // Beginner trophy
          _buildTrophyTile(
            "Beginner Trophy",
            "lib/assets/images/trophy_beginner.png",  // Path to the beginner trophy image
            userProgress!['beginner'] ?? false,
          ),
          // Intermediate trophy
          _buildTrophyTile(
            "Intermediate Trophy",
            "lib/assets/images/trophy_intermediate.png",  // Path to the intermediate trophy image
            userProgress!['intermediate'] ?? false,
          ),
          // Advanced trophy
          _buildTrophyTile(
            "Advanced Trophy",
            "lib/assets/images/trophy_advanced.png",  // Path to the advanced trophy image
            userProgress!['advanced'] ?? false,
          ),
        ],
      ),
    );
  }

  // Helper function to build a trophy item
  Widget _buildTrophyTile(String trophyName, String imagePath, bool isEarned) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Stack to overlay the lock icon on the image if not earned
          Stack(
            alignment: Alignment.center,
            children: [
              // Trophy image in a circle
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagePath,
                  width: 300,
                  height: 350,
                  fit: BoxFit.cover,
                ),
              ),
              // If the trophy is not earned, show the lock icon
              if (!isEarned)
                Icon(
                  Icons.lock,
                  color: Color(0xFF0A192F),
                  size: 80,  // Adjust size as needed
                ),
            ],
          ),
          SizedBox(height: 10),  // Space between image and text
          // Title and Subtitle below the image
          Text(
            trophyName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
