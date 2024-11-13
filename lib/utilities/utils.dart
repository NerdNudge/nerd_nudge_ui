import 'package:intl/intl.dart';

class Utils {
  static String getDaystamp() {
    DateTime now = DateTime.now();
    int dayOfYear = int.parse(DateFormat("D").format(now)); // Get day of the year
    int year = now.year % 100; // Get the last two digits of the year

    String dayOfYearStr = dayOfYear.toString().padLeft(3, '0'); // Format day to 3 digits
    String yearStr = year.toString().padLeft(2, '0'); // Format year to 2 digits

    return dayOfYearStr + yearStr;
  }

  static String formatDateAsDaystamp(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    int year = date.year % 100;

    String dayOfYearStr = dayOfYear.toString().padLeft(3, '0');
    String yearStr = year.toString().padLeft(2, '0');

    return dayOfYearStr + yearStr;
  }
}