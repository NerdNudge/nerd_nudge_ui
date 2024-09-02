import 'dart:convert';

import '../../user_profile/dto/user_profile_entity.dart';
import '../../utilities/api_end_points.dart';
import '../../utilities/api_service.dart';

class UserInsightsService {
  UserInsightsService._privateConstructor();
  static final UserInsightsService _instance =
  UserInsightsService._privateConstructor();

  factory UserInsightsService() {
    return _instance;
  }

  Future<Map<String, dynamic>> getUserInsights() async {
    print('getting User Insights now..');
    final ApiService apiService = ApiService();
    dynamic result;
    try {
      print(APIEndpoints.USER_INSIGHTS_BASE_URL + APIEndpoints.USER_INSIGHTS + "/" + UserProfileEntity().getUserEmail());
      result = await apiService.getRequest(APIEndpoints.USER_INSIGHTS_BASE_URL, APIEndpoints.USER_INSIGHTS + "/" + UserProfileEntity().getUserEmail());
      print('API Result: $result');

      if (result is Map<String, dynamic>) {
        return result['data'];
      } else if (result is String) {
        return json.decode(result);
      } else {
        throw const FormatException("Unexpected response format");
      }
    } catch (e) {
      print(e);
      return {};
    }
  }
}