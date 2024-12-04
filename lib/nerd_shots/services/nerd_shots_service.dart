import 'dart:convert';

import '../../utilities/api_end_points.dart';
import '../../utilities/api_service.dart';
import '../../utilities/logger.dart';
import '../dto/shots_user_activity_api_entity.dart';

class NerdShotsService {
  NerdShotsService._privateConstructor();
  static final NerdShotsService _instance =
  NerdShotsService._privateConstructor();

  factory NerdShotsService() {
    return _instance;
  }

  Future<dynamic> getNextShots(String topic, String subtopic, int limit) async {
    final ApiService apiService = ApiService();
    dynamic result;
    try {
      NerdLogger.logger.d("${APIEndpoints.CONTENT_MANAGER_BASE_URL}${APIEndpoints.NERDSHOTS}?topic=$topic&subtopic=$subtopic&limit=$limit");
      result = await apiService.getRequest(APIEndpoints.CONTENT_MANAGER_BASE_URL, "${APIEndpoints.NERDSHOTS}?topic=$topic&subtopic=$subtopic&limit=$limit");
      NerdLogger.logger.d('API Result: $result');

      if (result is Map<String, dynamic>) {
        return result;
      } else if (result is String) {
        return json.decode(result);
      } else {
        throw const FormatException("Unexpected response format");
      }
    } catch (e) {
      NerdLogger.logger.e(e);
      return '{}';
    }
  }


  Future<dynamic> shotsSubmission(ShotsUserActivityAPIEntity entity) async {
    final ApiService apiService = ApiService();
    dynamic result;
    try {
      const String url = APIEndpoints.USER_ACTIVITY_BASE_URL + APIEndpoints.SHOTS_SUBMISSION;
      final Map<String, dynamic> jsonBody = entity.toJson();

      NerdLogger.logger.d('Sending PUT request to: $url');
      NerdLogger.logger.d('Request Body: ${json.encode(jsonBody)}');

      result = await apiService.putRequest(url, jsonBody);
      NerdLogger.logger.d('API Result: $result');

      if (result is Map<String, dynamic>) {
        return result;
      } else if (result is String) {
        return json.decode(result);
      } else {
        throw const FormatException("Unexpected response format");
      }
    } catch (e) {
      NerdLogger.logger.e('Error during shotsSubmission: $e');
      return '{}';
    }
  }
}