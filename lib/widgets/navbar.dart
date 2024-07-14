import 'package:app1/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app1/auth.dart';
import 'package:app1/main.dart';
import 'package:app1/user_data.dart';

class Navbar extends StatefulWidget {
  static String id = 'home_screen';
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  final AuthController authController = Get.find();
  int currentIndex = GlobalVariable.instance.myGlobalVariable;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 'Home', 0, '/home'),
            _buildNavItem(Icons.search, 'Search', 1, '/search'),
            _buildNavItem(Icons.music_note, 'Playlists', 2, '/my_playlists'),
            _buildNavItem(Icons.person, 'Profile', 3, '/profile'),
          ],
        ),
      );
  }

  Widget _buildNavItem(IconData icon, String label, int index, String route) {
    bool isSelected = (currentIndex == index);
    return GestureDetector(
      onTap: () {
        Get.toNamed(route);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? TextColors.PrimaryTextColor : TextColors.SecondaryTextColor,
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? TextColors.PrimaryTextColor : TextColors.SecondaryTextColor,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}






