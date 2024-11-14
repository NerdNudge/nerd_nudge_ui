import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:nerd_nudge/quiz/quiz_answers/dto/quizflex_user_activity_api_entity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/rendering.dart';
import 'dart:io';

import '../../../menus/screens/menu_options.dart';
import '../../../topics/screens/topic_selection_home_page.dart';
import '../../../utilities/colors.dart';
import '../../../utilities/constants.dart';
import '../../../utilities/styles.dart';
import '../../quiz_question/screens/question_header.dart';

class ReadMorePage extends StatefulWidget {
  const ReadMorePage({super.key, required this.completeQuiz});

  final completeQuiz;
  static QuizflexUserActivityAPIEntity quizflexUserActivityAPIEntity = QuizflexUserActivityAPIEntity();

  static void initializeUserActivityEntity() {
    quizflexUserActivityAPIEntity = QuizflexUserActivityAPIEntity();
  }

  static void resetUserActivityEntity() {
    quizflexUserActivityAPIEntity.clearData();
    initializeUserActivityEntity();
  }

  static bool isQuizflexEmpty() {
    return quizflexUserActivityAPIEntity.isQuizflexEmpty();
  }

  @override
  State<ReadMorePage> createState() => _ReadMorePageState();
}

class _ReadMorePageState extends State<ReadMorePage> {
  late int _likeCount;
  late int _dislikeCount;
  late int _favoriteCount;
  late int _shareCount;

  IconData _likesIcon = Icons.thumb_up_alt_outlined;
  IconData _dislikesIcon = Icons.thumb_down_alt_outlined;
  IconData _favoriteIcon = Icons.favorite_border_outlined;
  IconData _shareIcon = Icons.share_outlined;

