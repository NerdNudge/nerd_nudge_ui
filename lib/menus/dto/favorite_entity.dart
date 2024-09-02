import 'package:nerd_nudge/user_profile/dto/user_profile_entity.dart';

class FavoriteUserActivityEntity {
  final String _id = UserProfileEntity().getUserEmail();
  int _timestamp = 0;
  List<String> _likes = [];
  List<String> _dislikes = [];
  List<String> _shares = [];
  Map<String, Map<String, List<String>>> _favoritesToDelete = {};

  void addToDeleteFavorites(String topic, String subtopic, String id) {
    _favoritesToDelete[topic] ??= {};
    _favoritesToDelete[topic]![subtopic] ??= [];
    _favoritesToDelete[topic]![subtopic]!.add(id);
  }

  void undoDeleteFavorite(String topic, String subtopic, String id) {
    _favoritesToDelete[topic]?[subtopic]?.remove(id);
    if (_favoritesToDelete[topic]?[subtopic]?.isEmpty ?? true) {
      _favoritesToDelete[topic]?[subtopic]?.remove(id);
    }
  }

  bool isFavoriteRemovedByUser(String topic, String subtopic, String id) {
    if(_favoritesToDelete[topic]?[subtopic]?.contains(id) ?? false) {
      return true;
    }

    return false;
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

  void _addToArray(List<String> array, String id) {
    if (!array.contains(id)) {
      array.add(id);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': _id,
      'timestamp': _timestamp,
      'favoritesToDelete': _favoritesToDelete,
      'likes': _likes,
      'dislikes': _dislikes,
      'shares': _shares,
    };
  }

  @override
  String toString() {
    return '''
FavoriteUserActivityEntity {
  userId: $_id,
  timestamp: $_timestamp,
  likes: $_likes,
  dislikes: $_dislikes,
  shares: $_shares,
  favoritesToDelete: $_favoritesToDelete
}
    ''';
  }
}