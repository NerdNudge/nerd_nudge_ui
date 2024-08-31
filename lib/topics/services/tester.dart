import 'package:flutter/material.dart';
import 'topics_service.dart'; // Ensure this path matches where you have your TopicsService

class TopicsScreen extends StatefulWidget {
  @override
  _TopicsScreenState createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  late Future<dynamic> _topicsFuture;

  @override
  void initState() {
    super.initState();
    // Fetch topics when the widget is initialized
    _topicsFuture = TopicsService().getTopics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Topics'),
      ),
      body: FutureBuilder<dynamic>(
        future: _topicsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While the future is being fetched, show a loading spinner
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there was an error, show an error message
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // If the data was fetched successfully, show the topics
            var topics = snapshot.data['data'] as List<dynamic>;
            return ListView.builder(
              itemCount: topics.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(topics[index]['topicName']),
                );
              },
            );
          } else {
            // If there's no data, show an empty state
            return Center(child: Text('No topics available'));
          }
        },
      ),
    );
  }
}