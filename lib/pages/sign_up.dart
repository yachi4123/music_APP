import 'package:app1/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app1/auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:app1/pages/google.dart';




bool _isobsecured = true;
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  final AuthController authController = Get.find();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
        resizeToAvoidBottomInset: false,
        body:Column(
          //mainAxisAlignment: MainAxisAlignment.,
          children: [
            Container(
              margin: EdgeInsets.only(top: 130),
              alignment: Alignment.center,
              // color: Colors.red,
              height: 220,
              child: Image.asset('assets/icon/app_icon.png',fit:BoxFit.fill)
            ),
            Container(
              margin: EdgeInsets.only(top: 80,left: 25,right: 25),
              // color: Colors.blueAccent,
              child: TextFormField(
                controller: _emailController,
                style: TextStyle(color: TextColors.PrimaryTextColor,fontSize: 18),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail,size: 25,),
                  hintText: "Enter your Email",
                  hintStyle: TextStyle(color: TextColors.SecondaryTextColor,fontSize: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                        color: TextColors.SecondaryTextColor,
                        width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      color: TextColors.PrimaryTextColor,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30,left: 25,right: 25),
              // color: Colors.blueAccent,
              child: TextFormField(
                controller: _passwordController,
                obscureText: _isobsecured,
                style: (TextStyle(color: TextColors.PrimaryTextColor,fontSize: 18)),
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock,size: 25,),
                    suffixIcon: IconButton(
                        onPressed: (){
                          setState(() {
                            _isobsecured=!_isobsecured;
                          });
                        },
                        icon:_isobsecured ? Icon(Icons.visibility_off):Icon(Icons.visibility)
                    ),
                    hintText: "Enter your password",
                    hintStyle: TextStyle(color: TextColors.SecondaryTextColor,fontSize: 18),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(
                            color: TextColors.SecondaryTextColor,
                            width: 1.5,
                        )

                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(
                          color: TextColors.PrimaryTextColor,
                          width: 1.5,
                        )
                    )
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 100,left: 20,right: 20),
                height: 50,
                width: 380,
                child:ElevatedButton(
                  style:ElevatedButton.styleFrom(backgroundColor: CustomColors.primaryColor),
                  onPressed: (){
                    authController.signUp(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                    );
                  },
                  child: Text('Signup',style: TextStyle(color: Colors.white,fontSize: 22, fontWeight: FontWeight.w400),),
                )
            ),
            Container(
              margin: EdgeInsets.only(top: 80),
             // color: Colors.green,
              height: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ",style: TextStyle(color: TextColors.PrimaryTextColor),),
                  InkWell(
                    onTap: (){
                      Get.toNamed('/login');
                    },
                    child: Text("LogIn",style: TextStyle(color: CustomColors.primaryColor),),
                  )

              ],
              ),
              
            )

          ],
        )
    );
  }
}




