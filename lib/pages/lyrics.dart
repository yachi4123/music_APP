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
import 'package:genius_lyrics/genius_lyrics.dart';

class LyricsPage extends StatefulWidget {
  const LyricsPage({super.key});

  @override
  State<LyricsPage> createState() => _LyricsPageState();
}

class _LyricsPageState extends State<LyricsPage> {
  Genius genius = Genius(accessToken: "LNpdjPGd3SyP2_VC5Isrv3H-V3slwKoLVkYs857AHYp6xPAepRZiEkJX-rT8cXZB");
  final MusicController musicController = Get.find<MusicController>();
  String? lyrics;

  @override
  void initState(){
    fetchLyrics();
    super.initState();
  }

  void fetchLyrics() async {
    Song? song = (await genius.searchSong(
      artist: musicController.currentSong['artists'][0]['name'], 
      title: musicController.currentSong['name'])
    );
    if(song!=null){
      setState(() {
        lyrics = song.lyrics;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColors.primaryColor,
        bottomNavigationBar: Navbar(),
        appBar: AppBar(
        backgroundColor: CustomColors.primaryColor,
        leading: IconButton(
          onPressed: (){
            Get.back(closeOverlays: true);
          },
          icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
        ),
        title: Text(musicController.currentSong['name'],style: TextStyle(fontFamily: 'Harmattan',fontSize: 25,color: TextColors.PrimaryTextColor, fontWeight: FontWeight.w400),overflow: TextOverflow.ellipsis,),
        centerTitle: true,
      ),
        body: SingleChildScrollView(
          child: lyrics!=null
          ?Container(
            padding: EdgeInsets.only(top:15, right: 15, left: 15),
            child: Text(lyrics??"", style: TextStyle(color: TextColors.PrimaryTextColor, fontSize: 20, fontWeight: FontWeight.w300),)
          )
          :Center(
          child: Container(
            padding: EdgeInsets.only(top: 50),
            child: CircularProgressIndicator(color: Colors.white,),
            )
          )
        )
      ),
    );
  }
}