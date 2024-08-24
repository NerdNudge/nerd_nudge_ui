import 'dart:convert';
import 'dart:ffi';

import '../../utilities/api_end_points.dart';
import '../../utilities/api_service.dart';

class TopicsService {
  TopicsService._privateConstructor();

  static final TopicsService _instance = TopicsService._privateConstructor();

  factory TopicsService() {
    return _instance;
  }

  Future<dynamic> getTopics() async {
    print('getting Quizflex data now..');
    final ApiService apiService = ApiService();
    dynamic result;
    try {
      print(APIEndpoints.CONTENT_MANAGER_BASE_URL + APIEndpoints.TOPICS);
      result = await apiService.getRequest(APIEndpoints.CONTENT_MANAGER_BASE_URL, APIEndpoints.TOPICS);
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

  Future<dynamic> getSubtopics(String topic) async {
    print('getting Quizflex Subtopics data now..');
    final ApiService apiService = ApiService();
    dynamic result;
    try {
      print(APIEndpoints.CONTENT_MANAGER_BASE_URL + APIEndpoints.SUB_TOPICS + "/" + topic);
      result = await apiService.getRequest(APIEndpoints.CONTENT_MANAGER_BASE_URL, APIEndpoints.SUB_TOPICS + "/" + topic);
      print('API Result: $result');

      if (result is Map<String, dynamic> && result.containsKey('data')) {
        List<dynamic> subtopicsList = result['data'];
        return List<Map<String, String>>.from(subtopicsList.map((item) => Map<String, String>.from(item)));
      } else {
        throw const FormatException("Unexpected response format");
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  int getNumberOfTopics() {
    return 0;
  }
}
