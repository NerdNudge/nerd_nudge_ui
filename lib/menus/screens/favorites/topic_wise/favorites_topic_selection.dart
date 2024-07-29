import 'package:flutter/material.dart';
import 'package:nerd_nudge/menus/screens/favorites/topic_wise/favorites_sub_topics.dart';
import '../../../../utilities/colors.dart';
import '../../../../utilities/quiz_topics.dart';
import '../../../../utilities/styles.dart';
import '../../../services/favorites/favorite_topics_service.dart';

class FavoritesTopicSelectionPage extends StatefulWidget {
  const FavoritesTopicSelectionPage({super.key});

  @override
  State<FavoritesTopicSelectionPage> createState() =>
      _FavoritesTopicSelectionPageState();
}

class _FavoritesTopicSelectionPageState
    extends State<FavoritesTopicSelectionPage> {
  late Widget tabPlaceholder;

  @override
  void initState() {
    super.initState();
    tabPlaceholder = _getTopicListingPage(context);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: tabPlaceholder,
    );
  }

  void updateListingPage(Widget onTapWidget) {
    setState(() {
      print('Called the update listing page');
      tabPlaceholder = onTapWidget;
    });
  }

  Widget _getSubTopicListingPage(String topic) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black, // Background color of the box
              borderRadius: BorderRadius.circular(0), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // Shadow position
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: 300.0,
                  right: 40.0,
                  left: 40.0,
                ), // Padding to leave space for buttons
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 40),
                    Text(
                      'Select a Sub-Topic.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 40),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: FavoriteTopicsService()
                          .getSubtopicList(topic)
                          .map((subtopic) {
                        return FilterChip(
                          label: Text(subtopic['id'] ?? ''),
                          onSelected: (bool val) {
                            print('${subtopic['id']}');
                            updateListingPage(_getSubtopicListDrillDown(topic, subtopic['id']!));
                          },
                          selectedColor: Colors.white,
                          checkmarkColor: Colors.green,
                          backgroundColor: Colors.grey.shade500,
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      child: Styles.getElevatedButton(
                          'CLOSE',
                          CustomColors.mainThemeColor,
                          Colors.white,
                          context,
                          (ctx) =>
                              updateListingPage(_getTopicListingPage(context))),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getSubtopicListDrillDown(String topic, String subtopic) {
    return FavoriteSubTopics(topic: topic, subtopic: subtopic);
  }

  Widget _getTopicListingPage(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black, // Background color of the box
              borderRadius: BorderRadius.circular(0), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // Shadow position
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 300.0,
                right: 40.0,
                left: 40.0,
              ), // Padding to leave space for buttons
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Select a Topic.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 40),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: Topics.options.map((String option) {
                      return FilterChip(
                        label: Text(option),
                        onSelected: (bool val) {
                          print('$option');
                          updateListingPage(_getSubTopicListingPage(option));
                        },
                        selectedColor: Colors.white,
                        checkmarkColor: Colors.green,
                        backgroundColor: Colors.grey.shade500,
                      );
                    }).toList(),
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
