import 'dart:convert';

class TopicTrendInsightsService {
  var topicScoreTrend = json.decode(
      '{"status":"SUCCESS","frequency":"Weekly","score_trend":{"2024-06-18":24.5,"2024-06-19":27.8,"2024-06-20":53.4,"2024-06-21":31.7,"2024-06-22":36.9,"2024-06-23":44.3,"2024-06-24":28.1,"2024-06-25":52.6,"2024-06-26":39.2,"2024-06-27":25.4,"2024-06-28":46.7,"2024-06-29":33.9,"2024-06-30":40.5},"rank_trend":{"2024-06-18":1243,"2024-06-19":1123,"2024-06-20":1455,"2024-06-21":1090,"2024-06-22":875,"2024-06-23":999,"2024-06-24":761,"2024-06-25":621,"2024-06-26":555,"2024-06-27":590,"2024-06-28":432,"2024-06-29":499,"2024-06-30":401}}');

  TopicTrendInsightsService._privateConstructor();
  static final TopicTrendInsightsService _instance =
  TopicTrendInsightsService._privateConstructor();

  factory TopicTrendInsightsService() {
    return _instance;
  }

  Map<String, double> getTopicTrend(String topic, String type) {
    Map<String, dynamic> trend;
    if(type == 'Score')
      trend = topicScoreTrend['score_trend'];
    else
      trend = topicScoreTrend['rank_trend'];

    return trend.map((key, value) => MapEntry(key, (value as num).toDouble()));
  }
}