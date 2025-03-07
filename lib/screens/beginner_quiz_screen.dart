import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'user_global_vars.dart';
import 'package:flutter_tts/flutter_tts.dart';

class QuizScreen extends StatefulWidget {
  final String topic;

  QuizScreen({required this.topic});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  FlutterTts flutterTts = FlutterTts(); // Initialize flutterTts instance
  int _currentQuestionIndex = 0; // Track the current question
  List<int> _selectedAnswers = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1]; // Store selected answers
  bool _isQuizComplete = false; // Track if the quiz is complete

  // Define questions for each topic
  final Map<String, List<Map<String, dynamic>>> _questionsMap = {
    'Phishing': [
      {
        'question': '1. What is Phishing?',
        'options': ['A type of fish', 'A scam', 'A type of malware', 'A password attack'],
        'correctAnswer': 1
      },
      {
        'question': '2. What should you do if you receive a suspicious email?',
        'options': ['Delete it', 'Click the link', 'Respond immediately', 'Ignore it'],
        'correctAnswer': 0
      },
      {
        'question': '3. What does a phishing attack aim to steal?',
        'options': ['Emails', 'Personal data', 'Website views', 'Videos'],
        'correctAnswer': 1
      },
      {
        'question': '4. Which of these is a common phishing tactic?',
        'options': ['Sending fake emails', 'Hiring hackers', 'Using encryption', 'Installing antivirus'],
        'correctAnswer': 0
      },
      {
        'question': '5. How can you protect yourself from phishing?',
        'options': ['By clicking on all links', 'By sharing passwords', 'By not opening unknown emails', 'By ignoring emails'],
        'correctAnswer': 2
      },
      {
        'question': '6. What is a common sign of a phishing email?',
        'options': ['Poor grammar and spelling', 'A trusted sender name', 'No links or attachments', 'A professional logo'],
        'correctAnswer': 0
      },
      {
        'question': '7. What is spear phishing?',
        'options': ['A type of fishing with a spear', 'A targeted phishing attack', 'A type of malware', 'A password attack'],
        'correctAnswer': 1
      },
      {
        'question': '8. What should you do if you accidentally click on a phishing link?',
        'options': ['Change your passwords immediately', 'Share the link with friends', 'Do nothing', 'Ignore it'],
        'correctAnswer': 2
      },
      {
        'question': '9. What is a common way phishing emails try to trick you?',
        'options': ['By offering free gifts', 'By using urgent language', 'By sending emails at night', 'By using long paragraphs'],
        'correctAnswer': 1
      },
      {
        'question': '10. What is the best way to verify a suspicious email?',
        'options': ['Contact the sender directly', 'Click on the links', 'Reply to the email', 'Ignore it'],
        'correctAnswer': 0
      },
    ],
    'Password Management': [
      {
        'question': '1. What is a strong password?',
        'options': ['A simple word', 'A combination of letters, numbers, and symbols', 'Your name', '12345'],
        'correctAnswer': 1
      },
      {
        'question': '2. What is the benefit of using a password manager?',
        'options': ['To remember passwords', 'To share passwords with others', 'To store passwords securely', 'None'],
        'correctAnswer': 2
      },
      {
        'question': '3. What should you avoid when creating a password?',
        'options': ['Using your birthdate', 'Using a random combination of characters', 'Using uppercase letters', 'Using numbers'],
        'correctAnswer': 0
      },
      {
        'question': '4. How often should you change your password?',
        'options': ['Once every 10 years', 'Once every 5 years', 'Regularly, every few months', 'Never'],
        'correctAnswer': 2
      },
      {
        'question': '5. Should you use the same password for different sites?',
        'options': ['Yes', 'No', 'It doesn’t matter', 'Only for social media accounts'],
        'correctAnswer': 1
      },
      {
        'question': '6. What is two-factor authentication (2FA)?',
        'options': ['A second password', 'A security measure requiring two forms of verification', 'An alternative to passwords', 'A backup password'],
        'correctAnswer': 1
      },
      {
        'question': '7. Which of these is the most secure way to store passwords?',
        'options': ['Writing them down', 'Saving them in a plain text file', 'Using a password manager', 'Memorizing only one password'],
        'correctAnswer': 2
      },
      {
        'question': '8. What is phishing?',
        'options': ['A method to securely store passwords', 'A cyber attack to steal information', 'A strong password technique', 'A way to recover lost passwords'],
        'correctAnswer': 1
      },
      {
        'question': '9. What should you do if a website you use has a data breach?',
        'options': ['Change your password immediately', 'Do nothing', 'Use the same password again', 'Ignore the news'],
        'correctAnswer': 0
      },
      {
        'question': '10. Which password is the strongest?',
        'options': ['password123', 'QwErTy', 'MyDogMax2024', '@s7Y&g!92j'],
        'correctAnswer': 3
      }
    ],
    'Malware': [
      {
        'question': '1. What is Malware?',
        'options': ['A virus', 'A type of software designed to harm', 'A type of computer hardware', 'A web browser'],
        'correctAnswer': 1
      },
      {
        'question': '2. What can malware do to your computer?',
        'options': ['Nothing', 'Steal personal information', 'Speed up the computer', 'Make the computer faster'],
        'correctAnswer': 1
      },
      {
        'question': '3. How can you avoid malware?',
        'options': ['By installing antivirus software', 'By avoiding clicking on suspicious links', 'By keeping your software up to date', 'All of the above'],
        'correctAnswer': 3
      },
      {
        'question': '4. Which of these is a type of malware?',
        'options': ['Trojan', 'Firewall', 'Password manager', 'Operating system'],
        'correctAnswer': 0
      },
      {
        'question': '5. What is Ransomware?',
        'options': ['A way to protect your computer', 'Malware that holds your files hostage for money', 'A free software', 'A type of virus'],
        'correctAnswer': 1
      },
      {
        'question': '6. Which of these is an example of malware?',
        'options': ['Spyware', 'Adware', 'Worms', 'All of the above'],
        'correctAnswer': 3
      },
      {
        'question': '7. How does malware typically spread?',
        'options': ['Through email attachments', 'By clicking on suspicious links', 'By downloading files from untrusted sources', 'All of the above'],
        'correctAnswer': 3
      },
      {
        'question': '8. What is a Trojan Horse in terms of cybersecurity?',
        'options': ['A type of hardware', 'A malware disguised as a legitimate program', 'A security tool', 'A type of password'],
        'correctAnswer': 1
      },
      {
        'question': '9. How can you detect malware on your device?',
        'options': ['By running an antivirus scan', 'By checking for slow performance or unexpected pop-ups', 'By monitoring unusual network activity', 'All of the above'],
        'correctAnswer': 3
      },
      {
        'question': '10. What should you do if your device is infected with malware?',
        'options': ['Ignore it', 'Run an antivirus scan and remove the malware', 'Give out your personal information', 'Restart the computer and hope it fixes itself'],
        'correctAnswer': 1
      }
    ],
    'Social Engineering': [
      {
        'question': '1. What is Social Engineering?',
        'options': ['Manipulating people into revealing sensitive information', 'A type of software', 'An encryption method', 'A programming language'],
        'correctAnswer': 0
      },
      {
        'question': '2. Which of these is a common social engineering tactic?',
        'options': ['Installing antivirus', 'Creating passwords','Phishing emails',  'Encrypting data'],
        'correctAnswer': 2
      },
      {
        'question': '3. What is a "pretext" in social engineering?',
        'options': ['A story to manipulate the victim into providing information', 'A real identity', 'A kind of software', 'None of the above'],
        'correctAnswer': 0
      },
      {
        'question': '4. How can you protect yourself from social engineering attacks?',
        'options': ['By sharing personal information', 'By verifying the identity of people who ask for information', 'By ignoring emails', 'By clicking links'],
        'correctAnswer': 1
      },
      {
        'question': '5. Which action can help in preventing social engineering attacks?',
        'options': ['Being cautious of unsolicited phone calls', 'Giving out passwords', 'Sharing information openly', 'None'],
        'correctAnswer': 0
      },
      {
        'question': '6. What is phishing?',
        'options': ['A method to catch fish', 'A cyber attack using deceptive emails or websites', 'A secure way to share passwords', 'An encryption technique'],
        'correctAnswer': 1
      },
      {
        'question': '7. Which of these is NOT a social engineering method?',
        'options': ['Baiting', 'Tailgating', 'Encryption', 'Phishing'],
        'correctAnswer': 2
      },
      {
        'question': '8. What is "tailgating" in cybersecurity?',
        'options': ['Following someone into a secure area without proper authentication', 'A type of malware', 'An advanced encryption technique', 'A social media scam'],
        'correctAnswer': 0
      },
      {
        'question': '9. What should you do if you receive a suspicious email requesting sensitive information?',
        'options': ['Reply with fake information', 'Click the links to verify', 'Ignore and report it', 'Forward it to friends'],
        'correctAnswer': 2
      },
      {
        'question': '10. Why do attackers use social engineering instead of hacking into systems?',
        'options': ['It’s often easier to trick humans than to bypass security systems', 'It’s less effective', 'It’s always unsuccessful', 'It requires advanced programming skills'],
        'correctAnswer': 0
      }
    ],
    "Secure Browsing and HTTPS": [
      {
        "question": "1. What is HTTPS?",
        "options": ["A secure version of HTTP", "A type of encryption", "A programming language", "A type of virus"],
        "correctAnswer": 1
      },
      {
        "question": "2. Why should you use HTTPS?",
        "options": ["To speed up your connection", "To secure your connection with encryption", "To access blocked websites", "None"],
        "correctAnswer": 3
      },
      {
        "question": "3. What should you check before submitting sensitive data on a website?",
        "options": ["If the site is using HTTPS", "If the website is colorful", "If the website has advertisements", "None of the above"],
        "correctAnswer": 2
      },
      {
        "question": "4. What is the purpose of SSL certificates?",
        "options": ["Encrypt data between your browser and the server", "To increase website traffic", "To monitor website users", "To display advertisements"],
        "correctAnswer": 3
      },
      {
        "question": "5. Which of these is an indicator that a website is secure?",
        "options": ["HTTPS in the URL", "The website is slow", "The website has ads", "None of the above"],
        "correctAnswer": 0
      },
      {
        "question": "6. What should you do if a website does not have HTTPS?",
        "options": ["Avoid entering sensitive information", "Trust it if it looks professional", "Disable antivirus", "Enter your information anyway"],
        "correctAnswer": 1
      },
      {
        "question": "7. What does a browser warning about an insecure site mean?",
        "options": ["The site is safe", "The site does not use proper encryption", "The website is government-approved", "The site loads faster"],
        "correctAnswer": 0
      },
      {
        "question": "8. Why do some websites still use HTTP instead of HTTPS?",
        "options": ["They have not upgraded their security", "HTTPS is illegal", "HTTPS slows down websites", "HTTPS is only for banks"],
        "correctAnswer": 2
      },
      {
        "question": "9. Which type of website is most important to have HTTPS?",
        "options": ["E-commerce sites", "Banking and financial websites", "Any site that collects personal information", "All of the above"],
        "correctAnswer": 1
      },
      {
        "question": "10. Can HTTPS protect you from all cyber threats?",
        "options": ["Yes, it makes you completely safe", "No, but it secures your data from being intercepted", "Only on public Wi-Fi", "Only on mobile devices"],
        "correctAnswer": 0
      }
    ],
  };

  // Function to check if the selected answer is correct
  void _checkAnswer(int selectedOption) {
    int correctAnswer = _questionsMap[widget.topic]![_currentQuestionIndex]['correctAnswer'];
    setState(() {
      _selectedAnswers[_currentQuestionIndex] = selectedOption;
    });

    if (selectedOption == correctAnswer) {
      _playSound("Your answer is correct");
      _showSuccessDialog();
    } else {
      _playSound("Your answer is incorrect");
      _showFailureDialog(correctAnswer);
    }
  }

  // Function to move to the next question
  void _goToNextQuestion() {
    setState(() {
      if (_currentQuestionIndex < _questionsMap[widget.topic]!.length - 1) {
        _currentQuestionIndex++;
      } else {
        _isQuizComplete = true;
        _submitQuiz();
      }
    });
  }

  // Function to submit the quiz and show the result
  void _submitQuiz() {
    int correctAnswers = 0;
    List<Map<String, dynamic>> currentQuestions = _questionsMap[widget.topic] ?? [];

    for (var i = 0; i < currentQuestions.length; i++) {
      if (currentQuestions[i]['correctAnswer'] == _selectedAnswers[i]) {
        correctAnswers++;
      }
    }

    if (correctAnswers == currentQuestions.length) {
      _playSound("Congratulations! You passed the quiz");
      _showQuizCompleteDialog(true);
      int? userId = AppUser.getUserId();
      if (userId != null) {
        _updateTopicProgress(context, userId); // Update Supabase progress
      }
    } else {
      _playSound("Oops! You failed the quiz. Try again");
      _showQuizCompleteDialog(false);
    }
  }

  // Function to play sound using flutter_tts
  void _playSound(String message) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(message); // Speak the provided message
  }

  // Function to show success dialog for correct answer
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.purple[200],
          title: Text(
            'Correct!',
            style: TextStyle(color: Color(0xFF00FF9D), fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Congrats. Your answer is correct!',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _goToNextQuestion();
              },
              child: Text('Next', style: TextStyle(color: Color(0xFF00FF9D))),
            ),
          ],
        );
      },
    );
  }

  // Function to show failure dialog for incorrect answer
  void _showFailureDialog(int correctAnswer) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.purple[200],
          title: Text(
            'Incorrect!',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Your answer is incorrect!',
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 10),
              Text(
                'Correct Answer: ${_questionsMap[widget.topic]![_currentQuestionIndex]['options'][correctAnswer]}',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _goToNextQuestion();
              },
              child: Text('Next', style: TextStyle(color: Color(0xFF00FF9D))),
            ),
          ],
        );
      },
    );
  }

  // Function to show quiz completion dialog
  void _showQuizCompleteDialog(bool isPassed) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.purple[200],
          title: Text(
            isPassed ? 'Congratulations!' : 'Oops!',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            isPassed ? 'You passed the quiz!' : 'You failed the quiz. Try again!',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog

                if (isPassed) {
                  // Navigate to the /advance screen if the quiz is passed
                  Navigator.pushReplacementNamed(context, '/beginner');
                } else {
                  // Navigate back to the previous screen if the user chooses Retry
                  Navigator.pop(context); // Pop the current screen, going back to the previous one
                }
              },
              child: Text(
                isPassed ? 'Continue' : 'Retry',
                style: TextStyle(color: Color(0xFF00FF9D)), // Neon Green color
              ),
            ),
          ],
        );
      },
    );
  }


  Future<bool> _updateTopicProgress(BuildContext context, int userId) async {
    final Map<String, String> columnMapping = {
      'Phishing': 'phishing',
      'Password Management': 'passwordmanagement',
      'Malware': 'malware',
      'Social Engineering': 'socialengineering',
      'Secure Browsing and HTTPS': 'securebrowsing',
    };

    final columnName = columnMapping[widget.topic];
    if (columnName == null) {
      throw Exception('Invalid topic: ${widget.topic}');
    }

    try {
      // First, check if the user record already exists
      final response = await Supabase.instance.client
          .from('beginner')
          .select('user_id')  // Selecting 'user_id' to check if the user exists
          .eq('user_id', userId)
          .maybeSingle();  // Expecting a single record

      if (response == null) {
        // User does not exist, insert new record
        await Supabase.instance.client
            .from('beginner')
            .insert({
            'user_id': userId,
            columnName: true, // Set the specific column for the topic to true
        });

      } else {
        // If the user exists, update the progress
        await Supabase.instance.client
            .from('beginner')
            .update({
          columnName: true,  // Set the specific column for the topic to true
        })
            .eq('user_id', userId);
      }

      return true; // Success
    } catch (e) {
      // Catch any error and print/log it
      print('Error occurred: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
      return false; // Failure
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> currentQuestions = _questionsMap[widget.topic] ?? [];
    Map<String, dynamic> currentQuestion = currentQuestions[_currentQuestionIndex];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 20), // Increase the height of the AppBar to accommodate padding
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 6.0), // Vertical padding for the entire AppBar
          child: AppBar(
            leading: IconButton(
              icon: Image.asset(
                'lib/assets/images/back.png', // Path to your PNG image
                width: 30, // Adjust the width of the image
                height: 30, // Adjust the height of the image
              ),
              onPressed: () {
                Navigator.pop(context); // Navigate back when the button is pressed
              },
            ),
            title: Text(
              "Quiz: ${widget.topic}",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question text with purple background and black borders
            Container(
              width: double.infinity, // Full width
              padding: EdgeInsets.all(16.0), // Padding around the text
              decoration: BoxDecoration(
                color: Colors.purple, // Set purple background
                border: Border.all(
                  color: Colors.black, // Black border
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                currentQuestion['question'],
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white), // White text color for contrast
              ),
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align options to the left
              children: [
                for (var j = 0; j < currentQuestion['options'].length; j++)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: double.infinity, // Full width for options
                      decoration: BoxDecoration(
                        color: Colors.purpleAccent[400], // Purple background
                        border: Border.all(
                          color: _selectedAnswers[_currentQuestionIndex] == j
                              ? (_selectedAnswers[_currentQuestionIndex] == currentQuestion['correctAnswer']
                              ? Color(0xFF00FF9D) // Neon Green for correct
                              : Colors.red) // Red for incorrect
                              : Colors.black, // Black border for question options
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ElevatedButton(
                        onPressed: () => _checkAnswer(j),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent, // Transparent to show the purple background
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          currentQuestion['options'][j],
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 18.0),
              child: ElevatedButton(
                onPressed: _isQuizComplete ? null : _goToNextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent, // Primary accent
                  foregroundColor: Colors.white, // High contrast
                  padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(_currentQuestionIndex < currentQuestions.length - 1 ? 'Next' : 'Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}