class UserScores {
  static late double _currentScore = 40.0;

  static set currentScore(double value) {
    _currentScore = value;
  }

  static void updateUserScore(String difficultyLevel, bool isCorrect) {
    if(isCorrect) {
      _currentScore += getPointsToAdd(difficultyLevel);
    }
    else {
      _currentScore -= getPointsToDeduct(difficultyLevel);
    }

    _currentScore = double.parse(_currentScore.toStringAsFixed(2));
  }

  static double getUserScore() {
    return _currentScore;
  }

  static double getPointsToAdd(String difficultyLevel) {
    switch(difficultyLevel) {
      case 'Easy':
        return 1.0;
      case 'Medium':
        return 1.2;
      case 'Hard':
        return 1.4;
      default:
        throw Exception('Invalid Difficulty Level.');
    }
  }

  static double getPointsToDeduct(String difficultyLevel) {
    switch(difficultyLevel) {
      case 'Easy':
        return 0.6;
      case 'Medium':
        return 0.4;
      case 'Hard':
        return 0.2;
      default:
        throw Exception('Invalid Difficulty Level.');
    }
  }
}