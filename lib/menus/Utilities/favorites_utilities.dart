import 'package:flutter/material.dart';
import '../screens/favorites/recents/recent_favorites_details.dart';
import 'menu_utilities.dart';

class FavoriteUtils {
  static getFavoritesListing(BuildContext context, List<Map<String, dynamic>> favoritesListings) {
    return DefaultTabController(
      length: 2,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  '<< Tap to see more details >>',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                ...favoritesListings.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, dynamic> recentFavorite = entry.value;
                  return Column(
                    children: [
                      MenuUtils.getRecentFavoritesCard(
                        recentFavorite: recentFavorite,
                        onTap: () {
                          print('Challenge ${recentFavorite['topic']} selected');

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecentFavoritesDetails(
                                recentFavorites: favoritesListings,
                                index: index,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          )
        ],
      ),
    );
  }
}