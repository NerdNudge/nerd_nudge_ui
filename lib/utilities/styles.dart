import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nerd_nudge/utilities/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../bottom_menus/screens/bottom_menu_options.dart';
import 'api_end_points.dart';
import 'api_service.dart';
import 'colors.dart';
import 'dart:ui' as ui;

class Styles {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static ButtonStyle getButtonStyle() {
    return TextButton.styleFrom(
      backgroundColor: CustomColors.mainThemeColor, // Button color
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation:
          2.0, // Adding elevation to TextButton requires wrapping with Material
      textStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
      ),
    );
  }

  static ThemeData getThemeData() {
    return ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: CustomColors.mainThemeColor,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }

  static AppBar getAppBar(String titleMessage) {
    return AppBar(
      title: Text(titleMessage),
      //leading: Styles.getIconButton(),
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
    );
  }

  static IconButton getIconButton() {
    return IconButton(
      icon: Icon(
        Icons.menu,
      ),
      onPressed: () {
        //TODO: Add the menu page data here.
      },
    );
  }

  static ElevatedButton getElevatedButton(
      String text,
      Color buttonColor,
      Color textColor,
      BuildContext context,
      Function(BuildContext) onButtonTap) {
    return ElevatedButton(
      onPressed: () => onButtonTap(context),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
        ),
      ),
      style: TextButton.styleFrom(
        backgroundColor: buttonColor,
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 2.0,
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
      ),
    );
  }

  static TextFormField getTextFormField(
      controller, String hintText, String labelText, bool obscureText) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white54, fontSize: 12),
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      style: TextStyle(color: Colors.white),
    );
  }

  static Text getTitleDescriptionWidgetWithSoftWrap(
      String title,
      String description,
      Color titleColor,
      Color descriptionColor,
      double titleFontSize,
      double descriptionFontSize) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: title,
            style: TextStyle(
              fontSize: titleFontSize,
              color: titleColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: description,
            style: TextStyle(
              fontSize: descriptionFontSize,
              color: descriptionColor,
            ),
          ),
        ],
      ),
      softWrap: true,
      overflow: TextOverflow.ellipsis,
    );
  }

  static Text getTitleDescriptionWidget(
      String title,
      String description,
      Color titleColor,
      Color descriptionColor,
      double titleFontSize,
      double descriptionFontSize) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: title,
            style: TextStyle(
              fontSize: titleFontSize,
              color: titleColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: description,
            style: TextStyle(
              fontSize: descriptionFontSize,
              color: descriptionColor,
            ),
          ),
        ],
      ),
      softWrap: true,
      //overflow: TextOverflow.ellipsis,
    );
  }

  static Widget getSlider(double value, Color color) {
    return Slider(
      activeColor: color,
      value: value,
      min: 0,
      max: 100,
      onChanged: (double newValue) {
        /*setState(() {
          // Update the value
        });*/
      },
    );
  }

  static getSliderColorForPercentageCorrect(double percentage) {
    if (percentage >= 90) return Colors.green;

    if (percentage >= 75) return Colors.orange;

    return Colors.red;
  }

  static Widget getDivider() {
    return const Divider(
      color: Colors.grey,
      thickness: 1,
      indent: 25,
      endIndent: 25,
    );
  }

  static Widget buildIconButtonWithCounter({
    required IconData icon,
    required Color color,
    required int count,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.white54, Colors.white70],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            SizedBox(width: 4),
            Text('$count'),
          ],
        ),
      ),
    );
  }

  static void showAlert(
      BuildContext context, String titleText, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titleText),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Widget buildNextActionButton(
      BuildContext context, String textMessage, int index, Widget screen) {
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () {
          BottomMenu.updateIndex(index);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => screen,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: CustomColors.purpleButtonColor,
          backgroundColor: Colors.white, // Text color
          minimumSize: const Size(300, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          textMessage,
          style: TextStyle(
            color: CustomColors.purpleButtonColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  static Widget buildQuoteCard(BuildContext context, String quoteOfTheDay,
      String author, String quoteId) {
    final GlobalKey repaintBoundaryKey = GlobalKey();

    return Column(
      children: [
        RepaintBoundary(
          key: repaintBoundaryKey, // Assign the key to the RepaintBoundary
          child: Card(
            color: CustomColors.purpleButtonColor,
            margin:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          quoteOfTheDay,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          print('Marked as favorite');
                          showGlobalSnackbarMessage(
                              'Quote Marked As Favorite.');
                          favoriteQuoteSubmission(quoteId, true);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '~ $author',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            Styles.shareCardContent(repaintBoundaryKey);
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: CustomColors.purpleButtonColor,
            backgroundColor: Colors.white, // Text color
            minimumSize: const Size(300, 10),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            'SHARE',
            style: TextStyle(
              color: CustomColors.purpleButtonColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  static Map<String, dynamic> favoriteQuoteToJson(
      String userId, int timestamp, String quoteId, bool add) {
    String type = add ? 'add' : 'delete';
    return {
      'userId': userId,
      'quoteId': quoteId,
    };
  }

  static Future<dynamic> favoriteQuoteSubmission(
      String quoteId, bool add) async {
    final ApiService apiService = ApiService();
    dynamic result;
    try {
      final String url = APIEndpoints.USER_ACTIVITY_BASE_URL +
          APIEndpoints.FAVORITES_QUOTE_SUBMISSION;

      final Map<String, dynamic> jsonBody =
          favoriteQuoteToJson('abc@gmail.com', 0, quoteId, add);

      print('Sending PUT request to: $url, value: $jsonBody');
      result = await apiService.putRequest(url, jsonBody);
      print('API Result: $result');

      if (result is Map<String, dynamic>) {
        return result;
      } else if (result is String) {
        return json.decode(result);
      } else {
        throw const FormatException("Unexpected response format");
      }
    } catch (e) {
      print('Error during shotsSubmission: $e');
      return '{}';
    }
  }

  static getBackgroundBoxDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.black, Color(0xFF6A69EB), Colors.black],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  static Widget getColoredDivider(Color dividerColor) {
    return Divider(
      color: dividerColor,
      thickness: 1,
      indent: 25,
      endIndent: 25,
    );
  }

  static Widget getSizedHeightBox(double height) {
    return SizedBox(
      height: height,
    );
  }

  static Widget getSizedWidthBox(double width) {
    return SizedBox(
      width: width,
    );
  }

  static void showGlobalSnackbarMessage(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        backgroundColor: CustomColors.purpleButtonColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: Duration(seconds: 3),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }

  static void showGlobalSnackbarMessageAndIcon(String message, IconData icon) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.black),
            SizedBox(width: 8.0),
            Text(
              message,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        backgroundColor: CustomColors.purpleButtonColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: Duration(seconds: 3),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }

  static Future<void> shareCardContent(GlobalKey key) async {
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future.delayed(Duration(milliseconds: 100));

        RenderRepaintBoundary? boundary =
            key.currentContext!.findRenderObject() as RenderRepaintBoundary?;

        if (boundary == null) {
          print('Error: RenderRepaintBoundary is null');
          return;
        }

        ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);

        if (byteData == null) {
          print('Error: byteData is null');
          return;
        }

        Uint8List pngBytes = byteData.buffer.asUint8List();

        final directory = await getApplicationDocumentsDirectory();
        final imagePath = File('${directory.path}/screenshot.png');
        await imagePath.writeAsBytes(pngBytes);

        const String shareMessage = Constants.shareQuoteMessage;
        Share.shareFiles([imagePath.path], text: '\n\n$shareMessage');
      });
    } catch (e) {
      print('Error capturing screenshot: $e');
    }
  }
}
