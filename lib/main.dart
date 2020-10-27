import 'package:flutter/material.dart';
import 'package:ChatterFly/screens/welcome_screen.dart';
import 'package:ChatterFly/screens/login_screen.dart';
import 'package:ChatterFly/screens/registration_screen.dart';
import 'package:ChatterFly/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChatterFly());
}

class ChatterFly extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id : (context) => WelcomeScreen(),
        LoginScreen.id : (context) => LoginScreen(),
        RegistrationScreen.id : (context) => RegistrationScreen(),
        ChatScreen.id : (context) => ChatScreen()
      },
    );
  }
}
