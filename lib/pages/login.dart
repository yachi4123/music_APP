import 'package:app1/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app1/auth.dart';

bool passwordVisible = false;
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController authController = Get.find();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      body:SafeArea(
        child:SingleChildScrollView(
        padding: const EdgeInsets.only(top: 120),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 50),
                      height: 300,
                      child: Center(
                      child: Container(
                      height: 200,
                      width: 175,
                      child: Image.asset('assets/images/logo.jpg'),
                    ),
                  ),
                ),
                  ]
              )
              ],

            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  // padding: const EdgeInsets.only(top: 100),
                  height: 200,
                  width: 325,
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width:325,
                        child: TextFormField(
                          style: TextStyle(color: TextColors.PrimaryTextColor),
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(color: TextColors.SecondaryTextColor),
                            prefixIcon: Icon(Icons.email, color: TextColors.SecondaryTextColor,),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: TextColors.PrimaryTextColor,
                                width: 1.5,
                              )
                            ),
                            border: OutlineInputBorder(
                              borderRadius:BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2,
                              )
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 325,
                        child: TextFormField(
                          style: TextStyle(color: TextColors.PrimaryTextColor),
                          controller: _passwordController,
                          obscureText: !passwordVisible,
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyle(color: TextColors.SecondaryTextColor),
                            prefixIcon: Icon(Icons.lock, color: TextColors.SecondaryTextColor,),
                            suffixIcon: IconButton(
                              icon: Icon(
                                passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                                color: TextColors.SecondaryTextColor,
                              ),
                              onPressed: () {
                                setState(() {
                                    passwordVisible = !passwordVisible;
                                });
                              },
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: TextColors.PrimaryTextColor,
                                width: 1.5,
                              )
                            ),
                            border: OutlineInputBorder(
                              borderRadius:BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color:Colors.black,
                                width: 2,
                              )
                            )
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: (){
                              print("object");
                            },
                            child: const Text("Forget password ?",style: TextStyle(color: TextColors.PrimaryTextColor),),
                          )
                        ],
                      )
                    ]
                  )
                )
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  width: 325,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 325,
                        height: 50,
                        child:  ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColors.primaryColor,
                          ),
                          onPressed: (){
                            authController.signIn(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );
                          },
                          child: const Text("LogIn",style: TextStyle(fontSize: 20,color: TextColors.PrimaryTextColor),)
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don,t have an account? ", style: TextStyle(color: TextColors.PrimaryTextColor),),
                          InkWell(
                            onTap: (){
                              Get.toNamed('/signup');
                            },
                            child: Text("SIGNUP",style: TextStyle(color: Color.fromARGB(255, 73, 92, 188)),),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ]
        ),
      ),
    )
    );
  }
}




