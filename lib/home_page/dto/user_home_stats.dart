import 'package:nerd_nudge/user_profile/screens/user_account_types.dart';

class UserHomeStats {
  late Map<String, dynamic> _userData;

  late AccountType _accountType;

  late int _totalQuizzesAttempted;
  late double _totalPercentageCorrect;

  late int _highestInADay;
  late int _highestCorrectInADay;
  late int _averagePerDay;

  late int _currentStreak;
  late int _highestStreak;

  late int _quizCountToday;
  late int _shotsCountToday;

  late String _quoteOfTheDay;
  late int _numPeopleUsedNerdNudge;

  late double _lastFetchTime;

  static final UserHomeStats _instance = UserHomeStats._internal();

  factory UserHomeStats() {
    return _instance;
  }

  UserHomeStats._internal() {
    //TODO: Initialize the fields with actual values using the api.
    /*_accountType = AccountType.FREEMIUM;
    _totalQuizzesAttempted = 204;
    _totalPercentageCorrect = 80.42;
    _highestInADay = 21;
    _highestCorrectInADay = 18;
    _averagePerDay = 12;
    _currentStreak = 5;
    _highestStreak = 16;
    _quizCountToday = 0;
    _shotsCountToday = 8;*/
  }

  factory UserHomeStats.fromJson(Map<String, dynamic> userData) {
    UserHomeStats instance = UserHomeStats._instance;

    instance._userData = userData;
    instance.accountType = userData;
    instance.totalQuizzesAttempted = userData;
    instance.totalPercentageCorrect = userData;
    instance.highestInADay = userData;
    instance.highestCorrectInADay = userData;
    instance.currentStreak = userData;
    instance.highestStreak = userData;

    instance._quizCountToday = userData['quizCountToday'];
    instance._shotsCountToday = userData['shotsCountToday'];
    instance._quoteOfTheDay = userData['quoteOfTheDay'];
    instance._numPeopleUsedNerdNudge = userData['numPeopleUsedNerdNudge'];
    instance._lastFetchTime = userData['lastFetchTime'];

    return instance;
  }

  int getCurrentStreak() {
    return _currentStreak;
  }

  int getHighestStreak() {
    return _highestStreak;
  }

  int getHighestInADay() {
    return _highestInADay;
  }

  int getHighestCorrectInADay() {
    return _highestCorrectInADay;
  }

  int getAveragePerDay() {
    return _averagePerDay;
  }

  AccountType getUserAccountType() {
    return _accountType;
  }

  int getUserQuizCountToday() {
    return _quizCountToday;
  }

  int getUserShotsCountToday() {
    return _shotsCountToday;
  }

  int getTotalQuizzesAttempted() {
    return _totalQuizzesAttempted;
  }

  double getTotalPercentageCorrect() {
    return _totalPercentageCorrect;
  }

  set accountType(Map<String, dynamic> userData) {
    if (userData.containsKey('accountType')) {
      _accountType = _getFromAccountTypeEnum(userData['accountType']);
    } else {
      _accountType = AccountType.FREEMIUM;
    }
  }

  _getFromAccountTypeEnum(String type) {
    switch (type) {
      case 'Freemium':
        return AccountType.FREEMIUM;
      case 'NerdNudgePro':
        return AccountType.NERD_NUDGE_PRO;
      case 'NerdNudgeMax':
        return AccountType.NERD_NUDGE_MAX;
    }
  }

  set totalQuizzesAttempted(Map<String, dynamic> userData) {
    if (userData.containsKey('Summary')) {
      Map<String, dynamic> summaryData = userData['Summary'];
      if (summaryData.containsKey('overallSummary')) {
        Map<String, dynamic> overallSummaryData = userData['overallSummary'];
        if (overallSummaryData.containsKey('total')) {
          List<int> totalSummary = overallSummaryData['total'];
          _totalQuizzesAttempted = totalSummary[0];
          return;
        }
      }
    }

    _totalQuizzesAttempted = 0;
  }

  set totalPercentageCorrect(Map<String, dynamic> userData) {
    if (userData.containsKey('Summary')) {
      Map<String, dynamic> summaryData = userData['Summary'];
      if (summaryData.containsKey('overallSummary')) {
        Map<String, dynamic> overallSummaryData = userData['overallSummary'];
        if (overallSummaryData.containsKey('total')) {
          List<int> totalSummary = overallSummaryData['total'];
          int totalQuizzes = totalSummary[0];
          int totalCorrect = totalSummary[1];
          _totalPercentageCorrect = (totalCorrect / totalQuizzes) * 100;
          return;
        }
      }
    }
    _totalPercentageCorrect = 0;
  }

  set highestInADay(Map<String, dynamic> userData) {
    if (userData.containsKey('dayStats')) {
      Map<String, dynamic> dayStats = userData['dayStats'];
      if (dayStats.containsKey('highest')) {
        _highestInADay = dayStats['highest'];
        return;
      }
    }
    _highestInADay = 0;
  }

  set highestCorrectInADay(Map<String, dynamic> userData) {
    if (userData.containsKey('dayStats')) {
      Map<String, dynamic> dayStats = userData['dayStats'];
      if (dayStats.containsKey('highestCorrect')) {
        _highestCorrectInADay = dayStats['highestCorrect'];
        return;
      }
    }
    _highestCorrectInADay = 0;
  }

  set currentStreak(Map<String, dynamic> userData) {
    if (userData.containsKey('streak')) {
      Map<String, int> streak = userData['streak'];
      if (streak.containsKey('current')) {
        _currentStreak = streak['current']!;
        return;
      }
    }
    _currentStreak = 0;
  }

  set highestStreak(Map<String, dynamic> userData) {
    if (userData.containsKey('streak')) {
      Map<String, int> streak = userData['streak'];
      if (streak.containsKey('highest')) {
        _highestStreak = streak['highest']!;
        return;
      }
    }
    _highestStreak = 0;
  }

  set quizCountToday(int value) {
    _quizCountToday = value;
  }

  set shotsCountToday(int value) {
    _shotsCountToday = value;
  }

  getDailyQuizRemaining() {
    return _getTotalNerdQuizQuota(_accountType) - _quizCountToday;
  }

  getDailyShotsRemaining() {
    return _getTotalNerdShotsQuota(_accountType) - _shotsCountToday;
  }

  _getTotalNerdShotsQuota(AccountType accountType) {
    switch (accountType) {
      case AccountType.FREEMIUM:
        return 12;
      case AccountType.NERD_NUDGE_PRO:
        return 50;
      case AccountType.NERD_NUDGE_MAX:
        return 10000;
    }
  }

  _getTotalNerdQuizQuota(AccountType accountType) {
    switch (accountType) {
      case AccountType.FREEMIUM:
        return 12;
      case AccountType.NERD_NUDGE_PRO:
        return 40;
      case AccountType.NERD_NUDGE_MAX:
        return 10000;
    }
  }

  void incrementQuizCount() {
    _quizCountToday++;
  }

  void incrementShotsCount() {
    _shotsCountToday++;
  }

  bool hasUserExhaustedNerdShots() {
    return _shotsCountToday >= _getTotalNerdShotsQuota(_accountType);
  }

  bool hasUserExhaustedNerdQuiz() {
    return _quizCountToday >= _getTotalNerdQuizQuota(_accountType);
  }
}
