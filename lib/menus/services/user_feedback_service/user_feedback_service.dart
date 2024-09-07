import 'package:nerd_nudge/menus/dto/user_feedback_entity.dart';
import 'package:nerd_nudge/user_profile/dto/user_profile_entity.dart';

import '../../../utilities/api_end_points.dart';
import '../../../utilities/api_service.dart';

class UserFeedbackService {
  UserFeedbackService._privateConstructor();
  static final UserFeedbackService _instance = UserFeedbackService._privateConstructor();

  factory UserFeedbackService() {
    return _instance;
  }

  Future<void> submitUserFeedBack(String feedbackType, String feedback) async {
    print('Submitting User Feedback now..');
    UserFeedbackEntity userFeedbackEntity = UserFeedbackEntity();
    userFeedbackEntity.feedbackType = feedbackType;
    userFeedbackEntity.feedback = feedback;

    final Map<String, dynamic> jsonBody = userFeedbackEntity.toJson();
    final ApiService apiService = ApiService();
    dynamic result;
    String url = APIEndpoints.USER_ACTIVITY_BASE_URL + APIEndpoints.USER_FEEDBACK_SUBMISSION;
    try {
      print(url);
      result = await apiService.putRequest(url, jsonBody);
      print('API Result: $result');
    } catch (e) {
      print(e);
    }
  }
}