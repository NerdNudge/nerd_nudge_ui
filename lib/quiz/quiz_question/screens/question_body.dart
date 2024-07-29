import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:nerd_nudge/utilities/colors.dart';

class QuestionContainer extends StatelessWidget {
  const QuestionContainer({super.key, required this.questionText});

  final questionText;

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 270.0,
      child: Card(
        color: CustomColors.mainThemeColor,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        child: ListTile(
          title: Center(
            child: MarkdownBody(
              data: questionText,
              styleSheet: customMarkdownStyle(context),
            ),
          ),
        ),
      ),
    );
  }

  MarkdownStyleSheet customMarkdownStyle(BuildContext context) {
    return MarkdownStyleSheet(
      p: TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
