import '../../user_profile/dto/user_profile_entity.dart';

class ShotsUserActivityAPIEntity {

  static final ShotsUserActivityAPIEntity _instance = ShotsUserActivityAPIEntity._internal();

  factory ShotsUserActivityAPIEntity() {
    return _instance;
  }

  ShotsUserActivityAPIEntity._internal() {
    _initialize();
  }

  final String _id = UserProfileEntity().getUserEmail();
  int _timestamp = 0;
  Map<String, Map<String, int>> _shots = {};
  List<String> _likes = [];
  List<String> _dislikes = [];
  List<String> _shares = [];
  Map<String, Map<String, List<String>>> _favorites = {};

  void _initialize() {
    _shots.clear();
    _likes.clear();
    _dislikes.clear();
    _favorites.clear();
    _shares.clear();
  }

  void clear() {
    _initialize();
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

  bool isFavoriteByUser(String topic, String subtopic, String id) {
    if(! _favorites.containsKey(topic))
      return false;

    if(! _favorites[topic]!.containsKey(subtopic))
      return false;

    return _favorites[topic]?[subtopic]?.contains(id) ?? false;
  }


  void incrementShot(String topic, String subtopic) {
    Map<String, int>? topicObject;
    if (_shots.containsKey(topic)) {
      topicObject = _shots[topic];
    } else {
      topicObject = {};
    }

    int? currentSubtopic = 0;
    if (topicObject!.containsKey(subtopic)) {
      currentSubtopic = topicObject[subtopic];
    }

    topicObject[subtopic] = (currentSubtopic! + 1)!;
    _shots[topic] = topicObject;
  }


  void decrementShot(String topic, String subtopic) {
    Map<String, int>? topicObject;
    if (!_shots.containsKey(topic)) {
      return;
    }

    print('existing: $_shots[$topic]');
    topicObject = _shots[topic];

    if (!topicObject!.containsKey(subtopic)) {
      return;
    }

    int? currentSubtopic = topicObject[subtopic];

    topicObject[subtopic] = (currentSubtopic! - 1)!;
    _shots[topic] = topicObject;
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

  bool isShotsEmpty() {
    return _shots.isEmpty;
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': _id,
      'timestamp': _timestamp,
      'shots': _shots,
      'favorites': _favorites,
      'likes': _likes,
      'dislikes': _dislikes,
      'shares': _shares,
    };
  }

  @override
  String toString() {
    return '''
ShotsUserActivityAPIEntity {
  userId: $_id,
  timestamp: $_timestamp,
  shots: $_shots,
  likes: $_likes,
  dislikes: $_dislikes,
  shares: $_shares,
  favorites: $_favorites
}
    ''';
  }
}
