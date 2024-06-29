import 'package:flutter/material.dart';
import 'package:flutter/Cupertino.dart';
import 'package:app1/constants/style.dart';
import 'package:app1/auth.dart';
import 'package:app1/music_controller.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app1/widgets/navbar.dart';

class AudioPlayerPage extends StatefulWidget {
  const AudioPlayerPage({super.key});

  @override
  State<AudioPlayerPage> createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  final AuthController authController = Get.find();
  final MusicController musicController = Get.find<MusicController>();
  final user = FirebaseAuth.instance.currentUser;
  bool liked = false;
  @override
  void initState(){
    super.initState();
    checkIfSongIsInFavourites();
  }

  Future<void> checkIfSongIsInFavourites() async {
    bool result = await musicController.isSongFavourite(musicController.currentSong.value);
    setState(() {
      liked = result;
    });
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

   void showPlaylistDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose Playlist", style: TextStyle(color: TextColors.PrimaryTextColor, fontSize: 22),),
          backgroundColor: CustomColors.secondaryColor,
          content: Container(
          height: 200,
          width: 200,
          child: Expanded(
            child: ListView(
              children: musicController.myPlaylists.skip(1).toList().asMap().entries.map((playlist)=>
              ListTile(
                onTap: () {
                  musicController.addToPlaylist(playlist.key+1, musicController.currentSong.value);
                  Navigator.of(context).pop();
                },
                title: Text(
                  playlist.value['name'],
                  style: TextStyle(color: TextColors.PrimaryTextColor, fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                ),
              )
              ).toList()
            )
          )
        ),
      );
      }
    );
   }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
    child: Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: CustomColors.backgroundColor,
      bottomNavigationBar: Navbar(),
      appBar: AppBar(
        backgroundColor: CustomColors.backgroundColor,
        leading: IconButton(
          onPressed: (){
            Get.offNamed('/home');
          },
          icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
        ),
        title: Text("Now Playing",style: TextStyle(fontFamily: 'Harmattan',fontSize: 25,color: TextColors.PrimaryTextColor),),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){
              if(liked){
                musicController.removeFromPlaylist(0, musicController.currentSong.value);
                setState(() {
                  liked = false;
                });
              }else{
                musicController.addToPlaylist(0, musicController.currentSong.value);
                setState(() {
                  liked = true;
                });
              }
            },
          icon: Icon(liked?CupertinoIcons.heart_fill:CupertinoIcons.heart, color: Colors.white,)
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 25,
            margin: EdgeInsets.only(top: 15, bottom: 10),
            child: Text(
              "From Playlist Name",
              style: TextStyle(fontFamily: 'Harmattan',color: Colors.white,fontSize: 18),
              overflow: TextOverflow.ellipsis,
              ),
          ),
          Card(
              margin: EdgeInsets.only(top: 15,left: 15,right: 15, bottom: 15),
              elevation: 15,
              color: Colors.black,
              shadowColor: Color.fromRGBO(114, 54, 239, 1.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(musicController.currentSong['album']['images'][0]['url'],)
              ),
            ),
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
            child: Column(
              children: [
                Text(
                  musicController.currentSong['name'],
                  style: TextStyle(fontFamily: 'Harmattan',color: TextColors.PrimaryTextColor,fontSize: 22),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  musicController.currentSong['artists'][0]['name'],
                  style: TextStyle(fontFamily: 'Harmattan',color: TextColors.SecondaryTextColor,fontSize: 18),
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
          Container(
            height: 65,
            child: StreamBuilder<Duration?>(
              stream: musicController.audioPlayer.durationStream,
              builder: (context, snapshot) {
                final duration = snapshot.data ?? Duration.zero;
                return StreamBuilder<Duration>(
                  stream: musicController.audioPlayer.positionStream, 
                  builder: (context, snapshot) {
                  var position = snapshot.data ?? Duration.zero;
                  if (position > duration) {
                    position = duration;
                  }
                  return Column(
                  children: [
                    Slider(
                      min: 0.0,
                      max: duration.inMilliseconds.toDouble(),
                      value: position.inMilliseconds.toDouble(),
                      onChanged: (value) {
                        musicController.audioPlayer.seek(Duration(milliseconds: value.toInt()));
                      },
                    ),
                    Container(
                      height: 15,
                      margin: EdgeInsets.only(left: 18,right: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(formatDuration(position),style: TextStyle(color: Colors.white),),
                          Text(formatDuration(duration),style: TextStyle(color: Colors.white),),
                        ]
                      ),
                    ),
                  ],
                  );
                  }
                );
              }
            )
          ),
          Container(
            height: 60,
            margin: EdgeInsets.only(top: 10,left: 10,right: 10, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: (){

                  },
                  icon: Icon(Icons.share, color: Colors.white,size: 25,),
                ),
                IconButton(
                  onPressed: (){

                  },
                  icon: Icon(CupertinoIcons.backward_end_fill, color: Colors.white,size: 25,),

                ),
                Container(
                decoration: BoxDecoration(
                  color: CustomColors.primaryColor,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Obx(() => IconButton(
                  icon: Icon(
                    musicController.isPlaying.value ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    if (musicController.isPlaying.value) {
                      musicController.pauseSong();
                    } else {
                      musicController.playSong();
                    }
                  },
                )),
                ),
                IconButton(
                  onPressed: (){

                  },
                  icon: Icon(CupertinoIcons.forward_end_fill ,color: Colors.white,size: 25,),

                ),
                IconButton(
                  onPressed: (){
                    showPlaylistDialog(context);
                  },
                  icon: Icon(Icons.add_circle, color: Colors.white,size: 25,),
                ),

              ],
            ),
          ),
           ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.primaryColor,
            ),
            onPressed: (){
                            
            },
            child: const Text("View Lyrics",style: TextStyle(fontSize: 20,color: TextColors.PrimaryTextColor, fontWeight: FontWeight.w400),)
            ),
        ],
      ),
    ),
    );
  }
}