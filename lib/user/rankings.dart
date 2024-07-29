import 'dart:math';

class UserRankings {
  static int _currentRank = 50771;
  static final Random _random = Random();

  static void updateUserRank(String difficultyLevel, bool isCorrect) {
    if(isCorrect) {
      _currentRank -= _getRankToDecrease(difficultyLevel);
    }
    else {
      _currentRank += _getRankToIncrease(difficultyLevel);
    }
  }

  static int getUserRank() {
    return _currentRank;
  }

  static int _getRankToIncrease(String difficultyLevel) {
    switch(difficultyLevel) {
      case 'Easy':
        return _random.nextInt(1200);
      case 'Medium':
        return _random.nextInt(800);
      case 'Hard':
        return _random.nextInt(500);
      default:
        throw Exception('Invalid Difficulty Level.');
    }
  }

  static int _getRankToDecrease(String difficultyLevel) {
    switch(difficultyLevel) {
      case 'Easy':
        return _random.nextInt(500);
      case 'Medium':
        return _random.nextInt(800);
      case 'Hard':
        return _random.nextInt(1200);
      default:
        throw Exception('Invalid Difficulty Level.');
    }
  }
}