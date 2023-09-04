import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginApp;

  const RegisterPage({Key? key, required this.showLoginApp});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  FlutterTts flutterTts = FlutterTts();

  Future<void> speakOptionName(String optionName) async {
    await flutterTts.speak(optionName);
  }

  Future<void> signUp() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();

    if (password == confirmPassword) {
      try {
        final authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // User registration was successful, add user details to Firestore.
        await addUserDetails(
          _nameController.text.trim(),
          _phoneNumberController.text.trim(),
          _addressController.text.trim(),
          _pincodeController.text.trim(),
          _emailController.text.trim(),
        );

        // Access user information from authResult.user
        print('User registration successful: ${authResult.user?.email}');

        // Navigate to the next screen or perform other actions on successful registration.
      } catch (e) {
        // Handle any errors that occur during registration.
        print('Error during registration: $e');
        // You can display an error message to the user here.
        speakOptionName("Error during registration. Please try again.");
      }
    } else {
      // Passwords do not match, you can display an error message.
      print('Passwords do not match');
      // You can display an error message to the user here.
      speakOptionName("Passwords do not match. Please make sure they match.");
    }
  }

  Future<void> addUserDetails(String fullName, String phoneNumber, String address, String pincode, String email) async {
    await FirebaseFirestore.instance.collection('users').add({
      'Full Name': fullName,
      'Phone Number': phoneNumber,
      'Address': address,
      'Pincode': pincode,
      'Email': email,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Registration',
          style: TextStyle(color: Colors.white), // Customize text color
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildFormField(_nameController, 'Full Name', Icons.person, Colors.red),
            _buildFormField(_phoneNumberController, 'Phone Number', Icons.phone, Colors.blue),
            _buildFormField(_addressController, 'Address', Icons.home, Colors.green),
            _buildFormField(_pincodeController, 'Pincode', Icons.signpost_sharp, Colors.orange),
            _buildFormField(_emailController, 'Email', Icons.email, Colors.purple),
            _buildFormField(_passwordController, 'Password', Icons.lock, Colors.teal, isObscureText: true),
            _buildFormField(_confirmPasswordController, 'Confirm Password', Icons.lock, Colors.brown, isObscureText: true),
            SizedBox(height: 20),
            _buildSignUpButton(),
            SizedBox(height: 10),
            Center( // Center the "Log in now" link
              child: GestureDetector(
                onTap: widget.showLoginApp,
                child: Text(
                  "Already a user? Log in now",
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
    );
  }

  Widget _buildFormField(TextEditingController controller, String labelText, IconData icon, Color iconColor, {bool isObscureText = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        icon: Icon(icon, color: iconColor), // Customize icon color
        suffixIcon: IconButton(
          icon: Icon(Icons.volume_up),
          onPressed: () {
            speakOptionName(labelText);
          },
        ),
      ),
      obscureText: isObscureText,
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: signUp,
      child: Text('Sign Up'),
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
        padding: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _pincodeController.dispose();
    _phoneNumberController.dispose();
    flutterTts.stop();

    super.dispose();
  }
}
