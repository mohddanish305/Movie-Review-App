import 'package:flutter/material.dart';
import '../services/movie_service.dart';
import '../models/movie_model.dart';
import '../widgets/movie_card.dart';
import 'movie_details_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Movie>>? moviesFuture;
  final TextEditingController searchController = TextEditingController();

  void searchMovie(String query) {
    setState(() {
      moviesFuture = MovieService.searchMovies(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Movies')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              onSubmitted: searchMovie,
              decoration: const InputDecoration(
                hintText: "Search movie (e.g. batman)",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: moviesFuture == null
                ? const Center(child: Text("Search a movie"))
                : FutureBuilder<List<Movie>>(
              future: moviesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text("Error"));
                }

                final movies = snapshot.data!;

                if (movies.isEmpty) {
                  return const Center(child: Text("No results"));
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];

                    return MovieCard(
                      movie: movie,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                MovieDetailsScreen(imdbID: movie.imdbID),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}