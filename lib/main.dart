import 'package:app1/pages/my_playlists.dart';
import 'package:app1/widgets/navbar.dart';
import 'package:app1/music_controller.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'package:get/get.dart';
import 'package:app1/pages/login.dart';
import 'package:app1/pages/sign_up.dart';
import 'package:app1/auth.dart';
import 'package:app1/pages/edit_profile.dart';
import 'package:app1/pages/profile.dart';
import 'package:app1/pages/home.dart';
import 'package:app1/pages/search.dart';
import 'package:app1/pages/audio_player.dart';
import 'package:app1/pages/playlist.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); 
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(MusicController());
    Get.put(AuthController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login', 
      getPages: [
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/navbar', page: () => Navbar()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/signup', page: () => SignUpPage()),
        GetPage(name: '/profile', page: () => ProfilePage()),
        GetPage(name: '/edit_profile', page: () => UpdateProfilePage()),
        GetPage(name: '/search', page: () => SearchWidget()),
        GetPage(name: '/audio_player', page: () => AudioPlayerPage()),
        GetPage(name: '/my_playlists', page: () => MyPlaylists()),
        GetPage(name: '/playlist', page: () => PlaylistPage()),
      ],
    );
  }
}


