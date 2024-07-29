import 'dart:convert';

class HomePageService {

  var _quoteOfTheDay = json.decode('{"quote":"Technology is best when it brings people together.","author":"Matt Mullenweg (WordPress co-founder)"}');

  HomePageService._privateConstructor();
  static final HomePageService _instance = HomePageService._privateConstructor();

  factory HomePageService() {
    return _instance;
  }

  getQuoteOfTheDay() {
    return _quoteOfTheDay;
  }
}