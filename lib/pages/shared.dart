import 'package:app1/constants/style.dart';
import 'package:app1/user_controller.dart';
import 'package:app1/user_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app1/auth.dart';
import 'package:app1/widgets/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app1/assets/images.dart';
import 'package:app1/widgets/bottom_bar.dart';
import 'package:app1/music_controller.dart';

class SharedPage extends StatefulWidget {
  const SharedPage({super.key});

  @override
  State<SharedPage> createState() => _SharedPageState();
}

class _SharedPageState extends State<SharedPage> {
  final MusicController musicController = Get.find<MusicController>();
  final AuthController authController = Get.find();
  final UserController userController = Get.find<UserController>();
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    GlobalVariable.instance.myGlobalVariable = 3;
    userController.getSharedList(userController.currentDisplayUser['username']);
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
          title: Text("Songs Shared", style: TextStyle(fontSize: 22, color: TextColors.PrimaryTextColor),),
          centerTitle: true,
        ),
        bottomNavigationBar: Navbar(),
        body: Stack(
          children: [
            Column(
              children: [
              GestureDetector(
              onTap: (){
                Get.toNamed('/profile');
              },
              child: Container(
                height: 70,
                margin:EdgeInsets.only(top: 10,bottom: 10,left: 25,right: 25),
                child: Center(
                  child: Container(
                    height: 75,
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("With",style: TextStyle(fontFamily:'Harmattan' ,fontWeight: FontWeight.w300,fontSize: 15,color: Colors.white),),
                            Text(userController.currentDisplayUser['username'],style: TextStyle(fontFamily: 'Harmattan',fontSize: 30,fontWeight: FontWeight.w200,color: Colors.white),overflow: TextOverflow.ellipsis,),
                          ],
                        ),
                        CircleAvatar(
                          backgroundImage: NetworkImage(userController.currentDisplayUser['photoURL']),
                          radius: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ),
              Expanded(
              child: Obx(() {
                if (userController.sharedList.isEmpty) {
                  return Center(child: Text('No songs shared', style: TextStyle(color: TextColors.SecondaryTextColor),));
                }
                return ListView.builder(
                  padding: EdgeInsets.only(top: 15),
                  itemCount: userController.sharedList.length,
                  itemBuilder: (context, index) {
                    var song = userController.sharedList[index]['song'];
                    var user = userController.sharedList[index]['by'];
                    return Container(
                      padding: EdgeInsets.only(bottom: 20),
                    child:  Column(
                    children: [
                    ListTile( 
                      onTap: () {
                        musicController.currentSong.value = song;
                        musicController.searchAndPlayTrack(song['name']+" "+song['artists'][0]['name']);
                        musicController.addToRecentlyPlayed(song);
                      },
                      leading: Image.network(song['album']['images'][0]['url'], height: 55, width: 55, fit: BoxFit.cover),
                      title: Text(
                        song['name'],
                        style: TextStyle(color: TextColors.PrimaryTextColor, fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        song['artists'][0]['name'],
                        style: TextStyle(color: TextColors.SecondaryTextColor, fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          // Handle more options
                        },
                        icon: Icon(Icons.more_vert, size: 30, color: TextColors.SecondaryTextColor),
                      ),
                      
                    ),
                    Center(
                      child: Text("By $user", style: TextStyle(color: TextColors.SecondaryTextColor, fontSize: 15, fontWeight: FontWeight.w300),overflow: TextOverflow.ellipsis,),
                    )
                    ]
                    )
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
          ],
        )
      ),
    );
  }
}