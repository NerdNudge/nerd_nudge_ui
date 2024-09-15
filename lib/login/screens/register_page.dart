import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nerd_nudge/login/screens/login_or_register.dart';

import '../../cache_and_lock_manager/cache_locks_keys.dart';
import '../../utilities/colors.dart';
import '../../utilities/styles.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  @override
  void initState() {
    super.initState();
    print('Clearing cache now.');
    CacheLockKeys cacheLockKeys = CacheLockKeys();
    cacheLockKeys.updateQuizFlexShotsKey();
  }

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
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
                    Styles.getTextFormField(fullNameController,
                        'Enter your Full Name', 'Full Name', false),
                    Styles.getSizedHeightBox(20),
                    Styles.getTextFormField(emailController,
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


  Future<void> createNewAccount() async {
    print('creating new account now.');
    User? user = FirebaseAuth.instance.currentUser;
    if(user != null) {
      print('singning out now: ${user.email}');
      FirebaseAuth.instance.signOut();
    }

    if(fullNameController.text == '' || emailController.text == '' || passwordController.text == '' || confirmPasswordController.text == '') {
      Styles.showGlobalSnackbarMessage('Please fill all the details!');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Styles.showGlobalSnackbarMessage('Password does not match!');
      return;
    }

    try {
      print('starting to create account in firebase now');
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      User? user = userCredential.user;
      if(user == null) {
        print('user is null');
        Styles.showGlobalSnackbarMessage('User is null. Please try again.');
        return;
      }

      if (!user.emailVerified) {
        print('user is not verified already');
        await user.sendEmailVerification();
        Styles.showGlobalSnackbarMessage('A verification link has been sent to your email.');

        await Future.delayed(const Duration(seconds: 3));
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginOrRegister(),
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('Email is already in use');
        Styles.showGlobalSnackbarMessage('Email is already in use. Please try logging in.');
      } else {
        print('FirebaseAuthException: ${e.message}');
        Styles.showGlobalSnackbarMessage(e.message!);
      }
    } catch (e) {
      print('Error: $e');
      Styles.showGlobalSnackbarMessage('An error occurred. Please try again.');
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
