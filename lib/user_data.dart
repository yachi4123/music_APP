import 'package:app1/assets/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app1/auth.dart';

final AuthController authController = Get.find();
final user = FirebaseAuth.instance.currentUser;


String username = user?.displayName?? "user" ;
String profileURL = user?.photoURL?? userProfileURL;

class GlobalVariable {
  GlobalVariable._privateConstructor();

  // The single instance of the class
  static final GlobalVariable instance = GlobalVariable._privateConstructor();

  // A variable to hold the data
  int _myGlobalVariable = 0;

  // Getter to access the variable
  int get myGlobalVariable => _myGlobalVariable;

  // Setter to modify the variable
  set myGlobalVariable(int value) {
    _myGlobalVariable = value;
  }
}