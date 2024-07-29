import 'package:flutter/material.dart';
import 'package:nerd_nudge/utilities/constants.dart';
import 'package:share_plus/share_plus.dart';
import '../bottom_menus/screens/bottom_menu_options.dart';
import '../login/screens/login_or_register.dart';
import 'colors.dart';

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

  static Widget buildQuoteCard(
      BuildContext context, String quoteOfTheDay, String author) {
    return Column(
      children: [
        Card(
          color: CustomColors.purpleButtonColor,
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
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
                        Icons.favorite_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // Add functionality to mark as favorite
                        print('Marked as favorite');
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
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            String shareMessage = Constants.shareQuoteMessage;
            final String content = '$quoteOfTheDay\n~ $author\n\n$shareMessage';
            Share.share(content);
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
              //fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
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
        content: Center(child: Text(message)),
      ),
    );
  }
}
