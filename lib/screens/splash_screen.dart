import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _startIntro();
  }

  Future<void> _startIntro() async {
    // Speak a welcome message using TTS
    await _flutterTts.speak("Welcome To Cybersecurity Quiz App!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Pink background
          Positioned.fill(
            child: Container(
              color: Colors.purpleAccent, // Set background color to purple
            ),
          ),

          // Double-line frame around the screen
          Positioned(
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

          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Image logo (centered)
                Image.asset(
                  'lib/assets/images/splash.jpg',
                  width: 450,
                  height: 400,
                ),
                // Animated welcome text
                Text(
                  "Welcome to Gamified",
                  style: TextStyle(
                    color: Colors.black, // Black text
                    fontSize: 34,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  "Learning App for",
                  style: TextStyle(
                    color: Colors.black, // Black text
                    fontSize: 34,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  "Cybersecurity",
                  style: TextStyle(
                    color: Colors.black, // Black text
                    fontSize: 34,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Spacer(), // Takes up the remaining space
                // "Get Started" button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/input_screen');
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Colors.blue, // Black text
                    side: BorderSide(color: Colors.black), // Black border
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                  ),
                  child: Text(
                    "Get Started",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                // Image logo (centered)
                Image.asset(
                  'lib/assets/images/splash2.jpg',
                  width: 350,
                  height: 300,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
