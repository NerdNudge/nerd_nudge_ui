import 'package:flutter/material.dart';

import '../../../services/favorites/favorite_topics_service.dart';

class FutureFavoriteTopicsListing extends StatefulWidget {
  const FutureFavoriteTopicsListing({super.key});

  @override
  State<FutureFavoriteTopicsListing> createState() => _FutureFavoriteTopicsListingState();
}

class _FutureFavoriteTopicsListingState extends State<FutureFavoriteTopicsListing> {
  late Future<List<Map<String, dynamic>>> _futureTopics;  // Define a Future for topics

  @override
  void initState() {
    super.initState();
    _futureTopics = _loadTopics();  // Initialize the Future in initState
  }

  Future<List<Map<String, dynamic>>> _loadTopics() async {
    print('Starting to load topics...');
    try {
      final loadedTopics = await FavoriteTopicsService().getFavoritesTopics();
      print('Topics loaded successfully.');
      return loadedTopics;
    } catch (e) {
      print('Error loading topics: $e');
      return [];  // Return an empty list in case of error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Topics'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureTopics,  // Pass the Future to FutureBuilder
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While the Future is loading
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If the Future completed with an error
            return Center(child: Text('Error loading topics.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // If the Future completed but returned no data
            return Center(child: Text('No topics available.'));
          } else {
            // If the Future completed successfully with data
            final topics = snapshot.data!;
            return ListView.builder(
              itemCount: topics.length,
              itemBuilder: (BuildContext context, int index) {
                final topicName = topics[index]['topicName'];
                print('Topic: $topicName');
                return ListTile(
                  title: Text(
                    topicName,
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
