import 'dart:convert';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:jiosaavn/jiosaavn.dart';

class MusicController extends GetxController {
  var searchResults = [].obs;
  var isSearchingSongs = true.obs; // Default to searching users
  var isSearchingArtists = false.obs;
  var isSearchingUsers = false.obs;
  var recentlyPlayed = <Map<String, dynamic>>[].obs;
  var artists = <Map<String, dynamic>>[].obs;
  var myPlaylists = <dynamic>[].obs;
  var currentPlaylist = <dynamic>[].obs;
  var currentPlaylistName = "";

  var currentSong = <String, dynamic>{}.obs;
  var isPlaying = false.obs;
  var isSearchFieldFocused = false.obs;

  final String clientId = 'd40584fc8ebe43ebb91e2fd5ed7509c5';
  final String clientSecret = '0ded2e036a424fb0a7c4645bdccb803c';

  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void onInit() {
    super.onInit();
    search('');
    fetchRecentlyPlayedSongs();
    fetchPlaylists();
    fetchTopArtists();
  }

  void setSearchFieldFocus(bool isFocused) {
    isSearchFieldFocused.value = isFocused;
  }

  Future<String> _getAccessToken() async {
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization': 'Basic ' + base64Encode(utf8.encode('$clientId:$clientSecret')),
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'client_credentials',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['access_token'];
    } else {
      throw Exception('Failed to obtain token');
    }
  }

  void search(String query) async {
    if (query == '') searchResults.value = [];
    if (isSearchingUsers.value) {
      final response = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: query)
          .where('username', isLessThanOrEqualTo: query + '\uf8ff')
          .where('userId', isNotEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get();

      if (response.docs.isEmpty) {
        searchResults.value = [];
      } else {
        searchResults.value = response.docs.map((doc) => doc.data()).toList();
      }
    } else if (isSearchingSongs.value) {
      final String token = await _getAccessToken();
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/search?q=$query&type=track'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        searchResults.value = data['tracks']['items'];
      } else {
        searchResults.value = [];
        // throw Exception('Failed to search tracks');
      }
    } else if (isSearchingArtists.value) {
      final String token = await _getAccessToken();
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/search?q=$query&type=artist'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        searchResults.value = data['artists']['items'];
      } else {
        searchResults.value = [];
      }
    }
  }

  Future<void> searchAndPlayTrack(String trackName) async {
    final jiosaavn = JioSaavnClient();
    final data = await jiosaavn.search.songs(trackName);
      if(data.results[0].downloadUrl != null){
        await audioPlayer.setUrl(data.results[0].downloadUrl?[0].link ?? " ");
        audioPlayer.play();
        isPlaying.value = true;
      }
  }

  void playSong() {
    audioPlayer.play();
    isPlaying.value = true;
  }

  void pauseSong() {
    audioPlayer.pause();
    isPlaying.value = false;
  }

  void seekDuration(double value) {
    audioPlayer.seek(Duration(milliseconds: value.toInt()));
  }

  Future<void> createPlaylist({String? name}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final userData = await userDoc.get();
    List<dynamic> playlists = userData.data()?['playlists'] ?? [];
    Map<String,dynamic> playlist = {};
    int len = playlists.length;
    if(name == null){
      name = "Playlist $len";
    }
    playlist["name"] = name;
    playlist["songs"] = [];
    playlists.add(playlist);
    await userDoc.update({'playlists': playlists});
    myPlaylists.assignAll(playlists.cast<Map<String, dynamic>>());
  }

  Future<void> addToPlaylist(int index, Map<String, dynamic> song) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (song.containsKey('name')) {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final userData = await userDoc.get();
      List<dynamic> playlists = userData.data()?['playlists'] ?? [];
      List<dynamic> songs = playlists[index]['songs'];
      songs.removeWhere((element) => element['id'] == song['id']);
      songs.insert(0, song);
      playlists[index]['songs'] = songs;
      await userDoc.update({'playlists': playlists});
    } else {
      print("Song data is incomplete or invalid: $song");
    }
  }

  Future<void> removeFromPlaylist(int index, Map<String, dynamic> song) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (song.containsKey('name')) {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final userData = await userDoc.get();
      List<dynamic> playlists = userData.data()?['playlists'] ?? [];
      List<dynamic> songs = playlists[index]['songs'];
      songs.removeWhere((element) => element['id'] == song['id']);
      playlists[index]['songs'] = songs;
      await userDoc.update({'playlists': playlists});
    } else {
      print("Song data is incomplete or invalid: $song");
    }
  }

  Future<void> fetchPlaylists() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (userDoc.exists) {
      final data = userDoc.data();
      if (data != null && data['playlists'] != null) {
        myPlaylists.value = List<dynamic>.from(data['playlists']);
      }
    }
  }


  Future<bool> isSongFavourite( Map<String, dynamic> song) async{
    final user = FirebaseAuth.instance.currentUser;
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user?.uid);
    final userData = await userDoc.get();
    List<dynamic> playlists = userData.data()?['playlists'];
    List<dynamic> playlist = playlists[0]['songs'];
    for (var track in playlist) {
      if (track['id'] == song['id']) {
        return true;
      }
    }
    return false;
  }

  Future<void> addToRecentlyPlayed(Map<String, dynamic> song) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (song.containsKey('name')) {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final userData = await userDoc.get();

      List<dynamic> recentlyPlayed = userData.data()?['recently_played'] ?? [];

      recentlyPlayed.removeWhere((element) => element['id'] == song['id']);
      recentlyPlayed.insert(0, song);

      if (recentlyPlayed.length > 15) {
        recentlyPlayed = recentlyPlayed.sublist(0, 15);
      }

      await userDoc.update({'recently_played': recentlyPlayed});
      fetchRecentlyPlayedSongs();
    } else {
      // Handle the case where the song does not have the necessary keys
      print("Song data is incomplete or invalid: $song");
    }
  }

  Future<void> fetchRecentlyPlayedSongs() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (userDoc.exists) {
      final data = userDoc.data();
      if (data != null && data['recently_played'] != null) {
        recentlyPlayed.value = List<Map<String, dynamic>>.from(data['recently_played']);
      }
    }
  }

  Future<void> fetchTopArtists() async {
    final String token = await _getAccessToken(); // Function to get Spotify access token
    const String country = 'IN'; // Country code for India
    const int limit = 20; // Limit to fetch top 20 artists

    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/search?type=artist&limit=$limit&q=genre:pop'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data['artists'] != null && data['artists']['items'] != null) {
        artists.assignAll(List<Map<String, dynamic>>.from(data['artists']['items']));
      }
    } else {
      throw Exception('Failed to fetch top artists from Spotify');
    }
  }
}
