import 'package:app1/constants/style.dart';
import 'package:app1/pages/google.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:app1/auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:app1/pages/sign_up.dart';

bool _isobsecured =true;
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController authController = Get.find();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<bool> _showExitConfirmationDialog() async {
    return await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: CustomColors.secondaryColor,
        content: Text('Are you sure you want to exit?', style: TextStyle(color:TextColors.PrimaryTextColor)),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: Text('Yes'),
          ),
        ],
      ),
    ) ??
    false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async{
        if(didPop) return;
        await _showExitConfirmationDialog();
      },
    child: Scaffold(
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
              child: Image.asset('assets/icon/app_icon.png',fit:BoxFit.fill),
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
                        width: 1.5
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
                            width: 1.5
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
              margin: EdgeInsets.only(top: 15,right: 25),
              alignment: Alignment.centerRight,
              //color:Colors.blueAccent,
              height: 20,
              child: InkWell(
                  onTap: (){
                    Get.toNamed('/forgetpass');
                  },
                  child: Text('Forget password ?',style: TextStyle(color: TextColors.SecondaryTextColor),)),
            ),
            Container(
                margin: EdgeInsets.only(top: 50,left: 20,right: 20),
                height: 50,
                width: 380,
                child:ElevatedButton(
                  style:ElevatedButton.styleFrom(backgroundColor: CustomColors.primaryColor),
                  onPressed: (){
                    authController.signIn(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                    );
                  },
                  child: Text('Login',style: TextStyle(color: Colors.white,fontSize: 22, fontWeight: FontWeight.w400),),
                )
            ),
            // Container(
            //   margin: EdgeInsets.only(top: 50),
            //  // color: Colors.blueAccent,
            //   child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Text('Login with ',style: TextStyle(color: TextColors.SecondaryTextColor,fontSize: 20),),
            //         InkWell(
            //           onTap: (){
            //               googleauth().signInWithGoogle(context);

            //         },
            //           child: CircleAvatar(
            //             backgroundImage: AssetImage('lib/assets/google.png'),
            //             radius: 25,
            //           ),
            //         ),
            //       ]
            //   ),
            // ),
            Container(
              margin: EdgeInsets.only(top: 50                               ),
             // color: Colors.green,
              height: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? ",style: TextStyle(color: TextColors.PrimaryTextColor),),
                  InkWell(
                    onTap: (){
                      Get.toNamed('/signup');
                    },
                    child: Text("SignUp",style: TextStyle(color: CustomColors.primaryColor),),
                  )

              ],
              ),
              
            )

          ],
        )

    //   body:SafeArea(
    //     child:SingleChildScrollView(
    //     padding: const EdgeInsets.only(top: 120),
    //     child:Column(
    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       children: [
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Column(
    //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //               children: [
    //                 Container(
    //                   padding: EdgeInsets.only(bottom: 50),
    //                   height: 300,
    //                   child: Center(
    //                   child: Container(
    //                   height: 200,
    //                   width: 175,
    //                   child: Image.asset('assets/images/logo.jpg'),
    //                 ),
    //               ),
    //             ),
    //               ]
    //           )
    //           ],
    //
    //         ),
    //
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Container(
    //               // padding: const EdgeInsets.only(top: 100),
    //               height: 200,
    //               width: 325,
    //               child:Column(
    //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
    //                 children: [
    //                   Container(
    //                     width:325,
    //                     child: TextFormField(
    //                       style: TextStyle(color: TextColors.PrimaryTextColor),
    //                       controller: _emailController,
    //                       decoration: InputDecoration(
    //                         hintText: "Email",
    //                         hintStyle: TextStyle(color: TextColors.SecondaryTextColor),
    //                         prefixIcon: Icon(Icons.email, color: TextColors.SecondaryTextColor,),
    //                         focusedBorder: OutlineInputBorder(
    //                           borderRadius: BorderRadius.circular(30),
    //                           borderSide: BorderSide(
    //                             color: TextColors.PrimaryTextColor,
    //                             width: 1.5,
    //                           )
    //                         ),
    //                         border: OutlineInputBorder(
    //                           borderRadius:BorderRadius.circular(30),
    //                           borderSide: BorderSide(
    //                             color: Colors.black,
    //                             width: 2,
    //                           )
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                   Container(
    //                     width: 325,
    //                     child: TextFormField(
    //                       style: TextStyle(color: TextColors.PrimaryTextColor),
    //                       controller: _passwordController,
    //                       obscureText: !passwordVisible,
    //                       decoration: InputDecoration(
    //                         hintText: "Password",
    //                         hintStyle: TextStyle(color: TextColors.SecondaryTextColor),
    //                         prefixIcon: Icon(Icons.lock, color: TextColors.SecondaryTextColor,),
    //                         suffixIcon: IconButton(
    //                           icon: Icon(
    //                             passwordVisible
    //                             ? Icons.visibility
    //                             : Icons.visibility_off,
    //                             color: TextColors.SecondaryTextColor,
    //                           ),
    //                           onPressed: () {
    //                             setState(() {
    //                                 passwordVisible = !passwordVisible;
    //                             });
    //                           },
    //                         ),
    //                         focusedBorder: OutlineInputBorder(
    //                           borderRadius: BorderRadius.circular(30),
    //                           borderSide: BorderSide(
    //                             color: TextColors.PrimaryTextColor,
    //                             width: 1.5,
    //                           )
    //                         ),
    //                         border: OutlineInputBorder(
    //                           borderRadius:BorderRadius.circular(30),
    //                           borderSide: BorderSide(
    //                             color:Colors.black,
    //                             width: 2,
    //                           )
    //                         )
    //                       ),
    //                     ),
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.end,
    //                     children: [
    //                       InkWell(
    //                         onTap: (){
    //                           print("object");
    //                         },
    //                         child: Text("Forget password ?",style: TextStyle(color: TextColors.PrimaryTextColor),),
    //                       )
    //                     ],
    //                   )
    //                 ]
    //               )
    //             )
    //           ]
    //         ),
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Container(
    //               height: 200,
    //               width: 325,
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
    //                 children: [
    //                   SizedBox(
    //                     width: 325,
    //                     height: 50,
    //                     child:  ElevatedButton(
    //                       style: ElevatedButton.styleFrom(
    //                         backgroundColor: CustomColors.primaryColor,
    //                       ),
    //                       onPressed: (){
    //                         authController.signIn(
    //                           _emailController.text.trim(),
    //                           _passwordController.text.trim(),
    //                         );
    //                       },
    //                       child:  Text("LogIn",style: TextStyle(fontSize: 20,color: TextColors.PrimaryTextColor),)
    //                     ),
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     children: [
    //                       Text("Don't have an account? ", style: TextStyle(color: TextColors.PrimaryTextColor),),
    //                       InkWell(
    //                         onTap: (){
    //                           Get.toNamed('/signup');
    //                         },
    //                         child: Text("SIGNUP",style: TextStyle(color: Color.fromARGB(255, 73, 92, 188)),),
    //                       )
    //                     ],
    //                   )
    //                 ],
    //               ),
    //             )
    //           ],
    //         ),
    //       ]
    //     ),
    //   ),
    // ),
    ),
    );
  }
}




