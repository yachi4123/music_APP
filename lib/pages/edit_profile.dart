import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app1/auth.dart';
import 'package:app1/constants/style.dart';
import 'package:app1/user_data.dart';
import 'package:app1/assets/images.dart';
import 'package:app1/widgets/navbar.dart';
import 'package:app1/widgets/bottom_bar.dart';


class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfilePage> {
  final AuthController authController = Get.find();
  final TextEditingController _usernameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final user = FirebaseAuth.instance.currentUser;
  File? _imageFile;
  String? _profileImageUrl = "https://media.istockphoto.com/id/1300845620/vector/user-icon-flat-isolated-on-white-background-user-symbol-vector-illustration.jpg?s=612x612&w=0&k=20&c=yBeyba0hUkh14_jgv1OKqIH0CCSWU_4ckRkAoy2p73o=";
  bool _isLoading1 = false;
  bool _isLoading2 = false;

  @override
  void initState() {
    super.initState();
    username = user?.displayName??"user";
    profileURL = user?.photoURL?? userProfileURL;
    
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    setState(() {
      _isLoading1 = true;
    });

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images/${authController.currentUser.value!.uid}');
      final uploadTask = storageRef.putFile(_imageFile!);
      final snapshot = await uploadTask.whenComplete(() => {});
      _profileImageUrl = await snapshot.ref.getDownloadURL();
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload image: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      setState(() {
        _isLoading1 = true;
      });
    }
  }

  Future<bool> _isUsernameUnique(String username) async {
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get();
      return result.docs.isEmpty;
    } catch (e) {
      print('Error checking username uniqueness: $e');
      return false;
    }
  }

  Future<void> _updateUsername() async {
    String? currentUsername = user?.displayName;
    if(currentUsername != _usernameController.text.trim())
    {
    setState(() {
      _isLoading2 = true;
    });
    bool isUnique = await _isUsernameUnique(_usernameController.text.trim());
    if (isUnique) {
      try {
        await user?.updateDisplayName(_usernameController.text.trim());
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .update({'username': _usernameController.text.trim()});
        Get.snackbar('Success', 'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM);
      } catch (e) {
        Get.snackbar('Error', 'Failed to update username: $e',
        snackPosition: SnackPosition.BOTTOM);
      } finally {
        setState(() {
          _isLoading2 = false;
        });
      }
    } else {
      Get.snackbar('Error', 'Username already taken',
      snackPosition: SnackPosition.BOTTOM);
    }
    }
    else{
      Get.snackbar('Success', 'Profile updated successfully',
      snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> _updateUserProfile() async {
    try {
      User? user = authController.currentUser.value;
      await user?.updatePhotoURL(_profileImageUrl);
      await FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .update({'photoURL': _profileImageUrl});
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: CustomColors.backgroundColor,
          appBar: AppBar(
          backgroundColor: CustomColors.backgroundColor,
          leading: IconButton(
            onPressed: () {
            Get.offNamed('/profile');
            },
          icon: Icon(Icons.arrow_back_ios, color: TextColors.PrimaryTextColor,),
          ),
          title: Text("Edit Profile", style: TextStyle(fontSize: 20, color: TextColors.PrimaryTextColor),),
          centerTitle: true,
          ),
        bottomNavigationBar: Navbar(),
        body: Stack(
        children: [
          Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 160,
              child:Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : NetworkImage(profileURL),
                    child: Icon(Icons.camera_alt, size: 30, color: Colors.white.withOpacity(0.7)),
                  ),
                ),
              ),
            ),
            Container(
              height: 170,
              width: 325,
              child:Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width:325,
                    child: TextFormField(
                      style: TextStyle(color: TextColors.PrimaryTextColor),
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: username ?? "user",
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
                      readOnly: true,
                      style: TextStyle(color: TextColors.PrimaryTextColor),
                      decoration: InputDecoration(
                        hintText: authController.currentUser.value?.email ?? '',
                        hintStyle: TextStyle(color: TextColors.SecondaryTextColor),
                        prefixIcon: Icon(Icons.lock, color: TextColors.SecondaryTextColor,),
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
                  )
                ]
              )
            ),
            Container(
              child: TextButton(
                child: Container(
                  height: 50,
                  width: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: CustomColors.primaryColor,
                  ),
                  child: Center(
                    child: Text("Save Changes",style: TextStyle(fontSize: 18, color: TextColors.PrimaryTextColor),),
                  ),
                ),
                onPressed: () async {
                  if (_imageFile != null) {
                    await _uploadImage();
                    await _updateUserProfile();
                  }
                  if(_usernameController.text.trim() != ""){
                    await _updateUsername();
                  }
                  Get.offNamed('/profile');
                },
              
              )
            )
          ]
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: BottomBar(),
        ),
        ]
        ),
      )
    );
  }   
}
        
        
        
        
        
        
        
        
        
        
//         SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               if (_isLoading1 || _isLoading2) CircularProgressIndicator(),
//               GestureDetector(
//                 onTap: _pickImage,
//                 child: CircleAvatar(
//                   radius: 80,
//                   backgroundImage: _imageFile != null
//                       ? FileImage(_imageFile!)
//                       : NetworkImage(profileURL),
//                   child: Icon(Icons.camera_alt, size: 30, color: Colors.white.withOpacity(0.7)),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Text(authController.currentUser.value?.email ?? '',
//                   style: TextStyle(fontSize: 20, color: TextColors.PrimaryTextColor)),
//               SizedBox(height: 20),
//               TextFormField(
//                 controller: _usernameController,
//                 decoration: InputDecoration(
//                   hintText: username ?? "Username",
//                   hintStyle: TextStyle(color: CustomColors.secondaryColor),
//                   prefixIcon: Icon(Icons.person, color: CustomColors.secondaryColor),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30),
//                     borderSide: BorderSide(color: TextColors.PrimaryTextColor, width: 1.5),
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30),
//                     borderSide: BorderSide(color: Colors.black, width: 2),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () async {
//                   if (_imageFile != null) {
//                     await _uploadImage();
//                     await _updateUserProfile();
//                   }
//                   if(_usernameController.text.trim() != ""){
//                     await _updateUsername();
//                   }
//                   Get.offNamed('/profile');
//                 },
//                 child: Text("Update Profile"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
