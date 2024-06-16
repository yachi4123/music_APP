import 'package:app1/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app1/auth.dart';

class MyApp extends StatefulWidget {
  static String id = 'home_screen';
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

int currentPageIndex=0;
class _MyAppState extends State<MyApp> {
  final AuthController authController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: Colors.black,
          selectedIndex: currentPageIndex,
          backgroundColor: Colors.black,
          animationDuration: const Duration(seconds: 0),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          destinations:const [
            NavigationDestination(
              selectedIcon: Icon(Icons.home, color: Colors.white), 
              icon: Icon(Icons.home, color: CustomColors.secondaryColor), 
              label: 'Home'),
            NavigationDestination(
              selectedIcon: Icon(Icons.search, color: Colors.white), 
              icon: Icon(Icons.search, color: CustomColors.secondaryColor), 
              label: 'Search'),
            NavigationDestination(
              selectedIcon: Icon(Icons.music_note, color: Colors.white), 
              icon: Icon(Icons.music_note, color: CustomColors.secondaryColor), 
              label: 'Playlists'),
            NavigationDestination(
              selectedIcon: Icon(Icons.person, color: Colors.white), 
              icon: Icon(Icons.person, color: CustomColors.secondaryColor), 
              label: 'Profile'),
          ],
        ),
    );
  }
}