import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'forgot_pwd_page.dart';

class LoginApp extends StatefulWidget {
  final VoidCallback showRegisterPage;

  const LoginApp({Key? key, required this.showRegisterPage}) : super(key: key);

  @override
  State<LoginApp> createState() => _LoginAppState();
}

class _LoginAppState extends State<LoginApp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  FlutterTts flutterTts = FlutterTts();

  Future<void> _speakWithPitch(String text, double pitch) async {
    await flutterTts.setPitch(pitch);
    await flutterTts.speak(text);
  }

  Future<void> _submitForm() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim())
        .then((userCredential) {
      // User is logged in successfully, you can navigate to another screen.
      print('Logged in as: ${userCredential.user?.email}');
      _speakWithPitch('Logged in ', 1.0);
    }).catchError((e) {
      // Handle login errors, e.g., display an error message.
      print('Login error: $e');
      _speakWithPitch('Login error: $e', 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: 350,
            decoration: BoxDecoration(
              color: Colors.orange, // Background color of the header
              borderRadius: BorderRadius.circular(20.0), // Rounded corners
            ),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0), // Rounded corners
                child: Image.asset(
                  'assets/images/login_page.jpg', // Replace with your image path
                  width: 400,
                  height: 350, // Adjust the height to fit within the container
                  fit: BoxFit.cover, // Make sure the image covers the entire container
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    icon: Icon(Icons.email),
                    fillColor: Colors.white, // Background color of input fields
                    filled: true,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.volume_up),
                      onPressed: () {
                        _speakWithPitch('Please enter email', 1.0);
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    icon: Icon(Icons.lock),
                    fillColor: Colors.white, // Background color of input fields
                    filled: true,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.volume_up),
                      onPressed: () {
                        _speakWithPitch('Please enter password', 1.0);
                      },
                    ),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return ForgotPasswordPage();
                            }));
                        // Removed TTS here to prevent speaking on tap.
                      },
                      child: Text(
                        'Forget Password ? ',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _submitForm();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // Background color of the button
                  ),
                  child: Text('Login'),
                ),
                SizedBox(height: 10),
                Center( // Center the text
                  child: GestureDetector(
                    onTap: () {
                      widget.showRegisterPage();
                    },
                    child: Text(
                      "Not a user yet? Sign up now",
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    flutterTts.stop();
    super.dispose();
  }
}
