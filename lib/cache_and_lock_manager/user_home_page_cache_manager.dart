import 'package:nerd_nudge/utilities/logger.dart';

import '../user_home_page/dto/user_home_stats.dart';
import '../user_home_page/services/home_page_service.dart';
import 'cache_locks_keys.dart';

class UserHomePageCacheManager {
  static final UserHomePageCacheManager _instance = UserHomePageCacheManager._privateConstructor();

  UserHomePageCacheManager._privateConstructor();

  factory UserHomePageCacheManager() {
    return _instance;
  }

  DateTime? _userHomeStatsLastUpdated;
  CacheLockKeys cacheLockKeys = CacheLockKeys();
  Future<UserHomeStats>? _futureUserHomeStats;

  void updateUserHomeStatsLastUpdatedTime(DateTime time) {
    _userHomeStatsLastUpdated = time;
  }

  bool isUserHomeStatsCacheExpired(Duration duration) {
    if (_userHomeStatsLastUpdated == null) {
      return true;
    }
    return DateTime.now().difference(_userHomeStatsLastUpdated!) > duration;
  }

  Future<UserHomeStats> fetchUserHomePageStats(String currentLocalLockKey) async {
    NerdLogger.logger.d('getting user home data now..');
    if (isUserHomeStatsCacheExpired(const Duration(minutes: 5)) || cacheLockKeys.isKeyChanged(currentLocalLockKey)) {
      NerdLogger.logger.d("Cache is expired, key changed or it's the first time. Fetching data from API...");
      _futureUserHomeStats = HomePageService().getUserHomePageStats();
      updateUserHomeStatsLastUpdatedTime(DateTime.now());
    } else {
      if (_futureUserHomeStats != null) {
        NerdLogger.logger.d("Cache is still valid. Using cached data.");
        return _futureUserHomeStats!;
      } else {
        NerdLogger.logger.d("Cache was expected but is missing, fetching from API...");
        _futureUserHomeStats = HomePageService().getUserHomePageStats();
        updateUserHomeStatsLastUpdatedTime(DateTime.now());
      }
    }
    return _futureUserHomeStats!;
  }
}