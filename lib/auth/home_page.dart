import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../pages/main_page.dart';
import 'auth_page.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key : key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
            if (snapshot.hasData) {
              return MainPage();
            } else {
              return AuthPage(); // Display the login or register page
            }
          }
      ),
    );
  }
}
