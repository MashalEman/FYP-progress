import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'user_global_vars.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AdvanceQuizScreen extends StatefulWidget {
  final String topic;

  AdvanceQuizScreen({required this.topic});

  @override
  _AdvanceQuizScreenState createState() => _AdvanceQuizScreenState();
}

class _AdvanceQuizScreenState extends State<AdvanceQuizScreen> {
  FlutterTts flutterTts = FlutterTts(); // Initialize flutterTts instance
  int _currentQuestionIndex = 0; // Track the current question
  List<int> _selectedAnswers = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1]; // Store selected answers
  bool _isQuizComplete = false; // Track if the quiz is complete

  final Map<String, List<Map<String, dynamic>>> _questionsMap = {
    'Advanced Cryptography': [
      {
        'question': '1. What is Quantum Cryptography?',
        'options': ['A type of encryption that uses quantum mechanics', 'A traditional encryption method', 'A kind of malware', 'None of the above'],
        'correctAnswer': 0
      },
      {
        'question': '2. What is the principle of elliptic curve cryptography?',
        'options': ['It is based on prime numbers', 'It uses symmetric key encryption', 'It uses complex mathematical curves for encryption', 'It is used for digital signatures only'],
        'correctAnswer': 2
      },
      {
        'question': '3. Which of the following is a type of symmetric key encryption algorithm?',
        'options': ['RSA', 'ECC', 'None of the above', 'AES'],
        'correctAnswer': 3
      },
      {
        'question': '4. What is a public key infrastructure (PKI)?',
        'options': ['A system for managing digital certificates and encryption keys', 'A method of securing Wi-Fi networks', 'A hardware security module', 'A type of encryption'],
        'correctAnswer': 0
      },
      {
        'question': '5. What is the main difference between asymmetric and symmetric encryption?',
        'options': ['Asymmetric encryption is faster', 'Asymmetric encryption uses two keys, while symmetric uses one key', 'Symmetric encryption is more secure', 'None of the above'],
        'correctAnswer': 1
      },
      {
        'question': '6. What is a digital signature?',
        'options': ['A cryptographic technique to validate authenticity and integrity', 'A handwritten signature scanned into a computer', 'A type of encryption algorithm', 'None of the above'],
        'correctAnswer': 0
      },
      {
        'question': '7. What is a hash function in cryptography?',
        'options': ['A function that converts data into a fixed-size string of characters', 'A function used for encryption', 'A function used for key exchange', 'None of the above'],
        'correctAnswer': 0
      },
      {
        'question': '8.What is the purpose of a nonce in cryptography?',
        'options': ['To encrypt data', 'To decrypt data', 'To ensure a unique value for each encryption operation', 'None of the above'],
        'correctAnswer': 2
      },
      {
        'question': '9. What is the main advantage of using elliptic curve cryptography (ECC)?',
        'options': ['It provides the same level of security with smaller key sizes', 'It is faster than symmetric encryption', 'It is easier to implement', 'None of the above'],
        'correctAnswer': 0
      },
      {
        'question': '10. What is the role of a certificate authority (CA) in PKI?',
        'options': ['To encrypt data', 'To issue and verify digital certificates', 'To decrypt data', 'None of the above'],
        'correctAnswer': 1
      },
    ],
    'Penetration Testing': [
      {
        'question': '1. What is a common tool used for penetration testing?',
        'options': ['Metasploit', 'Photoshop', 'Slack', 'None of the above'],
        'correctAnswer': 0
      },
      {
        'question': '2. Which phase of penetration testing involves gathering information about a target system?',
        'options': ['Reconnaissance', 'Exploitation', 'Post-exploitation', 'Reporting'],
        'correctAnswer': 0
      },
      {
        'question': '3. Which of the following is a common vulnerability scanner?',
        'options': ['Nessus', 'WordPress', 'Photoshop', 'Google Chrome'],
        'correctAnswer': 0
      },
      {
        'question': '4. Which of the following tools is primarily used for web application penetration testing?',
        'options': ['Wireshark', 'Burp Suite', 'Nmap', 'Netcat'],
        'correctAnswer': 1
      },
      {
        'question': '5. What is the purpose of a reverse shell in penetration testing?',
        'options': ['To encrypt data', 'To scan for vulnerabilities', 'To gain remote access to a target system', 'None of the above'],
        'correctAnswer': 2
      },
      {
        'question': '6. What is the difference between black-box and white-box penetration testing?',
        'options': ['Black-box testing has no prior knowledge of the system, while white-box testing has full knowledge', 'Black-box testing is faster', 'White-box testing is less thorough', 'None of the above'],
        'correctAnswer': 0
      },
      {
        'question': '7. What is social engineering in the context of penetration testing?',
        'options': ['A type of encryption', 'Manipulating people to gain unauthorized access', 'A vulnerability scanning technique', 'None of the above'],
        'correctAnswer': 1
      },
      {
        'question': '8. What is the purpose of a post-exploitation phase in penetration testing?',
        'options': ['To report vulnerabilities', 'To maintain access and gather further information', 'To scan for vulnerabilities', 'None of the above'],
        'correctAnswer': 1
      },
      {
        'question': '9. What is the importance of documenting findings in penetration testing?',
        'options': ['To provide a clear report for remediation', 'To hide vulnerabilities', 'To avoid legal issues', 'None of the above'],
        'correctAnswer': 0
      },
      {
        'question': '10. What is the main goal of penetration testing?',
        'options': ['Creating firewalls', 'Designing secure networks', 'Developing encryption algorithms', 'Finding and exploiting vulnerabilities'],
        'correctAnswer': 3
      },
    ],
    'Intrusion Detection Systems': [
      {
        'question': '1. What is an IDS used for?',
        'options': ['To block incoming traffic', 'To detect unauthorized access', 'To prevent hacking attempts', 'All of the above'],
        'correctAnswer': 1
      },
      {
        'question': '2. Which type of IDS is best for monitoring network traffic?',
        'options': ['Host-based IDS', 'Both', 'Network-based IDS', 'None'],
        'correctAnswer': 2
      },
      {
        'question': '3. Which of the following is an example of a signature-based IDS?',
        'options': ['Snort', 'OSSEC', 'Suricata', 'None of the above'],
        'correctAnswer': 0
      },
      {
        'question': '4. What is the main disadvantage of a signature-based IDS?',
        'options': ['It is too slow', 'It is too expensive', 'It generates too many false positives', 'It cannot detect new, unknown threats'],
        'correctAnswer': 3
      },
      {
        'question': '5. What type of IDS provides real-time monitoring?',
        'options': ['Intrusion Prevention Systems (IPS)', 'Firewall', 'Signature-based IDS', 'None of the above'],
        'correctAnswer': 0
      },
      {
        'question': '6. What is the difference between an IDS and an IPS?',
        'options': ['IDS is faster', 'IDS detects threats, while IPS prevents them', 'IPS is less accurate', 'None of the above'],
        'correctAnswer': 1
      },
      {
        'question': '7. What is an anomaly-based IDS?',
        'options': ['A system that detects deviations from normal behavior', 'A system that uses signatures', 'A system that blocks all traffic', 'None of the above'],
        'correctAnswer': 0
      },
      {
        'question': '8. What is a false positive in the context of IDS?',
        'options': ['A malicious activity flagged as legitimate', 'A system error', 'None of the above', 'A legitimate activity flagged as malicious'],
        'correctAnswer': 3
      },
      {
        'question': '9. What is the role of machine learning in modern IDS?',
        'options': ['To improve detection accuracy and reduce false positives', 'To replace traditional IDS', 'To slow down the system', 'None of the above'],
        'correctAnswer': 0
      },
      {
        'question': '10. What is a common challenge faced by IDS?',
        'options': ['Low detection rates', 'High cost', 'High false positive rates', 'None of the above'],
        'correctAnswer': 2
      },
    ],
    'Cloud Security': [
      {
        'question': '1. What is Cloud Security?',
        'options': ['Protection of data and applications in the cloud', 'Securing local devices only', 'Encryption of data on local servers', 'None of the above'],
        'correctAnswer': 0
      },
      {
        'question': '2. What is a common security concern when using public cloud services?',
        'options': ['High availability', 'Data privacy and control','Data redundancy', 'Cost of services'],
        'correctAnswer': 1
      },
      {
        'question': '3. What is the shared responsibility model in cloud security?',
        'options': ['The cloud provider and customer share security duties', 'The cloud provider is responsible for everything', 'The customer is fully responsible for security', 'None of the above'],
        'correctAnswer': 0
      },
      {
        'question': '4. Which of the following is an example of a cloud access security broker (CASB)?',
        'options': ['AWS Shield', 'Google Cloud Storage', 'McAfee MVISION Cloud', 'Azure Active Directory'],
        'correctAnswer': 2
      },
      {
        'question': '5. Which security measure helps protect data in a cloud environment?',
        'options': ['Encryption', 'Tokenization', 'Multi-factor authentication', 'All of the above'],
        'correctAnswer': 3
      },
      {
        'question': '6. What is the purpose of data encryption in cloud security?',
        'options': ['To protect data from unauthorized access', 'To increase data storage capacity', 'To reduce costs', 'None of the above'],
        'correctAnswer': 0
      },
      {
        'question': '7. What is a virtual private cloud (VPC)?',
        'options': ['A type of encryption', 'A physical data center', 'A private, isolated section of a public cloud', 'None of the above'],
        'correctAnswer': 2
      },
      {
        'question': '8. What is the role of identity and access management (IAM) in cloud security?',
        'options': ['To control user access to cloud resources', 'To encrypt data', 'To monitor network traffic', 'None of the above'],
        'correctAnswer': 0
      },
      {
        'question': '9. What is a cloud security posture management (CSPM) tool?',
        'options': ['A tool to encrypt data', 'A tool to monitor and manage cloud security risks', 'A tool to encrypt data', 'A tool to block network traffic', 'None of the above'],
        'correctAnswer': 1
      },
      {
        'question': '10. What is the importance of logging and monitoring in cloud security?',
        'options': ['To detect and respond to security incidents', 'To increase storage capacity', 'To reduce costs', 'None of the above'],
        'correctAnswer': 0
      },
    ],
    'Zero Trust Architecture': [
      {
        'question': '1. What is the core principle of Zero Trust Architecture?',
        'options': ['Trust everyone within the network', 'Allow access based on IP address', 'Trust no one, verify everyone', 'None of the above'],
        'correctAnswer': 2
      },
      {
        'question': '2. Which technology is often used in Zero Trust models?',
        'options': ['Multi-Factor Authentication (MFA)', 'VPNs', 'Encryption', 'Firewalls'],
        'correctAnswer': 0
      },
      {
        'question': '3. In Zero Trust, what happens when a user’s access is requested?',
        'options': ['The user is always authenticated and authorized', 'The user’s identity is continuously verified and access is granted based on least privilege', 'Access is automatically granted', 'None of the above'],
        'correctAnswer': 1
      },
      {
        'question': '4. What is one of the key components of Zero Trust Architecture?',
        'options': ['Least privilege access', 'Trusting internal networks', 'Open access for all employees', 'None of the above'],
        'correctAnswer': 0
      },
      {
        'question': '5. Which of the following is NOT a fundamental principle of Zero Trust?',
        'options': ['Assume breach', 'Verify explicitly', 'Use least privileged access', 'Default trust for internal users'],
        'correctAnswer': 3
      },
      {
        'question': '6. What is micro-segmentation in Zero Trust?',
        'options': ['Dividing a network into smaller, isolated segments', 'Encrypting data', 'Using firewalls', 'None of the above'],
        'correctAnswer': 0
      },
      {
        'question': '7. What is the role of continuous monitoring in Zero Trust?',
        'options': ['To block all traffic', 'To ensure ongoing verification of user activity',  'To reduce costs', 'None of the above'],
        'correctAnswer': 1
      },
      {
        'question': '8. What is the difference between Zero Trust and traditional perimeter-based security?',
        'options': ['Zero Trust assumes no trust, even within the network', 'Traditional security assumes trust within the network', 'Zero Trust is less secure', 'None of the above'],
        'correctAnswer': 0
      },
      {
        'question': '9. What is the importance of identity verification in Zero Trust?',
        'options': ['To block all traffic', 'To reduce costs', 'To ensure only authorized users gain access',  'None of the above'],
        'correctAnswer': 2
      },
      {
        'question': '10. What is the role of encryption in Zero Trust?',
        'options': [ 'To block network traffic', 'To protect data in transit and at rest', 'To reduce costs', 'None of the above'],
        'correctAnswer': 1
      },
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
                  Navigator.pushReplacementNamed(context, '/advance');
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
      'Advanced Cryptography': 'advancedcryptography',
      'Penetration Testing': 'penetrationtesting',
      'Intrusion Detection Systems': 'intrusiondetectionsystems',
      'Cloud Security': 'cloudsecurity',
      'Zero Trust Architecture': 'zerotrustarchitecture',
    };

    final columnName = columnMapping[widget.topic];
    if (columnName == null) {
      throw Exception('Invalid topic: ${widget.topic}');
    }

    try {
      // First, check if the user record already exists
      final response = await Supabase.instance.client
          .from('advanced')
          .select('user_id')  // Selecting 'user_id' to check if the user exists
          .eq('user_id', userId)
          .maybeSingle();  // Expecting a single record

      if (response == null) {
        // User does not exist, insert new record
        await Supabase.instance.client
            .from('advanced')
            .insert({
          'user_id': userId,
          columnName: true, // Set the specific column for the topic to true
        });

      } else {
        // If the user exists, update the progress
        await Supabase.instance.client
            .from('advanced')
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

    return Stack(
      children: [
        // Scaffold containing the app's content
        Scaffold(
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
            padding: EdgeInsets.all(26.0),
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
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // White text color for contrast
                    ),
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