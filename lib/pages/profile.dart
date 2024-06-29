import 'package:app1/constants/style.dart';
import 'package:app1/user_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app1/auth.dart';
import 'package:app1/widgets/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app1/assets/images.dart';
import 'package:app1/widgets/bottom_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthController authController = Get.find();
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    GlobalVariable.instance.myGlobalVariable = 3;
    username = user?.displayName??"user";
    profileURL = user?.photoURL??userProfileURL;
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
          Get.offNamed('/home');
          },
        icon: Icon(Icons.arrow_back_ios, color: TextColors.PrimaryTextColor,),
        ),
        title: Text("Profile", style: TextStyle(fontSize: 20, color: TextColors.PrimaryTextColor),),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.offNamed('/edit_profile');
            },
            icon: Icon(Icons.edit, color: TextColors.PrimaryTextColor,),
          ),
        ]
      ),
      bottomNavigationBar: Navbar(),
      body: Stack(
      children: [
        Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            padding: EdgeInsets.only(top: 20),
            height: 180,
            child:Center(
              child: CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(profileURL),
              )
            ),
          ),
          SizedBox(
            height: 40,
            child: Text(username, style: TextStyle(fontSize: 25, color: TextColors.PrimaryTextColor),),
          ),
          Container(
            height: 100,
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text("10",style: TextStyle(fontSize: 25, color: TextColors.PrimaryTextColor),),
                        Text("Friends",style: TextStyle(fontSize: 15, color: TextColors.PrimaryTextColor),),
                      ],
                    ),
                    Column(
                      children: [
                        Text("15",style: TextStyle(fontSize: 25, color: TextColors.PrimaryTextColor),),
                        Text("Playlists",style: TextStyle(fontSize: 15, color: TextColors.PrimaryTextColor),),
                      ],
                    ),
                  ],
                ),
              ]
            ),
          ),
          Container(
            height: 160,
            //color: Colors.green,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Center(
                  child:Container(
                    height: 60,
                    width:340,
                    decoration: BoxDecoration(
                      color: CustomColors.backgroundColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [BoxShadow(color: TextColors.SecondaryTextColor, blurRadius: 2, spreadRadius: 1.5)],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.people,size:30, color: TextColors.PrimaryTextColor,),
                        Text("My Friends", style: TextStyle(fontSize: 18, color: TextColors.PrimaryTextColor),),
                        SizedBox(
                          width: 90,
                        ),
                        IconButton(
                          onPressed: (){

                          },
                        icon: Icon(Icons.arrow_forward_ios, color: TextColors.PrimaryTextColor,),
                        )
                      ],
                    ),
                  ),
                ),
                Center(
                  child:Container(
                    height: 60,
                    width: 340,
                    decoration: BoxDecoration(
                      color: CustomColors.backgroundColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [BoxShadow(color: TextColors.SecondaryTextColor, blurRadius: 2, spreadRadius: 1.5)],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.music_note, size:30, color: TextColors.PrimaryTextColor,),
                        Text("My Playlists",style: TextStyle(fontSize: 18, color: TextColors.PrimaryTextColor,),),
                        SizedBox(
                          width: 90,
                        ),
                        IconButton(
                          onPressed: (){
                            Get.offNamed("/my_playlists");
                          },
                          icon: Icon(Icons.arrow_forward_ios, color: TextColors.PrimaryTextColor,),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 180,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: .25,
                  color: CustomColors.backgroundColor,
                )
              )
            ),
            child: Center(
              child:InkWell(
                onTap: (){
                  authController.signOut();
                  Get.offNamed('/login');
                },
                child: Container(
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: CustomColors.primaryColor,
                  ),
                  child: Center(
                    child: Text("LogOut",style: TextStyle(fontSize: 20, color: TextColors.PrimaryTextColor),),
                  ),
                ),
              ),
            ),
          ),
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
    ),
    );
  }
}
