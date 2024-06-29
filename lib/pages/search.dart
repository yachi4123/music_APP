import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app1/music_controller.dart';
import 'package:app1/constants/style.dart';
import 'package:app1/auth.dart';
import 'package:app1/widgets/navbar.dart';
import 'package:app1/user_data.dart';
import 'package:app1/assets/images.dart';
import 'package:app1/widgets/bottom_bar.dart';  

class SearchWidget extends StatefulWidget {
  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final AuthController authController = Get.find();
  final TextEditingController _searchController = TextEditingController();
  final MusicController musicController = Get.find<MusicController>();

  @override
  void initState() {
    GlobalVariable.instance.myGlobalVariable = 1;
    username = user?.displayName ?? "user";
    profileURL = user?.photoURL ?? userProfileURL;
    musicController.searchResults.clear();
    super.initState();
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
                Container(
                  height: 80,
                  padding: EdgeInsets.only(right: 15, left: 15),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 30),
                        child: IconButton(
                          onPressed: () {
                            Get.offNamed('/home');
                          },
                          icon: Icon(Icons.arrow_back_ios, color: TextColors.PrimaryTextColor),
                        ),
                      ),
                      Container(
                        child: Obx(() {
                          return _buildTabButtons();
                        }),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 48,
                  width: 390,
                  decoration: BoxDecoration(
                    color: CustomColors.secondaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: Center(
                    child: TextField(
                      style: TextStyle(color: TextColors.PrimaryTextColor),
                      controller: _searchController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: TextColors.PrimaryTextColor, size: 25),
                        suffixIcon: Icon(Icons.mic, color: TextColors.PrimaryTextColor, size: 25),
                        hintText: "Search for anything",
                        hintStyle: TextStyle(fontSize: 20, color: Color.fromARGB(255, 177, 174, 181), fontWeight: FontWeight.w400),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        musicController.search(value);
                      },
                    ),
                  ),
                ),
                Expanded(
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
                ),
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
        _searchController.clear();
        musicController.searchResults.clear();
        musicController.isSearchingSongs.value = (text == 'Songs');
        musicController.isSearchingArtists.value = (text == 'Artists');
        musicController.isSearchingUsers.value = (text == 'Users');
        musicController.search('');
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
        itemCount: musicController.searchResults.length,
        itemBuilder: (context, index) {
          var user = musicController.searchResults[index];
          return ListTile(
            minVerticalPadding: 70,
            onTap: () {
              // Handle user tap
            },
            contentPadding: EdgeInsets.only(left: 20, right: 5, top: 8),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user['photoURL']),
              radius: 30,
            ),
            title: Text(user['username'], style: TextStyle(color: TextColors.PrimaryTextColor, fontSize: 15)),
            trailing: Container(
              height: 55,
              width: 70,
              child: IconButton(
                onPressed: () {
                  // Handle more options
                },
                icon: Icon(Icons.more_vert, size: 30, color: TextColors.SecondaryTextColor),
              ),
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
      return Container(
        height: 215,
        margin: EdgeInsets.only(top: 10),
        child: ListView(
          children: musicController.searchResults.map((song) =>
            ListTile(
              onTap: () {
                musicController.currentSong.value = song;
                musicController.searchAndPlayTrack(song['name']);
                musicController.addToRecentlyPlayed(song);
              },
              contentPadding: EdgeInsets.only(left: 20, right: 5, top:2),
              leading: Container(
                height: 55,
                width: 65,
                child: Image(image: NetworkImage(song['album']['images'][0]['url'])),
              ),
              title: Text(
                song['name'], 
                style: TextStyle(color: TextColors.PrimaryTextColor, fontSize: 15,),
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                song['artists'][0]['name'], 
                style: TextStyle(color: TextColors.SecondaryTextColor, fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Container(
                height: 55,
                width: 70,
                child: IconButton(
                  onPressed: () {
                    // Handle more options
                  },
                  icon: Icon(Icons.more_vert, size: 30, color: TextColors.SecondaryTextColor),
                ),
              ),
            ),
          ).toList(),
        ),
      );
    });
  }

  Widget _buildArtistsList() {
    return Obx(() {
      if (musicController.searchResults.isEmpty) {
        return Center(child: Text('No artists found', style: TextStyle(color: TextColors.SecondaryTextColor),));
      }
      return ListView.builder(
        itemCount: musicController.searchResults.length,
        itemBuilder: (context, index) {
          var artist = musicController.searchResults[index];
          return ListTile(
            minVerticalPadding: 70,
            onTap: () {
              // Handle artist tap
            },
            contentPadding: EdgeInsets.only(left: 20, right: 5, top: 8),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(artist['images'][0]['url']),
              radius: 30,
            ),
            title: Text(artist['name'], style: TextStyle(color: TextColors.PrimaryTextColor, fontSize: 15)),
            trailing: Container(
              height: 55,
              width: 70,
              child: IconButton(
                onPressed: () {
                  // Handle more options
                },
                icon: Icon(Icons.more_vert, size: 30, color: TextColors.SecondaryTextColor),
              ),
            ),
          );
        },
      );
    });
  }
}
