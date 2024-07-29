import 'dart:convert';

class NerdNudgeChallengesService {
  var nerdChallenges = json.decode('[{"id":"DSA_AQ74K9o","owner":"NerdNudge","name":"DSA Mastery","prizes":100,"type":"Data Structures and Algorithms","description":"Challenge to top the charts for DSA","startDate":"01-07-2024","endDate":"31-07-2024","members":332},{"id":"SD_AQ74K9o","owner":"NerdNudge","name":"System Design Mastery","prizes":50,"type":"System Design","description":"Master System Design","startDate":"15-07-2024","endDate":"15-08-2024","members":189},{"id":"Py_AQ74K9o","owner":"NerdNudge","name":"Python Mastery","prizes":100,"type":"Python","description":"Master the Python Programming language","startDate":"20-07-2024","endDate":"10-08-2024","members":1892},{"id":"Java_AQ74K9o","owner":"NerdNudge","name":"Java Language Mastery","prizes":200,"type":"Java","description":"Master the Java Programming language","startDate":"30-07-2024","endDate":"30-08-2024","members":2892}]');

  NerdNudgeChallengesService._privateConstructor();
  static final NerdNudgeChallengesService _instance = NerdNudgeChallengesService._privateConstructor();

  factory NerdNudgeChallengesService() {
    return _instance;
  }

  List<Map<String, dynamic>> getNerdNudgeChallenges() {
    return List<Map<String, dynamic>>.from(nerdChallenges);
  }
}