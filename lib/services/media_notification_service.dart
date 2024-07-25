import 'package:just_audio/just_audio.dart';
import 'package:get/get.dart';
import 'package:app1/music_controller.dart';

class CustomAudioPlayer extends AudioPlayer {
  final MusicController musicController = Get.find();

  @override
  Future<void> seekToNext() async {

    musicController.currentSong=<String,dynamic>{}.obs;
    await musicController.playNextTrack();
    musicController.pauseSong();
    await musicController.searchAndPlayTrack(musicController.currentSong['name']+" "+musicController.currentSong['artists'][0]['name']);
    await musicController.addToRecentlyPlayed(musicController.currentSong);
  }

  @override
  Future<void> seekToPrevious() async {
    musicController.currentSong=<String,dynamic>{}.obs;
    await musicController.playPreviousTrack();
    musicController.pauseSong();
    await musicController.searchAndPlayTrack(musicController.currentSong['name']+" "+musicController.currentSong['artists'][0]['name']);
    await musicController.addToRecentlyPlayed(musicController.currentSong);
  }
}
