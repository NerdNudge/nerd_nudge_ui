import 'dart:convert';

import 'package:nerd_nudge/utilities/api_end_points.dart';
import 'package:nerd_nudge/utilities/constants.dart';

import '../../utilities/api_service.dart';

class HomePageService {
  final _quoteOfTheDay = json.decode(
      '{"quote":"Technology is best when it brings people together.","author":"Matt Mullenweg (WordPress co-founder)"}');

  HomePageService._privateConstructor();
  static final HomePageService _instance =
      HomePageService._privateConstructor();

  factory HomePageService() {
    return _instance;
  }

  getQuoteOfTheDay() {
    return _quoteOfTheDay;
  }

  getUserHomePageStats() async {
    print('getting user home data now..');
    final ApiService apiService = ApiService();
    String data = '';
    Map<String, dynamic> result = {};
    try {
      print(APIEndpoints.BASE_URL + APIEndpoints.USER_HOME_STATS);
      result = await apiService.getRequest(APIEndpoints.USER_HOME_STATS);
      data = result.toString();
    } catch (e) {
      print(e);
    }
    print('Data: $data');
  }
}
