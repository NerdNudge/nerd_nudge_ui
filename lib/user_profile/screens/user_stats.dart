import 'package:nerd_nudge/user_profile/screens/user_account_types.dart';

class UserStats {

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

  static final UserStats _instance = UserStats._internal();

  factory UserStats() {
    return _instance;
  }

  UserStats._internal() {
    //TODO: Initialize the fields with actual values using the api.
    _accountType = AccountType.FREEMIUM;
    _totalQuizzesAttempted = 204;
    _totalPercentageCorrect = 80.42;
    _highestInADay = 21;
    _highestCorrectInADay = 18;
    _averagePerDay = 12;
    _currentStreak = 5;
    _highestStreak = 16;
    _quizCountToday = 0;
    _shotsCountToday = 8;
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

  set accountType(AccountType value) {
    _accountType = value;
  }

  set totalQuizzesAttempted(int value) {
    _totalQuizzesAttempted = value;
  }

  set totalPercentageCorrect(double value) {
    _totalPercentageCorrect = value;
  }

  set highestInADay(int value) {
    _highestInADay = value;
  }

  set highestCorrectInADay(int value) {
    _highestCorrectInADay = value;
  }

  set currentStreak(int value) {
    _currentStreak = value;
  }

  set highestStreak(int value) {
    _highestStreak = value;
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
    switch(accountType) {
      case AccountType.FREEMIUM:
        return 12;
      case AccountType.NERD_NUDGE_PRO:
        return 50;
      case AccountType.NERD_NUDGE_MAX:
        return 10000;
    }
  }

  _getTotalNerdQuizQuota(AccountType accountType) {
    switch(accountType) {
      case AccountType.FREEMIUM:
        return 12;
      case AccountType.NERD_NUDGE_PRO:
        return 40;
      case AccountType.NERD_NUDGE_MAX:
        return 10000;
    }
  }

  void incrementQuizCount() {
    _quizCountToday ++;
  }

  void incrementShotsCount() {
    _shotsCountToday ++;
  }

  bool hasUserExhaustedNerdShots() {
    return _shotsCountToday >= _getTotalNerdShotsQuota(_accountType);
  }

  bool hasUserExhaustedNerdQuiz() {
    return _quizCountToday >= _getTotalNerdQuizQuota(_accountType);
  }
}