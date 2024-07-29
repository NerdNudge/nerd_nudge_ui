import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nerd_nudge/login/screens/login_or_register.dart';

import '../../home_page/screens/home_page.dart';
import '../../utilities/colors.dart';
import '../../utilities/styles.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  Widget getBody(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black, // Background color of the box
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
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 120.0,
                right: 40.0,
                left: 40.0,
              ), // Padding to leave space for buttons
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Styles.getSizedHeightBox(10),
                    Image.asset(
                      'images/NN_icon_2.png',
                      height: 120,
                    ),
                    Styles.getSizedHeightBox(20),
                    Text(
                      'Let\'s create your account.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Styles.getSizedHeightBox(20),
                    Center(
                      child: Text(
                        'It\'s time to create your account to start your learning and save your progress.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Styles.getSizedHeightBox(30),
                    Styles.getTextFormField(usernameController,
                        'Enter your e-mail', 'E-mail', false),
                    Styles.getSizedHeightBox(20),
                    /*Styles.getTextFormField('Enter your Name', 'Name', false),
                    Styles.getSizedHeightBox(20),*/
                    Styles.getTextFormField(passwordController,
                        'Enter your password', 'Password', true),
                    Styles.getSizedHeightBox(20),
                    Styles.getTextFormField(confirmPasswordController,
                        'Confirm password', 'Password Confirmation', true),
                    Styles.getSizedHeightBox(50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Styles.getElevatedButton(
                              'Create',
                              CustomColors.purpleButtonColor,
                              Colors.white,
                              context,
                              (ctx) => createNewAccount()),
                        ),
                        Styles.getSizedWidthBox(20),
                        Container(
                          child: Styles.getElevatedButton(
                              'Back',
                              Colors.white,
                              Colors.black,
                              context,
                              (ctx) => onBackButtonTapped(ctx)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /*Future<void> createNewAccount() async {
    if (passwordController.text != confirmPasswordController.text) {
      showErrorMessage('Password does not match!');
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: usernameController.text,
        password: passwordController.text,
      );
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showErrorMessage(e.message!);
    }
  }*/

  Future<void> createNewAccount() async {
    if(usernameController.text == '' || passwordController.text == '' || confirmPasswordController.text == '') {
      Styles.showGlobalSnackbarMessage('Please fill all the details!');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Styles.showGlobalSnackbarMessage('Password does not match!');
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: usernameController.text,
        password: passwordController.text,
      );

      User? user = userCredential.user;
      if(user == null) {
        return;
      }

      if (!user.emailVerified) {
        await user.sendEmailVerification();
        Styles.showGlobalSnackbarMessage('A verification link has been sent to your email.');

        await Future.delayed(const Duration(seconds: 3)); // Wait for 3 seconds
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginOrRegister(),
            ),
          );
        }
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      Styles.showGlobalSnackbarMessage(e.message!);
    }
  }

  void onBackButtonTapped(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginOrRegister(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nerd Nudge'),
      ),
      body: getBody(context),
    );
  }
}
