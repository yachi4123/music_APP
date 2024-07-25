import 'package:flutter/material.dart';
import 'package:flutter/Cupertino.dart';
import 'package:app1/constants/style.dart';
import 'package:app1/auth.dart';
import 'package:app1/music_controller.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app1/widgets/navbar.dart';
import 'package:app1/download_controller.dart';
import 'package:app1/user_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:app1/services/media_notification_service.dart';

class AudioPlayerPage extends StatefulWidget {
  const AudioPlayerPage({super.key});

  @override
  State<AudioPlayerPage> createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  final AuthController authController = Get.find();
  final MusicController musicController = Get.find<MusicController>();
  final UserController userController = Get.find<UserController>();
  final user = FirebaseAuth.instance.currentUser;
  bool liked = false;
  // bool permissionGranted = false;
  List<FileSystemEntity> SongFiles = [];
  List<FileSystemEntity> ImagesFiles = [];
  Directory? downloadDirectory;
  Directory? songsDirectory;
  Directory? imagesDirectory;
  var playlistName = "";


  @override
  void initState(){
    super.initState();
    checkIfSongIsInFavourites();
    initializeDownloadDirectory();
    listDownloadedFiles();
  }

  Future<void> playNextTrack() async{
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

  Future<void> checkPermission() async {
    var status = await Permission.storage.status;
    if (await Permission.storage.request().isGranted ||
        await Permission.accessMediaLocation.request().isGranted ||
        await Permission.manageExternalStorage.request().isGranted ||
        await Permission.audio.request().isGranted) {
      String songUrl = musicController.currentSongUrl;
      String songName = musicController.currentSong['name'] + "." + musicController.currentSong['artists'][0]['name'];
      String imageUrl = musicController.currentSong['album']['images'][0]['url'];
      String imageName = musicController.currentSong['name'] + ".jpg";
      initializeDownloadDirectory();
      listDownloadedFiles();
      downloadFile(songUrl, songName, imageUrl, imageName);
      musicController.downloads.assignAll(SongFiles);
      musicController.images.assignAll(ImagesFiles);

    } 
    // else {
    //   setState(() {
    //     permissionGranted = false;
    //   });
    // }
  }

  Future<void> initializeDownloadDirectory() async {
    try {
      if(Platform.isIOS) {
        downloadDirectory = await getApplicationDocumentsDirectory();
      } else {
        downloadDirectory = await getExternalStorageDirectory();
      }

      if (downloadDirectory != null) {
        // Create songs and images directories
        songsDirectory = Directory('${downloadDirectory!.path}/songs');
        imagesDirectory = Directory('${downloadDirectory!.path}/images');

        if (!await songsDirectory!.exists()) {
          await songsDirectory!.create(recursive: true);
        }
        if (!await imagesDirectory!.exists()) {
          await imagesDirectory!.create(recursive: true);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> listDownloadedFiles() async {
    if (downloadDirectory != null) {
      final songFiles = songsDirectory!.listSync(recursive: true);
      final imageFiles = imagesDirectory!.listSync(recursive: true);
      setState(() {
        SongFiles = songFiles;
        ImagesFiles = imageFiles;
      });
    }
  }

  Future<void> downloadFile(String songUrl, String songName, String imageUrl, String imageName) async {
  // if (!permissionGranted) {
  //   await checkPermission();
  // }
  if (downloadDirectory != null) {
    try {
      final songDownloadPath = '${downloadDirectory!.path}/songs';
      final imageDownloadPath = '${downloadDirectory!.path}/images';

      final taskID = await FlutterDownloader.enqueue(
        url: songUrl,
        fileName: songName,
        savedDir: songDownloadPath,
        showNotification: true,
        openFileFromNotification: true,
      );

      final taskID2 = await FlutterDownloader.enqueue(
        url: imageUrl,
        fileName: imageName,
        savedDir: imageDownloadPath,
        showNotification: false,
        openFileFromNotification: false,
      );

      Get.snackbar(
        "Download Complete", 
        "Your song has been downloaded",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
        backgroundColor: CustomColors.secondaryColor,
        colorText: Colors.white, 
        );

      // initializeDownloadDirectory();
      // listDownloadedFiles();
    } catch (e) {
      print('Download failed: $e');
    }
  }
}

  void showFriendsDialog(BuildContext context) {
  List<dynamic> selectedFriends = [];

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text(
              "Share With",
              style: TextStyle(color: TextColors.PrimaryTextColor, fontSize: 22),
            ),
            backgroundColor: CustomColors.secondaryColor,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 200,
                  width: 300,
                  child: ListView(
                    children: userController.friendsList.map((friend) {
                      return ListTile(
                        contentPadding: EdgeInsets.only(top: 5, bottom: 5),
                        onTap: () {
                          setState(() {
                            if (selectedFriends.contains(friend)) {
                              selectedFriends.remove(friend);
                            } else {
                              selectedFriends.add(friend);
                            }
                          });
                        },
                        title: Text(
                          friend['username'],
                          style: TextStyle(color: TextColors.PrimaryTextColor, fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        ),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(friend['photoURL']),
                          radius: 30,
                        ),
                        trailing: Checkbox(
                          value: selectedFriends.contains(friend),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                selectedFriends.add(friend);
                              } else {
                                selectedFriends.remove(friend);
                              }
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    for(Map<String,dynamic> friend in selectedFriends){
                      userController.sendSong(friend['username']);
                    }
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text("Send"),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

  // void showLyrics(BuildContext context){
  //   final ItemScrollController itemScrollController = ItemScrollController();
  //   final ScrollOffsetController scrollOffsetController = ScrollOffsetController();
  //   final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  //   final ScrollOffsetListener scrollOffsetListener = ScrollOffsetListener.create();

  //   ScrollablePositionedList.builder(
  //     itemCount: musicController.lyrics!.length,
  //     itemBuilder: (context, index) => Text(musicController.lyrics![index].words),
  //     itemScrollController: itemScrollController,
  //     scrollOffsetController: scrollOffsetController,
  //     itemPositionsListener: itemPositionsListener,
  //     scrollOffsetListener: scrollOffsetListener,
  //   );
  // }

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
            Get.back(closeOverlays: true);
          },
          icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
        ),
        title: Text("Now Playing",style: TextStyle(fontFamily: 'Harmattan',fontSize: 25,color: TextColors.PrimaryTextColor),),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){
              if(!musicController.fromDownloads){
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
              "From ${musicController.playlistName}",
              style: TextStyle(fontFamily: 'Harmattan',color: TextColors.SecondaryTextColor,fontSize: 18),
              overflow: TextOverflow.ellipsis,
              ),
          ),
          Card(
              margin: EdgeInsets.only(top: 15,left: 15,right: 15, bottom: 15),
              elevation: 15,
              color: Colors.black,
              // shadowColor: Color.fromRGBO(114, 54, 239, 1.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: musicController.fromDownloads
                ? Image.file(File(musicController.currentImage))
                : Image.network(musicController.currentSong['album']['images'][0]['url'],)
              )
            ),
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
            child: Column(
              children: [
                Text(
                  musicController.fromDownloads
                  ? musicController.currentDownload.split('.').first.toString()
                  : musicController.currentSong['name'],
                  style: TextStyle(fontFamily: 'Harmattan',color: TextColors.PrimaryTextColor,fontSize: 22),
                  overflow: TextOverflow.ellipsis,
                ),
                GestureDetector(
                onTap: () {
                  musicController.getArtistSongs(musicController.currentSong['artists'][0]['id'], musicController.currentSong['artists'][0]['name'],null);
                },
                child: Text(
                  musicController.fromDownloads
                  ? musicController.currentDownload.split('.').last.toString()
                  : musicController.currentSong['artists'][0]['name'],
                  style: TextStyle(fontFamily: 'Harmattan',color: TextColors.SecondaryTextColor,fontSize: 18),
                  overflow: TextOverflow.ellipsis,
                )
                ),
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
                    showFriendsDialog(context);
                  },
                  icon: Icon(Icons.share, color: Colors.white,size: 25,),
                ),
                IconButton(
                  onPressed: (){
                    musicController.currentSong=<String,dynamic>{}.obs;
                    setState(() {
                      musicController.playPreviousTrack();
                      musicController.pauseSong();
                      musicController.searchAndPlayTrack(musicController.currentSong['name']+" "+musicController.currentSong['artists'][0]['name']);
                      musicController.addToRecentlyPlayed(musicController.currentSong);
                    });
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
                    musicController.currentSong=<String,dynamic>{}.obs;
                    setState(() {
                      musicController.playNextTrack();
                      musicController.pauseSong();
                      musicController.searchAndPlayTrack(musicController.currentSong['name']+" "+musicController.currentSong['artists'][0]['name']);
                      musicController.addToRecentlyPlayed(musicController.currentSong);
                    });
                  },
                  icon: Icon(CupertinoIcons.forward_end_fill ,color: Colors.white,size: 25,),

                ),
                IconButton(
                  onPressed: (){
                    userController.getRequestsList();
                    showPlaylistDialog(context);
                  },
                  icon: Icon(Icons.add_circle, color: Colors.white,size: 25,),
                ),

              ],
            ),
          ),
          Row(
          children: [
            Container(
            padding: EdgeInsets.only(left: 140, right: 80),
            child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.primaryColor,
            ),
            onPressed: (){
              Get.toNamed('/lyrics');         
            },
            child: const Text("View Lyrics",style: TextStyle(fontSize: 20,color: TextColors.PrimaryTextColor, fontWeight: FontWeight.w400),)
            ),
            ),
            IconButton(
              onPressed: (){
                musicController.setUrl(musicController.currentSong['name']);
                checkPermission();
              }, 
              icon: Icon(Icons.download, color: Colors.white, size: 25,)
            )
          ]
          ),
        ],
      ),
    ),
    );
  }
}