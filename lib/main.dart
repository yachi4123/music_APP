import 'package:app1/pages/artist.dart';
import 'package:app1/pages/forgetpass.dart';
import 'package:app1/pages/friends.dart';
import 'package:app1/pages/genre.dart';
import 'package:app1/pages/lyrics.dart';
import 'package:app1/pages/my_playlist.dart';
import 'package:app1/pages/my_playlists.dart';
import 'package:app1/pages/shared.dart';
import 'package:app1/pages/splash.dart';
import 'package:app1/pages/user_profile.dart';
import 'package:app1/services/media_notification_service.dart';
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
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:app1/pages/downloads.dart';
import 'package:app1/user_controller.dart';
import 'package:app1/pages/user_playlists.dart';
import 'package:app1/download_controller.dart';
import 'package:just_audio_background/just_audio_background.dart';


Future <void> main() async{
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); 
  await FlutterDownloader.initialize(
    debug: true
  );
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(MusicController());
    Get.put(UserController());
    Get.put(AuthController());
    Get.put(DownloadController());
    // final user = FirebaseAuth.instance.currentUser;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // initialRoute: user!=null ? '/home' : '/login',
      initialRoute: '/splash',
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
        GetPage(name: '/my_playlist', page: () => MyPlaylistPage()),
        GetPage(name: '/playlist', page: () => PlaylistPage()),
        GetPage(name: '/downloads', page: () => DownloadsPage()),
        GetPage(name: '/user_profile', page: () => UserProfilePage()),
        GetPage(name: '/user_playlists', page: () => UserPlaylists()),
        GetPage(name: '/friends', page: () => FriendsPage()),
        GetPage(name: '/shared', page: () => SharedPage()),
        GetPage(name: '/lyrics', page: () => LyricsPage()),
        GetPage(name: '/artist', page: () => ArtistPage()),
        GetPage(name: '/genre', page: () => GenrePage()),
        GetPage(name: '/splash', page: () => splashScreen()),
        GetPage(name: '/forgetpass', page: () => forgetpass()),
      ],
    );
  }
}


