import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Jenis trailer yang sedang dimainkan di popup.
enum TrailerType { none, youtube, mp4 }

class TrailerController extends GetxController {
  // --- STATE REAKTIF ---
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;
  var trailerType = TrailerType.none.obs;

  // Controller-controller pemutar (non-observable, dipakai langsung oleh widget).
  YoutubePlayerController? youtubeController;
  VideoPlayerController? videoController;
  ChewieController? chewieController;

  // ---------------------------------------------------------------------------
  // INIT — validasi url dan siapkan player sesuai jenisnya.
  // ---------------------------------------------------------------------------
  Future<void> initTrailer(String url) async {
    // Reset state tiap kali dipanggil.
    disposePlayer();
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';
    trailerType.value = TrailerType.none;

    final trimmed = url.trim();

    // 1) Validasi dummy: harus http/https.
    if (!(trimmed.startsWith('http://') || trimmed.startsWith('https://'))) {
      _setError('Trailer belum tersedia');
      return;
    }

    // 2) YouTube → pakai YoutubePlayerController.
    if (trimmed.contains('youtube.com') || trimmed.contains('youtu.be')) {
      final videoId = YoutubePlayer.convertUrlToId(trimmed);
      if (videoId == null || videoId.isEmpty) {
        _setError('Trailer belum tersedia');
        return;
      }

      youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          disableDragSeek: false,
          loop: false,
          enableCaption: true,
        ),
      );
      trailerType.value = TrailerType.youtube;
      isLoading.value = false;
      return;
    }

    // 3) MP4 / URL video standar → video_player + chewie.
    try {
      videoController = VideoPlayerController.networkUrl(Uri.parse(trimmed));
      await videoController!.initialize();

      chewieController = ChewieController(
        videoPlayerController: videoController!,
        autoPlay: true,
        looping: false,
        aspectRatio: videoController!.value.aspectRatio,
        allowFullScreen: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: const Color(0xFFE50914),
          handleColor: const Color(0xFFE50914),
          backgroundColor: Colors.grey,
          bufferedColor: Colors.white54,
        ),
      );

      trailerType.value = TrailerType.mp4;
      isLoading.value = false;
    } catch (e) {
      _setError('Gagal memutar trailer');
    }
  }

  void _setError(String message) {
    hasError.value = true;
    errorMessage.value = message;
    isLoading.value = false;
    trailerType.value = TrailerType.none;
  }

  // ---------------------------------------------------------------------------
  // DISPOSE — wajib dipanggil saat dialog ditutup agar RAM tidak bocor.
  // ---------------------------------------------------------------------------
  void disposePlayer() {
    youtubeController?.dispose();
    youtubeController = null;

    chewieController?.dispose();
    chewieController = null;

    videoController?.dispose();
    videoController = null;

    isLoading.value = false;
    hasError.value = false;
    errorMessage.value = '';
    trailerType.value = TrailerType.none;
  }

  @override
  void onClose() {
    disposePlayer();
    super.onClose();
  }
}
