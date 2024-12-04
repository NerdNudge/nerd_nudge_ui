import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nerd_nudge/login/screens/login_or_register.dart';
import 'package:nerd_nudge/login/services/auth_page.dart';
import 'package:nerd_nudge/menus/screens/favorites/favorites_main_page.dart';
import 'package:nerd_nudge/menus/screens/invite_nerds/invite_nerds.dart';
import 'package:nerd_nudge/menus/screens/sign_out/sign_out.dart';
import 'package:nerd_nudge/menus/screens/user_feedback/user_feedback.dart';
import 'package:nerd_nudge/menus/screens/user_profile/user_profile.dart';
import 'package:nerd_nudge/subscriptions/services/purchase_api.dart';
import 'package:nerd_nudge/utilities/styles.dart';

import 'firebase_options.dart';


main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeAppAsync();
  await PurchaseAPI.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const NerdNudgeApp());
  });
}

Future<void> initializeAppAsync() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  MobileAds.instance.initialize();
}


class NerdNudgeApp extends StatelessWidget {
  const NerdNudgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: Styles.scaffoldMessengerKey,
      title: 'Nerd Nudge',
      theme: Styles.getThemeData(),
      home: const Scaffold(
        body: Authpage(),
      ),
      routes: {
        '/feedback': (context) => FeedbackPage(),
        '/favorites': (context) => const Favorites(),
        '/inviteNerds': (context) => const InviteNerdsPage(),
        '/signout': (context) => const SignOut(),
        '/authpage': (context) => const Authpage(),
        '/startpage': (context) => const LoginOrRegister(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}

