import 'dart:convert';
import 'package:app1/services/music.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:jiosaavn/jiosaavn.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'dart:async';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:app1/services/media_notification_service.dart';
import 'package:app1/services/audio.dart';

class Lyric{
  final String words;
  final DateTime timeStamp;
  Lyric({required this.words, required this.timeStamp});
}

class MusicController extends GetxController {
  var searchResults = [].obs;
  var isSearchingSongs = true.obs; // Default to searching users
  var isSearchingArtists = false.obs;
  var isSearchingUsers = false.obs;
  var recentlyPlayed = <Map<String, dynamic>>[].obs;
  var discoverArtists = <Map<String,dynamic>>[];
  var artists = <dynamic>[].obs;
  var myPlaylists = <dynamic>[].obs;
  var currentPlaylist = <dynamic>[].obs;
  var recommendedTracks = <dynamic>[].obs;
  var songs = <dynamic>[].obs;
  var top50 = <dynamic>[].obs;
  var newRelease = <dynamic>[].obs;
  var latestHindi = <dynamic>[].obs;
  var bollywood = <dynamic>[].obs;
  var party = <dynamic>[].obs;
  var topDay = <dynamic>[].obs;
  var old = <dynamic>[].obs;
  var currentSong = <String, dynamic>{}.obs; 
  var downloads = <dynamic>[].obs;
  var images =<dynamic>[].obs;
  var artistSongs = <dynamic>[].obs;
  var currentArtist = <String,String>{};
  var topSongsForGenre = <Map<String, dynamic>>[].obs;
  var topArtistsForGenre = <Map<String, dynamic>>[];
  var currentSongIndex = 0;
  var currentPlaylistName = "";
  var currentPlaylistIndex = 0;
  var currentRoute = "";
  var previousRoute = "";
  var currentSongUrl = "";
  var currentDownload = "";
  var currentImage = "";
  var playlistName = "";
  var currentGenre = "";
  List<String>? lyrics;
  var isPlaying = false.obs;
  bool fromDownloads = false;
  bool fromSearch = false;
  bool fromPlaylist = false;
  bool fromRecentlyPlayed = false;
  List<RxList<dynamic>> madePlaylists = [];
  final List<String> madePlaylistNames = [
    "Top 50", 
    "Bollywood", 
    "Trending Today", 
    "New Releases", 
    "Latest Hindi", 
    "Party Songs",
    "Classics"
  ];
  final List<String> genres = [
    'pop',
    'rock',
    'hip hop',
    'electronic',
    'jazz',
    'classical',
    'country',
    'metal',
    'r&b',
    'funk',
    'soul',
    'indie',
    'punk',
  ]; 

  final String clientId = 'd40584fc8ebe43ebb91e2fd5ed7509c5';
  final String clientSecret = '0ded2e036a424fb0a7c4645bdccb803c';
  final AudioPlayer audioPlayer = AudioPlayer();
  var playlist;

  @override
  void onInit() {
    super.onInit();
    search('');
    fetchRecentlyPlayedSongs();
    getRecommendedArtists();
    fetchPlaylists();
  }

  Future<void> getMadePlaylists() async{
    getTop50();
    getTopDay();
    getNew();
    getBollywood();
    getLatestHindi();
    getOld();
    getParty();
    madePlaylists.add(top50);
    madePlaylists.add(bollywood);
    madePlaylists.add(topDay);
    madePlaylists.add(newRelease);
    madePlaylists.add(latestHindi);
    madePlaylists.add(party);
    madePlaylists.add(old);
  }

