import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app1/music_controller.dart';
import 'package:app1/constants/style.dart';
import 'package:app1/auth.dart';
import 'package:app1/widgets/navbar.dart';
import 'package:app1/user_data.dart';
import 'package:app1/widgets/bottom_bar.dart';  
import 'dart:async';
import 'package:app1/user_controller.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class SearchWidget extends StatefulWidget {
  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final AuthController authController = Get.find();
  final TextEditingController searchController = TextEditingController();
  final MusicController musicController = Get.find<MusicController>();
  final UserController userController = Get.find<UserController>();
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    GlobalVariable.instance.myGlobalVariable = 1;
    _initSpeech();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      musicController.searchResults.clear();
    });
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      searchController.text = _lastWords;
      musicController.search(_lastWords);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColors.backgroundColor,
        bottomNavigationBar: Navbar(),
        body: Stack(
          children: [
            Column(
              children: [
                _buildTopBar(),
                _buildSearchBar(),
                _buildResultsList(),
              ],
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

  Widget _buildTopBar() {
    return Container(
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios, color: TextColors.PrimaryTextColor),
          ),
          Obx(() => _buildTabButtons()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48,
      width: 390,
      decoration: BoxDecoration(
        color: CustomColors.secondaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Center(
        child: TextField(
          style: TextStyle(color: TextColors.PrimaryTextColor),
          controller: searchController,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: TextColors.PrimaryTextColor, size: 25),
            suffixIcon: IconButton(
              icon: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic, color: TextColors.PrimaryTextColor, size: 25),
              onPressed: () {
                _speechToText.isNotListening ? startListening() : stopListening();
              },
            ),
            hintText: _speechToText.isListening
              ? 'Say something'
              : 'Search for anything',
            hintStyle: TextStyle(fontSize: 20, color: Color.fromARGB(255, 177, 174, 181), fontWeight: FontWeight.w400),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            debounce(() {
              musicController.search(value);
            }, duration: Duration(milliseconds: 500));
          },
        ),
      ),
    );
  }

  Widget _buildResultsList() {
    return Expanded(
      child: Obx(() {
        if (musicController.isSearchingUsers.value) {
          return _buildUsersList();
        } else if (musicController.isSearchingSongs.value) {
          return _buildSongsList();
        } else if (musicController.isSearchingArtists.value) {
          return _buildArtistsList();
        } else {
          return Center(child: Text('No results found'));
        }
      }),
    );
  }

  Widget _buildTabButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTabButton('Songs', musicController.isSearchingSongs.value),
        SizedBox(width: 16),
        _buildTabButton('Artists', musicController.isSearchingArtists.value),
        SizedBox(width: 16),
        _buildTabButton('Users', musicController.isSearchingUsers.value),
      ],
    );
  }

  Widget _buildTabButton(String text, bool isSelected) {
    return ElevatedButton(
      onPressed: () {
        searchController.clear();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          musicController.searchResults.clear();
          musicController.isSearchingSongs.value = (text == 'Songs');
          musicController.isSearchingArtists.value = (text == 'Artists');
          musicController.isSearchingUsers.value = (text == 'Users');
          musicController.search('');
        });
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
          isSelected ? TextColors.PrimaryTextColor : CustomColors.secondaryColor,
        ),
        foregroundColor: WidgetStateProperty.all<Color>(
          isSelected ? CustomColors.backgroundColor : TextColors.PrimaryTextColor,
        ),
      ),
      child: Text(text),
    );
  }

  Widget _buildUsersList() {
    return Obx(() {
      if (musicController.searchResults.isEmpty) {
        return Center(child: Text('No users found', style: TextStyle(color: TextColors.SecondaryTextColor),));
      }
      return ListView.builder(
        padding: EdgeInsets.only(top: 10),
        itemCount: musicController.searchResults.length,
        itemBuilder: (context, index) {
          var user = musicController.searchResults[index];
          return ListTile(
            onTap: () {
              userController.currentDisplayUser.assignAll(user);
              userController.getFriendStatus(user['username']);
              Get.toNamed('user_profile');
            },
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user['photoURL']),
              radius: 30,
            ),
            title: Text(user['username'], style: TextStyle(color: TextColors.PrimaryTextColor, fontSize: 15)),
            trailing: IconButton(
              onPressed: () {
                // Handle more options
              },
              icon: Icon(Icons.more_vert, size: 30, color: TextColors.SecondaryTextColor),
            ),
          );
        },
      );
    });
  }

  Widget _buildSongsList() {
    return Obx(() {
      if (musicController.searchResults.isEmpty) {
        return Center(child: Text('No songs found', style: TextStyle(color: TextColors.SecondaryTextColor),));
      }
      return ListView.builder(
        padding: EdgeInsets.only(top: 10),
        itemCount: musicController.searchResults.length,
        itemBuilder: (context, index) {
          var song = musicController.searchResults[index];
          return ListTile(
            onTap: () {
              setState(() {
              musicController.currentSong.value = song;
              musicController.searchAndPlayTrack(song['name']+" "+song['artists'][0]['name']);
              musicController.addToRecentlyPlayed(song);
              musicController.playlistName = "Search";
              musicController.getRecommendations(song['id']);
              musicController.currentPlaylist=musicController.recommendedTracks;
              musicController.currentSongIndex=0;
              });
              // musicController.setPlaylist();
              // musicController.audioPlayer.setAudioSource(musicController.playlist, preload: true);
              // musicController.audioPlayer.play();
              // musicController.isPlaying.value=true;
              // musicController.fromDownloads=false;
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
          );
        },
      );
    });
  }

  Widget _buildArtistsList() {
    return Obx(() {
      if (musicController.searchResults.isEmpty) {
        return Center(child: Text('No artists found', style: TextStyle(color: TextColors.SecondaryTextColor),));
      }
      return ListView.builder(
        padding: EdgeInsets.only(top: 10),
        itemCount: musicController.searchResults.length,
        itemBuilder: (context, index) {
          var artist = musicController.searchResults[index];
          return ListTile(
            onTap: () {
              // Handle artist tap
            },
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(artist['images'][0]['url']),
              radius: 30,
            ),
            title: Text(artist['name'], style: TextStyle(color: TextColors.PrimaryTextColor, fontSize: 15)),
            trailing: IconButton(
              onPressed: () {
                // Handle more options
              },
              icon: Icon(Icons.more_vert, size: 30, color: TextColors.SecondaryTextColor),
            ),
          );
        },
      );
    });
  }

  // Debounce function to avoid excessive state changes
  void debounce(VoidCallback action, {Duration duration = const Duration(milliseconds: 500)}) {
    Timer? debounceTimer;
    if (debounceTimer != null) {
      debounceTimer.cancel();
    }
    debounceTimer = Timer(duration, action);
  }
}




// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:app1/music_controller.dart';
// import 'package:app1/constants/style.dart';
// import 'package:app1/auth.dart';
// import 'package:app1/widgets/navbar.dart';
// import 'package:app1/user_data.dart';
// import 'package:app1/assets/images.dart';
// import 'package:app1/widgets/bottom_bar.dart';  

// class SearchWidget extends StatefulWidget {
//   @override
//   _SearchWidgetState createState() => _SearchWidgetState();
// }

// class _SearchWidgetState extends State<SearchWidget> {
//   final AuthController authController = Get.find();
//   final TextEditingController searchController = TextEditingController();
//   final MusicController musicController = Get.find<MusicController>();

//   @override
//   void initState() {
//     GlobalVariable.instance.myGlobalVariable = 1;
//     // username = user?.displayName ?? "user";
//     // profileURL = user?.photoURL ?? userProfileURL;
//     musicController.searchResults.clear();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: CustomColors.backgroundColor,
//         bottomNavigationBar: Navbar(),
//         body: Stack(
//           children: [
//             Column(
//               children: [
//                 Container(
//                   height: 80,
//                   padding: EdgeInsets.only(right: 15, left: 15),
//                   child: Row(
//                     children: [
//                       Container(
//                         padding: EdgeInsets.only(right: 30),
//                         child: IconButton(
//                           onPressed: () {
//                             Get.back();
//                           },
//                           icon: Icon(Icons.arrow_back_ios, color: TextColors.PrimaryTextColor),
//                         ),
//                       ),
//                       Container(
//                         child: Obx(() {
//                           return _buildTabButtons();
//                         }),
//                       )
//                     ],
//                   ),
//                 ),
//                 Container(
//                   height: 48,
//                   width: 390,
//                   decoration: BoxDecoration(
//                     color: CustomColors.secondaryColor,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   margin: EdgeInsets.only(left: 15, right: 15),
//                   child: Center(
//                     child: TextField(
//                       style: TextStyle(color: TextColors.PrimaryTextColor),
//                       controller: searchController,
//                       decoration: InputDecoration(
//                         prefixIcon: Icon(Icons.search, color: TextColors.PrimaryTextColor, size: 25),
//                         suffixIcon: Icon(Icons.mic, color: TextColors.PrimaryTextColor, size: 25),
//                         hintText: "Search for anything",
//                         hintStyle: TextStyle(fontSize: 20, color: Color.fromARGB(255, 177, 174, 181), fontWeight: FontWeight.w400),
//                         border: InputBorder.none,
//                       ),
//                       onChanged: (value) {
//                         musicController.search(value);
//                       },
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Obx(() {
//                     if (musicController.isSearchingUsers.value) {
//                       return _buildUsersList();
//                     } else if (musicController.isSearchingSongs.value) {
//                       return _buildSongsList();
//                     } else if (musicController.isSearchingArtists.value) {
//                       return _buildArtistsList();
//                     } else {
//                       return Center(child: Text('No results found'));
//                     }
//                   }),
//                 ),
//               ],
//             ),
//             Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: BottomBar(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTabButtons() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         _buildTabButton('Songs', musicController.isSearchingSongs.value),
//         SizedBox(width: 16),
//         _buildTabButton('Artists', musicController.isSearchingArtists.value),
//         SizedBox(width: 16),
//         _buildTabButton('Users', musicController.isSearchingUsers.value),
//       ],
//     );
//   }

//   Widget _buildTabButton(String text, bool isSelected) {
//     return ElevatedButton(
//       onPressed: () {
//         searchController.clear();
//         musicController.searchResults.clear();
//         musicController.isSearchingSongs.value = (text == 'Songs');
//         musicController.isSearchingArtists.value = (text == 'Artists');
//         musicController.isSearchingUsers.value = (text == 'Users');
//         musicController.search('');
//       },
//       style: ButtonStyle(
//         backgroundColor: WidgetStateProperty.all<Color>(
//           isSelected ? TextColors.PrimaryTextColor : CustomColors.secondaryColor,
//         ),
//         foregroundColor: WidgetStateProperty.all<Color>(
//         isSelected ? CustomColors.backgroundColor : TextColors.PrimaryTextColor,
//         ),
//       ),
//       child: Text(text),
//     );
//   }

//   Widget _buildUsersList() {
//     return Obx(() {
//       if (musicController.searchResults.isEmpty) {
//         return Center(child: Text('No users found', style: TextStyle(color: TextColors.SecondaryTextColor),));
//       }
//       return ListView.builder(
//         padding: EdgeInsets.only(top: 10),
//         itemCount: musicController.searchResults.length,
//         itemBuilder: (context, index) {
//           var user = musicController.searchResults[index];
//           return ListTile(
//             onTap: () {
//               // Handle user tap
//             },
//             contentPadding: EdgeInsets.only(left: 20, right: 5, top: 7, bottom: 7),
//             leading: CircleAvatar(
//               backgroundImage: NetworkImage(user['photoURL']),
//               radius: 30,
//             ),
//             title: Text(user['username'], style: TextStyle(color: TextColors.PrimaryTextColor, fontSize: 15)),
//             trailing: Container(
//               height: 55,
//               width: 70,
//               child: IconButton(
//                 onPressed: () {
//                   // Handle more options
//                 },
//                 icon: Icon(Icons.more_vert, size: 30, color: TextColors.SecondaryTextColor),
//               ),
//             ),
//           );
//         },
//       );
//     });
//   }

//   Widget _buildSongsList() {
//     return Obx(() {
//       if (musicController.searchResults.isEmpty) {
//         return Center(child: Text('No songs found', style: TextStyle(color: TextColors.SecondaryTextColor),));
//       }
//       return Container(
//         height: 215,
//         margin: EdgeInsets.only(top: 10),
//         child: ListView(
//           children: musicController.searchResults.map((song) =>
//             ListTile(
//               onTap: () {
//                 musicController.currentSong.value = song;
//                 musicController.searchAndPlayTrack(song['name']);
//                 musicController.addToRecentlyPlayed(song);
//               },
//               contentPadding: EdgeInsets.only(left: 20, right: 5, top:2),
//               leading: Container(
//                 height: 55,
//                 width: 65,
//                 child: Image(image: NetworkImage(song['album']['images'][0]['url'])),
//               ),
//               title: Text(
//                 song['name'], 
//                 style: TextStyle(color: TextColors.PrimaryTextColor, fontSize: 15,),
//                 overflow: TextOverflow.ellipsis,
//               ),
//               subtitle: Text(
//                 song['artists'][0]['name'], 
//                 style: TextStyle(color: TextColors.SecondaryTextColor, fontSize: 13),
//                 overflow: TextOverflow.ellipsis,
//               ),
//               trailing: Container(
//                 height: 55,
//                 width: 70,
//                 child: IconButton(
//                   onPressed: () {
//                     // Handle more options
//                   },
//                   icon: Icon(Icons.more_vert, size: 30, color: TextColors.SecondaryTextColor),
//                 ),
//               ),
//             ),
//           ).toList(),
//         ),
//       );
//     });
//   }

//   Widget _buildArtistsList() {
//     return Obx(() {
//       if (musicController.searchResults.isEmpty) {
//         return Center(child: Text('No artists found', style: TextStyle(color: TextColors.SecondaryTextColor),));
//       }
//       return ListView.builder( 
//         padding: EdgeInsets.only(top: 10),
//         itemCount: musicController.searchResults.length,
//         itemBuilder: (context, index) {
//           var artist = musicController.searchResults[index];
//           return ListTile(
//             onTap: () {
//               // Handle artist tap
//             },
//             contentPadding: EdgeInsets.only(left: 20, right: 5, top: 7, bottom: 7),
//             leading: CircleAvatar(
//               backgroundImage: NetworkImage(artist['images'][0]['url']),
//               radius: 30,
//             ),
//             title: Text(artist['name'], style: TextStyle(color: TextColors.PrimaryTextColor, fontSize: 15)),
//             trailing: Container(
//               height: 55,
//               width: 70,
//               child: IconButton(
//                 onPressed: () {
//                   // Handle more options
//                 },
//                 icon: Icon(Icons.more_vert, size: 30, color: TextColors.SecondaryTextColor),
//               ),
//             ),
//           );
//         },
//       );
//     });
//   }
// }
