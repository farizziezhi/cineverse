int parseTanggalRilisInput(String value) {
  final parsedDate = DateTime.tryParse(value.trim());
  if (parsedDate != null) {
    return parsedDate.millisecondsSinceEpoch ~/ 1000;
  }

  return 0;
}

String formatTanggalRilis(int value) {
  if (value == 0) return 'Tidak diketahui';
  if (value >= 1000 && value <= 9999) return value.toString();

  final date = DateTime.fromMillisecondsSinceEpoch(value * 1000);
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');

  return '$day-$month-${date.year}';
}

String formatTanggalRilisInput(int value) {
  if (value == 0) return '';
  if (value >= 1000 && value <= 9999) return '$value-01-01';

  final date = DateTime.fromMillisecondsSinceEpoch(value * 1000);
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');

  return '${date.year}-$month-$day';
}

String? validateTanggalRilis(String? value) {
  if (value == null || value.isEmpty) return 'Tanggal rilis harus diisi';
  if (DateTime.tryParse(value.trim()) == null) {
    return 'Format tanggal harus YYYY-MM-DD';
  }

  return null;
}
