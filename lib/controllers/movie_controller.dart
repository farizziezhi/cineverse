import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../models/movie_model.dart';

class MovieController extends GetxController {
  var movies = <Movie>[].obs;
  var isLoading = false.obs;
  
  final String baseUrl = 'https://68ff8dfbe02b16d1753e765d.mockapi.io/film';
  final Dio _dio = Dio();

  @override
  void onInit() {
    super.onInit();
    fetchMovies();
  }

  // GET semua film
  Future<void> fetchMovies() async {
    try {
      isLoading.value = true;
      final response = await _dio.get(baseUrl);
      
      if (response.statusCode == 200) {
        List data = response.data;
        movies.value = data.map((json) => Movie.fromJson(json)).toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengambil data film');
    } finally {
      isLoading.value = false;
    }
  }

  // POST tambah film
  Future<bool> addMovie(Movie movie) async {
    try {
      isLoading.value = true;
      final response = await _dio.post(baseUrl, data: movie.toJson());
      
      if (response.statusCode == 201) {
        await fetchMovies();
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambahkan film');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // PUT edit film
  Future<bool> updateMovie(String id, Movie movie) async {
    try {
      isLoading.value = true;
      final response = await _dio.put('$baseUrl/$id', data: movie.toJson());
      
      if (response.statusCode == 200) {
        await fetchMovies();
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengupdate film');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // DELETE hapus film
  Future<bool> deleteMovie(String id) async {
    try {
      isLoading.value = true;
      final response = await _dio.delete('$baseUrl/$id');
      
      if (response.statusCode == 200) {
        movies.removeWhere((m) => m.id == id); // hapus lokal dulu
        fetchMovies(); // refresh di background
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus film');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}