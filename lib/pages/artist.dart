import 'package:app1/user_controller.dart';
import 'package:app1/user_data.dart';
import 'package:flutter/material.dart';
import 'package:app1/constants/style.dart';
import 'package:get/get.dart';
import 'package:app1/widgets/navbar.dart';
import 'package:app1/widgets/bottom_bar.dart';
import 'package:app1/music_controller.dart';


class ArtistPage extends StatefulWidget {
  const ArtistPage({super.key});

  @override
  State<ArtistPage> createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  final MusicController musicController = Get.find<MusicController>();
  final UserController userController = Get.find<UserController>();
  var status = "";

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
    child: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CustomColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: CustomColors.backgroundColor,
        leading: IconButton(
          onPressed: () {
          Get.back();
          },
        icon: Icon(Icons.arrow_back_ios, color: TextColors.PrimaryTextColor,),
        ),
        title: Text(musicController.currentArtist['name']??"", style: TextStyle(fontSize: 25, color: TextColors.PrimaryTextColor),),
        centerTitle: true,
      ),
      bottomNavigationBar: Navbar(),
      body: Stack(
      children: [
        Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: 210,
            padding: EdgeInsets.only(top: 20, bottom: 30),
            child:Center(
              child: CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(musicController.currentArtist['image']??""),
              )
            ),
          ),
          Container(
            height: 50,
            width: 390,
            child: Text("Top Tracks", style: TextStyle(color: TextColors.PrimaryTextColor, fontSize: 22, fontWeight: FontWeight.w400),),
          ),
          Expanded(
            child: Obx(() {
              if(musicController.currentPlaylist.isEmpty){
                return SizedBox.shrink();
              }
              return ListView.builder(
                itemCount: musicController.currentPlaylist.length,
                itemBuilder: (context, index) {
                  final song = musicController.currentPlaylist[index];
                  return ListTile(
                    onTap: () {
                      musicController.currentSong.value = song;
                      musicController.searchAndPlayTrack(song['name'] + " " + song['artists'][0]['name']);
                      musicController.addToRecentlyPlayed(song);
                      musicController.playlistName = musicController.currentPlaylistName;
                      musicController.currentSongIndex = index; // Set the current song index
                    },
                    contentPadding: EdgeInsets.only(left: 20, right: 5),
                    leading: Container(
                      height: 55,
                      width: 65,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Image(image: NetworkImage(song['album']['images'][0]['url'])),
                    ),
                    title: Text(
                      song['name'],
                      style: TextStyle(color: TextColors.PrimaryTextColor, fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      song['artists'][0]['name'],
                      style: TextStyle(color: TextColors.SecondaryTextColor, fontSize: 12),
                    ),
                    trailing: Container(
                      height: 55,
                      width: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.more_vert, size: 30, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          )
        ]
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: BottomBar(),
        ),
      ]
    ),
    )
    );
  }
}