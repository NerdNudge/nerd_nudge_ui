import 'package:flutter/cupertino.dart';

import '../../../utilities/api_end_points.dart';
import '../../../utilities/api_service.dart';
import '../screens/realworld_challenge_read_more.dart';

class QuizflexSubmissionService {
  QuizflexSubmissionService._privateConstructor();
  static final QuizflexSubmissionService _instance = QuizflexSubmissionService._privateConstructor();

  factory QuizflexSubmissionService() {
    return _instance;
  }

  Future<void> submitQuizflex() async {
    final ApiService apiService = ApiService();
    Map<String, dynamic> result = {};
    try {
      print(APIEndpoints.USER_ACTIVITY_BASE_URL + APIEndpoints.QUIZFLEX_SUBMISSION);
      print(RealworldChallengeReadMorePage.quizflexUserActivityAPIEntity.toJson());
      result = await apiService.putRequest(APIEndpoints.USER_ACTIVITY_BASE_URL + APIEndpoints.QUIZFLEX_SUBMISSION, RealworldChallengeReadMorePage.quizflexUserActivityAPIEntity.toJson());
      print('API Result: $result');

      RealworldChallengeReadMorePage.resetUserActivityEntity(); // Reset the entity after the API call
    } catch (e) {
      print(e);
    }
  }
}