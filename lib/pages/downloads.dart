import 'dart:io';
import 'package:app1/download_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/Cupertino.dart';
import 'package:app1/constants/style.dart';
import 'package:app1/music_controller.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app1/widgets/navbar.dart';
import 'package:app1/pages/audio_player.dart';
import 'package:app1/widgets/bottom_bar.dart';
import 'package:app1/user_data.dart';
import 'package:app1/assets/images.dart';


class DownloadsPage extends StatefulWidget {
  const DownloadsPage({super.key});

  @override
  State<DownloadsPage> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  final MusicController musicController = Get.find<MusicController>();
  final DownloadController downloadController =  Get.find<DownloadController>();
  final AudioPlayerPage audio = AudioPlayerPage();
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    downloadController.initializeDownloadDirectory();
    GlobalVariable.instance.myGlobalVariable = 3;
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
          title: Text("Downloads", style: TextStyle(color: TextColors.PrimaryTextColor),),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top: 20),
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                    Expanded(
                    child: Obx(() {
                      if(musicController.downloads.isEmpty){
                        return SizedBox.shrink();
                      }
                      return ListView.builder(
                        padding: EdgeInsets.only(top: 10),
                        itemCount: musicController.downloads.length,
                        itemBuilder: (context, index) {
                          var song = musicController.downloads[index];
                          var image = musicController.images[index];
                          return ListTile(
                            onTap: (){
                              musicController.currentDownload = song.path.split('/').last;
                              musicController.currentImage = image.path;
                              musicController.playFromFile(song.path);
                              musicController.playlistName = "Downloads";
                            },
                            contentPadding: EdgeInsets.only(left: 20, right: 5),
                            leading: Container(
                              height:55,
                              width: 65,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Image.file(File(image.path)),
                            ),
                            title: Text(song.path.split('/').last.split('.').first.toString(), style: TextStyle(color: TextColors.PrimaryTextColor, fontSize: 16), overflow: TextOverflow.ellipsis,),
                            subtitle: Text(song.path.split('/').last.split('.').last.toString(), style: TextStyle(color: TextColors.SecondaryTextColor, fontSize: 12)),
                            trailing:Container(
                              height: 55,
                              width: 60,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: (){
                                      downloadController.deleteFile(image);
                                      downloadController.deleteFile(song);
                                    },
                                    icon: Icon(Icons.delete, size: 25,color: Colors.white,),
                                  ),
                                ],
                              ),
                            )
                          );
                        },
                      );
                    }),
                  )
                  ]
                  ),
              ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BottomBar(),
            ),
          ],
        ),
      ),
    );
  }
}