import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:nerd_nudge/nerd_shots/services/nerd_shots_service.dart';
import 'package:nerd_nudge/subscriptions/upgrade_page.dart';
import 'package:nerd_nudge/topics/screens/topic_selection_home_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../utilities/colors.dart';
import '../../../utilities/styles.dart';
import '../../home_page/dto/user_home_stats.dart';
import '../../utilities/api_end_points.dart';
import '../../utilities/api_service.dart';
import '../../utilities/constants.dart';
import '../dto/shots_user_activity_api_entity.dart';

class NerdShotsSwiped extends StatefulWidget {
  NerdShotsSwiped({super.key});

  @override
  State<NerdShotsSwiped> createState() => _NerdShotsSwipedState();
}

class _NerdShotsSwipedState extends State<NerdShotsSwiped> {
  int _currentIndex = 0;
  int _maxIndex = -1;
  int _likeCount = 0;
  int _dislikeCount = 0;
  int _favoriteCount = 0;
  int _shareCount = 0;

  IconData _likesIcon = Icons.thumb_up_alt_outlined;
  IconData _dislikesIcon = Icons.thumb_down_alt_outlined;
  IconData _favoriteIcon = Icons.favorite_border_outlined;
  IconData _shareIcon = Icons.share_outlined;

  final GlobalKey _repaintBoundaryKey = GlobalKey();
  final List<dynamic> _currentQuizzes = [];

  late bool _shouldResetIcons = true;
  late ShotsUserActivityAPIEntity _shotsUserActivityAPIEntity;

  @override
  void initState() {
    super.initState();
    _updateCurrentQuiz();
    _shotsUserActivityAPIEntity = ShotsUserActivityAPIEntity();
    print('Inited. $_shotsUserActivityAPIEntity');
  }

  _resetIconsAndCounts(dynamic quiz) {
    _likesIcon = _getLikesIcon(quiz['id']);
    _dislikesIcon = _getDisLikesIcon(quiz['id']);
    _favoriteIcon = _getFavoritesIcon(quiz['topic_name'], quiz['sub_topic'], quiz['id']);
    _shareIcon = _getSharesIcon(quiz['id']);

    _likeCount = _getLikesCount(quiz, quiz['id']);
    _dislikeCount =_getDisLikesCount(quiz, quiz['id']);
    _favoriteCount = _getFavoritesCount(quiz, quiz['id']);
    _shareCount = _getSharesCount(quiz, quiz['id']);
  }

