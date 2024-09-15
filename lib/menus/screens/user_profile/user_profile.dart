import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nerd_nudge/menus/services/user_profile_service/user_profile_service.dart';
import 'package:nerd_nudge/subscriptions/screens/paywall_panel_screen.dart';
import 'package:nerd_nudge/user_profile/dto/user_profile_entity.dart';
import '../../../../utilities/colors.dart';
import '../../../../utilities/styles.dart';
import '../../../bottom_menus/screens/bottom_menu_options.dart';
import '../../../menus/screens/menu_options.dart';
import '../../../subscriptions/services/purchase_api.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String userName;
  late String userEmail;
  final PanelController _panelController = PanelController();
  List<Package> _packages = [];

  @override
  void initState() {
    super.initState();
    userEmail = UserProfileEntity().getUserEmail();
    userName = UserProfileEntity().getUserFullName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Styles.getAppBar('Nerd Profile'),
      drawer: MenuOptions.getMenuDrawer(context),
      bottomNavigationBar: const BottomMenu(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: Styles.getBackgroundBoxDecoration(),
              child: GestureDetector(
                onTap: () {
                  if (_panelController.isPanelOpen) {
                    _panelController.close();
                  }
                },
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildProfileHeader(
                            context), // Profile Picture and Name
                        const SizedBox(height: 40),
                        _buildProfileActions(
                            context), // Change Password, Account Options, Logout
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          PaywallPanel.getSlidingPanel(context, _panelController),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: CustomColors.purpleButtonColor,
          child: Text(
            userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
            style: const TextStyle(
              fontSize: 40,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          userName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          userEmail,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 20),
        Styles.getDivider(),
        const SizedBox(height: 20),
        _buildAccountTypeSection(context),
        const SizedBox(height: 5),
      ],
    );
  }

  Widget _buildAccountTypeSection(BuildContext context) {
    final String currentOffer = PurchaseAPI.userCurrentOffering;
    print('Current offer of user: $currentOffer');

    if (currentOffer == 'Freemium') {
      return _displayFreemiumAccountDetails();
    } else {
      return _displayNerdNudgeProAccountDetails();
    }
  }

  _displayNerdNudgeProAccountDetails() {
    return Column(
      children: [
        Text(
          'Nerd Nudge Pro',
          style: const TextStyle(
              color: Colors.white54, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () async {
            try {
              if (Platform.isAndroid) {
                // Redirect to Google Play Store subscription management page
                const url =
                    'https://play.google.com/store/account/subscriptions';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              } else if (Platform.isIOS) {
                // Redirect to iOS subscription management page
                const url = 'https://apps.apple.com/account/subscriptions';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              }
              PurchaseAPI.updateNerdNudgeOfferings();
              PurchaseAPI.updateCurrentOffer();
            } catch (e) {
              print('Error opening subscription management page: $e');
              Styles.showGlobalSnackbarMessage(
                  'Unable to open subscription management page.');
            }
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.mainThemeColor),
          child: const Text('Cancel Subscription'),
        ),
      ],
    );
  }

  _displayFreemiumAccountDetails() {
    return Column(
      children: [
        Text(
          'Freemium User',
          style: const TextStyle(
              color: Colors.white54, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () async {
            final List<Offering> offerings = PurchaseAPI.offerings;
            print('Offerings: $offerings');

            if (offerings == null || offerings.isEmpty) {
              Styles.showGlobalSnackbarMessage('No Offers found!');
            } else {
              setState(() {
                try {
                  _packages = offerings.map((offering) {
                        return offering.availablePackages!;
                      })
                      .expand((pkgList) => pkgList is Iterable
                          ? pkgList
                          : <Package>[]) // Flatten the list, handle type safely
                      .toList();
                  PurchaseAPI.updateNerdNudgeOfferings();
                  PurchaseAPI.updateCurrentOffer();
                } catch (e) {
                  print('Error during mapping and expanding packages: $e');
                }
              });

              _panelController.open(); // Open the sliding panel
            }
          },
          child: const Text('Upgrade Account',
              style: TextStyle(color: Colors.white70)),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildProfileActions(BuildContext context) {
    return Column(
      children: [
        _buildActionItem(
          icon: Icons.lock,
          label: 'Change Password',
          onTap: () {
            _changePassword(context);
          },
        ),
        _buildActionItem(
          icon: Icons.delete,
          label: 'Delete Account',
          onTap: () {
            _deleteAccount(context);
          },
        ),
        _buildActionItem(
          icon: Icons.logout,
          label: 'Log Out',
          onTap: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushNamed(context, '/startpage');
          },
        ),
      ],
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade800, Colors.grey.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 3), // Changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white54, size: 24),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                color: Colors.white54, size: 16),
          ],
        ),
      ),
    );
  }

  void _changePassword(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    final String? email = _auth.currentUser?.email;

    if (email != null && email.isNotEmpty) {
      try {
        await _auth.sendPasswordResetEmail(email: email);
        _showMessageDialog(context, 'Password Reset',
            'A password reset link has been sent to $email.');
      } catch (e) {
        _showMessageDialog(context, 'Error',
            'Unable to send password reset email. Please try again.');
      }
    } else {
      _showMessageDialog(context, 'Error', 'No email found for this user.');
    }
  }

  void _showMessageDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _deleteAccount(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;

    if (user != null) {
      final String? userEmail = user.email;

      // Confirm the user before proceeding
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Account'),
            content: const Text(
                'Are you sure you want to permanently delete your account? This action cannot be undone.'),
            actions: [
              TextButton(
                onPressed: () async {
                  bool result = await UserProfileService()
                      .callDeleteAccountAPI(userEmail!);

                  if (result) {
                    await _auth.currentUser?.delete();
                    Navigator.pop(context);
                    _showMessageDialog(
                        context, 'Success', 'Your account has been deleted.');
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/startpage', (route) => false);
                  } else {
                    Navigator.pop(context);
                    _showMessageDialog(context, 'Error',
                        'Failed to delete your account. Please try again.');
                  }
                },
                child: const Text('Yes, Delete'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      );
    } else {
      _showMessageDialog(context, 'Error', 'No user is logged in.');
    }
  }
}
