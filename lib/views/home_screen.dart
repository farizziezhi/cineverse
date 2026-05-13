import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/movie_controller.dart';
import '../controllers/auth_controller.dart';
import '../models/movie_model.dart';
import '../widgets/movie_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MovieController movieController = Get.find();
  final AuthController authController = Get.find();
  late PageController _pageController;
  var _currentPage = 0.obs;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    Future.delayed(Duration(seconds: 3), _autoSlide);
  }

  void _autoSlide() {
    if (!mounted) return;
    final topCount = movieController.movies.length < 5
        ? movieController.movies.length
        : 5;
    if (topCount == 0) {
      Future.delayed(Duration(seconds: 3), _autoSlide);
      return;
    }
    if (_pageController.hasClients) {
      int nextPage = (_currentPage.value + 1) % topCount;
      _pageController.animateToPage(
        nextPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      _currentPage.value = nextPage;
    }
    Future.delayed(Duration(seconds: 3), _autoSlide);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F0F0F),
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.movie, color: Color(0xFFE50914)),
            SizedBox(width: 8),
            Text('CineVerse'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => Get.snackbar('Info', 'Fitur search coming soon'),
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => Get.toNamed('/profile'),
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

        if (movieController.movies.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.movie, size: 80, color: Color(0xFFB3B3B3)),
                SizedBox(height: 16),
                Text('No Movies Found 🎬',
                    style: TextStyle(color: Color(0xFFB3B3B3), fontSize: 16)),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Get.toNamed('/add-movie'),
                  child: Text('Add Your First Movie'),
                ),
              ],
            ),
          );
        }

        List<Movie> topMovies = [...movieController.movies]
          ..sort((a, b) => b.skorRating.compareTo(a.skorRating));
        topMovies = topMovies.take(5).toList();

        return CustomScrollView(
          slivers: [
            // FEATURED BANNER
            SliverToBoxAdapter(
              child: SizedBox(
                height: 280,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: topMovies.length,
                  onPageChanged: (index) => _currentPage.value = index,
                  itemBuilder: (context, index) {
                    final movie = topMovies[index];
                    return GestureDetector(
                      onTap: () => Get.toNamed('/detail/${movie.id}'),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: NetworkImage(movie.gambarSampul),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.4),
                              BlendMode.darken,
                            ),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.9),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFE50914),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text('★ ${movie.skorRating}',
                                        style: TextStyle(color: Colors.white, fontSize: 12)),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    movie.judul,
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(movie.kategori,
                                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                                  SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Icon(Icons.play_circle, color: Color(0xFFE50914), size: 20),
                                      SizedBox(width: 8),
                                      Text('Watch Now', style: TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Indicator dots
            SliverToBoxAdapter(
              child: Obx(() => Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    topMovies.length,
                    (index) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage.value == index ? 16 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: _currentPage.value == index
                            ? Color(0xFFE50914)
                            : Color(0xFFB3B3B3),
                      ),
                    ),
                  ),
                ),
              )),
            ),

            // Category Row
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Popular Movies',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.snackbar('Info', 'See all movies coming soon'),
                      child: Text('See All >', style: TextStyle(color: Color(0xFFE50914))),
                    ),
                  ],
                ),
              ),
            ),

            // Movie Grid
            SliverPadding(
              padding: EdgeInsets.all(16),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => MovieCard(movie: movieController.movies[index]),
                  childCount: movieController.movies.length,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/add-movie'),
        backgroundColor: Color(0xFFE50914),
        child: Icon(Icons.add),
      ),
    );
  }
}
