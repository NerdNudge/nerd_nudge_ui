import 'package:flutter/material.dart';
import 'package:nerd_nudge/utilities/styles.dart';
import '../../../../utilities/colors.dart';
import '../bottom_menus/screens/bottom_menu_options.dart';
import '../menus/screens/menu_options.dart';


class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key, required this.leaderBoardList, required this.buttonClick, required this.topic});

  final String topic;
  final List<dynamic> leaderBoardList;
  final Function buttonClick;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: Styles.getAppBar('$topic Leaderboard'),
        drawer: MenuOptions.getMenuDrawer(context),
        body: _getBody(context),
        bottomNavigationBar: const BottomMenu(),
      ),
    );
  }

  Widget _getBody(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: Styles.getBackgroundBoxDecoration(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Table(
                    columnWidths: {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(3),
                      2: FlexColumnWidth(1),
                    },
                    children: [
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Rank',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'User',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Score',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(color: Colors.white),
                  Expanded(  // Ensure ListView expands properly within available space
                    child: ListView.builder(
                      itemCount: leaderBoardList.length,
                      itemBuilder: (context, index) {
                        final entry = leaderBoardList[index];
                        return Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.white24),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Table(
                              columnWidths: {
                                0: FlexColumnWidth(1),
                                1: FlexColumnWidth(3),
                                2: FlexColumnWidth(1),
                              },
                              children: [
                                TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                        child: Text(
                                          '${index + 1}',
                                          style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                                        ),
                                        backgroundColor:
                                        CustomColors.purpleButtonColor,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        entry['userId'],
                                        style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        entry['score'].toString(),
                                        style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 40),
                  Align(  // Align the close button at the bottom right
                    alignment: Alignment.bottomRight,
                    child: Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: CustomColors.mainThemeColor, // Background color of the button
                        borderRadius: BorderRadius.circular(
                            8.0), // Adjust the border radius for a square shape
                      ),
                      child: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => buttonClick(), // Ensure the buttonClick function works
                        color: Colors.white, // Foreground color of the X icon
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
