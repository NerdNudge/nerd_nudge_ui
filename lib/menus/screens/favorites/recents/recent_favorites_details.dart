import 'package:flutter/material.dart';
import 'package:nerd_nudge/menus/screens/favorites/favorites_main_page.dart';

import '../../../../quiz/quiz_question/screens/question_header.dart';
import '../../../../utilities/colors.dart';
import '../../../../utilities/styles.dart';
import '../../menu_options.dart';

class RecentFavoritesDetails extends StatefulWidget {
  const RecentFavoritesDetails(
      {super.key, required this.recentFavorites, required this.index});

  final List<Map<String, dynamic>> recentFavorites;
  final int index;

  @override
  State<RecentFavoritesDetails> createState() => _RecentFavoritesDetailsState();
}

class _RecentFavoritesDetailsState extends State<RecentFavoritesDetails> {
  late int _likeCount;
  late int _dislikeCount;
  late int _favoriteCount;
  late int _shareCount;

  IconData _likesIcon = Icons.thumb_up_alt_outlined;
  IconData _dislikesIcon = Icons.thumb_down_alt_outlined;
  IconData _favoriteIcon = Icons.favorite_border_outlined;
  IconData _shareIcon = Icons.share_outlined;

  @override
  void initState() {
    super.initState();

    //TODO: Uncomment this once the jsons are updated to have likes, dislikes, etc counts.
    /*_likeCount = widget.completeQuiz['likes'];
    _dislikeCount = widget.completeQuiz['dislikes'];
    _favoriteCount = widget.completeQuiz['favorites'];
    _shareCount = widget.completeQuiz['shares'];*/

    //TODO: Remove this after uncommenting the above.
    _likeCount = 0;
    _dislikeCount = 0;
    _favoriteCount = 0;
    _shareCount = 0;
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Styles.getAppBar('Nerd Favorites'),
      drawer: MenuOptions.getMenuDrawer(context),
      body: _getBody(),
    );
  }

  Widget _getBody() {
    String title = widget.recentFavorites[widget.index]['title'];
    String description =
        widget.recentFavorites[widget.index]['description_and_explanation'];
    String pro_tip = widget.recentFavorites[widget.index]['pro_tip'];
    String fun_fact = widget.recentFavorites[widget.index]['fun_fact'];

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            child: QuestionHeader(
              topic: widget.recentFavorites[widget.index]['topic'],
              subtopic: widget.recentFavorites[widget.index]['sub-topic'],
              difficultyLevel: widget.recentFavorites[widget.index]
                  ['difficulty_level'],
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Styles.getElevatedButton(
                            'CLOSE',
                            CustomColors.mainThemeColor,
                            Colors.white,
                            context,
                            (ctx) => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Favorites(),
                                    ),
                                  )
                                }),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        child: Styles.getElevatedButton(
                            '<<',
                            CustomColors.mainThemeColor,
                            Colors.white,
                            context,
                            (ctx) => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RecentFavoritesDetails(
                                        recentFavorites: widget.recentFavorites,
                                        index: (widget.index + 1) %
                                            (widget.recentFavorites.length),
                                      ),
                                    ),
                                  )
                                }),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        child: Styles.getElevatedButton(
                            '>>',
                            CustomColors.mainThemeColor,
                            Colors.white,
                            context,
                            (ctx) => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RecentFavoritesDetails(
                                        recentFavorites: widget.recentFavorites,
                                        index: (widget.index - 1) %
                                            (widget.recentFavorites.length),
                                      ),
                                    ),
                                  )
                                }),
                      ),
                    ],
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
