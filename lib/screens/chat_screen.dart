import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ChatterFly/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  String messageText;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() async {
    try{
    final user = await _auth.currentUser;
    if(user != null){
        loggedInUser = user;
        print(loggedInUser.email);
    } }
    catch(e){
      print(e);
    }
  }
//  void getMessages() async {
//
//    final messages = await _firestore.collection('messages').get();
//    for (var message in messages.docs){
//      print(message.data());
//    }
//  }
  void messageStream() async {
    await for(var snapshot in _firestore.collection('messages').snapshots()){
      for (var message in snapshot.docs){
      print(message.data());
    }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {

                //Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);

              }),
        ],
        title: Center(child: Text('⚡️Chatterfly')),
        backgroundColor: Colors.green[900],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('messages').orderBy('Timestamp').snapshots(),
                builder: (context , snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                    );
                  }
                    final messages = snapshot.data.docs.reversed;
                    List<MessageBubble> messageBubbles = [];
                    for (var message in messages) {
                          final messageText = message.get('text');
                          final messageSender = message.get('sender');
                          final currenUser = loggedInUser.email;


                          final messageBubble = MessageBubble(sender: messageSender, text: messageText,isMe: currenUser==messageSender,);

                          messageBubbles.add(messageBubble);
                          }
                      return Expanded(
                        child: ListView(
                          reverse: true,
                          padding: EdgeInsets.symmetric(horizontal: 10.0 , vertical: 20.0),
                          children: messageBubbles,
                        ),
                      );

                  },
                  ),

            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //Implement send functionality.
                      messageTextController.clear();
                      var now = DateTime.now();
                      String date = '${now.day.toString()}/${now.month.toString()}';
                      String time = '${DateFormat.jm().format(now).toString()}';

                        _firestore.collection('messages').add({
                          'text': messageText,
                          'sender': loggedInUser.email,
                          'date': date,
                          'time': time,
                          'Timestamp': FieldValue.serverTimestamp(),
                        });

                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {

  MessageBubble({this.sender,this.text , this.isMe});

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54
            ),
          ),
          Material(
            borderRadius: isMe?BorderRadius.only(topLeft: Radius.circular(30),bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)):
            BorderRadius.only(topRight: Radius.circular(30),bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
            elevation: 5.0,
            color: isMe? Colors.lightGreen[100] : Colors.lightGreen[800],
            child: Padding(
              padding: EdgeInsets.symmetric(vertical : 10.0 , horizontal: 20.0),
              child: Text(
                   text,
                  style : TextStyle(
                    color: isMe? Colors.black: Colors.white,
                    fontSize: 15,
                  )
              ),
            ),
          ),
        ],
      ),
    );
  }
}

