import 'package:flutter/material.dart';
import '../../../../utilities/colors.dart';
import '../../../../utilities/styles.dart';

class MyCompletedChallengeDetails extends StatefulWidget {
  const MyCompletedChallengeDetails({super.key, required this.challenge});

  final Map<String, dynamic> challenge;

  @override
  State<MyCompletedChallengeDetails> createState() =>
      _MyCompletedChallengeDetailsState();
}

class _MyCompletedChallengeDetailsState extends State<MyCompletedChallengeDetails> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: _getBody(context),
    );
  }

  _getBody(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.challenge['description'],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: CustomColors.purpleButtonColor,
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                Icon(Icons.folder, color: Colors.white70),
                SizedBox(width: 10.0),
                Text(
                  'Type: ${widget.challenge['type']}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.white70),
                SizedBox(width: 10.0),
                Text(
                  'Start Date: ${widget.challenge['startDate']}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.white70),
                SizedBox(width: 10.0),
                Text(
                  'End Date: ${widget.challenge['endDate']}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            _getChallengeDetails(),
            SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Styles.getElevatedButton(
                  'Close',
                  Colors.white70,
                  Colors.black,
                  context,
                      (ctx) => Navigator.pop(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getChallengeDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.group, color: Colors.white70),
            SizedBox(width: 10.0),
            Text(
              '${widget.challenge['members']} members joined',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.0),
        Row(
          children: [
            Icon(Icons.emoji_events, color: Colors.white70),
            SizedBox(width: 10.0),
            Text(
              '${widget.challenge['prizes']} prizes',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        SizedBox(height: 40.0),
        _buildChallengeProgress(),
        SizedBox(height: 40.0),
        Text(
          'Your Stats:',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: CustomColors.purpleButtonColor,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Rank: 181',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Number of Quizzes: 102',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Percentage Correct: 91.2 %',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Total Score: 34.2',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }


  Widget _buildChallengeProgress() {
    double progress = (widget.challenge['progress'] ?? 0.0).toDouble();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Challenge Progress',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: CustomColors.purpleButtonColor,
          ),
        ),
        SizedBox(height: 10.0),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.white24,
          valueColor: AlwaysStoppedAnimation<Color>(CustomColors.purpleButtonColor),
        ),
        SizedBox(height: 5.0),
        Text(
          '${(progress * 100).toStringAsFixed(2)}%',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  void joinChallenge(BuildContext ctx) {
    // Implement join challenge logic
  }
}