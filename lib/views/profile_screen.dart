import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/movie_controller.dart';

class ProfileScreen extends StatelessWidget {
  final AuthController authController = Get.find();

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F0F0F),
      appBar: AppBar(
        title: Text('My Profile'),
        backgroundColor: Color(0xFF1A1A1A),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Color(0xFF1A1A1A),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Color(0xFFE50914),
                ),
              ),
              SizedBox(height: 20),
              Obx(() => Text(
                authController.username.value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Kelompok 6 - Movie App',
                  style: TextStyle(color: Color(0xFFB3B3B3), fontSize: 12),
                ),
              ),
              SizedBox(height: 40),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.movie, color: Color(0xFFE50914)),
                      title: Text('Total Movies', style: TextStyle(color: Colors.white)),
                      trailing: Obx(() => Text(
                        '${Get.find<MovieController>().movies.length}',
                        style: TextStyle(color: Color(0xFFE50914), fontSize: 18),
                      )),
                    ),
                    Divider(color: Color(0xFF333333)),
                    ListTile(
                      leading: Icon(Icons.category, color: Color(0xFFE50914)),
                      title: Text('Categories', style: TextStyle(color: Colors.white)),
                      trailing: Text(
                        'All',
                        style: TextStyle(color: Color(0xFFB3B3B3)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => authController.logout(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text('LOGOUT'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}