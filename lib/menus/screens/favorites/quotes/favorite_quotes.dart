import 'package:flutter/material.dart';
import 'package:nerd_nudge/menus/services/favorites/favorite_quotes_service.dart';
import '../../../../utilities/colors.dart';

import '../../../../utilities/styles.dart';

class FavoriteQuotes extends StatelessWidget {
  FavoriteQuotes({super.key});

  final Map<int, GlobalKey> _cardKeys = {};

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: FavoriteQuotesService().getFavoriteQuotes(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No favorite quotes found.'));
                    } else {
                      return Column(
                        children: snapshot.data!.asMap().entries.map((entry) {
                          int index = entry.key;
                          Map<String, dynamic> thisQuote = entry.value;

                          _cardKeys[index] = GlobalKey();

                          return Column(
                            children: [
                              _buildFavoriteQuoteCard(
                                  thisQuote['quote'],
                                  thisQuote['author'],
                                  _cardKeys[index]!),
                              const SizedBox(height: 8),
                            ],
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFavoriteQuoteCard(String quote, String author, GlobalKey key) {
    return RepaintBoundary(
      key: key,
      child: Card(
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
              const SizedBox(height: 20),
              Text(
                '~ $author',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite_outlined, color: Colors.white),
                    onPressed: () {
                      // Handle favorite action
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.share, color: Colors.white),
                    onPressed: () {
                      Styles.shareCardContent(key);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}