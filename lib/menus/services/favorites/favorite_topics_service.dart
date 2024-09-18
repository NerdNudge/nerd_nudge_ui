import 'dart:convert';

import '../../../user_profile/dto/user_profile_entity.dart';
import '../../../utilities/api_end_points.dart';
import '../../../utilities/api_service.dart';

class FavoriteTopicsService {
  FavoriteTopicsService._privateConstructor();

  static final FavoriteTopicsService _instance = FavoriteTopicsService._privateConstructor();

  factory FavoriteTopicsService() {
    return _instance;
  }


  Future<List<Map<String, dynamic>>> getFavoritesTopics() async {
    print('getting favorite topics data now..');
    final ApiService apiService = ApiService();
    dynamic result;
    try {
      final String url = APIEndpoints.USER_INSIGHTS_BASE_URL + APIEndpoints.FAVORITE_TOPICS + "/" + UserProfileEntity().getUserEmail();
      print('Sending GET request to: $url');
      result = await apiService.getRequest(APIEndpoints.USER_INSIGHTS_BASE_URL, APIEndpoints.FAVORITE_TOPICS + "/" + UserProfileEntity().getUserEmail());
      print('API Result: $result');

      if (result is Map<String, dynamic>) {
        return List<Map<String, dynamic>>.from(result['data']);
      } else if (result is String) {
        Map<String, dynamic> decodedResult = json.decode(result);
        return List<Map<String, dynamic>>.from(decodedResult['data']);
      } else {
        throw const FormatException("Unexpected response format");
      }
    } catch (e) {
      print('Error during getRecentFavorites: $e');
      throw e;
    }
  }

  Future<List<Map<String, dynamic>>> getFavoritesSubtopics(String topic, String subtopic) async {
    print('getting favorite subtopics data now..');
    final ApiService apiService = ApiService();
    dynamic result;
    try {
      final String urlPath = APIEndpoints.FAVORITE_SUBTOPICS + "/" + topic + "/" + subtopic + "/" + UserProfileEntity().getUserEmail();
      print('Sending GET request to: ${APIEndpoints.USER_INSIGHTS_BASE_URL}/$urlPath');
      result = await apiService.getRequest(APIEndpoints.USER_INSIGHTS_BASE_URL, urlPath);
      print('API Result: $result');

      if (result is Map<String, dynamic>) {
        return List<Map<String, dynamic>>.from(result['data']);
      } else if (result is String) {
        Map<String, dynamic> decodedResult = json.decode(result);
        return List<Map<String, dynamic>>.from(decodedResult['data']);
      } else {
        throw const FormatException("Unexpected response format");
      }
    } catch (e) {
      print('Error during getRecentFavorites: $e');
      throw e;
    }
  }
}