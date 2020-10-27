import 'package:ChatterFly/constants.dart';
import 'package:ChatterFly/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:ChatterFly/Components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';


class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final _auth = FirebaseAuth.instance;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/butterfly.gif'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password')
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(title: 'Register',colour: Colors.green, tag : 'register',onPressed: () async {
//                print(email);
//                print(password);
              try {
                final newUser = await _auth.createUserWithEmailAndPassword(
                    email: email, password: password);

                if (newUser != null) {
                  Navigator.pushNamed(context, ChatScreen.id);
                }
              }
              catch(e){
                print(e);
              }
              }
              ,),
            ],
          ),
        ),
      ),
    );
  }
}
