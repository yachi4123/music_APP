import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app1/user_data.dart';
import 'package:app1/assets/images.dart';
import 'package:app1/music_controller.dart';

class UserController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final MusicController musicController = Get.find<MusicController>();
  var currentDisplayUser = {}.obs;
  var friendStatus = "";
  var userPlaylists = <dynamic>[].obs;
  var friendsList = <dynamic>[].obs;
  var sentList = <dynamic>[].obs;
  var receivedList = <dynamic>[].obs;
  var sharedList = <dynamic>[].obs;

  Future<void> fetchUserPlaylists() async {
    if(currentDisplayUser != {}){
      userPlaylists.assignAll(currentDisplayUser['playlists']);
    }
  }

  // Future<void> getFriendStatus(String username)async{
  //   for(Map<String,dynamic> item in friendsList){
  //     if(item['username'] == username){
  //       friendStatus = "Remove Friend";
  //       return;
  //     }
  //   }
  //   for(Map<String,dynamic> item in sentList){
  //     if(item['username'] == username){
  //       friendStatus = "Request Sent";
  //       return;
  //     }
  //   }
  //   for(Map<String,dynamic> item in receivedList){
  //     if(item['username'] == username){
  //       friendStatus = "Accept Request";
  //       return;
  //     }
  //   }
  //   friendStatus = "Add Friend";
  //   return;
  // }

  Future<void> getFriendStatus(String username) async{
    final querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('username', isEqualTo: username)
      .get();
    final uid = querySnapshot.docs.first.id;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final userData = await userDoc.get();
    Map<String, dynamic> requests = userData.data()?['requests'] ?? {};
    for(Map<String,dynamic> friendData in requests['friends']){
      if(friendData['uid'] == uid){
        friendStatus = "Remove Friend";
        return;
      }
    }
    for(String id in requests['sent']){
      if(id == uid){
        friendStatus = "Request Sent";
        return;
      }
    }
    for(String id in requests['received']){
      if(id == uid){
        friendStatus = "Accept Request";
        return;
      }
    }
    friendStatus = "Add Friend";
    return;
  }

  Future<void> createRequestsList() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final userData = await userDoc.get();
    Map<String, dynamic> requests = userData.data()?['requests'] ?? {};
    requests['friends']=[];
    requests['sent']=[];
    requests['received']=[];
    await userDoc.update({'requests': requests});
  }

  Future<void> getRequestsList() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final userData = await userDoc.get();
      Map<String, dynamic> requests = userData.data()?['requests'] ?? {};
      List<dynamic> friends = [];
      List<dynamic> sent = [];
      List<dynamic> received = [];
      for (Map<String,dynamic> friendData in requests['friends']) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(friendData['uid']).get();
        friends.add(doc.data());
      }
      for (String id in requests['sent']) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(id).get();
        sent.add(doc.data());
      }
      for (String id in requests['received']) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(id).get();
        received.add(doc.data());
      }
      friendsList.assignAll(friends);
      sentList.assignAll(sent);
      receivedList.assignAll(received);

    } catch (e) {
      print('Error getting user data: $e');
    }
  }

  Future<void> sendRequest({required String username}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
    final userDoc = querySnapshot.docs.first.reference;
    final userData = await userDoc.get();
    Map<String,dynamic> userRequests = userData.data()?['requests'] ?? {};
    List<dynamic> received = userRequests['received']??[];
    received.removeWhere((element) => element == user.uid);
    received.add(user.uid);
    await userDoc.update({'requests': userRequests});

    final myDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final myData = await myDoc.get();
    Map<String,dynamic> myRequests = myData.data()?['requests'] ?? {};
    List<dynamic> sent = myRequests['sent']??[];
    sent.removeWhere((element) => element == querySnapshot.docs.first.id);
    sent.add(querySnapshot.docs.first.id);
    await myDoc.update({'requests': myRequests});

    getRequestsList();
    getFriendStatus(username);
  }

  Future<void> acceptRequest({required String username}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
    final userDoc = querySnapshot.docs.first.reference;
    final userData = await userDoc.get();
    Map<String,dynamic> userRequests = userData.data()?['requests'] ?? {};
    List<dynamic> sent = userRequests['sent']??[];
    List<dynamic> userFriends = userRequests['friends']??[];
    Map<String,dynamic> friendData = {};
    friendData['uid']=user.uid;
    friendData['shared']=[];
    sent.removeWhere((element) => element == user.uid);
    userFriends.add(friendData);
    await userDoc.update({'requests': userRequests});

    final myDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final myData = await myDoc.get();
    Map<String,dynamic> myRequests = myData.data()?['requests'] ?? {};
    List<dynamic> received = myRequests['received']??[];
    List<dynamic> myFriends = myRequests['friends']??[];
    Map<String,dynamic> Data = {};
    Data['uid']=querySnapshot.docs.first.id;
    Data['shared']=[];
    received.removeWhere((element) => element == querySnapshot.docs.first.id);
    myFriends.add(Data);
    await myDoc.update({'requests': myRequests});

    getRequestsList();
    getFriendStatus(username);
  }

  Future<void> cancelRequest({required String username}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
    final userDoc = querySnapshot.docs.first.reference;
    final userData = await userDoc.get();
    Map<String,dynamic> userRequests = userData.data()?['requests'] ?? {};
    List<dynamic> userSent = userRequests['sent']??[];
    List<dynamic> userReceived = userRequests['received']??[];
    List<dynamic> userFriend = userRequests['friends']??[];
    userReceived.removeWhere((element) => element == user.uid);
    userSent.removeWhere((element) => element == user.uid);
    userFriend.removeWhere((element) => element['uid'] == user.uid);
    await userDoc.update({'requests': userRequests});

    final myDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final myData = await myDoc.get();
    Map<String,dynamic> myRequests = myData.data()?['requests'] ?? {};
    List<dynamic> myReceived = myRequests['received']??[];
    List<dynamic> mySent = myRequests['sent']??[];
    List<dynamic> myFriend = myRequests['friends']??[];
    myReceived.removeWhere((element) => element == querySnapshot.docs.first.id);
    mySent.removeWhere((element) => element == querySnapshot.docs.first.id);
    myFriend.removeWhere((element) => element['uid'] == querySnapshot.docs.first.id);
    await myDoc.update({'requests': myRequests});
    
    getRequestsList();
  }

  Future<void> sendSong(String username) async{
    final user = FirebaseAuth.instance.currentUser;
    final myDoc = FirebaseFirestore.instance.collection('users').doc(user?.uid);
    final myData = await myDoc.get();
    Map<String,dynamic> myRequests = myData.data()?['requests'] ?? {};
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
    final userDoc = querySnapshot.docs.first.reference;
    final userData = await userDoc.get();
    Map<String,dynamic> userRequests = userData.data()?['requests'] ?? {};
    final friendId = querySnapshot.docs.first.id;
    for(Map<String,dynamic> data in myRequests['friends']){
      if(data['uid'] == friendId){
        Map<String,dynamic> map = {};
        map['song']=musicController.currentSong;
        map['by']="You";
        data['shared'].add(map);
      }
    }
    for(Map<String,dynamic> data in userRequests['friends']){
      if(data['uid'] == user?.uid){
        Map<String,dynamic> map = {};
        map['song']=musicController.currentSong;
        map['by']=user?.displayName;
        data['shared'].add(map);
      }
    }
    await myDoc.update({'requests': myRequests});
    await userDoc.update({'requests': userRequests});
  }

  Future<void> getSharedList(String username) async{
    sharedList.clear();
    final user = FirebaseAuth.instance.currentUser;
    final myDoc = FirebaseFirestore.instance.collection('users').doc(user?.uid);
    final myData = await myDoc.get();
    Map<String,dynamic> myRequests = myData.data()?['requests'] ?? {};
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
    final friendId = querySnapshot.docs.first.id;
    for(Map<String,dynamic> data in myRequests['friends']){
      if(data['uid'] == friendId){
        sharedList.assignAll(data['shared']);
      }
    }
  }

}