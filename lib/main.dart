import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nerd_nudge/login/screens/login_or_register.dart';
import 'package:nerd_nudge/login/screens/login_page.dart';
import 'package:nerd_nudge/login/services/auth_page.dart';
import 'package:nerd_nudge/menus/screens/favorites/favorites_main_page.dart';
import 'package:nerd_nudge/menus/screens/sign_out/sign_out.dart';
import 'package:nerd_nudge/menus/screens/user_feedback/user_feedback.dart';
import 'package:nerd_nudge/menus/screens/user_profile/user_profile.dart';
import 'package:nerd_nudge/subscriptions/services/purchase_api.dart';
import 'package:nerd_nudge/subscriptions/subscription_comparison_page.dart';
import 'package:nerd_nudge/subscriptions/subscription_page.dart';
import 'package:nerd_nudge/subscriptions/subscription_page_tabs.dart';
import 'package:nerd_nudge/subscriptions/upgrade_page.dart';
import 'package:nerd_nudge/utilities/gauge_tester_base.dart';
import 'package:nerd_nudge/utilities/share_test.dart';
import 'package:nerd_nudge/utilities/styles.dart';
import 'package:nerd_nudge/ads_manager/ads_manager.dart';

import 'firebase_options.dart';


main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  MobileAds.instance.initialize();
  await PurchaseAPI.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(NerdNudgeApp());
  });
}


class NerdNudgeApp extends StatelessWidget {
  const NerdNudgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: Styles.scaffoldMessengerKey,
      title: 'Nerd Nudge',
      theme: Styles.getThemeData(),
      home: Scaffold(
        /*appBar: AppBar(
          title: const Text('Nerd Nudge'),
          leading: Styles.getIconButton(),
        ),*/
        body: const Authpage(),
      ),
      routes: {
        '/feedback': (context) => FeedbackPage(),
        '/favorites': (context) => const Favorites(),
        '/subscription': (context) => SubscriptionPageTabsBased(),
        '/inviteNerds': (context) => UpgradePage(),
        '/gaugetest': (context) => GaugeTesterBase(),
        '/signout': (context) => SignOut(),
        '/authpage': (context) => Authpage(),
        '/startpage': (context) => LoginOrRegister(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}

