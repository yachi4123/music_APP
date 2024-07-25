import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app1/constants/style.dart';
import 'package:app1/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:app1/auth.dart';

class splashScreen extends StatefulWidget{
  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen>
with SingleTickerProviderStateMixin{
  final AuthController authController = Get.find();
  late Animation animation;
  late AnimationController animationController;
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds:1500),(){
      final user = FirebaseAuth.instance.currentUser;
      if(authController.currentUser.value==null){
        Get.offNamed('/login');
      }else{
        Get.offNamed('/home');
      }
      // Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>Loginpage()));
    });
    animationController=AnimationController(vsync:this,duration:Duration(milliseconds:1200));
    animation = Tween(begin:200.0, end:400.0).animate(animationController);
    animationController.addListener((){
      setState(() {

      });

    });
    animationController.forward();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
    // CustomColors.primaryColor,
        color: CustomColors.backgroundColor,
    //color:CustomColors.backgroundColor,
        alignment: Alignment.center,
        child: Container(
            height:animation.value,
            width:animation.value,
           // color: Colors.blue,
            child: Image.asset('assets/icon/app_icon.png',fit:BoxFit.fill))
        ),
    );
  }
}