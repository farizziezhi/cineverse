import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../controllers/trailer_controller.dart';

/// Helper global untuk menampilkan popup trailer dari view manapun.
Future<void> showTrailerPopup(String url) async {
  // Lazy-put sekali; kalau sudah ada, pakai instance yang sama.
  final controller = Get.isRegistered<TrailerController>()
      ? Get.find<TrailerController>()
      : Get.put(TrailerController());

  // Mulai inisialisasi (tidak di-await agar state loading terlihat di UI).
  controller.initTrailer(url);

  await Get.dialog(
    const TrailerDialog(),
    barrierDismissible: true,
    barrierColor: Colors.black87,
  );

  controller.disposePlayer();
}

class TrailerDialog extends StatelessWidget {
  const TrailerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<TrailerController>();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(12),
            child: Obx(() {
              if (c.isLoading.value) {
                return const SizedBox(
                  height: 220,
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFFE50914)),
                    ),
                  ),
                );
              }

              if (c.hasError.value) {
                return SizedBox(
                  height: 220,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.videocam_off,
                            color: Color(0xFFB3B3B3), size: 48),
                        const SizedBox(height: 12),
                        Text(
                          c.errorMessage.value.isEmpty
                              ? 'Trailer belum tersedia'
                              : c.errorMessage.value,
                          style: const TextStyle(color: Color(0xFFB3B3B3)),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (c.trailerType.value == TrailerType.youtube &&
                  c.youtubeController != null) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: YoutubePlayer(
                    controller: c.youtubeController!,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: const Color(0xFFE50914),
                  ),
                );
              }

              if (c.trailerType.value == TrailerType.mp4 &&
                  c.chewieController != null) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: c.videoController!.value.aspectRatio,
                    child: Chewie(controller: c.chewieController!),
                  ),
                );
              }

              return const SizedBox.shrink();
            }),
          ),

          // Tombol tutup (X) di pojok kanan atas.
          Positioned(
            top: 8,
            right: 8,
            child: Material(
              color: const Color(0xFFE50914),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: Get.back,
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
