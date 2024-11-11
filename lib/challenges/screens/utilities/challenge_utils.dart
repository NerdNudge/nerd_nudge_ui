import 'package:flutter/material.dart';
import '../../../../utilities/colors.dart';
import '../../../utilities/quiz_topics.dart';
import '../../../utilities/styles.dart';

class ChallengeUtils {
  static _getChallengeCardBoxDecoration() {
    return BoxDecoration(
      color: Colors.white70,
      borderRadius: BorderRadius.circular(15.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
    );
  }

  static _getCardRow(String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16.0, color: Colors.grey[700]),
        SizedBox(width: 5.0),
        Text(
          '$value',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }


  static getRealWorldChallengeCard({
    required String message,
    required IconData icon,
    required int members,
    required int numQuestions,
    required int time,
    required Function onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      padding: EdgeInsets.all(10.0),
      decoration: _getChallengeCardBoxDecoration(),
      child: GestureDetector(
        onTap: () => onTap(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: CustomColors.purpleButtonColor, size: 40.0),
            Styles.getSizedHeightBox(18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        message,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: CustomColors.purpleButtonColor,
                        ),
                      ),
                      _getCardRow(members.toString(), Icons.group),
                    ],
                  ),
                  Styles.getSizedHeightBox(10),
                  _getCardRow('Questions: $numQuestions', Icons.format_list_numbered),
                  Styles.getSizedHeightBox(5),
                  _getCardRow('Time: $time minutes', Icons.timer),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static getChallengeCard({
    required String message,
    required IconData icon,
    required String startDate,
    required String endDate,
    required int prizes,
    required int members,
    required String owner,
    required bool joined,
    required Function onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      padding: EdgeInsets.all(10.0),
      decoration: _getChallengeCardBoxDecoration(),
      child: GestureDetector(
        onTap: () => onTap(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: CustomColors.purpleButtonColor, size: 40.0),
            SizedBox(width: 18.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        message,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: CustomColors.purpleButtonColor,
                        ),
                      ),
                      _getCardRow(members.toString(), Icons.group),
                    ],
                  ),
                  SizedBox(height: 15.0),
                  _getCardRow('Start Date: $startDate', Icons.calendar_today),
                  SizedBox(height: 5.0),
                  _getCardRow('End Date: $endDate', Icons.calendar_today),
                  SizedBox(height: 10.0),
                  //_getCardRow('$prizes prizes', Icons.emoji_events),
                  _getJoinedRow(joined),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _getJoinedRow(bool joined) {
    if (joined) {
      return Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 5.0),
          Text(
            'Joined',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.green,
            ),
          ),
        ],
      );
    } else {
      return Container(); // Return an empty container if not joined
    }
  }

  static getMyChallengeCard(
      {required Map<String, dynamic> challenge, required Function onTap}) {
    return _getMyNerdNudgeActiveChallengeCard(challenge, onTap);
  }

  static _getMyNerdNudgeActiveChallengeCard(
    Map<String, dynamic> challenge,
    Function onTap,
  ) {
    String message = challenge['name'];
    IconData icon = Topics.getIconForTopics(challenge['type']);
    String challengeTopic = challenge['type'];
    String challengeOwner = challenge['owner'];
    String startDate = challenge['startDate'];
    String endDate = challenge['endDate'];
    int prizes = challenge['prizes'];
    int members = challenge['members'];
    String owner = challenge['owner'];

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      padding: EdgeInsets.all(10.0),
      decoration: _getChallengeCardBoxDecoration(),
      child: GestureDetector(
        onTap: () => onTap(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: CustomColors.purpleButtonColor, size: 40.0),
            SizedBox(width: 18.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        message,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: CustomColors.purpleButtonColor,
                        ),
                      ),
                      _getCardRow(members.toString(), Icons.group),
                    ],
                  ),
                  SizedBox(height: 15.0),
                  _getCardRow('Topic: $challengeTopic', Icons.folder),
                  SizedBox(height: 5.0),
                  _getCardRow('Type: $challengeOwner Challenge', Icons.person),
                  SizedBox(height: 5.0),
                  _getCardRow('Start Date: $startDate', Icons.calendar_today),
                  SizedBox(height: 5.0),
                  _getCardRow('End Date: $endDate', Icons.calendar_today),
                  SizedBox(height: 10.0),
                  //_getCardRow('$prizes prizes', Icons.emoji_events),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
