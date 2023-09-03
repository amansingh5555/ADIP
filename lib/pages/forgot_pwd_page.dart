import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  String errorMessage = '';
  String successMessage = '';
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _configureTts();
  }

  void _configureTts() async {
    await flutterTts.setLanguage('en-US'); // Set the language (you can change it to your preferred language).
    await flutterTts.setSpeechRate(0.5); // Adjust the speech rate.
  }

  Future<void> speakText(String text) async {
    await flutterTts.speak(text);
  }

  Future<void> passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
      // Email sent successfully.
      // Display a success message to the user.
      setState(() {
        successMessage = 'Password reset email has been sent.';
        errorMessage = ''; // Clear any previous error message.
      });

      // Speak the success message.
      await speakText(successMessage);
    } catch (e) {
      // Handle errors as before.
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          // Handle the case where the user does not exist.
          // Display an error message to the user.
          setState(() {
            errorMessage = 'User does not exist.';
            successMessage = ''; // Clear any previous success message.
          });
        } else {
          // Handle other Firebase Auth exceptions.
          print('Error sending password reset email: ${e.message}');
        }
      } else {
        // Handle other exceptions.
        print('Error sending password reset email: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
        backgroundColor: Colors.indigo, // Navy blue color.
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            AnimatedContainer(
              duration: Duration(seconds: 1),
              child: Icon(
                Icons.email,
                size: 100,
                color: Colors.pink,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Forgot Your Password?',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Enter your email, and we will send you a password reset link.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                icon: Icon(
                  Icons.email,
                  color: Colors.pink,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: passwordReset,
              child: Text('Send Reset Email'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.indigo,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
            SizedBox(height: 20),
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (successMessage.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    successMessage,
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.volume_up),
                    onPressed: () {
                      speakText(successMessage);
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
