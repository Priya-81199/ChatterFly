import 'package:ChatterFly/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:ChatterFly/Components/rounded_button.dart';
import 'package:ChatterFly/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child:  ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: ListView(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      //crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(
                          height: 50,
                        ),
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
                          style: TextStyle(
                            color: Colors.white
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            //Do something with the user input.
                            email = value;
                          },
                          decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        TextField(
                          style: TextStyle(
                              color: Colors.white
                          ),
                          obscureText: true,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            password = value;
                            //Do something with the user input.
                          },
                          decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password'),
                        ),
                        SizedBox(
                          height: 24.0,
                        ),
                        RoundedButton(title: 'Log in',colour: Colors.lightGreen,tag: 'login',
                            onPressed: () async {
                              setState(() {
                                showSpinner = true;
                              });
                              try {
                                final user = await _auth.signInWithEmailAndPassword(
                                    email: email, password: password);

                                if (user != null) {
                                  Navigator.pushNamed(context, ChatScreen.id);
                                }
                                setState(() {
                                  showSpinner = false;
                                });
                              }
                              catch (e) {
                                print(e);
                              }
                            }
                        ),
                      ],
                    ),


              ),
            
          ),

      ),
    );
  }
}
