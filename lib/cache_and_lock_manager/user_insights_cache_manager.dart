import '../insights/services/user_insights_service.dart';
import '../utilities/logger.dart';
import 'cache_locks_keys.dart';

class UserInsightsCacheManager {
  static final UserInsightsCacheManager _instance = UserInsightsCacheManager._privateConstructor();

  UserInsightsCacheManager._privateConstructor();

  factory UserInsightsCacheManager() {
    return _instance;
  }

  DateTime? _userInsightsLastUpdated;
  Map<String, dynamic>? _cachedUserInsights = null;
  CacheLockKeys cacheLockKeys = CacheLockKeys();

  void updateUserInsightsLastUpdatedTime(DateTime time) {
    _userInsightsLastUpdated = time;
  }

  bool isUserInsightsCacheExpired(Duration duration) {
    if (_userInsightsLastUpdated == null) {
      return true;
    }
    return DateTime.now().difference(_userInsightsLastUpdated!) > duration;
  }

  Future<Map<String, dynamic>> fetchUserInsights(String currentLocalLockKey) async {
    if (isUserInsightsCacheExpired(const Duration(minutes: 5)) || cacheLockKeys.isKeyChanged(currentLocalLockKey)) {
      NerdLogger.logger.d("Cache is expired, key changed or it's the first time. Fetching data from API...");
      _cachedUserInsights = await _fetchUserInsightsFromAPI();
      updateUserInsightsLastUpdatedTime(DateTime.now());
    } else {
      if (_cachedUserInsights != null && _cachedUserInsights!.isNotEmpty) {
        NerdLogger.logger.d("Cache is still valid. Using cached data.");
        return _cachedUserInsights!;
      } else {
        NerdLogger.logger.d("Cache was expected but is missing, fetching from API...");
        _cachedUserInsights = await _fetchUserInsightsFromAPI();
        updateUserInsightsLastUpdatedTime(DateTime.now());
      }
    }
    return _cachedUserInsights!;
  }

  Future<Map<String, dynamic>> _fetchUserInsightsFromAPI() async {
    try {
      return await UserInsightsService().getUserInsights();
    } catch (e) {
      NerdLogger.logger.e('Error fetching user insights: $e');
      return {};
    }
  }
}