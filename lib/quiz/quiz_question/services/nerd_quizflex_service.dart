import 'dart:convert';

import '../../../utilities/api_end_points.dart';
import '../../../utilities/api_service.dart';

class NerdQuizflexService {
  NerdQuizflexService._privateConstructor();
  static final NerdQuizflexService _instance =
  NerdQuizflexService._privateConstructor();

  factory NerdQuizflexService() {
    return _instance;
  }

  Future<dynamic> getNextQuizflexes(String topic, String subtopic, int limit) async {
    print('getting Quizflex data now..');
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


  /*Future<dynamic> quizflexSubmission(ShotsUserActivityAPIEntity entity) async {
    final ApiService apiService = ApiService();
    dynamic result;
    try {
      // Construct the full URL for the PUT request
      final String url = APIEndpoints.CONTENT_MANAGER_BASE_URL +
          APIEndpoints.SHOTS_SUBMISSION;

      String jsonBody = json.encode(entity.toJson());

      print('Sending PUT request to: $url');
      print('Request Body: $jsonBody');

      result = await apiService.putRequest(url, jsonBody as Map<String, dynamic>);
      print('API Result: $result');

      // Process the response
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
  }*/
}