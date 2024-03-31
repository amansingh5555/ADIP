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

  Future<void> setPitch() async {
    await flutterTts.setPitch(1.0);
  }

  Future<void> speakOptionName(String optionName) async {
    await setPitch();
    await flutterTts.speak(optionName);
  }

  Future<void> speakPageOverview() async {
    await setPitch();

    try {
      await flutterTts.speak('नोंदणी पृष्ठाची आपली माहिती');
      await Future.delayed(Duration(seconds: 3));
      await flutterTts.speak('पूर्ण नाव, फोन नंबर, पत्ता, पिनकोड, ईमेल, आणि पासवर्ड भरा');
      await Future.delayed(Duration(seconds: 6));
      await flutterTts.speak('सर्व माहिती असल्यास "साइन अप करा" साठी बटणावर क्लिक करा');
      await Future.delayed(Duration(seconds: 5));
      await flutterTts.speak('सुधारित वाचा');
      await Future.delayed(Duration(seconds: 2));
      await flutterTts.speak('आपल्याला आधारित नियमानुसार इ.मेल आणि पासवर्ड तयार करा');
      await Future.delayed(Duration(seconds: 5));
      await flutterTts.speak('पासवर्ड विसरलात का? "सुधा वापरकर्ता आहात? लॉग इन करा" लिंकवर क्लिक करा');
      await Future.delayed(Duration(seconds: 7));
      await flutterTts.speak('सुधा सर्व माहितीसाठी "सर्व माहिती" बटणावर क्लिक करा');
    } catch (e) {
      print('TTS Error in speakPageOverview: $e');
    }
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

        await addUserDetails(
          _nameController.text.trim(),
          _phoneNumberController.text.trim(),
          _addressController.text.trim(),
          _pincodeController.text.trim(),
          _emailController.text.trim(),
        );

        print('User registration successful: ${authResult.user?.email}');
        speakOptionName('नोंदणी सफळ');

        // Navigate to the next screen or perform other actions on successful registration.
      } catch (e) {
        print('Error during registration: $e');
        speakOptionName('नोंदणीत त्रुटी. कृपया पुन्हा प्रयत्न करा.');
      }
    } else {
      print('Passwords do not match');
      speakOptionName('पासवर्ड सापडत नाहीत. कृपया खात्री करा की ते मेलावले आहे की नाही.');
    }
  }

  Future<void> addUserDetails(String fullName, String phoneNumber, String address, String pincode, String email) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final docReference = FirebaseFirestore.instance.collection('users').doc(user.uid);

      await docReference.set({
        'Full Name': fullName,
        'Phone Number': phoneNumber,
        'Address': address,
        'Pincode': pincode,
        'Email': email,
        'Role': 'User',
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'नोंदणी',
          style: TextStyle(color: Colors.white),
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
            Center(
              child: GestureDetector(
                onTap: widget.showLoginApp,
                child: Text(
                  "Already have an account? Log in here",
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            _buildAllInformationButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField(TextEditingController controller, String labelText, IconData icon, Color iconColor, {bool isObscureText = false}) {
    // Mapping of English field names to Marathi field names
    Map<String, String> fieldTranslations = {
      'Full Name': 'पूर्ण नाव',
      'Phone Number': 'फोन नंबर',
      'Address': 'पत्ता',
      'Pincode': 'पिनकोड',
      'Email': 'ईमेल',
      'Password': 'पासवर्ड',
      'Confirm Password': 'पासवर्ड पुनरावलोकन',
    };

    String marathiLabelText = fieldTranslations[labelText] ?? labelText;

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: marathiLabelText,
        icon: Icon(icon, color: iconColor),
        suffixIcon: IconButton(
          icon: Icon(Icons.volume_up),
          onPressed: () {
            speakOptionName("कृपया $marathiLabelText प्रविष्ट करा");
          },
        ),
      ),
      obscureText: isObscureText,
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: signUp,
      child: Text('साइन अप करा'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  Widget _buildAllInformationButton() {
    return ElevatedButton(
      onPressed: speakPageOverview,
      child: Text('सर्व माहिती'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  @override
  void dispose() {
    Future.delayed(Duration(milliseconds: 500), () {
      flutterTts.stop();
    });
    super.dispose();
  }
}
