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
  bool _isObscure = true; // Whether the password is obscured or not
  bool _isSpeaking = false;

  Future<void> _speakMarathi(String text) async {
    await flutterTts.setLanguage("mar"); // Set the language to Marathi

    // Adjust pitch and speed values as needed
    await flutterTts.setPitch(1.1); // Experiment with different pitch values
    await flutterTts.setSpeechRate(0.55); // Experiment with different speed values

    await flutterTts.speak(text);

    setState(() {
      _isSpeaking = true;
    });

    await flutterTts.awaitSpeakCompletion(true);

    setState(() {
      _isSpeaking = false;
    });
  }

  Future<void> _submitForm() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // User is logged in successfully, you can navigate to another screen.
      print('Logged in as: ${userCredential.user?.email}');
      _speakMarathi('लॉग इन झालं'); // Speak in Marathi
    } catch (e) {
      // Handle login errors, e.g., display an error message.
      print('Login error: $e');
      _speakMarathi('लॉग इन करण्यात त्रुटी आली: $e'); // Speak the error message in Marathi
    }
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
              color: Colors.orange,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.asset(
                  'assets/images/login_page.jpg',
                  width: 400,
                  height: 350,
                  fit: BoxFit.cover,
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
                    labelText: 'ईमेल',
                    icon: Icon(Icons.email),
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: IconButton(
                      icon: Icon(_isSpeaking ? Icons.volume_off : Icons.volume_up),
                      onPressed: () {
                        if (!_isSpeaking) {
                          _speakMarathi('कृपया ईमेल प्रविष्ट करा');
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'पासवर्ड',
                    icon: Icon(Icons.lock),
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(_isSpeaking ? Icons.volume_off : Icons.volume_up),
                          onPressed: () {
                            if (!_isSpeaking) {
                              _speakMarathi('कृपया पासवर्ड प्रविष्ट करा');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  obscureText: _isObscure,
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
                      },
                      child: Text(
                        'पासवर्ड विसरलात का?',
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
                    primary: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 13),
                  ),
                  child: Text(
                    'लॉग इन करा',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      widget.showRegisterPage();
                    },
                    child: Text(
                      "अद्याप वापरकर्ता नाही? आता साइन अप करा",
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
