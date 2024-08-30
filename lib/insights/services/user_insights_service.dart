import 'dart:convert';

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
      print(APIEndpoints.USER_INSIGHTS_BASE_URL + APIEndpoints.USER_INSIGHTS);
      result = await apiService.getRequest(APIEndpoints.USER_INSIGHTS_BASE_URL, APIEndpoints.USER_INSIGHTS);
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