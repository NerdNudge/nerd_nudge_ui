import 'package:flutter/material.dart';

import '../../../../utilities/quiz_topics.dart';

class FavoriteSubTopicSelectionPage extends StatelessWidget {
  const FavoriteSubTopicSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Stack(
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
              // Content of the container could be more widgets here
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
                      children: Topics.options.map((String option) {
                        return FilterChip(
                          label: Text(option),
                          onSelected: (bool val) {
                            //var key = option['id'];
                            print('$option');
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
      ),
    );
  }
}
