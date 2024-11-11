import 'dart:convert';

import '../../../utilities/api_end_points.dart';
import '../../../utilities/api_service.dart';

class RealworldChallengeService {
  RealworldChallengeService._privateConstructor();
  static final RealworldChallengeService _instance =
      RealworldChallengeService._privateConstructor();

  factory RealworldChallengeService() {
    return _instance;
  }

  Future<dynamic> getNextQuizflexes(
      String topic, String subtopic, int limit) async {
    print('getting Quizflex data now..');
    final ApiService apiService = ApiService();
    dynamic result;
    try {
      print(APIEndpoints.CONTENT_MANAGER_BASE_URL +
          APIEndpoints.QUIZFLEXES +
          "?topic=" +
          topic +
          "&subtopic=" +
          subtopic +
          "&limit=" +
          limit.toString());
      result = await apiService.getRequest(
          APIEndpoints.CONTENT_MANAGER_BASE_URL,
          APIEndpoints.QUIZFLEXES +
              "?topic=" +
              topic +
              "&subtopic=" +
              subtopic +
              "&limit=" +
              limit.toString());
      print('API Result: $result');

      if (result is Map<String, dynamic>) {
        return result;
      } else if (result is String) {
        return json.decode(result);
      } else {
        throw const FormatException("Unexpected response format");
      }
    } catch (e) {
      print(e);
      return '{}';
    }
  }
}
