import 'package:dosantonias_app/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dosantonias_app/pages/pages.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            //usuario logeado
            if (snapshot.hasData) {
              return HomePage();
            }
            //usuario no logeado
            else {
              return LoginPage();
            }
          }),
    );
  }
}
