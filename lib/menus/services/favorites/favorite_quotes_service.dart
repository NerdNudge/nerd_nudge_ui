import 'dart:convert';

import '../../../utilities/api_end_points.dart';
import '../../../utilities/api_service.dart';

class FavoriteQuotesService {
  var favoriteQuotes = json.decode('[{"quote":"Technology is best when it brings people together.","author":"Matt Mullenweg (WordPress co-founder)"},{"quote":"It has become appallingly obvious that our technology has exceeded our humanity.","author":"Albert Einstein (Theoretical Physicist)"},{"quote":"The science of today is the technology of tomorrow.","author":"Edward Teller (Physicist)"},{"quote":"Technology is a useful servant but a dangerous master.","author":"Christian Lous Lange (Historian)"},{"quote":"Any sufficiently advanced technology is indistinguishable from magic.","author":"Arthur C. Clarke (Writer and Futurist)"},{"quote":"The great myth of our times is that technology is communication.","author":"Libby Larsen (Composer)"},{"quote":"Technology is nothing. What’s important is that you have a faith in people.","author":"Steve Jobs (Apple co-founder)"},{"quote":"We are stuck with technology when what we really want is just stuff that works.","author":"Douglas Adams (Writer)"},{"quote":"It’s not a faith in technology. It’s faith in people.","author":"Steve Jobs (Apple co-founder)"},{"quote":"Technology made large populations possible; large populations now make technology indispensable.","author":"Joseph Wood Krutch (Writer and Naturalist)"}]');

  FavoriteQuotesService._privateConstructor();

  static final FavoriteQuotesService _instance = FavoriteQuotesService._privateConstructor();

  factory FavoriteQuotesService() {
    return _instance;
  }

  List<Map<String, dynamic>> getFavoriteQuotes_1() {
    return List<Map<String, dynamic>>.from(favoriteQuotes);
  }

  Future<List<Map<String, dynamic>>> getFavoriteQuotes() async {
    print('getting Favorite quotes data now..');
    final ApiService apiService = ApiService();
    dynamic result;
    try {
      final String url = APIEndpoints.USER_INSIGHTS_BASE_URL + APIEndpoints.FAVORITE_QUOTES;
      print('Sending GET request to: $url');
      result = await apiService.getRequest(APIEndpoints.USER_INSIGHTS_BASE_URL, APIEndpoints.FAVORITE_QUOTES);
      print('API Result: $result');

      if (result is Map<String, dynamic>) {
        return List<Map<String, dynamic>>.from(result['data']);
      } else if (result is String) {
        Map<String, dynamic> decodedResult = json.decode(result);
        return List<Map<String, dynamic>>.from(decodedResult['data']);
      } else {
        throw const FormatException("Unexpected response format");
      }
    } catch (e) {
      print('Error during getRecentFavorites: $e');
      throw e;
    }
  }
}