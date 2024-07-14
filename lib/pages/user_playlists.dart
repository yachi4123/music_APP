import 'package:app1/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app1/music_controller.dart';
import 'package:app1/widgets/bottom_bar.dart';
import 'package:app1/user_data.dart';
import 'package:app1/assets/images.dart';
import 'package:app1/constants/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app1/user_controller.dart';

class UserPlaylists extends StatefulWidget {
  const UserPlaylists({super.key});

  @override
  State<UserPlaylists> createState() => _MyPlaylistsState();
}

class _MyPlaylistsState extends State<UserPlaylists> {
  final MusicController musicController = Get.find<MusicController>();
   final UserController userController = Get.find<UserController>();
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                    padding: EdgeInsets.only(top: 10,bottom: 10, left: 10),
                    child: Row(
                    children: [
                      Text(
                      "${userController.currentDisplayUser['username']}'s Playlists",
                      style: TextStyle(color: TextColors.PrimaryTextColor, fontSize: 30, fontWeight: FontWeight.w300),
                      overflow: TextOverflow.ellipsis,
                      ),
                    ]
                    )
                  ),
                    Expanded(
                    child: Obx(() {
                      return ListView.builder(
                        padding: EdgeInsets.only(top: 10),
                        itemCount: userController.userPlaylists.length,
                        itemBuilder: (context, index) {
                          var playlist = userController.userPlaylists[index];
                          return ListTile(
                            onTap: () {
                              if (playlist['songs'] != null){
                                musicController.currentPlaylist.assignAll(playlist['songs']);
                                musicController.currentPlaylistName = playlist['name'];
                              }
                              Get.toNamed('/playlist');
                            },
                            contentPadding: EdgeInsets.only(left: 20, right: 5, bottom: 8),
                            leading: Container(
                              height:55,
                              width: 55,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Image(image: 
                              playlist['songs'].length!=0
                              ?  NetworkImage(playlist['songs'][0]['album']['images'][0]['url'])
                              : NetworkImage("https://img.freepik.com/free-vector/vector-abstract-musical-background-vector-illustration_206725-623.jpg?w=1480&t=st=1719648479~exp=1719649079~hmac=3d7949d47d5a6715d9743964724cf4a2fcba0ec3597bb2069f4d08e78db2b9aa")
                              ,fit: BoxFit.cover,
                              )
                            ),
                            title: Text(playlist['name'], style: TextStyle(color: TextColors.PrimaryTextColor, fontSize: 16), overflow: TextOverflow.ellipsis,),
                            subtitle: Text(playlist['songs'].length.toString() + " songs", style: TextStyle(color: TextColors.SecondaryTextColor, fontSize: 12)),
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
                          );
                        }
                      );
                    }),
                  ),
                  Container(
                    height: 70,
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