import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/movie_controller.dart';
import '../controllers/auth_controller.dart';
import '../models/movie_model.dart';
import '../widgets/trailer_popup.dart';

class DetailScreen extends StatelessWidget {
  final String id;
  final MovieController movieController = Get.find();
  final AuthController authController = Get.find();

  DetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    Movie? movie = movieController.movies.firstWhereOrNull((m) => m.id == id);

    if (movie == null) {
      return Scaffold(
        body: Center(child: Text('Movie not found')),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFF0F0F0F),
      appBar: AppBar(
        title: Text(movie.judul),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover
            Container(
              height: 250,
              width: double.infinity,
              child: Image.network(
                movie.gambarSampul,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Color(0xFF333333),
                    child: Center(child: Icon(Icons.broken_image, size: 50)),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.judul,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Color(0xFFFFD700), size: 20),
                      SizedBox(width: 4),
                      Text(
                        '${movie.skorRating}',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(width: 16),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Color(0xFFE50914),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          movie.kategori,
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Ringkasan:',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    movie.ringkasan,
                    style: TextStyle(color: Color(0xFFB3B3B3), height: 1.5),
                  ),
                  SizedBox(height: 24),
                  if (movie.urlTrailer.isNotEmpty)
                    ElevatedButton.icon(
                      onPressed: () {
                        showTrailerPopup(movie.urlTrailer);
                      },
                      icon: Icon(Icons.play_arrow),
                      label: Text('WATCH TRAILER'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE50914),
                      ),
                    ),
                  SizedBox(height: 16),
                  Obx(() => authController.isAdmin
                      ? Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => Get.toNamed('/edit-movie/$id'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF1A1A1A),
                                ),
                                child: Text('✏ EDIT'),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.defaultDialog(
                                    title: 'Hapus Film',
                                    middleText: 'Yakin ingin menghapus film ini?',
                                    textConfirm: 'Hapus',
                                    textCancel: 'Batal',
                                    confirmTextColor: Colors.white,
                                onConfirm: () async {
                                      Get.back();
                                      bool success = await movieController.deleteMovie(id);
                                      if (success) {
                                        Get.offAllNamed('/home');
                                        Get.snackbar('Berhasil', 'Film berhasil dihapus',
                                            backgroundColor: Color(0xFF1A1A1A),
                                            colorText: Colors.white,
                                            snackPosition: SnackPosition.BOTTOM);
                                      }
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: Text('🗑 DELETE'),
                              ),
                            ),
                          ],
                        )
                      : SizedBox.shrink()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}