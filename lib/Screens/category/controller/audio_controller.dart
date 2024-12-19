import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';

class AudioController extends GetxController {
  late AssetsAudioPlayer audioPlayer;

  RxBool isPlaying = false.obs;
  Rx<Duration> duration = Duration.zero.obs;
  Rx<Duration> position = Duration.zero.obs;

  @override
  void onInit() {
    super.onInit();
    audioPlayer = AssetsAudioPlayer();

    audioPlayer.current.listen((playingAudio) {
      if (playingAudio != null) {
        duration.value = playingAudio.audio.duration;
      }
    });

    audioPlayer.currentPosition.listen((p) {
      position.value = p;
    });

    audioPlayer.isPlaying.listen((playing) {
      isPlaying.value = playing;
    });
  }

  Future<void> playPauseAudio(String audioUrl) async {
    if (isPlaying.value) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.open(
        Audio.network(audioUrl),
        autoStart: true,
        showNotification: true,
      );
    }
  }

  Future<void> seekAudio(double value) async {
    final newPosition = Duration(milliseconds: value.toInt());
    await audioPlayer.seek(newPosition);
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }
}
