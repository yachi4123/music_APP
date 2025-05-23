import 'package:app1/pages/googledata.dart';
import 'package:app1/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class googleauth{
  final FirebaseAuth auth=FirebaseAuth.instance;

  getCurrentUser()async{
    return await auth.currentUser;
  }
  signInWithGoogle(BuildContext context)async{
    final FirebaseAuth firebaseAuth=FirebaseAuth.instance;
    final GoogleSignIn googleSignIn=GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount=await googleSignIn.signIn();

    final GoogleSignInAuthentication? googleSignInAuthentication =await googleSignInAccount?.authentication;

    final AuthCredential credential=GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication?.idToken,
      accessToken: googleSignInAuthentication?.accessToken
    );

    UserCredential result = await firebaseAuth.signInWithCredential(credential);
    User? userDetails=result.user;
    if(result!=null){
      Map<String,dynamic> userInfoMap={
        "email":userDetails!.email,
       // "name":userDetails.displayName,
       // "imgUrl":userDetails.photoURL,
        "id":userDetails.uid,
      };
      await Databasemethods().addUser(userDetails.uid,userInfoMap).then((value){
          Get.to(HomePage());
      });
    }
  }
}