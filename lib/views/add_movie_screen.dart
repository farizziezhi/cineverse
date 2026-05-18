import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/movie_controller.dart';
import '../models/movie_model.dart';
import '../utils/date_formatter.dart';

class AddMovieScreen extends StatelessWidget {
  final MovieController movieController = Get.find();
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final judulController = TextEditingController();
  final ringkasanController = TextEditingController();
  final posterController = TextEditingController();
  final sampulController = TextEditingController();
  final tanggalRilisController = TextEditingController();
  final ratingController = TextEditingController();
  final kategoriController = TextEditingController();
  final trailerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F0F0F),
      appBar: AppBar(
        title: Text('Add Movie'),
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
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 40),
                    child: Icon(Icons.description, color: Color(0xFFB3B3B3)),
                  ),
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
                  hintText: 'Kategori (Action, Drama, dll)',
                  prefixIcon: Icon(Icons.category, color: Color(0xFFB3B3B3)),
                ),
                validator: (value) => value!.isEmpty ? 'Kategori harus diisi' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: trailerController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'URL Trailer (Opsional)',
                  prefixIcon: Icon(Icons.play_circle, color: Color(0xFFB3B3B3)),
                ),
              ),
              SizedBox(height: 30),
              Obx(() => ElevatedButton(
                onPressed: movieController.isLoading.value
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          Movie newMovie = Movie(
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

                          bool success = await movieController.addMovie(newMovie);
                          if (success) {
                            Get.offAllNamed('/home');
                            Get.snackbar('Berhasil', 'Film berhasil ditambahkan',
                                backgroundColor: Color(0xFF1A1A1A),
                                colorText: Colors.white,
                                snackPosition: SnackPosition.BOTTOM);
                          }
                        }
                      },
                child: movieController.isLoading.value
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('SAVE MOVIE'),
              )),
            ],
          ),
        ),
      ),
    );
  }
}