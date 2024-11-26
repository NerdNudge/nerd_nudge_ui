import 'dart:convert';

import '../../../user_profile/dto/user_profile_entity.dart';
import '../../../utilities/api_end_points.dart';
import '../../../utilities/api_service.dart';
import '../../../utilities/logger.dart';

class FavoriteTopicsService {
  FavoriteTopicsService._privateConstructor();

  static final FavoriteTopicsService _instance = FavoriteTopicsService._privateConstructor();

  factory FavoriteTopicsService() {
    return _instance;
  }


  Future<List<Map<String, dynamic>>> getFavoritesTopics() async {
    final ApiService apiService = ApiService();
    dynamic result;
    try {
      final String url = "${APIEndpoints.USER_INSIGHTS_BASE_URL}${APIEndpoints.FAVORITE_TOPICS}/" + UserProfileEntity().getUserEmail();
      NerdLogger.logger.d('Sending GET request to: $url');
      result = await apiService.getRequest(APIEndpoints.USER_INSIGHTS_BASE_URL, "${APIEndpoints.FAVORITE_TOPICS}/" + UserProfileEntity().getUserEmail());
      NerdLogger.logger.d('API Result: $result');

      if (result is Map<String, dynamic>) {
        return List<Map<String, dynamic>>.from(result['data']);
      } else if (result is String) {
        Map<String, dynamic> decodedResult = json.decode(result);
        return List<Map<String, dynamic>>.from(decodedResult['data']);
      } else {
        throw const FormatException("Unexpected response format");
      }
    } catch (e) {
      NerdLogger.logger.e('Error during getRecentFavorites: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getFavoritesSubtopics(String topic, String subtopic) async {
    final ApiService apiService = ApiService();
    dynamic result;
    try {
      final String urlPath = "${APIEndpoints.FAVORITE_SUBTOPICS}/$topic/$subtopic/" + UserProfileEntity().getUserEmail();
      NerdLogger.logger.d('Sending GET request to: ${APIEndpoints.USER_INSIGHTS_BASE_URL}/$urlPath');
      result = await apiService.getRequest(APIEndpoints.USER_INSIGHTS_BASE_URL, urlPath);
      NerdLogger.logger.d('API Result: $result');

      if (result is Map<String, dynamic>) {
        return List<Map<String, dynamic>>.from(result['data']);
      } else if (result is String) {
        Map<String, dynamic> decodedResult = json.decode(result);
        return List<Map<String, dynamic>>.from(decodedResult['data']);
      } else {
        throw const FormatException("Unexpected response format");
      }
    } catch (e) {
      NerdLogger.logger.e('Error during getRecentFavorites: $e');
      rethrow;
    }
  }
}