import 'package:app1/constants/style.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app1/user_data.dart';
import 'package:app1/assets/images.dart';
import 'package:app1/music_controller.dart';
import 'package:app1/user_controller.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final MusicController musicController = Get.find<MusicController>();
  final UserController userController = Get.find<UserController>();
  Rx<User?> currentUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    // Listen to authentication changes
    _auth.authStateChanges().listen((User? user) {
      currentUser.value = user;
      if (user != null) {
      // Navigate to home screen when user is authenticated
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.offNamed('/home');
    } catch (e) {
      Get.snackbar('Sign In Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: CustomColors.secondaryColor,
          colorText: TextColors.PrimaryTextColor,
      );
    }
  }


  Future<void> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null) {
        await FirebaseAuth.instance.currentUser?.updatePhotoURL(profileURL);
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'username': null, // Username to be set later
          'photoURL': userProfileURL, // Profile image to be set later
          'recently_played': [],
          'playlists': [],
          'requests': {},
        });
        musicController.createPlaylist(name : "Favourites");
        userController.createRequestsList();
        Get.offNamed('/edit_profile'); // Redirect to profile setup page
      }
    } catch (e) {
      Get.snackbar('Sign Up Error', e.toString(), 
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: CustomColors.secondaryColor,
        colorText: TextColors.PrimaryTextColor
      );
    }
  }


  void signOut() async {
    profileURL = userProfileURL;
    username = 'user';
    musicController.currentSong = <String, dynamic>{}.obs;
    await _auth.signOut();
  }
}




// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class AuthController extends GetxController {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Rx<User?> currentUser = Rx<User?>(null);

//   @override
//   void onInit() {
//     super.onInit();
//     // Listen to authentication changes
//     _auth.authStateChanges().listen((User? user) {
//       currentUser.value = user;
//        if (user != null) {
//         // Navigate to home screen when user is authenticated
//         Get.offNamed('/home');
//       }
//     });
//   }

//   Future<void> signIn(String email, String password) async {
//     try {
//       await _auth.signInWithEmailAndPassword(email: email, password: password);
//     } catch (e) {
//       Get.snackbar('Sign In Error', e.toString(),
//           snackPosition: SnackPosition.BOTTOM);
//     }
//   }

//   Future<void> signUp(String email, String password) async {
//     try {
//       await _auth.createUserWithEmailAndPassword(
//           email: email, password: password);
//     } catch (e) {
//       Get.snackbar('Sign Up Error', e.toString(),
//           snackPosition: SnackPosition.BOTTOM);
//     }
//   }

//   void signOut() async {
//     await _auth.signOut();
//   }
// }
