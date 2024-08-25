import 'package:flutter/material.dart';
import '../../../../utilities/quiz_topics.dart';
import '../../../../utilities/styles.dart';
import '../../../services/favorites/favorite_topics_service.dart';

class FavoritesTopicSelectionPage extends StatefulWidget {
  const FavoritesTopicSelectionPage({super.key});

  @override
  State<FavoritesTopicSelectionPage> createState() =>
      _FavoritesTopicSelectionPageState();
}

class _FavoritesTopicSelectionPageState
    extends State<FavoritesTopicSelectionPage> {
  late Future<List<Map<String, dynamic>>> _futureTopics;
  late Widget tabPlaceholder;
  late final topics;

  @override
  void initState() {
    super.initState();
    _futureTopics = _loadTopics();
    tabPlaceholder = _getTopicListingPage(context);
  }

  Future<List<Map<String, dynamic>>> _loadTopics() async {
    print('Starting to load topics...');
    try {
      final loadedTopics = await FavoriteTopicsService().getFavoritesTopics();
      print('Topics loaded successfully.');
      return loadedTopics;
    } catch (e) {
      print('Error loading topics: $e');
      return [];
    }
  }

  _getSubtopicsListingPage(int topicindex) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: Styles.getBackgroundBoxDecoration(),
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemCount: topics[topicindex]['subtopics'].length,
                      itemBuilder: (BuildContext context, int index) {
                        final subtopics = topics[topicindex]['subtopics'];

                        return GestureDetector(
                          onTap: () {
                            // Handle tap to show subtopics or other action
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              side: const BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            color: Colors.white,
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Styles.getSizedHeightBox(10),
                                        Text(
                                          subtopics[index]['name'],
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Styles.getSizedHeightBox(10),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _getTopicListingPage(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _futureTopics,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading topics.'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No topics available.'));
        } else {
          topics = snapshot.data!;
          return Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: Styles.getBackgroundBoxDecoration(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: ListView.builder(
                            itemCount: topics.length,
                            itemBuilder: (BuildContext context, int index) {
                              final topic = topics[index];
                              final topicName = topic['topicName'];
                              final favoritesCount = topic['favoritesCount'];
                              final subtopics = topic['subtopics'];

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    tabPlaceholder =
                                        _getSubtopicsListingPage(index);
                                  });
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    side: const BorderSide(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  color: Colors.white,
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Topics.getIconForTopics(topicName),
                                          size: 40,
                                          color: const Color(0xFF6A69EB),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                topicName,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Icon(Icons.favorite,
                                                      size: 16,
                                                      color: Colors.red),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    "Favorite Count: $favoritesCount",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Icon(Icons.list_alt,
                                                      size: 16,
                                                      color: Colors.blueAccent),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    "Favorite Subtopics: ${subtopics.length}",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Styles.getSizedHeightBox(10),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return tabPlaceholder;
  }
}