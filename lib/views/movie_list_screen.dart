import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/movie_controller.dart';
import '../models/movie_model.dart';
import '../widgets/movie_card.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final MovieController movieController = Get.find();
  late final TextEditingController searchController;
  final RxString query = ''.obs;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    searchController.addListener(() {
      query.value = searchController.text;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Movie> _filteredMovies(List<Movie> movies, String query) {
    if (query.trim().isEmpty) return movies;
    final lower = query.toLowerCase();
    return movies.where((movie) {
      return movie.judul.toLowerCase().contains(lower) ||
          movie.kategori.toLowerCase().contains(lower);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F0F0F),
      appBar: AppBar(
        title: Text('Movies'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: movieController.fetchMovies,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Obx(() {
        if (movieController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE50914)),
            ),
          );
        }

        final filteredMovies =
            _filteredMovies(movieController.movies, query.value);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: searchController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search movies',
                  hintStyle: TextStyle(color: Color(0xFFB3B3B3)),
                  prefixIcon: Icon(Icons.search, color: Color(0xFFE50914)),
                  filled: true,
                  fillColor: Color(0xFF1A1A1A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            if (query.value.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Hasil untuk "${query.value}" (${filteredMovies.length})',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            Expanded(
              child: filteredMovies.isEmpty
                  ? Center(
                      child: Text(
                        query.value.isEmpty
                            ? 'No movies available.'
                            : 'No matching movies found.',
                        style:
                            TextStyle(color: Color(0xFFB3B3B3), fontSize: 16),
                      ),
                    )
                  : GridView.builder(
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: filteredMovies.length,
                      itemBuilder: (context, index) {
                        return MovieCard(movie: filteredMovies[index]);
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }
}
