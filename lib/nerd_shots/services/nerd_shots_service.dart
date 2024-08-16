import 'dart:convert';

import '../../utilities/api_end_points.dart';
import '../../utilities/api_service.dart';
import '../dto/shots_user_activity_api_entity.dart';

class NerdShotsService {
  NerdShotsService._privateConstructor();
  static final NerdShotsService _instance =
  NerdShotsService._privateConstructor();

  factory NerdShotsService() {
    return _instance;
  }

  Future<dynamic> getNextQuizflexes(String topic, String subtopic, int limit) async {
    print('getting user home data now..');
    final ApiService apiService = ApiService();
    dynamic result;
    try {
      print(APIEndpoints.CONTENT_MANAGER_BASE_URL + APIEndpoints.QUIZFLEXES + "?topic=" + topic + "&subtopic=" + subtopic + "&limit=" + limit.toString());
      result = await apiService.getRequest(APIEndpoints.CONTENT_MANAGER_BASE_URL, APIEndpoints.QUIZFLEXES + "?topic=" + topic + "&subtopic=" + subtopic + "&limit=" + limit.toString());
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


  Future<dynamic> shotsSubmission(ShotsUserActivityAPIEntity entity) async {
    final ApiService apiService = ApiService();
    dynamic result;
    try {
      final String url = APIEndpoints.USER_ACTIVITY_BASE_URL +
          APIEndpoints.SHOTS_SUBMISSION;

      final Map<String, dynamic> jsonBody = entity.toJson();

      print('Sending PUT request to: $url');
      print('Request Body: ${json.encode(jsonBody)}');

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
}