class APIEndpoints {
  static const String USER_INSIGHTS_BASE_URL = 'http://NerdNudge-ALB-Public-437225434.ap-southeast-1.elb.amazonaws.com';
  static const String CONTENT_MANAGER_BASE_URL = 'http://NerdNudge-ALB-Public-437225434.ap-southeast-1.elb.amazonaws.com';
  static const String USER_ACTIVITY_BASE_URL = 'http://NerdNudge-ALB-Public-437225434.ap-southeast-1.elb.amazonaws.com';
  static const String USER_RANK_SERVICE_BASE_URL = 'http://NerdNudge-ALB-Public-437225434.ap-southeast-1.elb.amazonaws.com';

  static const String USER_HOME_STATS = '/api/nerdnudge/userinsights/getUserHomePageStats';
  static const String USER_INSIGHTS = '/api/nerdnudge/userinsights/getuserinsights';
  static const String LEADERBOARD = '/api/nerdnudge/userranks/getLeaderBoard';

  static const String QUIZFLEXES = '/api/nerdnudge/quizflexes/getQuizFlexes';
  static const String SHOTS_SUBMISSION = '/api/nerdnudge/useractivity/shotsSubmission';
  static const String QUIZFLEX_SUBMISSION = '/api/nerdnudge/useractivity/quizflexSubmission';
  static const String FAVORITES_SUBMISSION = '/api/nerdnudge/useractivity/favoritesSubmission';
  static const String FAVORITES_QUOTE_SUBMISSION = '/api/nerdnudge/useractivity/favoriteQuoteSubmission';

  static const String RECENT_FAVORITES = '/api/nerdnudge/favorites/getUserRecentFavorites';
  static const String FAVORITE_QUOTES = '/api/nerdnudge/favorites/getUserFavoriteQuotes';
  static const String FAVORITE_TOPICS = '/api/nerdnudge/favorites/getUserFavoriteTopics';

  static const String TOPICS = '/api/nerdnudge/topics/getall';
  static const String SUB_TOPICS = '/api/nerdnudge/topics/getsubtopics';

  static const String USER_FEEDBACK_SUBMISSION = '/api/nerdnudge/useractivity/userFeedbackSubmission';
}