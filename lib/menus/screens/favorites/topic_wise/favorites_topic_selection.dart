import 'package:flutter/material.dart';
import '../../../../utilities/logger.dart';
import '../../../../utilities/quiz_topics.dart';
import '../../../../utilities/styles.dart';
import '../../../Utilities/favorites_utilities.dart';
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
    NerdLogger.logger.d('Starting to load topics...');
    try {
      final loadedTopics = await FavoriteTopicsService().getFavoritesTopics();
      NerdLogger.logger.d('Topics loaded successfully.');
      return loadedTopics;
    } catch (e) {
      NerdLogger.logger.e('Error loading topics: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _fetchSubtopics(String topic, String subtopic) async {
    NerdLogger.logger.d('Starting to load subtopics...');
    try {
      final fetchedSubtopicsData = await FavoriteTopicsService().getFavoritesSubtopics(topic, subtopic);
      NerdLogger.logger.d('Subtopics loaded successfully.');
      return fetchedSubtopicsData;
    } catch (e) {
      NerdLogger.logger.e('Error loading subtopics: $e');
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
                            setState(() {
                              tabPlaceholder = _showSubtopicFavoriteDetails(topics[topicindex]['topicName'], subtopics[index]['name']);
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
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Styles.getSizedHeightBox(10),
                                        Text(
                                        subtopics[index]['name'] + ' (' + subtopics[index]['count'].toString() + ')',
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

  _showSubtopicFavoriteDetails(String topic, String subtopic) {
    Future<List<Map<String, dynamic>>> futureSubtopics = _fetchSubtopics(topic, subtopic);
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: futureSubtopics,
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

  _getTopicListingPage(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _futureTopics,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading topics.'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No topics available.'));
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
                                                  const Icon(Icons.favorite,
                                                      size: 16,
                                                      color: Colors.red),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    "Favorite Count: $favoritesCount",
                                                    style: const TextStyle(
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
                                                  const Icon(Icons.list_alt,
                                                      size: 16,
                                                      color: Colors.blueAccent),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    "Favorite Subtopics: ${subtopics.length}",
                                                    style: const TextStyle(
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
