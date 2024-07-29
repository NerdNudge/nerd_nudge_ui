import 'dart:convert';

class MyChallengesService {

  var myActiveChallenges = json.decode('[{"id":"DSA_AQ74K9o","owner":"NerdNudge","name":"DSA Mastery","prizes":100,"type":"Data Structures and Algorithms","description":"Challenge to top the charts for DSA","startDate":"2024-07-05","endDate":"2024-08-05","members":332,"leaderboard":[{"name":"Ajay","score":123.2,"time":1009.23,"correct":89.88},{"name":"Vijay","score":121.3,"time":1009.23,"correct":89.88},{"name":"Ramesh","score":121.1,"time":1009.23,"correct":89.88},{"name":"Suresh","score":112.9,"time":1009.23,"correct":89.88},{"name":"Mathew Something Mark","score":111.2,"time":1009.23,"correct":89.88},{"name":"Mark","score":109.2,"time":1009.23,"correct":89.88},{"name":"Luke","score":108.4,"time":1009.23,"correct":89.88},{"name":"Jaden","score":106.3,"time":1009.23,"correct":89.88},{"name":"Will","score":105.2,"time":1009.23,"correct":89.88},{"name":"Bruce","score":105.1,"time":1009.23,"correct":89.88},{"name":"Ajay","score":123.2,"time":1009.23,"correct":89.88},{"name":"Vijay","score":121.3,"time":1009.23,"correct":89.88},{"name":"Ramesh","score":121.1,"time":1009.23,"correct":89.88},{"name":"Suresh","score":112.9,"time":1009.23,"correct":89.88},{"name":"Mathew","score":111.2,"time":1009.23,"correct":89.88},{"name":"Mark","score":109.2,"time":1009.23,"correct":89.88},{"name":"Luke","score":108.4,"time":1009.23,"correct":89.88},{"name":"Jaden","score":106.3,"time":1009.23,"correct":89.88},{"name":"Will","score":105.2,"time":1009.23,"correct":89.88},{"name":"Bruce","score":105.1,"time":1009.23,"correct":89.88}]},{"id":"Py_AQ74K9o","owner":"NerdNudge","name":"Python Mastery","prizes":100,"type":"Python","description":"Master the Python Programming language","startDate":"2024-07-20","endDate":"2024-08-20","members":1892,"leaderboard":[{"name":"Ajay","score":123.2,"time":1009.23,"correct":89.88},{"name":"Vijay","score":121.3,"time":1009.23,"correct":89.88},{"name":"Ramesh","score":121.1,"time":1009.23,"correct":89.88},{"name":"Suresh","score":112.9,"time":1009.23,"correct":89.88},{"name":"Mathew Something Mark","score":111.2,"time":1009.23,"correct":89.88},{"name":"Mark","score":109.2,"time":1009.23,"correct":89.88},{"name":"Luke","score":108.4,"time":1009.23,"correct":89.88},{"name":"Jaden","score":106.3,"time":1009.23,"correct":89.88},{"name":"Will","score":105.2,"time":1009.23,"correct":89.88},{"name":"Bruce","score":105.1,"time":1009.23,"correct":89.88},{"name":"Ajay","score":123.2,"time":1009.23,"correct":89.88},{"name":"Vijay","score":121.3,"time":1009.23,"correct":89.88},{"name":"Ramesh","score":121.1,"time":1009.23,"correct":89.88},{"name":"Suresh","score":112.9,"time":1009.23,"correct":89.88},{"name":"Mathew","score":111.2,"time":1009.23,"correct":89.88},{"name":"Mark","score":109.2,"time":1009.23,"correct":89.88},{"name":"Luke","score":108.4,"time":1009.23,"correct":89.88},{"name":"Jaden","score":106.3,"time":1009.23,"correct":89.88},{"name":"Will","score":105.2,"time":1009.23,"correct":89.88},{"name":"Bruce","score":105.1,"time":1009.23,"correct":89.88}]},{"id":"SD_AQ74K9o","owner":"NerdNudge","name":"System Design Mastery","prizes":100,"type":"System Design","description":"Mastering System Design","startDate":"2024-06-20","endDate":"2024-07-05","members":1892,"leaderboard":[{"name":"Ajay","score":123.2,"time":1009.23,"correct":89.88},{"name":"Vijay","score":121.3,"time":1009.23,"correct":89.88},{"name":"Ramesh","score":121.1,"time":1009.23,"correct":89.88},{"name":"Suresh","score":112.9,"time":1009.23,"correct":89.88},{"name":"Mathew Something Mark","score":111.2,"time":1009.23,"correct":89.88},{"name":"Mark","score":109.2,"time":1009.23,"correct":89.88},{"name":"Luke","score":108.4,"time":1009.23,"correct":89.88},{"name":"Jaden","score":106.3,"time":1009.23,"correct":89.88},{"name":"Will","score":105.2,"time":1009.23,"correct":89.88},{"name":"Bruce","score":105.1,"time":1009.23,"correct":89.88},{"name":"Ajay","score":123.2,"time":1009.23,"correct":89.88},{"name":"Vijay","score":121.3,"time":1009.23,"correct":89.88},{"name":"Ramesh","score":121.1,"time":1009.23,"correct":89.88},{"name":"Suresh","score":112.9,"time":1009.23,"correct":89.88},{"name":"Mathew","score":111.2,"time":1009.23,"correct":89.88},{"name":"Mark","score":109.2,"time":1009.23,"correct":89.88},{"name":"Luke","score":108.4,"time":1009.23,"correct":89.88},{"name":"Jaden","score":106.3,"time":1009.23,"correct":89.88},{"name":"Will","score":105.2,"time":1009.23,"correct":89.88},{"name":"Bruce","score":105.1,"time":1009.23,"correct":89.88}]}]');

  MyChallengesService._privateConstructor();
  static final MyChallengesService _instance = MyChallengesService._privateConstructor();

  factory MyChallengesService() {
    return _instance;
  }

  List<Map<String, dynamic>> getAllMyChallenges() {
    return List<Map<String, dynamic>>.from(myActiveChallenges).toList();
  }

  Set<String> getAllMyChallengeIds() {
    return myActiveChallenges.map<String>((challenge) => challenge['id'].toString()).toSet();
  }

  List<Map<String, dynamic>> getMyActiveChallenges() {
    DateTime currentDate = DateTime.now();
    return List<Map<String, dynamic>>.from(myActiveChallenges).where((challenge) {
      DateTime startDate = DateTime.parse(challenge['startDate']);
      DateTime endDate = DateTime.parse(challenge['endDate']);
      return startDate.isBefore(currentDate) && endDate.isAfter(currentDate);
    }).toList();
  }

  List<Map<String, dynamic>> getMyUpcomingChallenges() {
    DateTime currentDate = DateTime.now();
    return List<Map<String, dynamic>>.from(myActiveChallenges).where((challenge) {
      DateTime startDate = DateTime.parse(challenge['startDate']);
      return startDate.isAfter(currentDate);
    }).toList();
  }

  List<Map<String, dynamic>> getMyCompletedChallenges() {
    DateTime currentDate = DateTime.now();
    return List<Map<String, dynamic>>.from(myActiveChallenges).where((challenge) {
      DateTime endDate = DateTime.parse(challenge['endDate']);
      return endDate.isBefore(currentDate);
    }).toList();
  }
}