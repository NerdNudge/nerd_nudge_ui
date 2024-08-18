import 'package:flutter/material.dart';
import 'package:nerd_nudge/menus/Utilities/favorites_utilities.dart';
import 'package:nerd_nudge/menus/services/favorites/favorites_service.dart';

class RecentFavorites extends StatelessWidget {
  const RecentFavorites({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: FavoritesService().getRecentFavorites(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No favorites found.'));
        } else {
          return FavoriteUtils.getFavoritesListing(context, snapshot.data!);
        }
      },
    );
  }
}