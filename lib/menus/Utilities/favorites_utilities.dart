import 'package:flutter/material.dart';
import 'package:nerd_nudge/menus/screens/favorites/favoriteCommons/favorites_details_swiped.dart';
import 'package:nerd_nudge/utilities/styles.dart';
import 'menu_utilities.dart';

class FavoriteUtils {
  static getFavoritesListing(BuildContext context, List<Map<String, dynamic>> favoritesListings) {
    return DefaultTabController(
      length: 1,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  '<< Tap to see more details >>',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Styles.getSizedHeightBox(15),
                ...favoritesListings.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, dynamic> recentFavorite = entry.value;
                  return Column(
                    children: [
                      MenuUtils.getRecentFavoritesCard(
                        recentFavorite: recentFavorite,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FavoritesDetailsSwiped(
                                favorites: favoritesListings,
                                index: index,
                              ),
                            ),
                          );
                        },
                      ),
                      Styles.getSizedHeightBox(15),
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