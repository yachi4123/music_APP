import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app1/music_controller.dart';
import 'package:app1/constants/style.dart';
import 'dart:io';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final MusicController musicController = Get.find<MusicController>();

  Future<void> playNextTrack() async{
      print(musicController.currentSongIndex);
      setState(() {  
      musicController.currentSongIndex >=musicController.currentPlaylist.length-1
      ?musicController.currentSongIndex = 0
      :musicController.currentSongIndex = musicController.currentSongIndex + 1;
      musicController.currentSong.value = musicController.currentPlaylist[musicController.currentSongIndex];
      }); 
  }

  Future<void> playPreviousTrack() async{
      print(musicController.currentSongIndex);
      setState(() {  
      musicController.currentSongIndex == 0
      ?musicController.currentSongIndex = musicController.currentPlaylist.length-1
      :musicController.currentSongIndex = musicController.currentSongIndex - 1;
      musicController.currentSong.value = musicController.currentPlaylist[musicController.currentSongIndex];
      }); 
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (musicController.currentSong.isEmpty) {
        return SizedBox.shrink(); 
      }
      var song = musicController.currentSong.value;
      return GestureDetector(
        onTap: () {
          Get.toNamed('/audio_player');
        },
        child: Container(
          color: CustomColors.secondaryColor,
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Container(
                height: 50,
                width: 50,
                child: musicController.fromDownloads
                  ? Image.file(File(musicController.currentImage))
                  : Image.network(musicController.currentSong['album']['images'][0]['url'],)
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      musicController.fromDownloads
                      ? musicController.currentDownload.split('.').first.toString()
                      : musicController.currentSong['name'],
                      style: TextStyle(color: TextColors.PrimaryTextColor, fontSize: 15),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      musicController.fromDownloads
                      ? musicController.currentDownload.split('.').last.toString()
                      : musicController.currentSong['artists'][0]['name'],
                      style: TextStyle(color: TextColors.SecondaryTextColor, fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.skip_previous, color: Colors.white),
                onPressed: () {
                  playPreviousTrack();
                  musicController.pauseSong();
                  musicController.searchAndPlayTrack(musicController.currentSong['name']+" "+musicController.currentSong['artists'][0]['name']);
                  musicController.addToRecentlyPlayed(musicController.currentSong);
                },
              ),
              IconButton(
                icon: Icon(
                  musicController.isPlaying.value ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (musicController.isPlaying.value) {
                    musicController.pauseSong();
                  } else {
                    musicController.playSong();
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.skip_next, color: Colors.white),
                onPressed: () {
                  playNextTrack();
                  musicController.pauseSong();
                  musicController.searchAndPlayTrack(musicController.currentSong['name']+" "+musicController.currentSong['artists'][0]['name']);
                  musicController.addToRecentlyPlayed(musicController.currentSong);
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