  Future<void> setPlaylist() async {
    // playlist=ConcatenatingAudioSource(children: []);
    List<AudioSource> songs=[];
    for(var song in currentPlaylist){
      final yt = YoutubeExplode();
      final result = await yt.search.search(song['name']+song['artists'][0]['name']+"official audio");
      final videoId = result.first.id.value;
      var manifest = await yt.videos.streamsClient.getManifest(videoId);
      var audioUrl = manifest.audioOnly.first.url;

      var mediaItem = MediaItem(
        id: song['id'],
        title: song['name'],
        artUri: Uri.parse(song['album']['images'][0]['url']),
        artist: song['artists'][0]['name'],
      );
      songs.add(AudioSource.uri(
        Uri.parse(audioUrl.toString()),
        tag: mediaItem,
      ));
    }
    playlist = ConcatenatingAudioSource(children: songs);
  }

  Future<void> getTop50() async {
    // top50.clear();
    final String token = await _getAccessToken();
    const playlistId = "37i9dQZEVXbLZ52XmnySJg";
    const String apiUrl = 'https://api.spotify.com/v1/playlists/$playlistId/tracks';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> tracks = jsonResponse['items'];
      for(var item in tracks){
        top50.add(item['track']);
      }
    } else {
      throw Exception('Failed to fetch trending songs');
    }
  }

  Future<void> getOld() async {
    // old.clear();
    final String token = await _getAccessToken();
    const playlistId = "37i9dQZF1DXa6iPZDThhLh";
    const String apiUrl = 'https://api.spotify.com/v1/playlists/$playlistId/tracks';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> tracks = jsonResponse['items'];
      for(var item in tracks){
        old.add(item['track']);
      }
    } else {
      throw Exception('Failed to fetch trending songs');
    }
  }

  Future<void> getParty() async {
    // party.clear();
    final String token = await _getAccessToken();
    const playlistId = "37i9dQZF1DX2CqFedmO3RP";
    const String apiUrl = 'https://api.spotify.com/v1/playlists/$playlistId/tracks';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> tracks = jsonResponse['items'];
      for(var item in tracks){
        party.add(item['track']);
      }
    } else {
      throw Exception('Failed to fetch trending songs');
    }
  }

  Future<void> getLatestHindi() async {
    // latestHindi.clear();
    final String token = await _getAccessToken();
    const playlistId = "37i9dQZF1DXd8cOUiye1o2";
    const String apiUrl = 'https://api.spotify.com/v1/playlists/$playlistId/tracks';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> tracks = jsonResponse['items'];
      for(var item in tracks){
        latestHindi.add(item['track']);
      }
    } else {
      throw Exception('Failed to fetch trending songs');
    }
  }

  Future<void> getBollywood() async {
    // bollywood.clear();
    final String token = await _getAccessToken();
    const playlistId = "37i9dQZF1DX0XUfTFmNBRM";
    const String apiUrl = 'https://api.spotify.com/v1/playlists/$playlistId/tracks';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> tracks = jsonResponse['items'];
      for(var item in tracks){
        bollywood.add(item['track']);
      }
    } else {
      throw Exception('Failed to fetch trending songs');
    }
  }

  Future<void> getNew() async {
    // newRelease.clear();
    final String token = await _getAccessToken();
    const playlistId = "37i9dQZF1DX4JAvHpjipBk";
    const String apiUrl = 'https://api.spotify.com/v1/playlists/$playlistId/tracks';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> tracks = jsonResponse['items'];
      for(var item in tracks){
        newRelease.add(item['track']);
      }
    } else {
      throw Exception('Failed to fetch trending songs');
    }
  }

  Future<void> getTopDay() async {
    // topDay.clear();
    final String token = await _getAccessToken();
    const playlistId = "37i9dQZF1DXcBWIGoYBM5M";
    const String apiUrl = 'https://api.spotify.com/v1/playlists/$playlistId/tracks';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> tracks = jsonResponse['items'];
      for(var item in tracks){
        topDay.add(item['track']);
      }
    } else {
      throw Exception('Failed to fetch trending songs');
    }
  }
  
  Future<void> fetchTopSongsForGenre(String genre) async {
  final String token = await _getAccessToken(); 
  final int limit = 10;

  final response = await http.get(
    Uri.parse('https://api.spotify.com/v1/search?q=genre:$genre&type=track'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    if (data['tracks'] != null && data['tracks']['items'] != null) {
      topSongsForGenre.assignAll(List<Map<String, dynamic>>.from(data['tracks']['items']));
    }
  } else {
    throw Exception('Failed to fetch top songs for genre from Spotify');
  }
}

Future<void> fetchTopArtistsForGenre(String genre) async {
  final String token = await _getAccessToken(); // Function to get Spotify access token
  final int limit = 10; // Adjust the number of top artists you want to fetch
  var topArtists = <Map<String, dynamic>>[].obs;
  final response = await http.get(
    Uri.parse('https://api.spotify.com/v1/search?q=genre:$genre&type=artist&limit=$limit'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);

    if (data['artists'] != null && data['artists']['items'] != null) {
      topArtists.assignAll(List<Map<String, dynamic>>.from(data['artists']['items']));
    }
    for(var item in topArtists){
      Map<String,dynamic> map = {};
      map.addAll({
        'name': item['name'],
        'id': item['id'],
        'image': item['images'][0]['url']
      });
      topArtistsForGenre.add(map);
    }
  } else {
    throw Exception('Failed to fetch top artists for genre from Spotify');
  }
  Get.toNamed('/genre');
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
          .where('username', isNotEqualTo: FirebaseAuth.instance.currentUser?.displayName)
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

  Future<void> getSongLyrics(String trackName) async {
    Future<void> fetchLyrics() async {
      final response = await http.get(
          Uri.parse('https://paxsenixofc.my.id/server/getLyricsMusix.php?q=${currentSong['name']}&type=default'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        lyrics = data['lyrics'].split('\n');
        print(lyrics);
      } else {
        throw Exception('Failed to load lyrics');
      }
    }
  }

  Future<void> playFromFile(String filePath) async{
    if (filePath.toString() != "") {
    var mediaItem = MediaItem(
      id: filePath.split('/').last.split('.').first.toString(),
      title: filePath.split('/').last.split('.').first.toString(),
      // artUri: Uri.parse(currentSong['album']['images'][0]['url']),
      artist: filePath.split('/').last.split('.').last.toString(),
    );
    await audioPlayer.setAudioSource(AudioSource.uri(
      Uri.file(filePath),
      tag: mediaItem,
    ));
    }
    audioPlayer.setFilePath(filePath);
    fromDownloads = true;
    isPlaying.value = true;
    audioPlayer.play();
  }

  Future<void> searchAndPlayTrack(String trackName) async {
    // final jiosaavn = JioSaavnClient();
    // final data = await jiosaavn.search.songs(trackName);
    //   if(data.results[0].downloadUrl != null){
    //     await audioPlayer.setUrl(data.results[0].downloadUrl?[0].link ?? " ");
    //     audioPlayer.play();
    //     isPlaying.value = true;
    //     fromDownloads = false;
    //   }
    final yt = YoutubeExplode();
    final result = await yt.search.search(trackName+"official audio");
    final videoId = result.first.id.value;
    var manifest = await yt.videos.streamsClient.getManifest(videoId);
    var audioUrl = manifest.audioOnly.first.url;
    // if(audioUrl.toString() != ""){
    //     await audioPlayer.setUrl(audioUrl.toString());
    //     audioPlayer.play();
    //     isPlaying.value = true;
    //     fromDownloads = false;
    //   }
    if (audioUrl.toString() != "") {
    var mediaItem = MediaItem(
      id: currentSong['id'],
      title: currentSong['name'],
      artUri: Uri.parse(currentSong['album']['images'][0]['url']),
      artist: currentSong['artists'][0]['name'],
    );
    await audioPlayer.setAudioSource(AudioSource.uri(
      Uri.parse(audioUrl.toString()),
      tag: mediaItem,
    ));

    audioPlayer.play();
    isPlaying.value = true;
    fromDownloads = false;
    }
  }

  Future<void> setUrl(String trackName) async{
    final jiosaavn = JioSaavnClient();
    final data = await jiosaavn.search.songs(trackName);
      if(data.results[0].downloadUrl != null){
        currentSongUrl = data.results[0].downloadUrl?[0].link ?? " ";
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

  Future<void> playNextTrack() async{
      currentSongIndex >=currentPlaylist.length-1
      ?currentSongIndex = 0
      :currentSongIndex = currentSongIndex + 1;
      currentSong.value = currentPlaylist[currentSongIndex];
  }

  Future<void> playPreviousTrack() async{
      currentSongIndex == 0
      ?currentSongIndex = currentPlaylist.length-1
      :currentSongIndex = currentSongIndex - 1;
      currentSong.value = currentPlaylist[currentSongIndex];
  }

  Future<void> getRecommendations(String id) async {
    recommendedTracks.clear();
    final url = Uri.parse('https://api.spotify.com/v1/recommendations?seed_tracks=${id}&limit=20');
    final String token = await _getAccessToken();
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      recommendedTracks.assignAll(data['tracks']);
      recommendedTracks.insert(0,currentSong);
    } else {
      throw Exception('Failed to load recommendations');
    }
  }

  Future<void> getSongs() async {
    // for(var song in recentlyPlayed){
    //   id=id+song['id'];
    // } 
    String id = recentlyPlayed.map((song) => song['id']).join(',');
    final url = Uri.parse('https://api.spotify.com/v1/recommendations?seed_tracks=$id&limit=20');
    final String token = await _getAccessToken();
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      songs.assignAll(data['tracks']);
    } else {
      throw Exception('Failed to load recommendations');
    }
  }

  Future<void> getRecommendedArtists() async {
    final String token = await _getAccessToken();
    List<String> seedArtists = [];
      for (var item in recentlyPlayed) {
        seedArtists.add(item['id']);
      }
    final seedArtistsParam = seedArtists.take(5).join(',');
    final url = Uri.parse('https://api.spotify.com/v1/recommendations?seed_tracks=$seedArtistsParam');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      discoverArtists.clear();
      final data = json.decode(response.body);
      for(var item in data['tracks']){
        var map = <String,dynamic>{};
        final response = await http.get(
          Uri.parse('https://api.spotify.com/v1/artists/${item['album']['artists'][0]['id']}'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );
        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          if (data['images'] != null) {
            map['image']=data['images'][0]['url'];
          }
        }
        map['id']=item['album']['artists'][0]['id'];
        map['name']=item['album']['artists'][0]['name'];
        discoverArtists.removeWhere((element) => element['id'] == map['id']);
        if(map['id']!=null && map['name']!=null && map['image']!=null);
        discoverArtists.add(map);
        discoverArtists.removeWhere((element) => element['name'] == map['Various Artists']);
      }      
    } else {
      throw Exception('Failed to load recommendations');
    }
  }

  Future<void> getArtistSongs(String id, String name, String? url) async {
    final String token = await _getAccessToken(); // Function to get Spotify access token
    artistSongs.clear();
    currentArtist.clear();
    if(url==null){
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/artists/${currentSong['album']['artists'][0]['id']}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['images'] != null) {
          url=data['images'][0]['url'];
        }
      }
    }
    currentArtist['name'] = name;
    currentArtist['image'] = url??"";
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/artists/$id/top-tracks'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['tracks'] != null) {
        for(var item in data['tracks']){
          
          // map['id']=item['id'];
          // map['name']=item['name'];
          // map['image']=item['album']['images'][0]['url'];
          // map['artist']=item['artists'][0]['name'];
          // map['artistId']=item['artists'][0]['id'];
          artistSongs.add(item);
        }
        Get.toNamed('/artist');
      }
    } else {
      throw Exception('Failed to fetch top songs for artist from Spotify');
    }
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
      fetchPlaylists();
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

      if (recentlyPlayed.length > 20) {
        recentlyPlayed = recentlyPlayed.sublist(0, 20);
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


}
