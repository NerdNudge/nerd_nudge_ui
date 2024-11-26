import '../utilities/logger.dart';

class CacheLockKeys {
  String _quizFlexShotsKey = DateTime.now().toIso8601String();

  CacheLockKeys._privateConstructor();
  static final CacheLockKeys _instance = CacheLockKeys._privateConstructor();

  factory CacheLockKeys() {
    return _instance;
  }

  String getCurrentKey() {
    return _quizFlexShotsKey;
  }

  void updateQuizFlexShotsKey() {
    _quizFlexShotsKey = DateTime.now().toIso8601String();
    NerdLogger.logger.d('Cache keys changed: $_quizFlexShotsKey');
  }

  bool isKeyChanged(String lastKnownKey) {
    return _quizFlexShotsKey != lastKnownKey;
  }

  void resetQuizFlexShotsKey() {
    _quizFlexShotsKey = '';
  }
}