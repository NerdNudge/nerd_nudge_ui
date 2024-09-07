import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nerd_nudge/utilities/styles.dart';

import '../../cache_and_lock_manager/cache_locks_keys.dart';
import '../../user_home_page/screens/home_page.dart';
import '../services/auth_service.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key, required this.onRegisterNowTap});

  Function()? onRegisterNowTap;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CacheLockKeys cacheLockKeys = CacheLockKeys();
    cacheLockKeys.updateQuizFlexShotsKey();

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(0), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // Shadow position
                  ),
                ],
              ),
              // Content of the container could be more widgets here
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 70,
                    ),
                    Image.asset(
                      'images/NN_icon_2.png',
                      height: 130,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Nerd Nudge',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 50,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    _getTextField(usernameController, 'email', false),
                    const SizedBox(
                      height: 12,
                    ),
                    _getTextField(passwordController, 'password', true),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                            );
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    _getSignInButton(_signInWithEmail),
                    const SizedBox(
                      height: 30,
                    ),
                    const Row(
                      children: [
                        Expanded(
                            child: Divider(
                          thickness: 0.5,
                          color: Colors.grey,
                        )),
                        Text(
                          ' or continue with ',
                          style: TextStyle(color: Colors.white),
                        ),
                        Expanded(
                            child: Divider(
                          thickness: 0.5,
                          color: Colors.grey,
                        )),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: _signInWithGoogle,
                      child: Container(
                        padding: EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white24,
                        ),
                        child: Image.asset(
                          'images/google.png',
                          height: 40,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Not a member?',
                            style: TextStyle(color: Colors.white)),
                        SizedBox(
                          width: 4,
                        ),
                        GestureDetector(
                          onTap: widget.onRegisterNowTap,
                          child: Text(
                            'Register Now',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _signInWithGoogle() async {
    AuthService authService = AuthService();
    User? user = await authService.signInWithGoogle();
    Navigator.pop(context);

    if (user != null) {
      print('Sign-in successful: ${user.displayName}');
      String userFullName = user.displayName ?? user.email ?? '';
      String email = user.email ?? '';
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(userFullName: userFullName, userEmail: email,),
        ),
      );
    } else {
      print('Sign-in failed or canceled');
      Navigator.pushNamed(context, '/startpage');
    }
  }

  Widget _getSignInButton(Function signIn) {
    return GestureDetector(
      onTap: () {
        signIn();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: const Color(0xFF6A69EB),
            borderRadius: BorderRadius.circular(8)),
        child: const Center(
          child: Text(
            'Sign In',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void _signInWithEmail() async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });

    if (usernameController.text == '' || passwordController.text == '') {
      Styles.showGlobalSnackbarMessage('Username or password empty.');
      Navigator.pop(context);
      return;
    }

    try {
      // Sign in with email and password
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: usernameController.text,
        password: passwordController.text,
      );

      // Reload the user's data to ensure the latest email verification status is fetched
      User? user = userCredential.user;
      await user?.reload();
      user = FirebaseAuth.instance.currentUser;

      if (user != null && !user.emailVerified) {
        Styles.showGlobalSnackbarMessage('Please verify your email.');
        Navigator.pop(context);
        return;
      }

      Navigator.pop(context);

      String userFullName = user?.displayName ?? usernameController.text ?? '';
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              HomePage(userFullName: userFullName, userEmail: usernameController.text),
        ),
      );
    } on FirebaseAuthException catch (e) {
      print('Error: $e');
      Navigator.pop(context);

      if (e.code == 'user-not-found') {
        Styles.showGlobalSnackbarMessage('Invalid email and password!');
      } else if (e.code == 'invalid-credential') {
        Styles.showGlobalSnackbarMessage('Invalid email and password!');
      } else if (e.code == 'invalid-email') {
        Styles.showGlobalSnackbarMessage('Invalid email!');
      }
    }
  }

  Widget _getTextField(controller, String hintText, bool obscureText) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        color: Colors.white, //Color(0xFF6A69EB),
      ),
      obscureText: obscureText,
      decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white24,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.grey,
          )),
          fillColor: Colors.grey.shade900,
          filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.white, //Color(0xFF6A69EB),
          )),
    );
  }
}
