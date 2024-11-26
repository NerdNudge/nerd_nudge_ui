import '../../../utilities/api_end_points.dart';
import '../../../utilities/api_service.dart';
import '../../../utilities/logger.dart';
import '../screens/read_more.dart';

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
      NerdLogger.logger.d(ReadMorePage.quizflexUserActivityAPIEntity.toJson());
      result = await apiService.putRequest(APIEndpoints.USER_ACTIVITY_BASE_URL + APIEndpoints.QUIZFLEX_SUBMISSION, ReadMorePage.quizflexUserActivityAPIEntity.toJson());
      NerdLogger.logger.d('API Result: $result');

      ReadMorePage.resetUserActivityEntity(); // Reset the entity after the API call
    } catch (e) {
      NerdLogger.logger.e(e);
    }
  }
}