import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:nerd_nudge/menus/dto/favorite_entity.dart';
import 'package:nerd_nudge/menus/services/favorites/favorites_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../utilities/colors.dart';
import '../../../../utilities/constants.dart';
import '../../../../utilities/logger.dart';
import '../../../../utilities/styles.dart';
import '../../menu_options.dart';

class FavoritesDetailsSwiped extends StatefulWidget {
  FavoritesDetailsSwiped(
      {super.key, required this.favorites, required this.index});

  final List<Map<String, dynamic>> favorites;
  late int index;

  @override
  State<FavoritesDetailsSwiped> createState() => _FavoritesDetailsSwipedState();
}

class _FavoritesDetailsSwipedState extends State<FavoritesDetailsSwiped> {
  int _likeCount = 0;
  int _dislikeCount = 0;
  int _favoriteCount = 0;
  int _shareCount = 0;

  IconData _likesIcon = Icons.thumb_up_alt_outlined;
  IconData _dislikesIcon = Icons.thumb_down_alt_outlined;
  IconData _favoriteIcon = Icons.favorite;
  IconData _shareIcon = Icons.share_outlined;

  final GlobalKey _repaintBoundaryKey = GlobalKey();
  late FavoriteUserActivityEntity _favoriteUserActivityEntity;

  @override
  void initState() {
    super.initState();
    _favoriteUserActivityEntity = FavoriteUserActivityEntity();
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

  IconData _getLikesIcon(String id) {
    if(_favoriteUserActivityEntity.isLikedByUser(id)) {
      return Icons.thumb_up;
    }

    return Icons.thumb_up_alt_outlined;
  }

  int _getLikesCount(dynamic quiz, String id) {
    if(_favoriteUserActivityEntity.isLikedByUser(id)) {
      return quiz['likes'] + 1;
    }

    return quiz['likes'];
  }

  IconData _getDisLikesIcon(String id) {
    if(_favoriteUserActivityEntity.isDisLikedByUser(id)) {
      return Icons.thumb_down;
    }

    return Icons.thumb_down_alt_outlined;
  }

  int _getDisLikesCount(dynamic quiz, String id) {
    if(_favoriteUserActivityEntity.isDisLikedByUser(id)) {
      return quiz['dislikes'] + 1;
    }

    return quiz['dislikes'];
  }

  IconData _getFavoritesIcon(String topic, String subtopic, String id) {
    if(_favoriteUserActivityEntity.isFavoriteRemovedByUser(topic, subtopic, id)) {
      return Icons.favorite_border_outlined;
    }

    return Icons.favorite;
  }

  int _getFavoritesCount(dynamic quiz, String id) {
    if(_favoriteUserActivityEntity.isFavoriteRemovedByUser(quiz['topic_name'], quiz['sub_topic'], quiz['id'])) {
      return quiz['favorites'] - 1;
    }

    return quiz['favorites'];
  }

  IconData _getSharesIcon(String id) {
    if(_favoriteUserActivityEntity.isSharedByUser(id)) {
      return Icons.share;
    }

    return Icons.share_outlined;
  }

  int _getSharesCount(dynamic quiz, String id) {
    if(_favoriteUserActivityEntity.isSharedByUser(id)) {
      return quiz['shares'] + 1;
    }

    return quiz['shares'];
  }

  void _updateLike(String id) {
    setState(() {
      if (_likesIcon == Icons.thumb_up_alt_outlined) {
        NerdLogger.logger.d('updating likes');
        _likesIcon = Icons.thumb_up;
        _likeCount++;
        _favoriteUserActivityEntity.addLike(id);
      } else {
        _likesIcon = Icons.thumb_up_alt_outlined;
        _likeCount--;
        _favoriteUserActivityEntity.removeLike(id);
      }
    });
  }

  void _updateDislike(String id) {
    setState(() {
      if (_dislikesIcon == Icons.thumb_down_alt_outlined) {
        _dislikesIcon = Icons.thumb_down;
        _dislikeCount++;
        _favoriteUserActivityEntity.addDislike(id);
      } else {
        _dislikesIcon = Icons.thumb_down_alt_outlined;
        _dislikeCount--;
        _favoriteUserActivityEntity.removeDislike(id);
      }
    });
  }

  void _updateFavorite(dynamic quiz) {
    setState(() {
      if (_favoriteIcon == Icons.favorite_border_outlined) {
        _favoriteIcon = Icons.favorite;
        _favoriteCount = _favoriteCount + 1;
        NerdLogger.logger.d('fav count ++: $_favoriteCount');
        _favoriteUserActivityEntity.undoDeleteFavorite(quiz['topic_name'], quiz['sub_topic'], quiz['id']);
      } else {
        _favoriteIcon = Icons.favorite_border_outlined;
        _favoriteCount = _favoriteCount - 1;
        NerdLogger.logger.d('fav count --: $_favoriteCount');
        _favoriteUserActivityEntity.addToDeleteFavorites(quiz['topic_name'], quiz['sub_topic'], quiz['id']);
      }
    });
  }

  void _updateShare(String id) {
    setState(() {
      if (_shareIcon == Icons.share_outlined) {
        _shareIcon = Icons.share;
      }
      _shareCount++;
      _favoriteUserActivityEntity.addShare(id);
    });

    Styles.shareCardContent(_repaintBoundaryKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Styles.getAppBar('Nerd Favorites'),
      drawer: MenuOptions.getMenuDrawer(context),
      body: Container(
        decoration: Styles.getBackgroundBoxDecoration(),
        child: _getBody(),
      ),
    );
  }

  Widget _getBody() {
    final CardSwiperController controller = CardSwiperController();
    if (widget.favorites.isEmpty) {
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
            cardsCount: widget.favorites.length,
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
                  child: _getCard(),
                ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              bottom: 20.0),
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

  _getCard() {
    String quizId = widget.favorites[widget.index]['id'];
    _resetIconsAndCounts(widget.favorites[widget.index]);
    return RepaintBoundary(  // Wrapping the content you want to capture
      key: _repaintBoundaryKey,  // Attach the GlobalKey
      child: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Card(
              color: CustomColors.mainThemeColor,
              margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: ListTile(
                title: Center(
                  child: Text(
                    widget.favorites[widget.index]['title'],
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
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.white, Colors.white70],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Styles.getTitleDescriptionWidget(
                    'Description: ',
                    widget.favorites[widget.index]['description_and_explanation'],
                    Colors.black,
                    Colors.black,
                    18,
                    17,
                  ),
                  const SizedBox(height: 30.0),
                  Styles.getTitleDescriptionWidget(
                    'Pro Tip: ',
                    widget.favorites[widget.index]['pro_tip'],
                    Colors.black,
                    Colors.black,
                    18,
                    17,
                  ),
                  const SizedBox(height: 30.0),
                  Styles.getTitleDescriptionWidget(
                    'Fun Fact: ',
                    widget.favorites[widget.index]['fun_fact'],
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
                        onPressed: () => _updateFavorite(widget.favorites[widget.index]),
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
      ),
    );
  }

  Future<void> _onClose(BuildContext context) async {
    await FavoritesService().favoritesActivitySubmission(_favoriteUserActivityEntity);
    Navigator.pushNamed(context, "/favorites");
    //Navigator.pop(context);
  }

  bool _onSwipe(
      int previousIndex,
      int? currentIndex,
      CardSwiperDirection direction,
      ) {

    if (direction == CardSwiperDirection.right && widget.index == 0) {
      Styles.showGlobalSnackbarMessage("Can't swipe left. You're at the first favorite.");
      return false;
    }

    if (direction == CardSwiperDirection.left && widget.index == widget.favorites.length - 1) {
      Styles.showGlobalSnackbarMessage("Can't swipe right. You're at the last favorite.");
      return false;
    }

    if (direction == CardSwiperDirection.left) {
      if (widget.index < widget.favorites.length - 1) {
        setState(() {
          widget.index++;
          //_shouldResetIcons = true;
        });
      }
    } else if (direction == CardSwiperDirection.right) {
      if (widget.index > 0) {
        setState(() {
          widget.index --;
          //_shouldResetIcons = true;
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
