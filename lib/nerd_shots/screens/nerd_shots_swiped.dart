import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:nerd_nudge/subscriptions/upgrade_page.dart';
import 'package:nerd_nudge/topics/screens/topic_selection_home_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../utilities/colors.dart';
import '../../../utilities/quiz_topics.dart';
import '../../../utilities/styles.dart';
import '../../bottom_menus/screens/bottom_menu_options.dart';
import '../../menus/screens/menu_options.dart';
import '../../user_profile/screens/user_stats.dart';
import '../../utilities/constants.dart';

class NerdShotsSwiped extends StatefulWidget {
  NerdShotsSwiped({super.key});

  @override
  State<NerdShotsSwiped> createState() => _NerdShotsSwipedState();
}

class _NerdShotsSwipedState extends State<NerdShotsSwiped> {
  int _likeCount = 0;
  int _dislikeCount = 0;
  int _favoriteCount = 0;
  int _shareCount = 0;

  IconData _likesIcon = Icons.thumb_up_alt_outlined;
  IconData _dislikesIcon = Icons.thumb_down_alt_outlined;
  IconData _favoriteIcon = Icons.favorite_border_outlined;
  IconData _shareIcon = Icons.share_outlined;

  final GlobalKey _repaintBoundaryKey = GlobalKey();
  List<dynamic> _currentQuizzes = [];

  @override
  void initState() {
    super.initState();
    _updateCurrentQuiz();
  }

  _updateCurrentQuiz() {
    var nextQuiz = _getNextQuizzes();
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
        _currentQuizzes = nextQuiz;
        // Uncomment this once the jsons are updated to have likes, dislikes, etc counts.
        /*_likeCount = _currentQuiz['likes'];
        _dislikeCount = _currentQuiz['dislikes'];
        _favoriteCount = _currentQuiz['favorites'];
        _shareCount = _currentQuiz['shares'];*/
      });
    }
  }

  _getNextQuizzes() {
    if (UserStats().hasUserExhaustedNerdShots()) {
      print('User has exhausted the shots counts.');
      return null;
    } else {
      String topic = TopicSelection.selectedTopic;
      String subtopic = TopicSelection.selectedSubtopic;
      print('topic: $topic, subtopic: $subtopic');
      UserStats().incrementShotsCount();
      var quizType = Topics.getQuizType(topic);
      var nextQuestions = quizType.getNextQuestionsList(5);
      print('$nextQuestions');
      return nextQuestions;
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
      RenderRepaintBoundary boundary = _repaintBoundaryKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
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

  _getDivider() {
    return const Expanded(
        child: Divider(
          thickness: 0.5,
          color: Colors.grey,
        ));
  }

  Widget _getCard(dynamic quiz) {
    String title = TopicSelection.selectedSubtopic + ': ' + quiz['title'];
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Card(
            color: CustomColors.mainThemeColor,
            margin:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
            child: ListTile(
              title: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.white, Colors.white70],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            margin:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Styles.getTitleDescriptionWidget(
                  'Description: ',
                  quiz['description_and_explanation'],
                  Colors.black,
                  Colors.black,
                  18,
                  17,
                ),
                const SizedBox(height: 30.0),
                Styles.getTitleDescriptionWidget(
                  'Pro Tip: ',
                  quiz['pro_tip'],
                  Colors.black,
                  Colors.black,
                  18,
                  17,
                ),
                const SizedBox(height: 30.0),
                Styles.getTitleDescriptionWidget(
                  'Fun Fact: ',
                  quiz['fun_fact'],
                  Colors.black,
                  Colors.black,
                  18,
                  17,
                ),
                const SizedBox(height: 10.0),
                Styles.getDivider(),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Styles.buildIconButtonWithCounter(
                      icon: _likesIcon,
                      color: Colors.green,
                      count: _likeCount,
                      onPressed: _updateLike,
                    ),
                    Styles.buildIconButtonWithCounter(
                      icon: _dislikesIcon,
                      color: Colors.red,
                      count: _dislikeCount,
                      onPressed: _updateDislike,
                    ),
                    Styles.buildIconButtonWithCounter(
                      icon: _favoriteIcon,
                      color: Colors.pink,
                      count: _favoriteCount,
                      onPressed: _updateFavorite,
                    ),
                    Styles.buildIconButtonWithCounter(
                      icon: _shareIcon,
                      color: Colors.blue,
                      count: _shareCount,
                      onPressed: _updateShare,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: Styles.getAppBar('Nerd Shots Summary'),
        drawer: MenuOptions.getMenuDrawer(context),
        body: Container(
          decoration: Styles.getBackgroundBoxDecoration(),
          child: _getBody(),
        ),
        bottomNavigationBar: const BottomMenu(),
      ),
    );
  }

  Widget _getBody() {
    final CardSwiperController controller = CardSwiperController();
    return Column(
      children: [
        Styles.getSizedHeightBox(12),
        Expanded(
          child: CardSwiper(
            controller: controller,
            cardsCount: _currentQuizzes.length,
            onSwipe: _onSwipe,
            onUndo: _onUndo,
            numberOfCardsDisplayed: 1,
            padding: const EdgeInsets.all(1.0),
            cardBuilder: (
                context,
                index,
                horizontalThresholdPercentage,
                verticalThresholdPercentage,
                ) =>
                SingleChildScrollView(
                  child: _getCard(_currentQuizzes[index]),
                ),
          ),
        ),
      ],
    );
  }

  bool _onSwipe(
      int previousIndex,
      int? currentIndex,
      CardSwiperDirection direction,
      ) {
    return true;
  }

  bool _onUndo(
      int? previousIndex,
      int currentIndex,
      CardSwiperDirection direction,
      ) {
    return true;
  }
}