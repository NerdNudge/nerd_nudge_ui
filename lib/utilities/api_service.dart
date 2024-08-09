import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nerd_nudge/utilities/api_end_points.dart';

class ApiService {

  Future<dynamic> getRequest(String endpoint) async {
    const String baseURL = APIEndpoints.BASE_URL;
    final response = await http.get(Uri.parse('$baseURL$endpoint'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> postRequest(String endpoint, Map<String, dynamic> data) async {
    const String baseURL = APIEndpoints.BASE_URL;
    final response = await http.post(
      Uri.parse('$baseURL$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to post data');
    }
  }
}