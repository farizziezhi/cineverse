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

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;

    return 0;
  }

  static int _parseTanggalRilis(dynamic value) {
    if (value is int) return value;

    if (value is String) {
      final parsedInt = int.tryParse(value);
      if (parsedInt != null) return parsedInt;

      final parsedDate = DateTime.tryParse(value);
      if (parsedDate != null) {
        return parsedDate.millisecondsSinceEpoch ~/ 1000;
      }
    }

    return 0;
  }

  // Dari JSON ke object
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id']?.toString(),
      judul: json['judul']?.toString() ?? '',
      ringkasan: json['ringkasan']?.toString() ?? '',
      gambarPoster: json['gambar_poster']?.toString() ?? '',
      gambarSampul: json['gambar_sampul']?.toString() ?? '',
      tanggalRilis: _parseTanggalRilis(json['tanggal_rilis']),
      skorRating: _parseInt(json['skor_rating']),
      kategori: json['kategori']?.toString() ?? '',
      urlTrailer: json['url_trailer']?.toString() ?? '',
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