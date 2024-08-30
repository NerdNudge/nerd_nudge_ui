class APIEndpoints {
  static const String USER_INSIGHTS_BASE_URL = 'http://localhost:9095';
  static const String CONTENT_MANAGER_BASE_URL = 'http://localhost:9093';
  static const String USER_ACTIVITY_BASE_URL = 'http://localhost:9092';

  static const String USER_HOME_STATS = '/api/nerdnudge/userinsights/getUserHomePageStats/abc3@gmail.com';
  static const String USER_INSIGHTS = '/api/nerdnudge/userinsights/getuserinsights/abc10002@gmail.com';

  static const String QUIZFLEXES = '/api/nerdnudge/quizflexes/getQuizFlexes';
  static const String SHOTS_SUBMISSION = '/api/nerdnudge/useractivity/shotsSubmission';
  static const String QUIZFLEX_SUBMISSION = '/api/nerdnudge/useractivity/quizflexSubmission';
  static const String FAVORITES_SUBMISSION = '/api/nerdnudge/useractivity/favoritesSubmission';
  static const String FAVORITES_QUOTE_SUBMISSION = '/api/nerdnudge/useractivity/favoriteQuoteSubmission';

  static const String RECENT_FAVORITES = '/api/nerdnudge/favorites/getUserRecentFavorites/abc@gmail.com';
  static const String FAVORITE_QUOTES = '/api/nerdnudge/favorites/getUserFavoriteQuotes/abc@gmail.com';
  static const String FAVORITE_TOPICS = '/api/nerdnudge/favorites/getUserFavoriteTopics/abc@gmail.com';

  static const String TOPICS = '/api/nerdnudge/topics/getall/abc@gmail.com';
  static const String SUB_TOPICS = '/api/nerdnudge/topics/getsubtopics';
}