import 'dart:convert';

class SummaryInsightsService {
  var summaryInsights = json.decode('{"lifetime":{"summary":{"rank":12324,"stats":{"easy":68,"medium":21,"hard":5},"accuracy":{"easy":69,"medium":21,"hard":5,"overall":59},"peerComparison":{"Easy":[85.0,70.0,96.0],"Medium":[75.0,65.0,88.0],"Hard":[85.0,95.0,99.0],"userAvg":"85%","peersAvg":"78%","topAvg":"96%"}},"userTopics":["System Design","Java","Kubernetes"]},"last30days":{"summary":{"rank":12324,"stats":{"easy":18,"medium":11,"hard":2},"accuracy":{"easy":75,"medium":55,"hard":59,"overall":65},"peerComparison":{"Easy":[92.0,70.0,96.0],"Medium":[82.0,65.0,88.0],"Hard":[89.0,95.0,99.0],"userAvg":"89%","peersAvg":"78%","topAvg":"96%"}},"userTopics":["System Design","Java"]},"heatmap":{"2024-05-23":20,"2024-05-15":16,"2024-04-13":32,"2024-02-11":39,"2024-06-03":43,"2024-01-23":27,"2024-03-06":8,"2024-04-12":43,"2024-03-18":4,"2024-04-23":41,"2024-04-10":21,"2024-06-30":42,"2024-04-07":50,"2024-05-11":19,"2024-06-07":4,"2024-05-29":30,"2024-04-17":22,"2024-06-19":16,"2024-02-18":19,"2024-03-11":31,"2024-02-14":41,"2024-04-27":20,"2024-07-11":18,"2024-07-01":48,"2024-04-04":33,"2024-02-15":50,"2024-02-09":39,"2024-06-21":25,"2024-05-27":40,"2024-06-28":25,"2024-02-06":29,"2024-02-21":28,"2024-05-14":30,"2024-03-23":25,"2024-05-31":7,"2024-05-28":31,"2024-04-30":7,"2024-03-17":21,"2024-05-08":43,"2024-02-05":10,"2024-02-12":48,"2024-07-02":22,"2024-07-07":26,"2024-06-20":8,"2024-07-16":22,"2024-03-14":20,"2024-01-28":17,"2024-05-12":1,"2024-04-06":48,"2024-05-25":40}}');

  SummaryInsightsService._privateConstructor();
  static final SummaryInsightsService _instance = SummaryInsightsService._privateConstructor();

  factory SummaryInsightsService() {
    return _instance;
  }

  Map<String, dynamic> getUserSummaryInsights() {
    return Map<String, dynamic>.from(summaryInsights);
  }
}