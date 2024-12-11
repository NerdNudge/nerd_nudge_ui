import 'dart:convert';

import 'package:nerd_nudge/user/scores.dart';

import '../../user_profile/dto/user_profile_entity.dart';
import '../../utilities/api_end_points.dart';
import '../../utilities/api_service.dart';
import '../../utilities/logger.dart';

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

  // New: Subtopics Cache
  final Map<String, dynamic> _subtopicsCache = {};
  final Map<String, DateTime> _subtopicsFetchedTime = {};

  void invalidateTopicsCache() {
    NerdLogger.logger.i('Invalidating topics cache.');
    _lastFetchedTime = null;
  }

  // New: Invalidate Subtopics Cache
  void invalidateSubtopicsCache() {
    NerdLogger.logger.i('Invalidating subtopics cache.');
    _subtopicsCache.clear();
    _subtopicsFetchedTime.clear();
  }

  Future<dynamic> getTopics() async {
    if (_topicsResult == null || !isWithinRetentionTime()) {
      await _updateTopicCache();
    }
    return _topicsResult;
  }

  Future<void> _updateTopicCache() async {
    try {
      _topicsResult = await _apiService.getRequest(
          APIEndpoints.CONTENT_MANAGER_BASE_URL,
          "${APIEndpoints.TOPICS}/" + UserProfileEntity().getUserEmail());
      _lastFetchedTime = DateTime.now();
      NerdLogger.logger.d('API Result: $_topicsResult');

      if (_topicsResult is Map<String, dynamic>) {
        _updateTopicCodesAndNamesMapping();
      } else if (_topicsResult is String) {
        _topicsResult = json.decode(_topicsResult);
        _updateTopicCodesAndNamesMapping();
      } else {
        throw const FormatException("Unexpected response format");
      }
    } catch (e) {
      NerdLogger.logger.e(e);
    }
  }

  bool isWithinRetentionTime() {
    if (_lastFetchedTime == null) {
      return false;
    }
    final now = DateTime.now();
    return now.difference(_lastFetchedTime!).compareTo(_cacheDuration) < 0;
  }

  // New: Check Retention Time for Subtopics
  bool isSubtopicWithinRetentionTime(String topic) {
    if (!_subtopicsFetchedTime.containsKey(topic)) {
      return false;
    }
    final now = DateTime.now();
    return now
        .difference(_subtopicsFetchedTime[topic]!)
        .compareTo(_cacheDuration) <
        0;
  }

  void _updateTopicCodesAndNamesMapping() {
    if (_topicsResult != null &&
        _topicsResult is Map<String, dynamic> &&
        _topicsResult.containsKey('data') &&
        _topicsResult['data'] is Map<String, dynamic> &&
        _topicsResult['data'].containsKey('topics')) {
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

    NerdLogger.logger.d(_topicNameToCodesMapping);
    NerdLogger.logger.d(_topicCodeToNamesMapping);
  }

  Future<Map<String, String>> getTopicNamesToCodesMapping() async {
    if (!isWithinRetentionTime()) {
      await _updateTopicCache();
    }

    return _topicNameToCodesMapping;
  }

  Future<Map<String, String>> getTopicCodesToNamesMapping() async {
    if (!isWithinRetentionTime()) {
      await _updateTopicCache();
    }

    return _topicCodeToNamesMapping;
  }

  Future<dynamic> getSubtopics(String topic) async {
    if (_subtopicsCache.containsKey(topic) &&
        isSubtopicWithinRetentionTime(topic)) {
      NerdLogger.logger.d('Returning cached subtopics for topic: $topic');
      return _subtopicsCache[topic];
    }

    try {
      dynamic result = await _apiService.getRequest(
          APIEndpoints.CONTENT_MANAGER_BASE_URL,
          "${APIEndpoints.SUB_TOPICS}/$topic/${UserProfileEntity().getUserEmail()}");
      NerdLogger.logger.d('API Result: $result');

      if (result is Map<String, dynamic> && result.containsKey('data')) {
        var subtopicsEntity = result['data'];

        Map<String, String> subtopicData = Map<String, String>.from(subtopicsEntity['subtopicData']);
        double userTopicScore = subtopicsEntity['userTopicScore'] ?? 0.0;

        _subtopicsCache[topic] = subtopicData;
        UserScores.currentScore = userTopicScore;
        NerdLogger.logger.d('Updated user score: ${UserScores.getUserScore()}');
        NerdLogger.logger.d('User score from api call: $userTopicScore');
        _subtopicsFetchedTime[topic] = DateTime.now();

        return _subtopicsCache[topic];
      } else {
        throw const FormatException("Unexpected response format");
      }
    } catch (e) {
      NerdLogger.logger.e(e);
      return [];
    }
  }

  int getNumberOfTopics() {
    return _topicsResult != null ? (_topicsResult['data'] as List).length : 0;
  }
}
