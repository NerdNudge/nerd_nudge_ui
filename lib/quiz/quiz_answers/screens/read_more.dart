import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
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

    // Uncomment this once the jsons are updated to have likes, dislikes, etc counts.
    /*_likeCount = widget.completeQuiz['likes'];
    _dislikeCount = widget.completeQuiz['dislikes'];
    _favoriteCount = widget.completeQuiz['favorites'];
    _shareCount = widget.completeQuiz['shares'];*/

    // Remove this after uncommenting the above.
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

  Future<void> _captureAndShareScreenshot() async {
    try {
      RenderRepaintBoundary boundary = _repaintBoundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = await getApplicationDocumentsDirectory();
      final imagePath = File('${directory.path}/screenshot.png');
      await imagePath.writeAsBytes(pngBytes);

      final String shareMessage = Constants.shareQuoteMessage;
      Share.shareFiles([imagePath.path], text: '\n\n$shareMessage');
    } catch (e) {
      print('Error capturing screenshot: $e');
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

    return RepaintBoundary(
      key: _repaintBoundaryKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: QuestionHeader(
                topic: TopicSelection.selectedTopic,
                subtopic: TopicSelection.selectedSubtopic,
                difficultyLevel: widget.completeQuiz['difficulty_level'],
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
              margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
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
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
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
                          onPressed: _captureAndShareScreenshot,
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