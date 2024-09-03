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
  late String _quoteId = '';
  late int _numPeopleUsedNerdNudge = 0;
  late double _lastFetchTime = 0.0;
  late int _adsFrequencyQuizFlex = 7;
  late int _adsFrequencyShots = 9;
  late int _quizflexQuota = 12;

  int get quizflexQuota => _quizflexQuota;

  set quizflexQuota(int value) {
    _quizflexQuota = value;
  }

  late int _shotsQuota = 15;

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
    instance._quoteId = jsonData['quoteId'] ?? '';
    instance._numPeopleUsedNerdNudge = jsonData['numPeopleUsedNerdNudgeToday'] ?? 0;
    instance._adsFrequencyQuizFlex = jsonData['adsFrequencyQuizFlex'] ?? 7;
    instance._adsFrequencyShots = jsonData['adsFrequencyShots'] ?? 7;
    instance._quizflexQuota = jsonData['quizflexQuota'] ?? 12;
    instance._shotsQuota = jsonData['shotsQuota'] ?? 15;

    return instance;
  }

  static AccountType _getFromAccountTypeEnum(String accountType) {
    switch (accountType.toLowerCase()) {
      case 'freemium':
        return AccountType.FREEMIUM;
      case 'nerdNudgePro':
        return AccountType.NERD_NUDGE_PRO;
      case 'nerdNudgeMax':
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
    return _getTotalNerdQuizQuota() - _quizCountToday;
  }

  getDailyShotsRemaining() {
    return _getTotalNerdShotsQuota() - _shotsCountToday;
  }

  _getTotalNerdQuizQuota() {
    return _quizflexQuota;
  }

  _getTotalNerdShotsQuota() {
    return _shotsQuota;
  }

  void incrementQuizCount() {
    _quizCountToday++;
  }

  void incrementShotsCount() {
    _shotsCountToday++;
  }

  bool hasUserExhaustedNerdShots() {
    return _shotsCountToday >= _getTotalNerdShotsQuota();
  }

  bool hasUserExhaustedNerdQuiz() {
    return _quizCountToday >= _getTotalNerdQuizQuota();
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

  int get adsFrequencyQuizFlex => _adsFrequencyQuizFlex;

  set adsFrequencyQuizFlex(int value) {
    _adsFrequencyQuizFlex = value;
  }

  int get adsFrequencyShots => _adsFrequencyShots;

  set adsFrequencyShots(int value) {
    _adsFrequencyShots = value;
  }

  double get lastFetchTime => _lastFetchTime;

  set lastFetchTime(double value) {
    _lastFetchTime = value;
  }

  String get quoteAuthor => _quoteAuthor;

  set quoteAuthor(String value) {
    _quoteAuthor = value;
  }

  String get quoteId => _quoteId;

  set quoteId(String value) {
    _quoteId = value;
  }

  int get shotsQuota => _shotsQuota;

  set shotsQuota(int value) {
    _shotsQuota = value;
  }
}
