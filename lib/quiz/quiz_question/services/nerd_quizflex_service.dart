import 'dart:convert';

import '../../../utilities/api_end_points.dart';
import '../../../utilities/api_service.dart';
import '../../../utilities/logger.dart';

class NerdQuizflexService {
  NerdQuizflexService._privateConstructor();
  static final NerdQuizflexService _instance =
      NerdQuizflexService._privateConstructor();

  factory NerdQuizflexService() {
    return _instance;
  }

  Future<dynamic> getNextQuizflexes(
      String topic, String subtopic, int limit) async {
    NerdLogger.logger.d('getting Quizflex data now..');
    final ApiService apiService = ApiService();
    dynamic result;
    try {
      result = await apiService.getRequest(
          APIEndpoints.CONTENT_MANAGER_BASE_URL,
          "${APIEndpoints.QUIZFLEXES}?topic=$topic&subtopic=$subtopic&limit=$limit");
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

  Future<dynamic> getRealWorldChallenges(
      String topic, String subtopic, int limit) async {
    final ApiService apiService = ApiService();
    dynamic result;
    try {
      result = await apiService.getRequest(
          APIEndpoints.CONTENT_MANAGER_BASE_URL,
          "${APIEndpoints.REAL_WORLD_CHALLENGES}?topic=$topic&subtopic=$subtopic&limit=$limit");
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
}
