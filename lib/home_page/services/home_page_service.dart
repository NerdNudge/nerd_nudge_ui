import 'dart:convert';

import 'package:nerd_nudge/home_page/dto/user_home_stats.dart';
import 'package:nerd_nudge/utilities/api_end_points.dart';

import '../../utilities/api_service.dart';

class HomePageService {
  HomePageService._privateConstructor();
  static final HomePageService _instance =
      HomePageService._privateConstructor();

  factory HomePageService() {
    return _instance;
  }

  Future<UserHomeStats> getUserHomePageStats() async {
    print('getting user home data now..');
    final ApiService apiService = ApiService();
    Map<String, dynamic> result = {};
    try {
      print(APIEndpoints.USER_INSIGHTS_BASE_URL + APIEndpoints.USER_HOME_STATS);
      result = await apiService.getRequest(APIEndpoints.USER_INSIGHTS_BASE_URL, APIEndpoints.USER_HOME_STATS);
      print('API Result: $result');
      return UserHomeStats.fromJson(result);
    } catch (e) {
      print(e);
      return UserHomeStats();
    }
  }
}
