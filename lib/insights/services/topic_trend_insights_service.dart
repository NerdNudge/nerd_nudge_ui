
import '../../utilities/logger.dart';

class TopicTrendInsightsService {
  TopicTrendInsightsService._privateConstructor();
  static final TopicTrendInsightsService _instance =
      TopicTrendInsightsService._privateConstructor();

  factory TopicTrendInsightsService() {
    return _instance;
  }

  Map<String, dynamic> getTopicTrendInsights(
      String topic, String type, Map<String, dynamic> userTrendsObject) {
    Map<String, dynamic> trendData = {};
    NerdLogger.logger.d('input: $userTrendsObject');

    if (!userTrendsObject.containsKey('userTrends')) {
      return trendData;
    }

    Map<String, dynamic> topicsTrendData = userTrendsObject['userTrends'];
    if (topicsTrendData.containsKey(topic)) {
      Map<String, dynamic> topicData = topicsTrendData[topic];

      trendData = topicData.map((key, value) {
        int dayOfYear = int.parse(key.substring(0, 3));
        int year = 2000 +
            int.parse(key.substring(3, 5));

        DateTime date = DateTime(year).add(Duration(days: dayOfYear - 1));
        String formattedDate =
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

        if (type == 'Score') {
          return MapEntry(formattedDate, (value[0] as num).toDouble());
        } else if (type == 'Rank') {
          return MapEntry(formattedDate, (value[1] as num).toDouble());
        } else {
          return MapEntry(
              formattedDate, 0.0); // Default case, can be customized
        }
      });
    }

    NerdLogger.logger.d('returning: $trendData');
    return trendData;
  }
}
