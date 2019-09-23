import 'package:chat_app/screens/auth.dart';
import 'package:flutter/material.dart';

import './screens/chat.dart';

void main() {
  // TODO check if there is an authenticated user for routing
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        accentColor: Colors.pinkAccent,
      ),
      routes: {
        '/': (context) => AuthScreen(),
        '/chat': (context) => ChatScreen(),
      },
    );
  }
}
