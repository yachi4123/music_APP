import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app1/constants/style.dart';
import 'package:app1/pages/login.dart';
import 'package:app1/pages/sign_up.dart';

class forgetpass extends StatefulWidget{
  @override
  State<forgetpass> createState()=>_forgetstate();

}
class _forgetstate extends State<forgetpass>{
  String email="";
  TextEditingController mailcontroller = new TextEditingController();
  final _formkey = GlobalKey<FormState>();
  resetpass()async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Mailed Successfully !",
            style: TextStyle(color: Colors.white, fontSize: 18),
          )
      ));
    }
    on FirebaseAuthException catch(e){
      if(e.code=='user-not-found'){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "No user found",
              style: TextStyle(color: Colors.white, fontSize: 18),
            )
        ));
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "An unknown error occured",
              style: TextStyle(color: Colors.white, fontSize: 18),
            )
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor:CustomColors.backgroundColor,
      body: Column(
        children: [
          Container(
            //padding:EdgeInsets.only(top: 50,left: 120,right: 120),
            alignment: Alignment.bottomCenter,
            height: 100,
            // color: CustomColors.primaryColor,
            child: Text("Password Recovery",style: TextStyle(color: Colors.white,fontSize: 30),),
          ),
          Container(
            height: 100,
            alignment: Alignment.center,
            //  color: Colors.blueAccent,
            child: Text("Enter your Registered mail",style: TextStyle(color: Colors.white,fontSize: 25),),
          ),
          Container(
            margin:EdgeInsets.only(top: 70),
            padding: EdgeInsets.only(left: 10,right: 10),
            height: 150,
            //  color: Colors.green,
            child: Center(
              child: Form(
                key: _formkey,
                child: TextFormField(
                  controller: mailcontroller,
                  style:(TextStyle(color: TextColors.PrimaryTextColor,fontSize: 18)),
                  validator: (value){
                    if(value==null||value.isEmpty){
                      return "please enter the Email";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email_rounded,color: TextColors.SecondaryTextColor,size: 30,),
                      hintText:"Email",
                      hintStyle: TextStyle(fontSize: 20,color: TextColors.SecondaryTextColor),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:TextColors.SecondaryTextColor,
                            width: 1.5
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:TextColors.PrimaryTextColor,
                            width: 1.5
                        ),
                        borderRadius: BorderRadius.circular(15),
                      )

                  ),
                ),
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 30,left: 10,right: 10),
              height: 50,
              width: 380,
              child:ElevatedButton(
                style:ElevatedButton.styleFrom(backgroundColor: CustomColors.primaryColor),
                onPressed: (){
                  if(_formkey.currentState!.validate()){
                    setState(() {
                      email=mailcontroller.text;
                    });
                    resetpass();
                  }
                },
                child: Text('Send mail',style: TextStyle(color: Colors.white,fontSize: 30),),
              )
          ),
          Container(
              margin: EdgeInsets.only(top: 30),
              alignment: Alignment.topCenter,
              height: 100,
              //color: Colors.blueAccent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account ? ",style: TextStyle(color: TextColors.PrimaryTextColor,fontSize: 18),),
                  InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpPage()));
                      },child: Text("SignUP",style: TextStyle(color: Colors.blueAccent,fontSize: 20),))
                ],
              )
          )
        ],
      ),
    );

  }

}