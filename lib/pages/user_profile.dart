import 'package:app1/user_controller.dart';
import 'package:app1/user_data.dart';
import 'package:flutter/material.dart';
import 'package:app1/constants/style.dart';
import 'package:get/get.dart';
import 'package:app1/widgets/navbar.dart';
import 'package:app1/widgets/bottom_bar.dart';
import 'package:app1/music_controller.dart';


class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final MusicController musicController = Get.find<MusicController>();
  final UserController userController = Get.find<UserController>();
  var status = "";

  @override
  void initState(){
    userController.getFriendStatus(userController.currentDisplayUser['username']);
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
        actions: [
          Container(
          padding: EdgeInsets.only(right: 17),
          child: Obx((){
          userController.getFriendStatus(userController.currentDisplayUser['username']);
          return ElevatedButton(
            onPressed: () {
              if(userController.friendStatus == "Add Friend"){
                userController.sendRequest(username: userController.currentDisplayUser['username']);
                Get.snackbar(
                  "Request Sent", 
                  "",
                  snackPosition: SnackPosition.BOTTOM,
                  duration: Duration(seconds: 2),
                  backgroundColor: CustomColors.secondaryColor,
                  colorText: Colors.white, 
                  );
              }
              else if(userController.friendStatus == "Remove Friend"){
                userController.cancelRequest(username: userController.currentDisplayUser['username']);
                Get.snackbar(
                  "Removed Friend", 
                  "",
                  snackPosition: SnackPosition.BOTTOM,
                  duration: Duration(seconds: 2),
                  backgroundColor: CustomColors.secondaryColor,
                  colorText: Colors.white, 
                );
              }
              else if(userController.friendStatus == "Accept Request"){
                userController.acceptRequest(username: userController.currentDisplayUser['username']);
                Get.snackbar(
                  "Added Friend", 
                  "",
                  snackPosition: SnackPosition.BOTTOM,
                  duration: Duration(seconds: 2),
                  backgroundColor: CustomColors.secondaryColor,
                  colorText: Colors.white, 
                );
              }
              // userController.getFriendStatus(userController.currentDisplayUser['username']);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(CustomColors.primaryColor),
              foregroundColor: WidgetStateProperty.all<Color>(TextColors.PrimaryTextColor),
            ),
            child: Text(userController.friendStatus),
          );
          })
          )
        ]
      ),
      bottomNavigationBar: Navbar(),
      body: Stack(
      children: [
        Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: 160,
            child:Center(
              child: CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(userController.currentDisplayUser['photoURL']),
              )
            ),
          ),
          SizedBox(
            height: 30,
            child: Text(userController.currentDisplayUser['username'], style: TextStyle(fontSize: 25, color: TextColors.PrimaryTextColor),),
          ),
          Container(
            height: 80,
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(userController.currentDisplayUser['requests']['friends']!.length.toString()??"0",style: TextStyle(fontSize: 25, color: TextColors.PrimaryTextColor),),
                        Text("Friends",style: TextStyle(fontSize: 15, color: TextColors.PrimaryTextColor),),
                      ],
                    ),
                    Column(
                      children: [
                        Text((userController.currentDisplayUser['playlists']!.length-1).toString()??"0",style: TextStyle(fontSize: 25, color: TextColors.PrimaryTextColor),),
                        Text("Playlists",style: TextStyle(fontSize: 15, color: TextColors.PrimaryTextColor),),
                      ],
                    ),
                  ],
                ),
              ]
            ),
          ),
          Container(
            height: 240,
            padding: EdgeInsets.only(bottom: 50, top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
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
                        Text("Playlists",style: TextStyle(fontSize: 18, color: TextColors.PrimaryTextColor,),),
                        SizedBox(
                          width: 90,
                        ),
                        IconButton(
                          onPressed: (){
                            userController.fetchUserPlaylists();
                            Get.toNamed("/user_playlists");
                          },
                          icon: Icon(Icons.arrow_forward_ios, color: TextColors.PrimaryTextColor,),
                        )
                      ],
                    ),
                  ),
                ),
                userController.friendStatus!="Remove Friend"
                ?SizedBox.shrink()
                :Center(
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
                        Icon(Icons.share,size:25, color: TextColors.PrimaryTextColor,),
                        Text("Shared Songs", style: TextStyle(fontSize: 18, color: TextColors.PrimaryTextColor),),
                        SizedBox(
                          width: 90,
                        ),
                        IconButton(
                          onPressed: (){
                            userController.getSharedList(userController.currentDisplayUser['username']);
                            Get.toNamed('/shared');
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
            height: 170,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: .25,
                  color: CustomColors.backgroundColor,
                )
              )
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

// class UserProfilePage extends StatelessWidget {
//   final String userId;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('User Profile'),
//       ),
//       body: FutureBuilder<DocumentSnapshot>(
//         future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData) {
//             return Center(child: Text('User not found'));
//           }

//           var user = snapshot.data!;
//           var displayName = user['displayName'];
//           var photoURL = user['photoURL'];

//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CircleAvatar(
//                   radius: 50,
//                   backgroundImage: NetworkImage(photoURL),
//                 ),
//                 SizedBox(height: 20),
//                 Text(displayName, style: TextStyle(fontSize: 24)),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }