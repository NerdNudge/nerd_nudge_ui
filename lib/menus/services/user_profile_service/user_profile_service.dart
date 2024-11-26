import 'package:nerd_nudge/utilities/api_end_points.dart';

import '../../../utilities/api_service.dart';
import '../../../utilities/logger.dart';

class UserProfileService {
  UserProfileService._privateConstructor();
  static final UserProfileService _instance =
      UserProfileService._privateConstructor();

  factory UserProfileService() {
    return _instance;
  }

  Future<bool> callDeleteAccountAPI(String email) async {
    const String apiUrl = APIEndpoints.USER_ACTIVITY_BASE_URL + APIEndpoints.USER_TERMINATION;
    dynamic result;
    final ApiService apiService = ApiService();
    final Map<String, dynamic> data = {'email': email};

    try {
      result = await apiService.putRequest(apiUrl, data);
      NerdLogger.logger.d('API Result: $result');
      return true;
    } catch (e) {
      NerdLogger.logger.e('Error calling delete account API: $e');
      return false;
    }
  }
}
