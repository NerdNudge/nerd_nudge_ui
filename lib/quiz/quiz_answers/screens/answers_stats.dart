import 'package:flutter/material.dart';

class AnswerWithStats extends StatefulWidget {
  const AnswerWithStats({super.key, required this.completeQuiz, required this.didTimerEnd});

  final completeQuiz;
  final didTimerEnd;

  @override
  State<AnswerWithStats> createState() => _AnswerWithStatsState();
}

class _AnswerWithStatsState extends State<AnswerWithStats> {
  List<AnswerOption> allAnswers = [];
  Color defaultAnswerBorderColor = Colors.blueGrey.shade100;
  Color selectedAnswerBorderColor = Colors.green.shade500;
  Color wrongAnswerBorderColor = Colors.red;

  Icon defaultIcon = Icon(
    Icons.check_circle_outline_rounded,
    color: Colors.blueGrey.shade100,
  );

  Icon selectedIcon = Icon(
    Icons.check_circle_rounded,
    color: Colors.green,
  );

  Icon wrongIcon = Icon(
    Icons.check_circle_rounded,
    color: Colors.red,
  );

  @override
  void initState() {
    super.initState();

    allAnswers = [];
    (widget.completeQuiz['possible_answers']).forEach((key, value) {
      createAnswerBox(key, value);
    });
  }

  Color getAnswerOptionContainerColor(String answerSequence) {
    if(widget.didTimerEnd) {
      return (answerSequence == widget.completeQuiz['right_answer']) ? selectedAnswerBorderColor : defaultAnswerBorderColor;
    }
    else {
      if (!widget.completeQuiz['selected_answers'].contains(answerSequence))
        return defaultAnswerBorderColor;

      return (answerSequence == widget.completeQuiz['right_answer']) ? selectedAnswerBorderColor : wrongAnswerBorderColor;
    }
  }

  Icon getAnswerIcon(String answerSequence) {
    if(widget.didTimerEnd) {
      return (answerSequence == widget.completeQuiz['right_answer']) ? selectedIcon : defaultIcon;
    }
    else {
      if (answerSequence == widget.completeQuiz['right_answer']) {
        return selectedIcon;
      }

      return (!widget.completeQuiz['selected_answers'].contains(answerSequence)) ? defaultIcon : wrongIcon;
    }
  }

  Color getAnswerTextColor(String answerSequence) {
    if(widget.didTimerEnd) {
      return (answerSequence == widget.completeQuiz['right_answer']) ? selectedAnswerBorderColor : Colors.black;
    }
    else {
      if (!widget.completeQuiz['selected_answers'].contains(answerSequence)) {
        return (answerSequence == widget.completeQuiz['right_answer']) ? selectedAnswerBorderColor : Colors.black;
      }

      return (answerSequence == widget.completeQuiz['right_answer']) ? selectedAnswerBorderColor : wrongAnswerBorderColor;
    }
  }

  void createAnswerBox(String sequence, String text) {
    allAnswers.add(AnswerOption(
      sequence: sequence,
      text: text,
      textColor: Colors.black,
      color: getAnswerOptionContainerColor(sequence),
      icon: getAnswerIcon(sequence),
      percentage: widget.completeQuiz['answer_percentages'][sequence],
    ));
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
              title: Stack(
                children: [
                  Row(
                    children: [
                      Text(
                        answer.sequence,
                        style: TextStyle(
                          //color: answer.textColor,
                          color: getAnswerTextColor(answer.sequence),
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.grey[300],
                        width: 30.0,
                      ),
                      /*Expanded(
                        child: Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width *
                              (answer.percentage / 100),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),*/
                      Expanded(
                        child: Text(
                          answer.text,
                          style: TextStyle(
                            //color: answer.textColor,
                            color: getAnswerTextColor(answer.sequence),
                          ),
                        ),
                      ),
                      Container(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: getAnswerIcon(answer.sequence),
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Container(
                        child: Text(
                          "${answer.percentage}%", // Display the percentage
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            //color: Colors.black,
                            color: getAnswerTextColor(answer.sequence),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              tileColor: Colors.white,
              onTap: () {},
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
  double percentage;

  AnswerOption({
    required this.sequence,
    required this.text,
    required this.textColor,
    required this.color,
    required this.icon,
    required this.percentage,
  });
}
