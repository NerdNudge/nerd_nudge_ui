import 'dart:convert';

import '../../user_profile/dto/user_profile_entity.dart';
import '../../utilities/api_end_points.dart';
import '../../utilities/api_service.dart';

class TopicsService {
  TopicsService._privateConstructor();

  static final TopicsService _instance = TopicsService._privateConstructor();

  factory TopicsService() {
    return _instance;
  }

  dynamic _result;
  DateTime? _lastFetchedTime;
  static final ApiService _apiService = ApiService();
  final Duration _cacheDuration = const Duration(minutes: 10);
  Map<String, String> _topicCodeToNamesMapping = {};
  Map<String, String> _topicNameToCodesMapping = {};



  Future<dynamic> getTopics() async {
    print('getting Topics now..');
    if(_result == null || ! isWithinRetentionTime()) {
      await _updateTopicCache();
    }

    return _result;
  }


  Future<void> _updateTopicCache() async {
    try {
      print(APIEndpoints.CONTENT_MANAGER_BASE_URL + APIEndpoints.TOPICS + "/" + UserProfileEntity().getUserEmail());
      _result = await _apiService.getRequest(APIEndpoints.CONTENT_MANAGER_BASE_URL, APIEndpoints.TOPICS + "/" + UserProfileEntity().getUserEmail());
      _lastFetchedTime = DateTime.now();
      print('API Result: $_result');

      if (_result is Map<String, dynamic>) {
        _updateTopicCodesAndNamesMapping();
      } else if (_result is String) {
        _result = json.decode(_result);
        _updateTopicCodesAndNamesMapping();
      } else {
        throw const FormatException("Unexpected response format");
      }
    } catch (e) {
      print(e);
    }
  }

  bool isWithinRetentionTime() {
    if (_lastFetchedTime == null) {
      return false;
    }
    final now = DateTime.now();
    return now.difference(_lastFetchedTime!).compareTo(_cacheDuration) < 0;
  }

  void _updateTopicCodesAndNamesMapping() {
    if (_result != null && _result is Map<String, dynamic> && _result.containsKey('data')) {
      List<dynamic> topicsList = _result['data'];
      _topicNameToCodesMapping['global'] = 'global';
      _topicNameToCodesMapping['global'] = 'global';
      for (var topic in topicsList) {
        if (topic.containsKey('topicCode') && topic.containsKey('topicName')) {
          _topicCodeToNamesMapping[topic['topicCode']] = topic['topicName'];
          _topicNameToCodesMapping[topic['topicName']] = topic['topicCode'];
        }
      }
    }
    print(_topicNameToCodesMapping);
    print(_topicCodeToNamesMapping);
  }

  Future<Map<String, String>> getTopicNamesToCodesMapping() async {
    if(! isWithinRetentionTime()) {
      await _updateTopicCache();
    }

    return _topicNameToCodesMapping;
  }

  Future<Map<String, String>> getTopicCodesToNamesMapping() async {
    if(! isWithinRetentionTime()) {
      await _updateTopicCache();
    }

    return _topicCodeToNamesMapping;
  }


  Future<dynamic> getSubtopics(String topic) async {
    print('getting Quizflex Subtopics data now..');
    dynamic result;
    try {
      print(APIEndpoints.CONTENT_MANAGER_BASE_URL +
          APIEndpoints.SUB_TOPICS +
          "/" +
          topic);
      result = await _apiService.getRequest(
          APIEndpoints.CONTENT_MANAGER_BASE_URL,
          APIEndpoints.SUB_TOPICS + "/" + topic);
      print('API Result: $result');

      if (result is Map<String, dynamic> && result.containsKey('data')) {
        List<dynamic> subtopicsList = result['data'];
        return List<Map<String, String>>.from(
            subtopicsList.map((item) => Map<String, String>.from(item)));
      } else {
        throw const FormatException("Unexpected response format");
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  int getNumberOfTopics() {
    return _result != null ? (_result['data'] as List).length : 0;
  }
}
