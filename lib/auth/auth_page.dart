import 'package:flutter/material.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';


class AuthPage extends StatefulWidget {
  const AuthPage({super.key});
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
 bool showLoginApp = true;
 void toggleScreens(){
 setState(() {
   showLoginApp = ! showLoginApp;

});
 }
  @override
  Widget build(BuildContext context) {
    if(showLoginApp){
      return LoginApp(showRegisterPage: toggleScreens);
    }
    else{
      return RegisterPage(showLoginApp: toggleScreens);
    }

  }
}
