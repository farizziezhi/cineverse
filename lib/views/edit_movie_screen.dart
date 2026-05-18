import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/movie_controller.dart';
import '../models/movie_model.dart';
import '../utils/date_formatter.dart';

class EditMovieScreen extends StatelessWidget {
  final String id;
  final MovieController movieController = Get.find();
  final _formKey = GlobalKey<FormState>();

  EditMovieScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    Movie? movie = movieController.movies.firstWhereOrNull((m) => m.id == id);

    if (movie == null) {
      return Scaffold(
        body: Center(child: Text('Movie not found')),
      );
    }

    // Controllers with initial values
    final judulController = TextEditingController(text: movie.judul);
    final ringkasanController = TextEditingController(text: movie.ringkasan);
    final posterController = TextEditingController(text: movie.gambarPoster);
    final sampulController = TextEditingController(text: movie.gambarSampul);
    final tanggalRilisController =
        TextEditingController(text: formatTanggalRilisInput(movie.tanggalRilis));
    final ratingController = TextEditingController(text: movie.skorRating.toString());
    final kategoriController = TextEditingController(text: movie.kategori);
    final trailerController = TextEditingController(text: movie.urlTrailer);

    return Scaffold(
      backgroundColor: Color(0xFF0F0F0F),
      appBar: AppBar(
        title: Text('Edit Movie'),
        backgroundColor: Color(0xFF1A1A1A),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: judulController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Judul Film',
                  prefixIcon: Icon(Icons.title, color: Color(0xFFB3B3B3)),
                ),
                validator: (value) => value!.isEmpty ? 'Judul harus diisi' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: ringkasanController,
                maxLines: 3,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Ringkasan Film',
                  prefixIcon: Icon(Icons.description, color: Color(0xFFB3B3B3)),
                ),
                validator: (value) => value!.isEmpty ? 'Ringkasan harus diisi' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: posterController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'URL Poster',
                  prefixIcon: Icon(Icons.image, color: Color(0xFFB3B3B3)),
                ),
                validator: (value) => value!.isEmpty ? 'URL Poster harus diisi' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: sampulController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'URL Sampul/Cover',
                  prefixIcon: Icon(Icons.photo, color: Color(0xFFB3B3B3)),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: tanggalRilisController,
                keyboardType: TextInputType.datetime,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Tanggal Rilis (YYYY-MM-DD)',
                  prefixIcon:
                      Icon(Icons.calendar_today, color: Color(0xFFB3B3B3)),
                ),
                validator: validateTanggalRilis,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: ratingController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Rating (1-100)',
                  prefixIcon: Icon(Icons.star, color: Color(0xFFB3B3B3)),
                ),
                validator: (value) {
                  if (value!.isEmpty) return 'Rating harus diisi';
                  int? rating = int.tryParse(value);
                  if (rating == null || rating < 1 || rating > 100) {
                    return 'Rating harus 1-100';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: kategoriController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Kategori',
                  prefixIcon: Icon(Icons.category, color: Color(0xFFB3B3B3)),
                ),
                validator: (value) => value!.isEmpty ? 'Kategori harus diisi' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: trailerController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'URL Trailer',
                  prefixIcon: Icon(Icons.play_circle, color: Color(0xFFB3B3B3)),
                ),
              ),
              SizedBox(height: 30),
              Obx(() => ElevatedButton(
                onPressed: movieController.isLoading.value
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          Movie updatedMovie = Movie(
                            id: id,
                            judul: judulController.text,
                            ringkasan: ringkasanController.text,
                            gambarPoster: posterController.text,
                            gambarSampul: sampulController.text.isEmpty
                                ? posterController.text
                                : sampulController.text,
                            tanggalRilis: parseTanggalRilisInput(tanggalRilisController.text),
                            skorRating: int.parse(ratingController.text),
                            kategori: kategoriController.text,
                            urlTrailer: trailerController.text,
                          );

                          bool success = await movieController.updateMovie(id, updatedMovie);
                          if (success) {
                            Get.until((route) => route.settings.name == '/home');
                            Get.toNamed('/detail/$id');
                            Get.snackbar('Berhasil', 'Film berhasil diupdate',
                                backgroundColor: Color(0xFF1A1A1A),
                                colorText: Colors.white,
                                snackPosition: SnackPosition.BOTTOM);
                          }
                        }
                      },
                child: movieController.isLoading.value
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('UPDATE MOVIE'),
              )),
            ],
          ),
        ),
      ),
    );
  }
}