class APIEndpoints {
  static const String USER_INSIGHTS_BASE_URL = 'http://localhost:9095';
  static const String CONTENT_MANAGER_BASE_URL = 'http://localhost:9093';
  static const String USER_ACTIVITY_BASE_URL = 'http://localhost:9092';

  static const String USER_HOME_STATS = '/api/nerdnudge/userinsights/getUserHomePageStats/abc3@gmail.com';
  static const String QUIZFLEXES = '/api/nerdnudge/quizflexes/getQuizFlexes';
  static const String SHOTS_SUBMISSION = '/api/nerdnudge/useractivity/shotsSubmission';
  static const String QUIZFLEX_SUBMISSION = '/api/nerdnudge/useractivity/quizflexSubmission';
  static const String FAVORITES_SUBMISSION = '/api/nerdnudge/useractivity/favoritesSubmission';

  static const String RECENT_FAVORITES = '/api/nerdnudge/favorites/getUserRecentFavorites/abc@gmail.com';
}