  _updateCurrentQuiz() async {
    var nextQuizList = await _getNextQuizzes();
    if (nextQuizList.isEmpty) {
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
        _currentQuizzes.addAll(nextQuizList);
      });
    }
  }

  Future<List<dynamic>> _getNextQuizzes() async {
    if (UserHomeStats().hasUserExhaustedNerdShots()) {
      print('User has exhausted the shots counts.');
      return [];
    } else {
      var nextQuestions = await NerdShotsService().getNextQuizflexes(
          TopicSelection.selectedTopic, TopicSelection.selectedSubtopic, 6);
      print('$nextQuestions');
      return nextQuestions['data'];
    }
  }

  void _updateLike(String id) {
    setState(() {
      if (_likesIcon == Icons.thumb_up_alt_outlined) {
        print('updating likes');
        _likesIcon = Icons.thumb_up;
        _likeCount++;
        _shotsUserActivityAPIEntity.addLike(id);
      } else {
        _likesIcon = Icons.thumb_up_alt_outlined;
        _likeCount--;
        _shotsUserActivityAPIEntity.removeLike(id);
      }
    });
  }

  void _updateDislike(String id) {
    setState(() {
      if (_dislikesIcon == Icons.thumb_down_alt_outlined) {
        _dislikesIcon = Icons.thumb_down;
        _dislikeCount++;
        _shotsUserActivityAPIEntity.addDislike(id);
      } else {
        _dislikesIcon = Icons.thumb_down_alt_outlined;
        _dislikeCount--;
        _shotsUserActivityAPIEntity.removeDislike(id);
      }
    });
  }

  void _updateFavorite(dynamic quiz) {
    setState(() {
      if (_favoriteIcon == Icons.favorite_border_outlined) {
        _favoriteIcon = Icons.favorite;
        _favoriteCount++;
        _shotsUserActivityAPIEntity.addFavorite(quiz['topic_name'], quiz['sub_topic'], quiz['id']);
      } else {
        _favoriteIcon = Icons.favorite_border_outlined;
        _favoriteCount--;
        _shotsUserActivityAPIEntity.removeFavorite(quiz['topic_name'], quiz['sub_topic'], quiz['id']);
      }
    });
  }

  void _updateShare(String id) {
    setState(() {
      if (_shareIcon == Icons.share_outlined) {
        _shareIcon = Icons.share;
      }
      _shareCount++;
      _shotsUserActivityAPIEntity.addShare(id);
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

  Widget? _getNextShot() {
    print('index: $_currentIndex');
    if (_currentIndex == _currentQuizzes.length - 1) {
      _updateCurrentQuiz();
      if (_currentQuizzes.isEmpty) {
        return null;
      }
    }

    return _getCard(_currentQuizzes[_currentIndex]);
  }

  Widget _getCard(dynamic quiz) {
    print('get card called');
    String title = quiz['sub_topic'] + ': ' + quiz['title'];
    String quizId = quiz['id'];

    if (_shouldResetIcons) {
      _resetIconsAndCounts(quiz);
      _shouldResetIcons = false;

      if(_currentIndex > _maxIndex) {
        _maxIndex = _currentIndex;
        _shotsUserActivityAPIEntity.incrementShot(quiz['topic_name'], quiz['sub_topic']);
      }
    }

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
                      onPressed: () => _updateLike(quizId),
                    ),
                    Styles.buildIconButtonWithCounter(
                      icon: _dislikesIcon,
                      color: Colors.red,
                      count: _dislikeCount,
                      onPressed: () => _updateDislike(quizId),
                    ),
                    Styles.buildIconButtonWithCounter(
                      icon: _favoriteIcon,
                      color: Colors.pink,
                      count: _favoriteCount,
                      onPressed: () => _updateFavorite(quiz),
                    ),
                    Styles.buildIconButtonWithCounter(
                      icon: _shareIcon,
                      color: Colors.blue,
                      count: _shareCount,
                      onPressed: () => _updateShare(quizId),
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

  IconData _getLikesIcon(String id) {
    if(_shotsUserActivityAPIEntity.isLikedByUser(id)) {
      return Icons.thumb_up;
    }
    
    return Icons.thumb_up_alt_outlined;
  }

  int _getLikesCount(dynamic quiz, String id) {
    if(_shotsUserActivityAPIEntity.isLikedByUser(id)) {
      return quiz['likes'] + 1;
    }

    return quiz['likes'];
  }

  IconData _getDisLikesIcon(String id) {
    if(_shotsUserActivityAPIEntity.isDisLikedByUser(id)) {
      return Icons.thumb_down;
    }

    return Icons.thumb_down_alt_outlined;
  }

  int _getDisLikesCount(dynamic quiz, String id) {
    if(_shotsUserActivityAPIEntity.isDisLikedByUser(id)) {
      return quiz['dislikes'] + 1;
    }

    return quiz['dislikes'];
  }

  IconData _getFavoritesIcon(String topic, String subtopic, String id) {
    if(_shotsUserActivityAPIEntity.isFavoriteByUser(topic, subtopic, id)) {
      return Icons.favorite;
    }

    return Icons.favorite_border_outlined;
  }

  int _getFavoritesCount(dynamic quiz, String id) {
    if(_shotsUserActivityAPIEntity.isFavoriteByUser(quiz['topic_name'], quiz['sub_topic'], id)) {
      return quiz['favorites'] + 1;
    }

    return quiz['favorites'];
  }

  IconData _getSharesIcon(String id) {
    if(_shotsUserActivityAPIEntity.isSharedByUser(id)) {
      return Icons.share;
    }

    return Icons.share_outlined;
  }

  int _getSharesCount(dynamic quiz, String id) {
    if(_shotsUserActivityAPIEntity.isSharedByUser(id)) {
      return quiz['shares'] + 1;
    }

    return quiz['shares'];
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: Styles.getAppBar('Nerd Shots Summary'),
        //drawer: MenuOptions.getMenuDrawer(context),
        body: Container(
          decoration: Styles.getBackgroundBoxDecoration(),
          child: _getBody(),
        ),
        //bottomNavigationBar: const BottomMenu(),
      ),
    );
  }

  Widget _getBody() {
    final CardSwiperController controller = CardSwiperController();
    if (_currentQuizzes.isEmpty) {
      return const Center(
        child: Text(
          'No more shots available. Please upgrade your account or come back later.',
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              child: _getNextShot(), //_getCard(_currentQuizzes[index]),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              bottom: 20.0), // Adjust the padding as needed
          child: Container(
            child: Styles.getElevatedButton(
              'CLOSE',
              CustomColors.mainThemeColor,
              Colors.white,
              context,
              _onClose,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _onClose(BuildContext context) async {
    await NerdShotsService().shotsSubmission(_shotsUserActivityAPIEntity);
    Navigator.pop(context);
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    if (direction == CardSwiperDirection.left) {
      if (_currentIndex < _currentQuizzes.length - 1) {
        setState(() {
          _currentIndex++;
          _shouldResetIcons = true;
        });
      }
    } else if (direction == CardSwiperDirection.right) {
      if (_currentIndex > 0) {
        setState(() {
          _currentIndex--;
          _shouldResetIcons = true;
        });
      }
    }
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
