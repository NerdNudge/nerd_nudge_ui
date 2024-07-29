import 'package:flutter/material.dart';
import '../../bottom_menus/screens/bottom_menu_options.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nerd Profile'),
      ),
      body: _getProfileHomePageBody(context),
      bottomNavigationBar: BottomMenu(),
    );
  }

  Widget _getProfileHomePageBody(BuildContext context) {
    return Container();
  }
}
