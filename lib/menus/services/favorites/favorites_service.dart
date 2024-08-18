import 'dart:convert';

import 'package:nerd_nudge/menus/dto/favorite_entity.dart';

import '../../../utilities/api_end_points.dart';
import '../../../utilities/api_service.dart';

class FavoritesService {
  var recent = json.decode('{"status":"SUCCESS","recent":[{"id":"DSA_1ys3","topic":"DSA","sub-topic":"Stacks","title":"Stack Usage in Programming","difficulty_level":"Easy","question":"What is the primary use of a stack in computer programming?","description_and_explanation":"A stack is a data structure used to store a collection of objects. It operates on a last in, first out (LIFO) principle, making it particularly useful for managing function calls in programming languages. This allows programs to keep track of function invocations and return addresses.","pro_tip":"Always check for stack overflow conditions in recursive function implementations.","fun_fact":"The concept of a stack was formalized in computer science by Alan Turing in 1946."},{"id":"DSA_Y6&h","topic":"DSA","sub-topic":"Heaps","title":"Implementing Priority Queues","difficulty_level":"Medium","question":"What is the primary use of a stack in computer programming?","description_and_explanation":"A heap is a specialized tree-based data structure that satisfies the heap property. It is particularly effective for implementing priority queues where the highest (or lowest) priority element needs to be accessed quickly. Heaps are crucial in algorithms like Heapsort and in systems requiring quick access to the most urgent element.","pro_tip":"Consider using a binary heap for easier implementation and efficient performance.","fun_fact":"Heaps are particularly popular in network traffic management and operating system scheduling."},{"id":"SDE_NAH7u","topic":"SDE","sub-topic":"Database Types","title":"Best Database for Hierarchical Data","difficulty_level":"Medium","question":"Which database type is best suited for handling hierarchical data, such as organizational structures?","description_and_explanation":"Graph databases are designed to store and navigate relationships in a natural and efficient way, making them ideal for hierarchical data structures.","pro_tip":"When dealing with complex, interconnected data, graph databases can significantly simplify your queries.","fun_fact":"Graph databases are used by social networks to map users connections efficiently."}]}');

  FavoritesService._privateConstructor();

  static final FavoritesService _instance = FavoritesService._privateConstructor();

  factory FavoritesService() {
    return _instance;
  }

  Future<List<Map<String, dynamic>>> getRecentFavorites() async {
    print('getting Quizflex data now..');
    final ApiService apiService = ApiService();
    dynamic result;
    try {
      final String url = APIEndpoints.USER_INSIGHTS_BASE_URL + APIEndpoints.RECENT_FAVORITES;
      print('Sending GET request to: $url');
      result = await apiService.getRequest(APIEndpoints.USER_INSIGHTS_BASE_URL, APIEndpoints.RECENT_FAVORITES);
      print('API Result: $result');

      if (result is Map<String, dynamic>) {
        // Ensure that the data returned is a List<Map<String, dynamic>>
        return List<Map<String, dynamic>>.from(result['data']);
      } else if (result is String) {
        // Decode the string into a Map and then into a List<Map<String, dynamic>>
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

  Future<dynamic> favoritesActivitySubmission(FavoriteUserActivityEntity entity) async {
    final ApiService apiService = ApiService();
    dynamic result;
    try {
      final String url = APIEndpoints.USER_ACTIVITY_BASE_URL +
          APIEndpoints.FAVORITES_SUBMISSION;

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

  List<Map<String, dynamic>> getFavoritesBySubTopics(String topic, String subtopic) {
    return List<Map<String, dynamic>>.from(recent['recent']);
  }
}