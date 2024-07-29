class HomePageInfoDto {
  late int _totalQuizFlexes;
  late double _percentageCorrect;
  late int _highestInADay;
  late int _highestCorrectInADay;
  late int _currentStreak;
  late int _highestStreak;
  late int _quizzesRemaining;
  late int _shotsRemaining;
  late String _quoteOfTheDay;
  late int _numPeopleUsedNerdNudgeToday;

  late double _lastFetchTime;

  int get totalQuizFlexes => _totalQuizFlexes;

  set totalQuizFlexes(int value) {
    _totalQuizFlexes = value;
  }

  double get percentageCorrect => _percentageCorrect;

  int get numPeopleUsedNerdNudgeToday => _numPeopleUsedNerdNudgeToday;

  set numPeopleUsedNerdNudgeToday(int value) {
    _numPeopleUsedNerdNudgeToday = value;
  }

  String get quoteOfTheDay => _quoteOfTheDay;

  set quoteOfTheDay(String value) {
    _quoteOfTheDay = value;
  }

  int get shotsRemaining => _shotsRemaining;

  set shotsRemaining(int value) {
    _shotsRemaining = value;
  }

  int get quizzesRemaining => _quizzesRemaining;

  set quizzesRemaining(int value) {
    _quizzesRemaining = value;
  }

  int get highestStreak => _highestStreak;

  set highestStreak(int value) {
    _highestStreak = value;
  }

  int get currentStreak => _currentStreak;

  set currentStreak(int value) {
    _currentStreak = value;
  }

  int get highestCorrectInADay => _highestCorrectInADay;

  set highestCorrectInADay(int value) {
    _highestCorrectInADay = value;
  }

  int get highestInADay => _highestInADay;

  set highestInADay(int value) {
    _highestInADay = value;
  }

  set percentageCorrect(double value) {
    _percentageCorrect = value;
  }
}