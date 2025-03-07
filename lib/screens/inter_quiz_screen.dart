import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'user_global_vars.dart';
import 'package:flutter_tts/flutter_tts.dart';

class InterQuizScreen extends StatefulWidget {
  final String topic;

  InterQuizScreen({required this.topic});

  @override
  _InterQuizScreenState createState() => _InterQuizScreenState();
}

class _InterQuizScreenState extends State<InterQuizScreen> {
  FlutterTts flutterTts = FlutterTts(); // Initialize flutterTts instance
  int _currentQuestionIndex = 0; // Track the current question
  List<int> _selectedAnswers = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1]; // Store selected answers
  bool _isQuizComplete = false; // Track if the quiz is complete

  // Define questions for each topic
  final Map<String, List<Map<String, dynamic>>> _questionsMap = {
    'Cryptography': [
      {
        "question": "1. What is symmetric key cryptography?",
        "options": ["Using the same key for encryption and decryption", "Using different keys for encryption and decryption", "Using a public key for encryption and a private key for decryption", "Using a private key for encryption and a public key for decryption"
        ],
        "correctAnswer": 0
      },
      {
        "question": "2. What is asymmetric encryption?",
        "options": ["Using the same key for encryption and decryption", "Using different keys for encryption and decryption", "Using a public key for encryption and a private key for decryption", "Using a private key for encryption and a public key for decryption"
        ],
        "correctAnswer": 1
      },
      {
        'question': '3. What is the purpose of a cryptographic hash function?',
        'options': ['To encrypt data', 'To store data in plain text', 'To create a fixed-length output from variable input', 'To compress data'],
        'correctAnswer': 2
      },
      {
        'question': '4. What does RSA stand for in cryptography?',
        'options': ['Rivest, Shamir, and Adleman', 'Random Secure Algorithm', 'Reversible Secure Algorithm', 'Robust Security Algorithm'],
        'correctAnswer': 0
      },
      {
        'question': '5. Which of these is an asymmetric encryption algorithm?',
        'options': ['AES', 'DES', 'Blowfish', 'RSA'],
        'correctAnswer': 3
      },
      {
        'question': '6. What is the main advantage of asymmetric encryption?',
        'options': ['It requires less computational power', 'It uses a pair of keys for encryption and decryption', 'It is easier to implement', 'None of the above'],
        'correctAnswer': 1
      },
      {
        'question': '7. What is a digital signature used for?',
        'options': ['Encrypting emails', 'Ensuring data integrity and authenticity', 'Compressing files', 'None of the above'],
        'correctAnswer': 1
      },
      {
        'question': '8. What is the purpose of a certificate authority (CA)?',
        'options': ['To issue and manage security certificates', 'To encrypt network traffic', 'To act as a firewall', 'To store passwords'],
        'correctAnswer': 0
      },
      {
        'question': '9. Which cryptographic algorithm is commonly used for hashing?',
        'options': ['RSA', 'AES', 'SHA-256', 'DES'],
        'correctAnswer': 2
      },
      {
        'question': '10. What is the difference between encryption and hashing?',
        'options': ['Encryption is reversible, while hashing is not', 'Hashing is used for encryption', 'Encryption cannot be decrypted', 'Hashing produces a larger output'],
        'correctAnswer': 0
      },
    ],
    'Network Security': [
      {
        'question': '1. What is a firewall?',
        'options': ['A device that filters network traffic', 'A type of encryption', 'A virus', 'A network protocol'],
        'correctAnswer': 0
      },
      {
        'question': '2. What does a VPN do?',
        'options': ['Blocks malware', 'Prevents phishing attacks', 'Encrypts your internet connection', 'Filters web traffic'],
        'correctAnswer': 2
      },
      {
        'question': '3. What is an IDS/IPS?',
        'options': ['A system that detects and prevents intrusions', 'A type of firewall', 'A network switch', 'A virus'],
        'correctAnswer': 0
      },
      {
        'question': '4. What is the role of a router in a network?',
        'options': ['To encrypt communications', 'To connect multiple networks', 'To store user data', 'To provide antivirus protection'],
        'correctAnswer': 1
      },
      {
        'question': '5. What is network segmentation?',
        'options': ['Dividing a network into smaller segments to improve security', 'Reducing network speed', 'Adding more devices to a network', 'Increasing internet speed'],
        'correctAnswer': 0
      },
      {
        'question': '6. Which of these is NOT a type of network attack?',
        'options': ['DDoS', 'Phishing', 'Man-in-the-Middle', 'Cryptography'],
        'correctAnswer': 3
      },
      {
        'question': '7. What is the main purpose of a proxy server?',
        'options': ['To increase internet speed', 'To act as an intermediary between a client and a server', 'To encrypt data', 'To hack into networks'],
        'correctAnswer': 1
      },
      {
        'question': '8. What is the function of an access control list (ACL)?',
        'options': ['To define who can access network resources', 'To store passwords securely', 'To compress network data', 'To encrypt files'],
        'correctAnswer': 0
      },
      {
        'question': '9. Which security protocol is used to secure Wi-Fi networks?',
        'options': ['WEP', 'WPA2', 'HTTP', 'IPSec'],
        'correctAnswer': 1
      },
      {
        'question': '10. What is MAC address filtering?',
        'options': ['A type of encryption', 'A technique for detecting intrusions', 'A method to restrict network access based on hardware addresses', 'A tool for scanning malware'],
        'correctAnswer': 2
      },
    ],
    'Incident Response': [
      {
        'question': '1. What is the first step in the incident response process?',
        'options': ['Detection and analysis', 'Containment, eradication, and recovery', 'Preparation', 'Post-incident review'],
        'correctAnswer': 2
      },
      {
        'question': '2. What is a key objective of incident response?',
        'options': ['To identify the root cause of an incident', 'To prevent future incidents', 'To contain and minimize the impact of the attack', 'All of the above'],
        'correctAnswer': 3
      },
      {
        'question': '3. What is the purpose of a forensic investigation during an incident?',
        'options': ['To analyze data to understand how the attack occurred', 'To eliminate the attacker', 'To repair the systems', 'To notify stakeholders'],
        'correctAnswer': 0
      },
      {
        'question': '4. Which of the following is NOT part of the incident response process?',
        'options': ['Preparation', 'Containment', 'Prevention', 'Identification'],
        'correctAnswer': 2
      },
      {
        'question': '5. What is the role of the recovery phase in incident response?',
        'options': ['To identify how the incident happened', 'To fix and restore systems to normal operation', 'To notify the authorities', 'To prevent future attacks'],
        'correctAnswer': 1
      },
      {
        'question': '6. Why is documentation important in incident response?',
        'options': ['To blame someone for the attack', 'To ignore minor incidents', 'To create a record of the incident for future reference', 'None of the above'],
        'correctAnswer': 2
      },
      {
        'question': '7. What is an incident response playbook?',
        'options': ['A predefined set of procedures for handling specific incidents', 'A collection of attack tools', 'A report for stakeholders', 'None of the above'],
        'correctAnswer': 0
      },
      {
        'question': '8. How can organizations improve their incident response capabilities?',
        'options': ['By conducting regular training and simulations', 'By ignoring minor incidents', 'By relying only on automated systems', 'None of the above'],
        'correctAnswer': 0
      },
      {
        'question': '9. What is the main purpose of post-incident review?',
        'options': ['To punish employees responsible', 'To identify lessons learned and improve future responses', 'To erase evidence of the attack', 'To prevent external audits'],
        'correctAnswer': 1
      },
      {
        'question': '10. Which team is typically responsible for handling security incidents?',
        'options': ['Incident Response Team (IRT)', 'Marketing Team', 'Sales Team', 'Human Resources'],
        'correctAnswer': 0
      },
    ],
    "Access Control": [
      {
        "question": "1. What does RBAC stand for?",
        "options": ["Role-Based Access Control", "Read-By-Access Control", "Random-Based Access Control", "Role-Based Authorization Control"],
        "correctAnswer": 3
      },
      {
        "question": "2. What is the principle of least privilege?",
        "options": ["Users are given only the access they need to perform their job", "Users should have access to all resources", "Users should not access any resources", "None of the above"],
        "correctAnswer": 0
      },
      {
        "question": "3. What is multi-factor authentication (MFA)?",
        "options": ["Using only a password to authenticate", "A method where multiple pieces of evidence are required to authenticate a user", "A way of encrypting data", "None of the above"],
        "correctAnswer": 1
      },
      {
        "question": "4. What does an access control list (ACL) do?",
        "options": ["It defines which users or systems have access to resources", "It stores data securely", "It controls network traffic", "It tracks user activities"],
        "correctAnswer": 0
      },
      {
        "question": "5. Which is an example of something used in multi-factor authentication?",
        "options": ["Password and phone number", "Password and facial recognition", "Username and email", "None of the above"],
        "correctAnswer": 1
      },
      {
        "question": "6. Which of the following is an example of an access control mechanism?",
        "options": ["Firewalls", "VPNs", "Password protection", "Antivirus software"],
        "correctAnswer": 2
      },
      {
        "question": "7. What does an identity provider (IdP) do?",
        "options": ["Manages user identities and authentication", "Provides data encryption", "Detects security breaches", "Controls network traffic"],
        "correctAnswer": 1
      },
      {
        "question": "8. What is the main purpose of access control in cybersecurity?",
        "options": ["To ensure that only authorized users can access sensitive data or systems", "To prevent cyber attacks", "To back up data", "To encrypt communication"],
        "correctAnswer": 0
      },
      {
        "question": "9. What is the difference between authentication and authorization?",
        "options": ["Authentication verifies identity, and authorization grants access to resources", "Authentication grants access to resources, and authorization verifies identity", "Both are the same", "Neither is important"],
        "correctAnswer": 1
      },
      {
        "question": "10. What is the purpose of a Single Sign-On (SSO) system?",
        "options": ["To allow users to log in once and access multiple services without re-entering credentials", "To store passwords securely", "To block unauthorized access attempts", "To encrypt sensitive data"],
        "correctAnswer": 3
      }
    ],
    "Security Testing": [
      {
        "question": "1. What is penetration testing?",
        "options": ["Installing antivirus software", "Testing the security of a system by simulating an attack", "Scanning a network for malware", "All of the above"],
        "correctAnswer": 1
      },
      {
        "question": "2. What does a vulnerability scan do?",
        "options": ["It identifies security weaknesses in a system", "It encrypts data", "It creates backups", "It monitors network traffic"],
        "correctAnswer": 0
      },
      {
        "question": "3. What is the purpose of a security audit?",
        "options": ["To assess the security of a system and identify risks", "To upgrade software", "To check for system bugs", "To install firewalls"],
        "correctAnswer": 3
      },
      {
        "question": "4. Which of the following tools is used for penetration testing?",
        "options": ["Metasploit", "Photoshop", "MS Word", "Chrome"],
        "correctAnswer": 0
      },
      {
        "question": "5. What is social engineering in security testing?",
        "options": ["Manipulating people to gain access to systems or data", "Testing the encryption of a network", "Writing secure code", "None of the above"],
        "correctAnswer": 2
      },
      {
        "question": "6. What is a vulnerability management program?",
        "options": ["A process for identifying, assessing, and addressing security vulnerabilities", "A program for teaching employees about cybersecurity", "A firewall solution", "A backup system"],
        "correctAnswer": 0
      },
      {
        "question": "7. What does an ethical hacker do?",
        "options": ["Identifies vulnerabilities in systems by simulating attacks with permission", "Installs malware on systems to test security", "Attacks systems without authorization", "None of the above"],
        "correctAnswer": 1
      },
      {
        "question": "8. What is a common goal of a security audit?",
        "options": ["To assess and improve an organization’s overall security posture", "To create a disaster recovery plan", "To track employee productivity", "To upgrade software"],
        "correctAnswer": 0
      },
      {
        "question": "9. Which of the following is often used in security testing for detecting malware or vulnerabilities?",
        "options": ["Email clients", "Vulnerability scanners", "Office suites", "Web browsers"],
        "correctAnswer": 1
      },
      {
        "question": "10. What is the difference between a vulnerability scan and a penetration test?",
        "options": ["A vulnerability scan identifies weaknesses, while a penetration test actively exploits them", "A penetration test identifies weaknesses, while a vulnerability scan exploits them", "Both are the same", "Neither tests security"],
        "correctAnswer": 2
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
                  Navigator.pushReplacementNamed(context, '/intermediate');
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
      'Cryptography': 'cryptography',
      'Network Security': 'networksecurity',
      'Incident Response': 'incidentresponse',
      'Access Control': 'accesscontrol',
      'Security Testing': 'securitytesting',
    };

    final columnName = columnMapping[widget.topic];
    if (columnName == null) {
      throw Exception('Invalid topic: ${widget.topic}');
    }

    try {
      // First, check if the user record already exists
      final response = await Supabase.instance.client
          .from('intermediate')
          .select('user_id')  // Selecting 'user_id' to check if the user exists
          .eq('user_id', userId)
          .maybeSingle();  // Expecting a single record

      if (response == null) {
        // User does not exist, insert new record
        await Supabase.instance.client
            .from('intermediate')
            .insert({
          'user_id': userId,
          columnName: true, // Set the specific column for the topic to true
        });

      } else {
        // If the user exists, update the progress
        await Supabase.instance.client
            .from('intermediate')
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