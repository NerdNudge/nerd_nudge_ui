import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nerd_nudge/subscriptions/upgrade_page.dart';
import 'package:nerd_nudge/topics/screens/topic_selection_home_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../utilities/colors.dart';
import '../../../utilities/quiz_topics.dart';
import '../../../utilities/styles.dart';
import '../../bottom_menus/screens/bottom_menu_options.dart';
import '../../menus/screens/menu_options.dart';
import '../../quiz/quiz_question/screens/question_header.dart';
import '../../home_page/dto/user_home_stats.dart';
import '../../utilities/constants.dart';

class NerdShots extends StatefulWidget {
  NerdShots({super.key});

  @override
  State<NerdShots> createState() => _NerdShotsState();
}

class _NerdShotsState extends State<NerdShots> {
  final GlobalKey _repaintBoundaryKey = GlobalKey();
  var _currentQuiz;
  int _likeCount = 0;
  int _dislikeCount = 0;
  int _favoriteCount = 0;
  int _shareCount = 0;

  IconData _likesIcon = Icons.thumb_up_alt_outlined;
  IconData _dislikesIcon = Icons.thumb_down_alt_outlined;
  IconData _favoriteIcon = Icons.favorite_border_outlined;
  IconData _shareIcon = Icons.share_outlined;

  @override
  void initState() {
    super.initState();
    _updateCurrentQuiz();
  }

  _updateCurrentQuiz() {
    var nextQuiz = _getNextQuiz();
    if (nextQuiz == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UpgradePage(),
          ),
        );
      });
    } else {
      setState(() {
        _currentQuiz = nextQuiz;
        // Uncomment this once the jsons are updated to have likes, dislikes, etc counts.
        /*_likeCount = _currentQuiz['likes'];
        _dislikeCount = _currentQuiz['dislikes'];
        _favoriteCount = _currentQuiz['favorites'];
        _shareCount = _currentQuiz['shares'];*/
      });
    }
  }

  _getNextQuiz() {
    if (UserHomeStats().hasUserExhaustedNerdShots()) {
      print('User has exhausted the shots counts.');
      return null;
    } else {
      String topic = TopicSelection.selectedTopic;
      String subtopic = TopicSelection.selectedSubtopic;
      print('topic: $topic, subtopic: $subtopic');
      UserHomeStats().incrementShotsCount();
      var quizType = Topics.getQuizType(topic);
      var nextQuestion = quizType.getNextQuestion();
      print('$nextQuestion');
      return nextQuestion;
    }
  }

  void _updateLike() {
    setState(() {
      if (_likesIcon == Icons.thumb_up_alt_outlined) {
        _likesIcon = Icons.thumb_up;
        _likeCount++;
      } else {
        _likesIcon = Icons.thumb_up_alt_outlined;
        _likeCount--;
      }
    });
  }

  void _updateDislike() {
    setState(() {
      if (_dislikesIcon == Icons.thumb_down_alt_outlined) {
        _dislikesIcon = Icons.thumb_down;
        _dislikeCount++;
      } else {
        _dislikesIcon = Icons.thumb_down_alt_outlined;
        _dislikeCount--;
      }
    });
  }

  void _updateFavorite() {
    setState(() {
      if (_favoriteIcon == Icons.favorite_border_outlined) {
        _favoriteIcon = Icons.favorite;
        _favoriteCount++;
      } else {
        _favoriteIcon = Icons.favorite_border_outlined;
        _favoriteCount--;
      }
    });
  }

  void _updateShare() {
    setState(() {
      if (_shareIcon == Icons.share_outlined) {
        _shareIcon = Icons.share;
      }
      _shareCount++;
    });

    _shareContent();
  }

  Future<void> _shareContent() async {
    try {
      RenderRepaintBoundary boundary = _repaintBoundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = await getApplicationDocumentsDirectory();
      final imagePath = File('${directory.path}/screenshot.png');
      await imagePath.writeAsBytes(pngBytes as List<int>);

      const String shareMessage = Constants.shareQuoteMessage;
      Share.shareFiles([imagePath.path], text: '\n\n$shareMessage');
    } catch (e) {
      print('Error capturing screenshot: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: Styles.getAppBar('Nerd Shots Summary'),
        drawer: MenuOptions.getMenuDrawer(context),
        body: _getBody(),
        bottomNavigationBar: const BottomMenu(),
      ),
    );
  }

  Widget _getBody() {
    if (_currentQuiz == null) {
      return Center(
        child: Text(
          'You have exhausted your daily quota. Please upgrade to continue.',
          style: TextStyle(color: Colors.black, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      );
    }

    String title = _currentQuiz['title'];
    String description = _currentQuiz['description_and_explanation'];
    String pro_tip = _currentQuiz['pro_tip'];
    String fun_fact = _currentQuiz['fun_fact'];

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            child: QuestionHeader(
              topic: TopicSelection.selectedTopic,
              subtopic: TopicSelection.selectedSubtopic,
              difficultyLevel: _currentQuiz['difficulty_level'],
            ),
          ),
          Container(
            height: 4, // Height of the horizontal bar
            width: double.infinity, // Width of the horizontal bar
            color: const Color(0xFF252d3c),
          ),
          const SizedBox(
            height: 20.0,
          ),
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
              margin:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: Column(
                children: <Widget>[
                  Styles.getTitleDescriptionWidget('Description: ', description,
                      Colors.black, Colors.black, 18, 17),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Styles.getTitleDescriptionWidget(
                      'Pro Tip: ', pro_tip, Colors.black, Colors.black, 18, 17),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Styles.getTitleDescriptionWidget('Fun Fact: ', fun_fact,
                      Colors.black, Colors.black, 18, 17),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Styles.getDivider(),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Styles.buildIconButtonWithCounter(
                        icon: _likesIcon,
                        color: Colors.green,
                        count: _likeCount,
                        onPressed: _updateLike,
                      ),
                      const SizedBox(width: 10),
                      Styles.buildIconButtonWithCounter(
                        icon: _dislikesIcon,
                        color: Colors.red,
                        count: _dislikeCount,
                        onPressed: _updateDislike,
                      ),
                      const SizedBox(width: 10),
                      Styles.buildIconButtonWithCounter(
                        icon: _favoriteIcon,
                        color: Colors.pink,
                        count: _favoriteCount,
                        onPressed: _updateFavorite,
                      ),
                      const SizedBox(width: 10),
                      Styles.buildIconButtonWithCounter(
                        icon: _shareIcon,
                        color: Colors.blue,
                        count: _shareCount,
                        onPressed: _updateShare,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: Styles.getElevatedButton(
                      'Next',
                      CustomColors.mainThemeColor,
                      Colors.white,
                      context,
                          (ctx) => _updateCurrentQuiz(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}