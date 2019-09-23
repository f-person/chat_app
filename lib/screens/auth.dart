import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../blocs/auth.dart';

GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: [
    'profile',
    'email',
  ],
);

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  GoogleSignInAccount _currentUser;
  final authBloc = AuthBloc();

  @override
  void initState() {
    googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount account) async {
      _currentUser = account;
      final GoogleSignInAuthentication googleSignInAuthentication =
          await _currentUser.authentication;
      authBloc.loginWithGoogle(googleSignInAuthentication.idToken);

      Navigator.of(context).pushReplacementNamed('/chat');
    });
    googleSignIn.signInSilently();
    super.initState();
  }

  Future<void> _handleSignIn() async {
    try {
      print('_handleSignIn');
      await googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log in'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: GoogleSignInButton(
            onPressed: _handleSignIn,
          ),
        ),
      ),
    );
  }
}
