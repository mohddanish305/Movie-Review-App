import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';
import '../utils/constants.dart';

class MovieService {
  static Future<List<Movie>> searchMovies(String query) async {
    final url = "$baseUrl?apikey=$omdbApiKey&s=$query";

    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      if (data['Search'] == null) return [];

      return (data['Search'] as List)
          .map((e) => Movie.fromJson(e))
          .toList();
    } else {
      throw Exception("Failed to load movies");
    }
  }

  static Future<Map<String, dynamic>> getMovieDetails(
      String imdbID) async {
    final url = "$baseUrl?apikey=$omdbApiKey&i=$imdbID&plot=full";

    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Failed to load details");
    }
  }
}