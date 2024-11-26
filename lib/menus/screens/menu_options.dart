import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nerd_nudge/user_profile/dto/user_profile_entity.dart';
import 'package:nerd_nudge/utilities/api_end_points.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utilities/colors.dart';
import '../../utilities/logger.dart';

class MenuOptions {
  static Drawer getMenuDrawer(BuildContext context) {
    final userName = UserProfileEntity().getUserFullName();
    const title = 'Nerd Menu';
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: 125.0, // Set the desired height here
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: CustomColors.mainThemeColor,
              ),
              child: const Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          _getMenuListTile(context, Icons.person, 'Profile', '/profile'),
          _getMenuListTile(context, Icons.favorite, 'Favorites', '/favorites'),
          //_getMenuListTile(context, Icons.group_add, 'Invite Nerds', '/inviteNerds'),
          _getMenuListTile(context, Icons.star, 'Rate', null, _rateNerdNudge),
          _getMenuListTile(context, Icons.feedback, 'Feedback', '/feedback'),
          //_getMenuListTile(context, Icons.notifications_active, 'Nudger', '/gaugetest'),
          _getSignOutTile(context),
        ],
      ),
    );
  }

  static _getMenuListTile(BuildContext context, IconData icon, String titleText, String? navigatePage, [VoidCallback? action]) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        titleText,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        if (action != null) {
          action(); // Perform custom action if provided
        } else if (navigatePage != null) {
          Navigator.pushNamed(context, navigatePage);
        }
      },
    );
  }

  static void _rateNerdNudge() async {
    final String url = Platform.isAndroid ? APIEndpoints.PLAYSTORE_LINK : APIEndpoints.APPSTORE_LINK;

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      NerdLogger.logger.e('Could not launch $url');
    }
  }

  static _getSignOutTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.exit_to_app),
      title: const Text(
        'Sign Out',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () async {
        await FirebaseAuth.instance.signOut();
        Navigator.pushNamed(context, '/startpage');
        //Navigator.of(context).pushNamedAndRemoveUntil('/startpage', (Route<dynamic> route) => false);
      },
    );
  }
}