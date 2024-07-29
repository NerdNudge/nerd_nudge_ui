import 'package:flutter/cupertino.dart';

import '../../../Utilities/favorites_utilities.dart';
import '../../../services/favorites/recent_favorites_service.dart';

class FavoriteSubTopics extends StatelessWidget {
  const FavoriteSubTopics({super.key, required this.topic, required this.subtopic});

  final String topic;
  final String subtopic;

  @override
  Widget build(BuildContext context) {
    final subtopicFavorites = RecentFavoritesService().getFavoritesBySubTopics(topic, subtopic);
    return FavoriteUtils.getFavoritesListing(context, subtopicFavorites);
  }
}
