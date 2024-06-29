import 'package:app1/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app1/music_controller.dart';
import 'package:app1/widgets/bottom_bar.dart';
import 'package:app1/user_data.dart';
import 'package:app1/assets/images.dart';
import 'package:app1/constants/style.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  final MusicController musicController = Get.find<MusicController>();
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    username = user?.displayName??"user";
    profileURL = user?.photoURL?? userProfileURL;
    GlobalVariable.instance.myGlobalVariable = 2;
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
            Get.offNamed('/my_playlists');
            },
          icon: Icon(Icons.arrow_back_ios, color: TextColors.PrimaryTextColor,),
          ),
        ),
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  Container(
                    width: 400,
                    height: 78,
                    padding: EdgeInsets.only(top: 10,bottom: 30, left: 15),
                    child: Row(
                    children: [
                      Text(
                      musicController.currentPlaylistName,
                      style: TextStyle(color: TextColors.PrimaryTextColor, fontSize: 30, fontWeight: FontWeight.w300),
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
                      if(musicController.currentPlaylist.isEmpty){
                        return SizedBox.shrink();
                      }
                      return ListView(
                      children: musicController.currentPlaylist.map((song)=>
                          ListTile(
                            contentPadding: EdgeInsets.only(left: 20, right: 5),
                            leading: Container(
                              height:55,
                              width: 65,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Image(image: NetworkImage(song['album']['images'][0]['url']))
                            ),
                            title: Text(song['name'], style: TextStyle(color: TextColors.PrimaryTextColor, fontSize: 16), overflow: TextOverflow.ellipsis,),
                            subtitle: Text(song['artists'][0]['name'], style: TextStyle(color: TextColors.SecondaryTextColor, fontSize: 12)),
                            trailing:Container(
                              height: 55,
                              width: 60,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: (){

                                    },
                                    icon: Icon(Icons.more_vert,size: 30,color: Colors.white,),
                                  ),
                                ],
                              ),
                            )
                          )
                      ).toList()
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