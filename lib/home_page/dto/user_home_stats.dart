import 'package:nerd_nudge/user_profile/screens/user_account_types.dart';

class UserHomeStats {
  late Map<String, dynamic> _userData;
  late AccountType _accountType = AccountType.FREEMIUM;
  late int _totalQuizzesAttempted = 0;
  late double _totalPercentageCorrect = 0.0;
  late int _highestInADay = 0;
  late int _highestCorrectInADay = 0;
  late int _averagePerDay = 0;
  late int _currentStreak = 0;
  late int _highestStreak = 0;
  late int _quizCountToday = 0;
  late int _shotsCountToday = 0;
  late String _quoteOfTheDay = '';
  late String _quoteAuthor = '';
  late int _numPeopleUsedNerdNudge = 0;
  late double _lastFetchTime = 0.0;

  static final UserHomeStats _instance = UserHomeStats._internal();

  factory UserHomeStats() {
    return _instance;
  }

  UserHomeStats._internal();

  factory UserHomeStats.fromJson(Map<String, dynamic> userData) {
    UserHomeStats instance = UserHomeStats._instance;

    instance._userData = userData;
    var jsonData = userData['data'];

    instance._accountType = jsonData.containsKey('accountType')
        ? _getFromAccountTypeEnum(jsonData['accountType'])
        : AccountType.FREEMIUM;

    instance._totalQuizzesAttempted = jsonData['totalQuizzes'] ?? 0;
    instance._totalPercentageCorrect = jsonData['correctPercentage']?.toDouble() ?? 0.0;
    instance._highestInADay = jsonData['highestInADay'] ?? 0;
    instance._highestCorrectInADay = jsonData['highestCorrectInADay'] ?? 0;
    instance._currentStreak = jsonData['currentStreak'] ?? 0;
    instance._highestStreak = jsonData['highestStreak'] ?? 0;
    instance._quizCountToday = jsonData['quizflexCountToday'] ?? 0;
    instance._shotsCountToday = jsonData['shotsCountToday'] ?? 0;
    instance._quoteOfTheDay = jsonData['quoteOfTheDay'] ?? '';
    instance._quoteAuthor = jsonData['quoteAuthor'] ?? '';
    instance._numPeopleUsedNerdNudge = jsonData['numPeopleUsedNerdNudgeToday'] ?? 0;

    return instance;
  }

  static AccountType _getFromAccountTypeEnum(String accountType) {
    switch (accountType.toLowerCase()) {
      case 'freemium':
        return AccountType.FREEMIUM;
      case 'nerd_nudge_pro':
        return AccountType.NERD_NUDGE_PRO;
      case 'nerd_nudge_max':
        return AccountType.NERD_NUDGE_MAX;
      default:
        return AccountType.FREEMIUM; // Default case
    }
  }

  Map<String, dynamic> get userData => _userData;

  set userData(Map<String, dynamic> value) {
    _userData = value;
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
        return 120;
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

  AccountType get accountType => _accountType;

  set accountType(AccountType value) {
    _accountType = value;
  }

  int get totalQuizzesAttempted => _totalQuizzesAttempted;

  set totalQuizzesAttempted(int value) {
    _totalQuizzesAttempted = value;
  }

  double get totalPercentageCorrect => _totalPercentageCorrect;

  set totalPercentageCorrect(double value) {
    _totalPercentageCorrect = value;
  }

  int get highestInADay => _highestInADay;

  set highestInADay(int value) {
    _highestInADay = value;
  }

  int get highestCorrectInADay => _highestCorrectInADay;

  set highestCorrectInADay(int value) {
    _highestCorrectInADay = value;
  }

  int get averagePerDay => _averagePerDay;

  set averagePerDay(int value) {
    _averagePerDay = value;
  }

  int get currentStreak => _currentStreak;

  set currentStreak(int value) {
    _currentStreak = value;
  }

  int get highestStreak => _highestStreak;

  set highestStreak(int value) {
    _highestStreak = value;
  }

  String get quoteOfTheDay => _quoteOfTheDay;

  set quoteOfTheDay(String value) {
    _quoteOfTheDay = value;
  }

  int get numPeopleUsedNerdNudge => _numPeopleUsedNerdNudge;

  set numPeopleUsedNerdNudge(int value) {
    _numPeopleUsedNerdNudge = value;
  }

  double get lastFetchTime => _lastFetchTime;

  set lastFetchTime(double value) {
    _lastFetchTime = value;
  }

  String get quoteAuthor => _quoteAuthor;

  set quoteAuthor(String value) {
    _quoteAuthor = value;
  }
}
