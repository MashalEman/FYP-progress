import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TopicDetailScreen extends StatefulWidget {
  final String title;
  final String article;
  final String videoId; // Add videoId to the constructor

  TopicDetailScreen({
    required this.title,
    required this.article,
    required this.videoId, // Initialize videoId
  });

  @override
  _TopicDetailScreenState createState() => _TopicDetailScreenState();
}

class _TopicDetailScreenState extends State<TopicDetailScreen> {
  late YoutubePlayerController _controller; // Declare the YouTube controller

  @override
  void initState() {
    super.initState();
    // Initialize the YouTube player controller with the videoId
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId, // Use the videoId passed to the widget
      flags: YoutubePlayerFlags(
        autoPlay: true, // Set to true if you want the video to autoplay
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Scaffold containing the app's content
        Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Image.asset(
                'lib/assets/images/back.png',
                width: 30,
                height: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Container(
            color: Theme.of(context).colorScheme.surface,
            padding: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // YouTube Video Player
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: YoutubePlayer(
                      controller: _controller,
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: Theme.of(context).colorScheme.primary,
                      onReady: () {
                        // Called when the player is ready
                      },
                    ),
                  ),

                  // Display article content
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      widget.article,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Button to navigate to the quiz screen
                  ElevatedButton(
                    onPressed: () {
                      String quizRoute = '/quiz/${widget.title.toLowerCase().replaceAll(' ', '_')}';
                      Navigator.pushNamed(context, quizRoute);
                    },
                    child: Text("Start Quiz"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, // Primary accent
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Double-line frame around the entire screen
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
}
