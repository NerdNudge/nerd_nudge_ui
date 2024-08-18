import 'package:flutter/material.dart';
import '../../utilities/colors.dart';
import '../../utilities/styles.dart';

class MenuUtils {
  static getRecentFavoritesCard({
    required Map<String, dynamic> recentFavorite,
    required Function onTap,
  }) {
    final String type = recentFavorite['topic_name'];
    final String topic = recentFavorite['sub_topic'];
    final String title = recentFavorite['title'];
    final String difficulty_level = recentFavorite['difficulty_level'];

    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.0, horizontal: 15.0),
      padding: EdgeInsets.all(15.0),
      decoration: _getChallengeCardBoxDecoration(),
      child: GestureDetector(
        onTap: () => onTap(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: CustomColors.purpleButtonColor,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Styles.getSizedHeightBox(15),
                  _getCardRowForText('Topic: ', type, Icons.category),
                  Styles.getSizedHeightBox(5),
                  _getCardRowForText('Sub-Topic: ', topic, Icons.topic),
                  Styles.getSizedHeightBox(5),
                  _getCardRowForText('Difficulty Level: ', difficulty_level, Icons.assessment),
                  Styles.getSizedHeightBox(10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  static _getCardRowForText(String title, String value, IconData icon) {
    Text textValue = Styles.getTitleDescriptionWidgetWithSoftWrap(
      title,
      value,
      Colors.black,
      Colors.black,
      15,
      14,
    );
    return Row(
      children: [
        Icon(icon, size: 16.0, color: Colors.grey[700]),
        SizedBox(width: 15.0),
        Expanded(child: textValue,

        ),
      ],
    );
  }



  static getSubtopicsListingCards({
    required Map<String, dynamic> subtopics,
    required Function onTap,
  }) {
    final String id = subtopics['id'];
    final String description = subtopics['description'];

    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.0, horizontal: 15.0),
      padding: EdgeInsets.all(15.0),
      decoration: _getChallengeCardBoxDecoration(),
      child: GestureDetector(
        onTap: () => onTap(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          id,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: CustomColors.purpleButtonColor,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0),
                  _getCardRowForText('Description: ', description, Icons.category),
                  /*SizedBox(height: 5.0),
                  _getCardRowForText('Sub-Topic: ', topic, Icons.topic),
                  SizedBox(height: 5.0),
                  _getCardRowForText(
                      'Difficulty Level: ', difficulty_level, Icons.assessment),*/
                  SizedBox(height: 10.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
