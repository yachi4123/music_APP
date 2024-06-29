import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app1/music_controller.dart';
import 'package:app1/constants/style.dart';

class BottomBar extends StatelessWidget {
  final MusicController musicController = Get.find<MusicController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (musicController.currentSong.isEmpty) {
        return SizedBox.shrink();  // Hide when there's no song
      }
      var song = musicController.currentSong.value;
      return GestureDetector(
        onTap: () {
          Get.offNamed('/audio_player');
        },
        child: Container(
          color: CustomColors.secondaryColor,
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Image.network(
                song['album']['images'][0]['url'],
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song['name'], 
                      style: TextStyle(color: TextColors.PrimaryTextColor, fontSize: 15),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      song['artists'][0]['name'],
                      style: TextStyle(color: TextColors.SecondaryTextColor, fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.skip_previous, color: Colors.white),
                onPressed: () {
                  // Handle previous song
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
                  // Handle next song
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
