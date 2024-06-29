import 'package:app1/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app1/music_controller.dart';
import 'package:app1/widgets/bottom_bar.dart';
import 'package:app1/user_data.dart';
import 'package:app1/assets/images.dart';
import 'package:app1/constants/style.dart';
import 'package:app1/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    final AuthController authController = Get.find();
    final MusicController musicController = Get.find<MusicController>();
    final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    username = user?.displayName??"user";
    profileURL = user?.photoURL?? userProfileURL;
    musicController.fetchRecentlyPlayedSongs();
    GlobalVariable.instance.myGlobalVariable = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
    child: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CustomColors.backgroundColor,
      bottomNavigationBar: Navbar(),
      body:
      Stack(
      children: [  
      Container(
        width: double.infinity,
        height: double.infinity,
        child: 
        Column(
          children: [
          GestureDetector(
          onTap: (){
            Get.offNamed('/profile');
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
                        Text("Hello",style: TextStyle(fontFamily:'Harmattan' ,fontSize: 15,color: Colors.white),),
                        Text(username,style: TextStyle(fontFamily: 'Harmattan',fontSize: 30,fontWeight: FontWeight.w200,color: Colors.white),),
                      ],
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(profileURL),
                      radius: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
          ),

          InkWell(
          onTap: () {
            Get.offNamed('/search');
          },
          child: Container(
            height: 48,
            width: 390,
            decoration: BoxDecoration(
              color: CustomColors.secondaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            margin: EdgeInsets.only(left: 15,right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Icon(Icons.search,size: 30,color: Colors.white,),
                ),
                Container(
                  width: 200,
                  child: Text("Search for anything", style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 177, 174, 181), fontWeight: FontWeight.w400),),
                ),
                Container(
                  margin: EdgeInsets.only(left: 75),
                  padding: EdgeInsets.only(right: 4),
                  child: Icon(Icons.mic,color: Colors.white,size: 30,),
                )
              ]
            )
          )
          ),
        
          Expanded (
          child: 
          Container (
          child: ListView(
          children: [        // }
          Obx((){
            if (musicController.recentlyPlayed.length < 3) {
            return SizedBox.shrink();
            }
          return Column(  
          children: [
            Container(
            height: 45,
            margin: EdgeInsets.only(top:15,left: 15,right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Recently Played",style: TextStyle(fontFamily: 'Harmattan',fontSize:25, color: TextColors.PrimaryTextColor),),
                InkWell(
                  child: Text("See All >",style: TextStyle(fontFamily: 'Harmattan',fontSize: 15,color: Colors.grey),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 215,
            margin: EdgeInsets.only(top: 10),
            child: ListView(
              children: musicController.recentlyPlayed.map((song)=>
                GestureDetector(
                  child: ListTile(
                    onTap: (){
                      musicController.currentSong.value = song;
                      musicController.searchAndPlayTrack(song['name']);
                      musicController.addToRecentlyPlayed(song);
                    },
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
                      padding: EdgeInsets.only(left: 40),
                      height: 55,
                      width: 100,
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
                  )
              ).toList()
            ),
          ),
          ]
          );
          }),
          Container(
            height: 45,
            margin: EdgeInsets.only(top: 20,left: 15,right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Discover Artists",style: TextStyle(fontFamily: 'Harmattan',fontSize: 25,color: TextColors.PrimaryTextColor ),),
                // InkWell(child: Text("See All >",style: TextStyle(fontFamily: 'Harmattan',fontSize: 20,color: Colors.grey),))
              ],
            ),
          ),
          Container(
            height: 180,
            margin: EdgeInsets.only(left: 15,right: 15),
            child: ListView(
              scrollDirection: Axis.horizontal,
                  children:musicController.artists.map((artist)=>
                      Container(
                        height: 180,
                        width: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(artist['images'][0]['url']),
                              radius: 60,
                            ),
                            Container(
                            padding: EdgeInsets.only(top:10),
                            child: Text(artist['name'], style: TextStyle(fontFamily: 'Harmattan',fontSize: 18, color: TextColors.PrimaryTextColor),),
                            )
                          ],
                        ),
                      ),
            ).toList()
            ),
          ),
          // Container(
          //   height: 120,
          //   //color: Colors.blue,
          //   margin: EdgeInsets.only(left: 15,right: 15),
          //   child: ListView(
          //       scrollDirection: Axis.horizontal,
          //       children:arrSquare.map((value)=>
          //           Container(
          //             height: 120,
          //             width: 120,
          //             //margin: EdgeInsets.only(left: 10,right: 10),
          //             // color: Colors.green,
          //             child: Column(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               children: [
          //                 Container(
          //                   height: 90,
          //                   width: 90,
          //                   child: Image.asset(value['image'].toString()),
          //                 ),
          //                 Text(value['singer'].toString(),style: TextStyle(fontFamily: 'Harmattan',fontSize: 18,fontWeight: FontWeight.w600,color: Colors.white),),
          //               ],
          //             ),

          //           ),
          //       ).toList()
          //   ),
          // )
        Container(
            height: 45,
            margin: EdgeInsets.only(top: 20,left: 15,right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Discover Artists",style: TextStyle(fontFamily: 'Harmattan',fontSize: 25,color: TextColors.PrimaryTextColor ),),
                // InkWell(child: Text("See All >",style: TextStyle(fontFamily: 'Harmattan',fontSize: 20,color: Colors.grey),))
              ],
            ),
          ),
          Container(
            height: 180,
            margin: EdgeInsets.only(left: 15,right: 15),
            child: ListView(
              scrollDirection: Axis.horizontal,
                  children:musicController.artists.map((artist)=>
                      Container(
                        height: 180,
                        width: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(artist['images'][0]['url']),
                              radius: 60,
                            ),
                            Container(
                            padding: EdgeInsets.only(top:10),
                            child: Text(artist['name'], style: TextStyle(fontFamily: 'Harmattan',fontSize: 18, color: TextColors.PrimaryTextColor),),
                            )
                          ],
                        ),
                      ),
            ).toList()
            ),
          ),
          Container(
            height: 45,
            margin: EdgeInsets.only(top: 20,left: 15,right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Discover Artists",style: TextStyle(fontFamily: 'Harmattan',fontSize: 25,color: TextColors.PrimaryTextColor ),),
                // InkWell(child: Text("See All >",style: TextStyle(fontFamily: 'Harmattan',fontSize: 20,color: Colors.grey),))
              ],
            ),
          ),
          Container(
            height: 180,
            margin: EdgeInsets.only(left: 15,right: 15),
            child: ListView(
              scrollDirection: Axis.horizontal,
                  children:musicController.artists.map((artist)=>
                      Container(
                        height: 180,
                        width: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(artist['images'][0]['url']),
                              radius: 60,
                            ),
                            Container(
                            padding: EdgeInsets.only(top:10),
                            child: Text(artist['name'], style: TextStyle(fontFamily: 'Harmattan',fontSize: 18, color: TextColors.PrimaryTextColor),),
                            )
                          ],
                        ),
                      ),
            ).toList()
            ),
          ),
          Container(
            height: 45,
            margin: EdgeInsets.only(top: 20,left: 15,right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Discover Artists",style: TextStyle(fontFamily: 'Harmattan',fontSize: 25,color: TextColors.PrimaryTextColor ),),
                // InkWell(child: Text("See All >",style: TextStyle(fontFamily: 'Harmattan',fontSize: 20,color: Colors.grey),))
              ],
            ),
          ),
          Container(
            height: 180,
            margin: EdgeInsets.only(left: 15,right: 15),
            child: ListView(
              scrollDirection: Axis.horizontal,
                  children:musicController.artists.map((artist)=>
                      Container(
                        height: 180,
                        width: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(artist['images'][0]['url']),
                              radius: 60,
                            ),
                            Container(
                            padding: EdgeInsets.only(top:10),
                            child: Text(artist['name'], style: TextStyle(fontFamily: 'Harmattan',fontSize: 18, color: TextColors.PrimaryTextColor),),
                            )
                          ],
                        ),
                      ),
            ).toList()
            ),
          ),
        ]
        ),
        ),
        ),
      ]
    ),
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








