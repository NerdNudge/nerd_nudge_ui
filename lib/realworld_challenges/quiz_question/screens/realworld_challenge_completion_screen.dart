import 'package:flutter/material.dart';

import '../../../bottom_menus/screens/bottom_menu_options.dart';
import '../../../menus/screens/menu_options.dart';
import '../../../utilities/styles.dart';

class RealworldChallengeCompletionScreen extends StatelessWidget {
  const RealworldChallengeCompletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: Styles.getAppBar('Real-World Challenge'),
        drawer: MenuOptions.getMenuDrawer(context),
        bottomNavigationBar: const BottomMenu(),
        body: _getBody(),
      ),
    );
  }

  Widget _getBody() {
    return Column(
      children: [
        Text('Daily Real-World challenge completed !!!')
      ],
    );
  }
}
