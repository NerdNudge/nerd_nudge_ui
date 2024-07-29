import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../utilities/colors.dart';

class MenuOptions {
  static Drawer getMenuDrawer(BuildContext context) {
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
                'Nerd Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          _getMenuListTile(context, Icons.person, 'Profile', '/share'),
          _getMenuListTile(context, Icons.favorite, 'Favorites', '/favorites'),
          _getMenuListTile(context, Icons.subscriptions, 'Subscription', '/subscription'),
          _getMenuListTile(context, Icons.feedback, 'Feedback', '/feedback'),
          _getMenuListTile(context, Icons.group_add, 'Invite Nerds', '/inviteNerds'),
          _getMenuListTile(context, Icons.notifications_active, 'Nudger', ''),
          _getMenuListTile(context, Icons.delete_forever, 'Delete Account', ''),
          //_getMenuListTile(context, Icons.exit_to_app, 'Sign Out', '/signout'),
          _getSignOutTile(context),
        ],
      ),
    );
  }

  static _getMenuListTile(BuildContext context, IconData icon, String titleText, String navigatePage) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        titleText,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, navigatePage);
      },
    );
  }

  static _getSignOutTile(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.exit_to_app),
      title: Text(
        'Sign Out',
        style: const TextStyle(
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