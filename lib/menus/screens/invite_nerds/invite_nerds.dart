import 'package:flutter/material.dart';
import 'package:nerd_nudge/utilities/api_end_points.dart';
import 'package:share_plus/share_plus.dart';

import '../../../bottom_menus/screens/bottom_menu_options.dart';
import '../../../utilities/colors.dart';
import '../../../utilities/styles.dart';
import '../menu_options.dart';

class InviteNerdsPage extends StatelessWidget {
  const InviteNerdsPage({Key? key}) : super(key: key);

  void _inviteNerds() {
    const String inviteLink = APIEndpoints.CONTENT_MANAGER_BASE_URL + APIEndpoints.INVITE_NERDS_URL;
    Share.share(
      'Check out Nerd Nudge! It’s the ultimate app for tech quizzes and learning.\nGet it here: $inviteLink',
      subject: 'Join me on Nerd Nudge!',
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: Styles.getAppBar('Invite Nerds'),
        drawer: MenuOptions.getMenuDrawer(context),
        body: _getBody(context),
        bottomNavigationBar: const BottomMenu(),
        backgroundColor: Colors.black,
      ),
    );
  }

  _getBody(BuildContext context) {
    return Container(
      decoration: Styles.getBackgroundBoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.group_add,
            size: 80,
            color: Colors.black54,
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Invite your nerd friends to join Nerd Nudge! Let’s make learning tech fun and collaborative.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: _inviteNerds,
            style: ElevatedButton.styleFrom(
              foregroundColor: CustomColors.purpleButtonColor,
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            icon: Icon(
              Icons.share,
              color: CustomColors.purpleButtonColor, // Icon color
            ),
            label: Text(
              'Share Invite Link',
              style: TextStyle(
                fontSize: 16,
                color: CustomColors.purpleButtonColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
