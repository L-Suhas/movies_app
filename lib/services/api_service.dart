import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class ApiService {
  final String apiKey = 'a690119a';  // Insert your OMDb API key

  Future<List<Movie>> fetchMovies(String query) async {
    final url = 'https://www.omdbapi.com/?s=$query&apikey=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['Response'] == 'True') {
        List<Movie> movies = (data['Search'] as List)
            .map((movieJson) => Movie.fromJson(movieJson))
            .toList();
        return movies;
      } else {
        throw Exception('Movie not found');
      }
    } else {
      throw Exception('Failed to load movies');
    }
  }
}
