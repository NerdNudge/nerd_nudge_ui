import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nerd_nudge/utilities/api_end_points.dart';
import 'package:nerd_nudge/utilities/styles.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../cache_and_lock_manager/cache_locks_keys.dart';
import '../../user_home_page/screens/home_page.dart';
import '../../utilities/logger.dart';
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
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(0), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // Shadow position
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
                              MaterialPageRoute(
                                  builder: (context) => ForgotPasswordPage()),
                            );
                          },
                          child: const Text(
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
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _getThirdPartySignIn(
                            _signInWithGoogle, 'images/google.png'),
                        if (Platform.isIOS) ...[
                          Styles.getSizedWidthBoxByScreen(context, 20),
                          _getThirdPartySignIn(
                              _signInWithApple, 'images/apple.png'),
                        ],
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Not a member?',
                            style: TextStyle(color: Colors.white)),
                        const SizedBox(
                          width: 4,
                        ),
                        GestureDetector(
                          onTap: widget.onRegisterNowTap,
                          child: const Text(
                            'Register Now',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    Styles.getSizedHeightBoxByScreen(context, 30),
                    if (Platform.isIOS)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: RichText(
                          //textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "* By continuing, you agree to ",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(
                                text: 'Terms of Use',
                                style: const TextStyle(
                                  color: Colors.blue,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launchUrl(Uri.parse(
                                        APIEndpoints.TERMS_OF_USE_LINK));
                                  },
                              ),
                              const TextSpan(
                                text: ' and ',
                                style: TextStyle(color: Colors.white),
                              ),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: const TextStyle(
                                  color: Colors.blue,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launchUrl(Uri.parse(
                                        APIEndpoints.PRIVACY_POLICY_LINK));
                                  },
                              ),
                              const TextSpan(
                                text: '.',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getThirdPartySignIn(GestureTapCallback signInFunction, String image) {
    return GestureDetector(
      onTap: signInFunction,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(16),
          color: Colors.white24,
        ),
        child: Image.asset(
          image,
          height: 40,
        ),
      ),
    );
  }

  _signInWithGoogle() async {
    AuthService authService = AuthService();
    User? user = await authService.signInWithGoogle();
    _validateUserAndNavigateToHome(user);
  }

  _signInWithApple() async {
    AuthService authService = AuthService();
    User? user = await authService.signInWithApple();
    _validateUserAndNavigateToHome(user);
  }

  _validateUserAndNavigateToHome(User? user) {
    if (user != null) {
      String userFullName = user.displayName ?? user.email ?? '';
      String email = user.email ?? '';
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            userFullName: userFullName,
            userEmail: email,
          ),
        ),
      );
    } else {
      NerdLogger.logger.d('Sign-in failed or canceled');
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
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    if (usernameController.text == '' || passwordController.text == '') {
      Styles.showGlobalSnackbarMessage('Username or password empty.');
      Navigator.pop(context);
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usernameController.text,
        password: passwordController.text,
      );

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
          builder: (context) => HomePage(
              userFullName: userFullName, userEmail: usernameController.text),
        ),
      );
    } on FirebaseAuthException catch (e) {
      NerdLogger.logger.e('Error: $e');
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
