import 'package:app1/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app1/music_controller.dart';
import 'package:app1/widgets/bottom_bar.dart';
import 'package:app1/user_data.dart';
import 'package:app1/assets/images.dart';
import 'package:app1/constants/style.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GenrePage extends StatefulWidget {
  const GenrePage({super.key});

  @override
  State<GenrePage> createState() => _GenrePageState();
}

class _GenrePageState extends State<GenrePage> {
  final MusicController musicController = Get.find<MusicController>();
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    username = user?.displayName??"user";
    profileURL = user?.photoURL?? userProfileURL;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColors.backgroundColor,
        bottomNavigationBar: Navbar(),
        appBar: AppBar(
          backgroundColor: CustomColors.backgroundColor,
          leading: IconButton(
            onPressed: () {
            Get.back();
            },
          icon: Icon(Icons.arrow_back_ios, color: TextColors.PrimaryTextColor,),
          ),
          title: Text(
            musicController.currentGenre,
            style: TextStyle(color: TextColors.PrimaryTextColor, fontSize: 30, fontWeight: FontWeight.w300)
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                  Container(
                    width: 400,
                    height: 70,
                    padding: EdgeInsets.only(top: 20,bottom: 20, left: 15),
                    child: Row(
                    children: [
                      Text(
                      "Top ${musicController.currentGenre} Artists",
                      style: TextStyle(color: TextColors.PrimaryTextColor, fontSize: 22, fontWeight: FontWeight.w300),
                      overflow: TextOverflow.ellipsis,
                      ),
                      Container(
                      width: 160,
                      padding: EdgeInsets.only(left: 130),
                      )
                    ]
                    )
                  ),
                  Container(
                    height: 220,
                    margin: EdgeInsets.only(left: 15,right: 15),
                    child: Obx(() {
                      if(musicController.topSongsForGenre.isEmpty){
                        return SizedBox.shrink();
                      }
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: musicController.topArtistsForGenre.length,
                        itemBuilder: (context, index) {
                          final artist = musicController.topArtistsForGenre[index];
                          return GestureDetector(
                            onTap: () {
                              musicController.getArtistSongs(artist['id'], artist['name'], artist['image']);
                            },
                            child: Container(
                            height: 220,
                            width: 165,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(artist['image']),
                                  radius: 70,
                                ),
                                Container(
                                  height: 80,
                                  padding: EdgeInsets.only(top:10,left:5,right: 5),
                                  child: Text(artist['name'],textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Harmattan',fontSize: 18, color: TextColors.PrimaryTextColor),),
                                )
                              ],
                            ),
                            )
                          );
                        },
                      );
                    }),
                  ),
                  Container(
                    width: 400,
                    height: 70,
                    padding: EdgeInsets.only(top: 20,bottom: 20, left: 15),
                    child: Row(
                    children: [
                      Text(
                      "Top ${musicController.currentGenre} Tracks",
                      style: TextStyle(color: TextColors.PrimaryTextColor, fontSize: 22, fontWeight: FontWeight.w300),
                      overflow: TextOverflow.ellipsis,
                      ),
                      Container(
                      width: 160,
                      padding: EdgeInsets.only(left: 130),
                      )
                    ]
                    )
                  ),
                  Expanded(
                    child: Obx(() {
                      if(musicController.topSongsForGenre.isEmpty){
                        return SizedBox.shrink();
                      }
                      return ListView.builder(
                        itemCount: musicController.topSongsForGenre.length,
                        itemBuilder: (context, index) {
                          final song = musicController.topSongsForGenre[index];
                          return ListTile(
                            onTap: () {
                              musicController.currentSong.value = song;
                              musicController.searchAndPlayTrack(song['name'] + " " + song['artists'][0]['name']);
                              musicController.addToRecentlyPlayed(song);
                              musicController.playlistName = musicController.currentPlaylistName;
                              musicController.currentSongIndex = index; 
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