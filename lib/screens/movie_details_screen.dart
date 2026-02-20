import 'package:flutter/material.dart';
import '../services/movie_service.dart';
import '../services/favorites_service.dart';
import '../widgets/movie_shimmer.dart';

class MovieDetailsScreen extends StatefulWidget {
  final String imdbID;

  const MovieDetailsScreen({super.key, required this.imdbID});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  late Future<Map<String, dynamic>> detailsFuture;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    detailsFuture = MovieService.getMovieDetails(widget.imdbID);
    _checkFavorite();
  }

  Future<void> _checkFavorite() async {
    final fav = await FavoritesService.isFavorite(widget.imdbID);
    setState(() => isFavorite = fav);
  }

  Future<void> _toggleFavorite() async {
    await FavoritesService.toggleFavorite(widget.imdbID);
    _checkFavorite();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isFavorite
                ? "Removed from favorites"
                : "Added to favorites",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Movie Details"),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.redAccent,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: detailsFuture,
        builder: (context, snapshot) {
          // ✨ Shimmer loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MovieShimmer();
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading details"));
          }

          final movie = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                // 🎬 Poster
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    movie['Poster'] != "N/A"
                        ? movie['Poster']
                        : "https://via.placeholder.com/300x450",
                    height: 420,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 16),

                // 🎬 Title
                Text(
                  movie['Title'] ?? "",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                // ⭐ Rating
                Text(
                  "⭐ IMDb: ${movie['imdbRating']}",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.amber,
                  ),
                ),

                const SizedBox(height: 16),

                // 📝 Plot
                Text(
                  movie['Plot'] ?? "",
                  style: const TextStyle(fontSize: 15, height: 1.5),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}