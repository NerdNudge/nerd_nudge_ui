import 'package:flutter/material.dart';

class RealworldChallengePossibleAnswersContainer extends StatefulWidget {
  const RealworldChallengePossibleAnswersContainer({super.key, required this.completeQuiz});

  final completeQuiz;

  @override
  State<RealworldChallengePossibleAnswersContainer> createState() =>
      _RealworldChallengePossibleAnswersContainerState();
}

class _RealworldChallengePossibleAnswersContainerState extends State<RealworldChallengePossibleAnswersContainer> {
  List<AnswerOption> allAnswers = [];
  Color defaultAnswerBorderColor = Colors.blueGrey.shade100;
  Color selectedAnswerBorderColor = Colors.green.shade500;

  Icon defaultIcon = Icon(
    Icons.check_circle_outline_rounded,
    color: Colors.blueGrey.shade100,
  );

  Icon selectedIcon = Icon(
    Icons.check_circle_rounded,
    color: Colors.green,
  );

  @override
  void initState() {
    super.initState();

    allAnswers = [];
    (widget.completeQuiz['possible_answers']).forEach((key, value) {
      createAnswerBox(key, value);
    });
  }

  void createAnswerBox(String sequence, String text) {
    allAnswers.add(AnswerOption(
      sequence: sequence,
      text: text,
      textColor: Colors.black,
      color: defaultAnswerBorderColor,
      icon: defaultIcon,
    ));
  }

  void updateAnswerBoxes(AnswerOption answer) {
    setState(() {
      widget.completeQuiz['selected_answers'] = [];
      allAnswers.forEach((a) {
        if (a == answer && a.color != selectedAnswerBorderColor) {
          (widget.completeQuiz['selected_answers'] as List)
              .add(answer.sequence);
          a.color = selectedAnswerBorderColor;
          a.textColor = selectedAnswerBorderColor;
          a.icon = selectedIcon;
        } else {
          a.color = defaultAnswerBorderColor;
          a.textColor = Colors.black;
          a.icon = defaultIcon;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: allAnswers.map((answer) {
          return Card.outlined(
            elevation: 2.0,
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: answer.color,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: ListTile(
              title: IntrinsicHeight(
                child: Row(children: <Widget>[
                  Text(
                    answer.sequence,
                    style: TextStyle(
                      color: answer.textColor,
                    ),
                  ),
                  VerticalDivider(
                    color: defaultAnswerBorderColor,
                    width: 30.0,
                  ),
                  Expanded(
                    child: Text(
                      answer.text,
                      style: TextStyle(
                        color: answer.textColor,
                      ),
                    ),
                  ),
                  Container(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: answer.icon,
                    ),
                  ),
                ]),
              ),
              tileColor: Colors.white,
              onTap: () {
                updateAnswerBoxes(answer);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

class AnswerOption {
  String sequence;
  String text;
  Color textColor;
  Color color;
  Icon icon;

  AnswerOption(
      {required this.sequence,
      required this.text,
      required this.textColor,
      required this.color,
      required this.icon});
}
