class ShotsUserActivityAPIEntity {
  String _id = 'abc@gmail.com';
  int _timestamp = 0;
  Map<String, Map<String, int>> _shots = {};
  List<String> _likes = [];
  List<String> _dislikes = [];
  List<String> _shares = [];
  Map<String, Map<String, List<String>>> _favorites = {};

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
