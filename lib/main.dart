import 'package:flutter/material.dart';
import 'models/movie.dart';
import 'services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MovieListScreen(),
    );
  }
}

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({Key? key}) : super(key: key);

  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final ApiService apiService = ApiService();
  List<Movie> _movies = [];
  bool _isLoading = false;

  void _fetchMovies(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final movies = await apiService.fetchMovies(query);
      setState(() {
        _movies = movies;
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies App'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search for a movie...',
              ),
              onSubmitted: (query) {
                _fetchMovies(query);
              },
            ),
          ),
          _isLoading
              ? const CircularProgressIndicator()
              : Expanded(
            child: ListView.builder(
              itemCount: _movies.length,
              itemBuilder: (context, index) {
                final movie = _movies[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(movie.poster),
                    title: Text(movie.title),
                    subtitle: Text('Year: ${movie.year}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
