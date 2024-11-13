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

  dynamic _topicsResult;
  DateTime? _lastFetchedTime;
  static final ApiService _apiService = ApiService();
  final Duration _cacheDuration = const Duration(minutes: 10);
  Map<String, String> _topicCodeToNamesMapping = {};
  Map<String, String> _topicNameToCodesMapping = {};


  void invalidateTopicsCache() {
    print('Invalidating topics cache.');    
    _lastFetchedTime = null;
  }


  Future<dynamic> getTopics() async {
    print('getting Topics now..');
    if(_topicsResult == null || ! isWithinRetentionTime()) {
      await _updateTopicCache();
    }

    return _topicsResult;
  }


  Future<void> _updateTopicCache() async {
    try {
      print(APIEndpoints.CONTENT_MANAGER_BASE_URL + APIEndpoints.TOPICS + "/" + UserProfileEntity().getUserEmail());
      _topicsResult = await _apiService.getRequest(APIEndpoints.CONTENT_MANAGER_BASE_URL, APIEndpoints.TOPICS + "/" + UserProfileEntity().getUserEmail());
      _lastFetchedTime = DateTime.now();
      print('API Result: $_topicsResult');

      if (_topicsResult is Map<String, dynamic>) {
        _updateTopicCodesAndNamesMapping();
      } else if (_topicsResult is String) {
        _topicsResult = json.decode(_topicsResult);
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
    if (_topicsResult != null && _topicsResult is Map<String, dynamic> && _topicsResult.containsKey('data') && _topicsResult['data'] is Map<String, dynamic> && _topicsResult['data'].containsKey('topics')) {

      Map<String, dynamic> topicsMap = _topicsResult['data']['topics'];
      _topicNameToCodesMapping['global'] = 'global';
      _topicCodeToNamesMapping['global'] = 'global';

      topicsMap.forEach((topicCode, topicDetails) {
        if (topicDetails is Map<String, dynamic> &&
            topicDetails.containsKey('topicName')) {
          String topicName = topicDetails['topicName'];
          _topicCodeToNamesMapping[topicCode] = topicName;
          _topicNameToCodesMapping[topicName] = topicCode;
        }
      });
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
    return _topicsResult != null ? (_topicsResult['data'] as List).length : 0;
  }
}
