import 'package:app1/user_controller.dart';
import 'package:app1/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final UserController userController = Get.find<UserController>();
    final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    username = user?.displayName??"user";
    profileURL = user?.photoURL?? userProfileURL;
    musicController.fetchRecentlyPlayedSongs();
    musicController.getRecommendedArtists();
    musicController.getMadePlaylists();
    musicController.getSongs();
    GlobalVariable.instance.myGlobalVariable = 0;
    userController.getRequestsList();
    super.initState();
  }

  Future<bool> _showExitConfirmationDialog() async {
    return await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: CustomColors.secondaryColor,
        content: Text('Are you sure you want to exit?', style: TextStyle(color: TextColors.PrimaryTextColor),),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: Text('Yes'),
          ),
        ],
      ),
    ) ??
    false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async{
        if(didPop) return;
        await _showExitConfirmationDialog();
      },
    child: SafeArea(
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
                        Text("Hello",style: TextStyle(fontFamily:'Harmattan' ,fontSize: 15,color: Colors.white),),
                        Text(username,style: TextStyle(fontFamily: 'Harmattan',fontSize: 30,fontWeight: FontWeight.w200,color: Colors.white),overflow: TextOverflow.ellipsis,),
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
            Get.toNamed('/search');
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
          children: [        
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
                  onTap: (){
                    musicController.currentPlaylist = musicController.recentlyPlayed;
                    musicController.currentPlaylistName = "Recently Played";
                    Get.toNamed('/playlist');
                  },
                  child: Text("See All >",style: TextStyle(fontFamily: 'Harmattan',fontSize: 15,color: Colors.grey),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 215,
            margin: EdgeInsets.only(top: 5,bottom: 10),
            child: ListView(
              children: musicController.recentlyPlayed.map((song)=>
                  ListTile(
                    onTap: (){
                      musicController.currentPlaylist=musicController.recentlyPlayed;
                      musicController.currentPlaylistName="Recently Played";
                      // musicController.setPlaylist();
                      musicController.currentSong.value = song;
                      // musicController.audioPlayer.setAudioSource(musicController.playlist,preload: false);
                      // musicController.audioPlayer.play();
                      musicController.searchAndPlayTrack(song['name']+" "+song['artists'][0]['name']);
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
                  )
              ).toList()
            ),
          ),
          ]
          );
          }),
          Container(
            height: 45,
            margin: EdgeInsets.only(top: 25,left: 15,right: 15,bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Discover Artists",style: TextStyle(fontFamily: 'Harmattan',fontSize: 25,color: TextColors.PrimaryTextColor ),),
                // InkWell(child: Text("See All >",style: TextStyle(fontFamily: 'Harmattan',fontSize: 20,color: Colors.grey),))
              ],
            ),
          ),
          Container(
            height: 220,
            margin: EdgeInsets.only(left: 15,right: 15),
            child: ListView(
              scrollDirection: Axis.horizontal,
                children:musicController.discoverArtists.map((artist)=>
                  GestureDetector(
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
                Text("Explore Different Genres",style: TextStyle(fontFamily: 'Harmattan',fontSize: 25,color: TextColors.PrimaryTextColor ),),
                // InkWell(child: Text("See All >",style: TextStyle(fontFamily: 'Harmattan',fontSize: 20,color: Colors.grey),))
              ],
            ),
          ),
          Container(
            height: 120,
            margin: EdgeInsets.only(left: 15,right: 15, bottom: 10),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children:musicController.genres.map((value)=>
              GestureDetector(
                onTap: () {
                  musicController.currentGenre = value;
                  musicController.fetchTopSongsForGenre(value);
                  musicController.fetchTopArtistsForGenre(value);
                },
                child: Container(
                  height: 130,
                  width: 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [CustomColors.primaryColor,CustomColors.secondaryColor],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                        child: Text(value.toString(),style: TextStyle(fontWeight: FontWeight.w300, fontFamily: 'Harmattan',fontSize: 18,color: Colors.white),),
                        ),
                      ),
                    ],
                  ),
                ),
                )
                ).toList()
            ),
          ),
          Container(
            height: 45,
            margin: EdgeInsets.only(top: 20,left: 15,right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Playlists For You",style: TextStyle(fontFamily: 'Harmattan',fontSize: 25,color: TextColors.PrimaryTextColor ),),
                // InkWell(child: Text("See All >",style: TextStyle(fontFamily: 'Harmattan',fontSize: 20,color: Colors.grey),))
              ],
            ),
          ),
          Container(
            height: 200,
            margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (context, index) {
                var value = musicController.madePlaylists[index];
                var name = musicController.madePlaylistNames[index];
                return GestureDetector(
                  onTap: () {
                    musicController.currentPlaylist = value;
                    musicController.currentPlaylistName = name;
                    Get.toNamed('/playlist');
                  },
                  child: Container(
                    height: 160,
                    width: 160,
                    margin: EdgeInsets.symmetric(horizontal: 5), // Add margin if needed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 150,
                          width: 150,
                          child: Image.network(value[0]['album']['images'][0]['url']),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(name, style: TextStyle(color: TextColors.PrimaryTextColor, fontWeight: FontWeight.w300, fontSize: 18),overflow: TextOverflow.ellipsis,),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            height: 45,
            margin: EdgeInsets.only(top:15,left: 15,right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Songs you might like",style: TextStyle(fontFamily: 'Harmattan',fontSize:25, color: TextColors.PrimaryTextColor),),
                InkWell(
                  onTap: (){
                    musicController.currentPlaylist = musicController.songs;
                    musicController.currentPlaylistName = "Songs you might like";
                    Get.toNamed('/playlist');
                  },
                  child: Text("See All >",style: TextStyle(fontFamily: 'Harmattan',fontSize: 15,color: Colors.grey),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 400,
            margin: EdgeInsets.only(top: 5,bottom: 10),
            child: ListView(
              children: musicController.songs.map((song)=>
                  ListTile(
                    onTap: (){
                      musicController.currentPlaylist=musicController.songs;
                      musicController.currentPlaylistName="Songs You Might Like";
                      // musicController.setPlaylist();
                      musicController.currentSong.value = song;
                      // musicController.audioPlayer.setAudioSource(musicController.playlist,preload: false);
                      // musicController.audioPlayer.play();
                      musicController.searchAndPlayTrack(song['name']+" "+song['artists'][0]['name']);
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
                  )
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
    ),
    );
  }
}








