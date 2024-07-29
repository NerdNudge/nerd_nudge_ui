import 'package:flutter/cupertino.dart';
import 'package:nerd_nudge/login/screens/login_page.dart';
import 'package:nerd_nudge/login/screens/register_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {

  bool showLoginPage = true;

  void toggleShowLogin() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showLoginPage) {
      return LoginPage(onRegisterNowTap: toggleShowLogin,);
    }
    else {
      return RegisterPage();
    }
  }
}
