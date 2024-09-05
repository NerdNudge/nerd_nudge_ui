import 'package:flutter/cupertino.dart';
import 'package:nerd_nudge/login/screens/login_page.dart';
import 'package:nerd_nudge/login/screens/register_page.dart';

import '../../cache_and_lock_manager/cache_locks_keys.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {

  @override
  void init() {
    super.initState();
    print('Clearing cache now.');
    CacheLockKeys cacheLockKeys = CacheLockKeys();
    cacheLockKeys.updateQuizFlexShotsKey();
  }

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
