import 'package:app1/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:app1/constants/style.dart';
import 'package:get/get.dart';
import 'package:app1/widgets/navbar.dart';
import 'package:app1/widgets/bottom_bar.dart';
import 'package:app1/music_controller.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> with TickerProviderStateMixin {
  final MusicController musicController = Get.find<MusicController>();
  final UserController userController = Get.find<UserController>();
  late final TabController tabController;

  @override
  void initState(){
    userController.getRequestsList();
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  void dispose() {
    tabController.dispose();
    super.dispose();
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
        title: Text("Friends", style: TextStyle(color: TextColors.PrimaryTextColor, fontSize: 22),),
        centerTitle: true,
        bottom: TabBar(
          controller: tabController,
          dividerColor: TextColors.SecondaryTextColor,
          indicatorWeight: 4,
          labelStyle: TextStyle(fontSize: 16),
          tabs: [
            Tab(text: "Friends",),
            Tab(text: "Sent",),
            Tab(text: "Received"),
          ],
        ),
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: tabController,
                children: [
                  Obx(() {
                  if(userController.friendsList.isEmpty) {
                    return Center(
                      child: Text("No Friends", style: TextStyle(color: TextColors.SecondaryTextColor),),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.only(top:12),
                    itemCount: userController.friendsList.length,
                    itemBuilder: (context, index) {
                      var user = userController.friendsList[index];
                      return ListTile(
                        onTap: () {
                          userController.currentDisplayUser.assignAll(user);
                          userController.getSharedList(user['username']);
                          Get.toNamed('/shared');
                        },
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                        leading: GestureDetector(
                        onTap: () {
                          userController.friendStatus="Remove Friend";
                          userController.currentDisplayUser.assignAll(user);
                          Get.toNamed('user_profile');
                        },
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(user['photoURL']),
                          radius: 30,
                        ),
                        ),
                        title: Text(user['username'], style: TextStyle(color: TextColors.PrimaryTextColor, fontSize: 15)),
                        trailing: IconButton(
                          icon: Icon(Icons.arrow_forward_ios, color: TextColors.PrimaryTextColor,),
                          onPressed: () {
                            
                          },
                        ),
                      );
                    },
                  );
                  }),
                  Obx(() {
                  if(userController.sentList.isEmpty) {
                    return Center(
                      child: Text("No sent requests", style: TextStyle(color: TextColors.SecondaryTextColor),),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.only(top:12),
                    itemCount: userController.sentList.length,
                    itemBuilder: (context, index) {
                      var user = userController.sentList[index];
                      return ListTile(
                        onTap: () {
                          userController.currentDisplayUser.assignAll(user);
                          Get.toNamed('user_profile');
                        },
                        contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 7),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user['photoURL']),
                          radius: 30,
                        ),
                        title: Text(user['username'], style: TextStyle(color: TextColors.PrimaryTextColor, fontSize: 15)),
                        trailing: IconButton(
                          icon: Icon(Icons.close, color: Colors.white,),
                          onPressed: () {
                            userController.cancelRequest(username: user['username']);
                            Get.snackbar(
                              "Request Canceled", 
                              "",
                              snackPosition: SnackPosition.BOTTOM,
                              duration: Duration(seconds: 2),
                              backgroundColor: CustomColors.secondaryColor,
                              colorText: Colors.white, 
                            );
                          },
                        ),
                      );
                    },
                  );
                  }),
                  Obx(() {
                  if(userController.receivedList.isEmpty) {
                    return Center(
                      child: Text("No pending requests", style: TextStyle(color: TextColors.SecondaryTextColor),),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.only(top:12),
                    itemCount: userController.receivedList.length,
                    itemBuilder: (context, index) {
                      var user = userController.receivedList[index];
                      return ListTile(
                        onTap: () {
                          userController.currentDisplayUser.assignAll(user);
                          Get.toNamed('user_profile');
                        },
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user['photoURL']),
                          radius: 30,
                        ),
                        title: Text(user['username'], style: TextStyle(color: TextColors.PrimaryTextColor, fontSize: 15)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.check, color: Colors.white,),
                              onPressed: () {
                                userController.acceptRequest(username: user['username']);
                                Get.snackbar(
                                  "Request Accepted", 
                                  "",
                                  snackPosition: SnackPosition.BOTTOM,
                                  duration: Duration(seconds: 2),
                                  backgroundColor: CustomColors.secondaryColor,
                                  colorText: Colors.white, 
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.white,),
                              onPressed: () {
                                userController.cancelRequest(username: user['username']);
                                Get.snackbar(
                                  "Request Denied", 
                                  "",
                                  snackPosition: SnackPosition.BOTTOM,
                                  duration: Duration(seconds: 2),
                                  backgroundColor: CustomColors.secondaryColor,
                                  colorText: Colors.white, 
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                  })
                ],
              ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BottomBar(),
            ),
          ]
        )
      ),
    );
  }
}