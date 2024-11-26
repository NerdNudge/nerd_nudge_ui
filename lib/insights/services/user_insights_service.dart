import 'dart:convert';

import '../../user_profile/dto/user_profile_entity.dart';
import '../../utilities/api_end_points.dart';
import '../../utilities/api_service.dart';
import '../../utilities/logger.dart';

class UserInsightsService {
  UserInsightsService._privateConstructor();
  static final UserInsightsService _instance =
  UserInsightsService._privateConstructor();

  factory UserInsightsService() {
    return _instance;
  }

  Future<Map<String, dynamic>> getUserInsights() async {
    final ApiService apiService = ApiService();
    dynamic result;
    try {
      result = await apiService.getRequest(APIEndpoints.USER_INSIGHTS_BASE_URL, "${APIEndpoints.USER_INSIGHTS}/" + UserProfileEntity().getUserEmail());
      NerdLogger.logger.d('API Result: $result');

      if (result is Map<String, dynamic>) {
        return result['data'];
      } else if (result is String) {
        return json.decode(result);
      } else {
        throw const FormatException("Unexpected response format");
      }
    } catch (e) {
      NerdLogger.logger.e(e);
      return {};
    }
  }

  Future<List<dynamic>> getLeaderBoard(String topic, int limit) async {
    final ApiService apiService = ApiService();
    dynamic result;
    try {
      result = await apiService.getRequest(APIEndpoints.USER_RANK_SERVICE_BASE_URL, "${APIEndpoints.LEADERBOARD}?topic=$topic&limit=$limit");
      NerdLogger.logger.d('API Result: $result');

      if (result is Map<String, dynamic>) {
        return result['data'];
      } else if (result is String) {
        return json.decode(result);
      } else {
        throw const FormatException("Unexpected response format");
      }
    } catch (e) {
      NerdLogger.logger.e(e);
      return [];
    }
  }
}