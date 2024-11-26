import 'package:nerd_nudge/user_profile/dto/user_profile_entity.dart';

class QuizflexUserActivityAPIEntity {

  static final QuizflexUserActivityAPIEntity _instance = QuizflexUserActivityAPIEntity._internal();

  factory QuizflexUserActivityAPIEntity() {
    return _instance;
  }

  QuizflexUserActivityAPIEntity._internal() {
    _initialize();
  }

  final String _id = UserProfileEntity().getUserEmail();
  final String _fullName = UserProfileEntity().getUserFullName();
  int _timestamp = 0;
  static Map<String, Map<String, List<String>>> _quizflex = {};
  static List<String> _likes = [];
  static List<String> _dislikes = [];
  static List<String> _shares = [];
  static Map<String, Map<String, List<String>>> _favorites = {};

  void _initialize() {
    _quizflex.clear();
    _likes.clear();
    _dislikes.clear();
    _shares.clear();
    _favorites.clear();
    _timestamp = 0;
  }

  void clearData() {
    _initialize();
    print('Data cleared: $this');
  }

  bool isFavoriteByUser(String topic, String subtopic, String id) {
    if(! _favorites.containsKey(topic)) {
      return false;
    }

    if(! _favorites[topic]!.containsKey(subtopic)) {
      return false;
    }

    return _favorites[topic]?[subtopic]?.contains(id) ?? false;
  }

  bool isLikedByUser(String id) {
    return _likes.contains(id);
  }

  bool isDisLikedByUser(String id) {
    return _dislikes.contains(id);
  }

  bool isSharedByUser(String id) {
    return _shares.contains(id);
  }


  void addFavorite(String topic, String subtopic, String id) {
    _favorites[topic] ??= {};
    _favorites[topic]![subtopic] ??= [];
    _favorites[topic]![subtopic]!.add(id);
  }

  void removeFavorite(String topic, String subtopic, String id) {
    _favorites[topic]?[subtopic]?.remove(id);
    if (_favorites[topic]?[subtopic]?.isEmpty ?? true) {
      _favorites[topic]?[subtopic]?.remove(id);
    }
  }

  void addQuizflex(String topic, String subtopic, String quizId,
      String difficulty, bool isCorrect) {
    Map<String, List<String>>? topicObject =
        (_quizflex.containsKey(topic)) ? _quizflex[topic] : {};
    List<String>? currentQuizflex =
        (topicObject!.containsKey(subtopic)) ? topicObject[subtopic] : [];

    currentQuizflex?.add(subtopic);
    currentQuizflex?.add(difficulty);
    currentQuizflex?.add((isCorrect) ? 'Y' : 'N');

    topicObject[quizId] = currentQuizflex!;
    _quizflex[topic] = topicObject;
  }

  void addLike(String id) {
    _addToArray(_likes, id);
  }

  void removeLike(String id) {
    _likes.remove(id);
  }

  void addDislike(String id) {
    _addToArray(_dislikes, id);
  }

  void removeDislike(String id) {
    _dislikes.remove(id);
  }

  void addShare(String id) {
    _addToArray(_shares, id);
  }

  void removeShare(String id) {
    _shares.remove(id);
  }

  void _addToArray(List<String> array, String id) {
    if (!array.contains(id)) {
      array.add(id);
    }
  }

  bool isQuizflexEmpty() {
    return _quizflex.isEmpty;
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': _id,
      'userFullName': _fullName,
      'timestamp': _timestamp,
      'quizflex': _quizflex,
      'favorites': _favorites,
      'likes': _likes,
      'dislikes': _dislikes,
      'shares': _shares,
    };
  }

  @override
  String toString() {
    return '''
QuizflexUserActivityAPIEntity {
  userId: $_id,
  userFullName: $_fullName,
  timestamp: $_timestamp,
  quizflex: $_quizflex,
  likes: $_likes,
  dislikes: $_dislikes,
  shares: $_shares,
  favorites: $_favorites
}
    ''';
  }
}