  final GlobalKey _repaintBoundaryKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    ReadMorePage.initializeUserActivityEntity();
  }

  _resetIconsAndCounts(dynamic quiz) {
    setState(() {
      _likesIcon = _getLikesIcon(quiz['id']);
      _dislikesIcon = _getDisLikesIcon(quiz['id']);
      _favoriteIcon = _getFavoritesIcon(quiz['topic_name'], quiz['sub_topic'], quiz['id']);
      _shareIcon = _getSharesIcon(quiz['id']);

      _likeCount = _getLikesCount(quiz, quiz['id']);
      _dislikeCount =_getDisLikesCount(quiz, quiz['id']);
      _favoriteCount = _getFavoritesCount(quiz, quiz['id']);
      _shareCount = _getSharesCount(quiz, quiz['id']);
    });
  }

  void _updateLike(String id) {
    setState(() {
      if (_likesIcon == Icons.thumb_up_alt_outlined) {
        _likesIcon = Icons.thumb_up;
        _likeCount++;
        ReadMorePage.quizflexUserActivityAPIEntity.addLike(id);
      } else {
        _likesIcon = Icons.thumb_up_alt_outlined;
        _likeCount--;
        ReadMorePage.quizflexUserActivityAPIEntity.removeLike(id);
      }
    });
  }

  void _updateDislike(String id) {
    setState(() {
      if (_dislikesIcon == Icons.thumb_down_alt_outlined) {
        _dislikesIcon = Icons.thumb_down;
        _dislikeCount++;
        ReadMorePage.quizflexUserActivityAPIEntity.addDislike(id);
      } else {
        _dislikesIcon = Icons.thumb_down_alt_outlined;
        _dislikeCount--;
        ReadMorePage.quizflexUserActivityAPIEntity.removeDislike(id);
      }
    });
  }

  void _updateFavorite(dynamic quiz) {
    setState(() {
      if (_favoriteIcon == Icons.favorite_border_outlined) {
        _favoriteIcon = Icons.favorite;
        _favoriteCount++;
        ReadMorePage.quizflexUserActivityAPIEntity.addFavorite(
            quiz['topic_name'], quiz['sub_topic'], quiz['id']);
      } else {
        _favoriteIcon = Icons.favorite_border_outlined;
        _favoriteCount--;
        ReadMorePage.quizflexUserActivityAPIEntity.removeFavorite(
            quiz['topic_name'], quiz['sub_topic'], quiz['id']);
      }
    });
  }

  IconData _getLikesIcon(String id) {
    if(ReadMorePage.quizflexUserActivityAPIEntity.isLikedByUser(id)) {
      return Icons.thumb_up;
    }

    return Icons.thumb_up_alt_outlined;
  }

  int _getLikesCount(dynamic quiz, String id) {
    if(ReadMorePage.quizflexUserActivityAPIEntity.isLikedByUser(id)) {
      return quiz['likes'] + 1;
    }

    return quiz['likes'];
  }

  IconData _getDisLikesIcon(String id) {
    if(ReadMorePage.quizflexUserActivityAPIEntity.isDisLikedByUser(id)) {
      return Icons.thumb_down;
    }

    return Icons.thumb_down_alt_outlined;
  }

  int _getDisLikesCount(dynamic quiz, String id) {
    if(ReadMorePage.quizflexUserActivityAPIEntity.isDisLikedByUser(id)) {
      return quiz['dislikes'] + 1;
    }

    return quiz['dislikes'];
  }

  IconData _getFavoritesIcon(String topic, String subtopic, String id) {
    if(ReadMorePage.quizflexUserActivityAPIEntity.isFavoriteByUser(topic, subtopic, id)) {
      return Icons.favorite;
    }

    return Icons.favorite_border_outlined;
  }

  int _getFavoritesCount(dynamic quiz, String id) {
    if(ReadMorePage.quizflexUserActivityAPIEntity.isFavoriteByUser(quiz['topic_name'], quiz['sub_topic'], id)) {
      return quiz['favorites'] + 1;
    }

    return quiz['favorites'];
  }

  IconData _getSharesIcon(String id) {
    if(ReadMorePage.quizflexUserActivityAPIEntity.isSharedByUser(id)) {
      return Icons.share;
    }

    return Icons.share_outlined;
  }

  int _getSharesCount(dynamic quiz, String id) {
    if(ReadMorePage.quizflexUserActivityAPIEntity.isSharedByUser(id)) {
      return quiz['shares'] + 1;
    }

    return quiz['shares'];
  }

  Future<void> _captureAndShareScreenshot(String id) async {
    try {
      ReadMorePage.quizflexUserActivityAPIEntity.addShare(id);
      RenderRepaintBoundary boundary = _repaintBoundaryKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = await getApplicationDocumentsDirectory();
      final imagePath = File('${directory.path}/screenshot.png');
      await imagePath.writeAsBytes(pngBytes);

      final String shareMessage = Constants.shareQuoteMessage;
      Share.shareFiles([imagePath.path], text: '\n\n$shareMessage');
    } catch (e) {
      print('Error capturing screenshot: $e');
      Styles.showGlobalSnackbarMessage('Failed to capture screenshot. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Styles.getAppBar('Nerd Shots Summary'),
      drawer: MenuOptions.getMenuDrawer(context),
      body: _getBody(),
    );
  }

  Widget _getBody() {
    String title = widget.completeQuiz['title'];
    String description = widget.completeQuiz['description_and_explanation'];
    String pro_tip = widget.completeQuiz['pro_tip'];
    String fun_fact = widget.completeQuiz['fun_fact'];
    String quizId = widget.completeQuiz['id'];

    _resetIconsAndCounts(widget.completeQuiz);

    return RepaintBoundary(
      key: _repaintBoundaryKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: QuestionHeader(
                topic: TopicSelection.selectedTopic,
                subtopic: widget.completeQuiz['sub_topic'],
                difficultyLevel: widget.completeQuiz['difficulty_level'],
              ),
            ),
            Container(
              height: 4, // Height of the horizontal bar
              width: double.infinity, // Width of the horizontal bar
              color: const Color(0xFF252d3c),
            ),
            Styles.getSizedHeightBoxByScreen(context, 20),
            Card(
              color: CustomColors.mainThemeColor,
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: ListTile(
                title: Center(
                  child: Text(title,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center),
                ),
              ),
            ),
            Card(
              child: Container(
                margin: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 25.0),
                child: Column(
                  children: <Widget>[
                    Styles.getTitleDescriptionWidget('Description: ',
                        description, Colors.black, Colors.black, 18, 17),
                    Styles.getSizedHeightBoxByScreen(context, 30),
                    Styles.getTitleDescriptionWidget('Pro Tip: ', pro_tip,
                        Colors.black, Colors.black, 18, 17),
                    Styles.getSizedHeightBoxByScreen(context, 30),
                    Styles.getTitleDescriptionWidget('Fun Fact: ', fun_fact,
                        Colors.black, Colors.black, 18, 17),
                    Styles.getSizedHeightBoxByScreen(context, 20),
                    Styles.getDivider(),
                    Styles.getSizedHeightBoxByScreen(context, 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Styles.buildIconButtonWithCounter(
                          icon: _likesIcon,
                          color: Colors.green,
                          count: _likeCount,
                          onPressed: () => _updateLike(quizId),
                        ),
                        Styles.getSizedWidthBoxByScreen(context, 10),
                        Styles.buildIconButtonWithCounter(
                          icon: _dislikesIcon,
                          color: Colors.red,
                          count: _dislikeCount,
                          onPressed: () => _updateDislike(quizId),
                        ),
                        Styles.getSizedWidthBoxByScreen(context, 10),
                        Styles.buildIconButtonWithCounter(
                          icon: _favoriteIcon,
                          color: Colors.pink,
                          count: _favoriteCount,
                          onPressed: () => _updateFavorite(widget.completeQuiz),
                        ),
                        Styles.getSizedWidthBoxByScreen(context, 10),
                        Styles.buildIconButtonWithCounter(
                          icon: _shareIcon,
                          color: Colors.blue,
                          count: _shareCount,
                          onPressed: () => _captureAndShareScreenshot(quizId),
                        ),
                      ],
                    ),
                    Styles.getSizedHeightBoxByScreen(context, 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Styles.getElevatedButton(
                              'CLOSE',
                              CustomColors.mainThemeColor,
                              Colors.white,
                              context,
                              (ctx) => Navigator.pop(ctx)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
