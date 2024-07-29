import 'package:flutter/material.dart';
import 'package:nerd_nudge/menus/services/favorites/favorite_quotes_service.dart';
import '../../../../utilities/colors.dart';

class FavoriteQuotes extends StatelessWidget {
  const FavoriteQuotes({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteQuotes = FavoriteQuotesService().getFavoriteQuotes();

    return DefaultTabController(
      length: 1,
      child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  ...favoriteQuotes.map((thisQuote) {
                    return Column(
                      children: [
                        _buildFavoriteQuoteCard(
                            thisQuote['quote'], thisQuote['author']),
                        SizedBox(
                          height: 8,
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

  Widget _buildFavoriteQuoteCard(String quote, String author) {
    return Card(
      color: CustomColors.purpleButtonColor,
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              quote,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              '~ $author',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.favorite_border, color: Colors.white),
                  onPressed: () {
                    // Handle favorite action
                  },
                ),
                IconButton(
                  icon: Icon(Icons.share, color: Colors.white),
                  onPressed: () {
                    // Handle share action
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}