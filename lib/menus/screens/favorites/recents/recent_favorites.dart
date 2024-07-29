import 'package:flutter/material.dart';
import 'package:nerd_nudge/menus/Utilities/favorites_utilities.dart';
import 'package:nerd_nudge/menus/services/favorites/recent_favorites_service.dart';

class RecentFavorites extends StatelessWidget {
  const RecentFavorites({super.key});

  @override
  Widget build(BuildContext context) {
    final recentFavorites = RecentFavoritesService().getRecentFavorites();
    return FavoriteUtils.getFavoritesListing(context, recentFavorites);
  }
}