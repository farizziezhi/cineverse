class Movie {
  String? id;
  String judul;
  String ringkasan;
  String gambarPoster;
  String gambarSampul;
  int tanggalRilis;
  int skorRating;
  String kategori;
  String urlTrailer;

  Movie({
    this.id,
    required this.judul,
    required this.ringkasan,
    required this.gambarPoster,
    required this.gambarSampul,
    required this.tanggalRilis,
    required this.skorRating,
    required this.kategori,
    required this.urlTrailer,
  });

  // Dari JSON ke object
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'].toString(),
      judul: json['judul'] ?? '',
      ringkasan: json['ringkasan'] ?? '',
      gambarPoster: json['gambar_poster'] ?? '',
      gambarSampul: json['gambar_sampul'] ?? '',
      tanggalRilis: json['tanggal_rilis'] ?? 0,
      skorRating: json['skor_rating'] is String
          ? int.tryParse(json['skor_rating']) ?? 0
          : json['skor_rating'] ?? 0,
      kategori: json['kategori'] ?? '',
      urlTrailer: json['url_trailer'] ?? '',
    );
  }

  // Dari object ke JSON
  Map<String, dynamic> toJson() {
    return {
      'judul': judul,
      'ringkasan': ringkasan,
      'gambar_poster': gambarPoster,
      'gambar_sampul': gambarSampul,
      'tanggal_rilis': tanggalRilis,
      'skor_rating': skorRating,
      'kategori': kategori,
      'url_trailer': urlTrailer,
    };
  }
}