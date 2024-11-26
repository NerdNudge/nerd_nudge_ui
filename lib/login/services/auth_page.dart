import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nerd_nudge/login/screens/login_or_register.dart';

import '../../user_home_page/screens/home_page.dart';
import '../../user_profile/dto/user_profile_entity.dart';
import '../../utilities/logger.dart';

class Authpage extends StatelessWidget {
  const Authpage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData && UserProfileEntity().getUserEmail() != '') {
          NerdLogger.logger.d('user data present');
          UserProfileEntity userProfileEntity = UserProfileEntity();
          return HomePage(userFullName: userProfileEntity.getUserFullName(), userEmail: userProfileEntity.getUserEmail(),);
        } else {
          NerdLogger.logger.d('no user data present');
          /*CacheLockKeys cacheLockKeys = CacheLockKeys();
          cacheLockKeys.updateQuizFlexShotsKey();*/
          return const LoginOrRegister();
        }
      },
    );
  }
}
