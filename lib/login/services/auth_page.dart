import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nerd_nudge/home_page/screens/home_page.dart';
import 'package:nerd_nudge/login/screens/login_or_register.dart';

class Authpage extends StatelessWidget {
  const Authpage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print('user data present');
          return const HomePage();
        } else {
          print('no user data present');
          return const LoginOrRegister();
        }
      },
    );
  }
}
