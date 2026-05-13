import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  final AuthController authController = Get.find();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F0F0F),
      appBar: AppBar(
        title: Text('Create Account'),
        backgroundColor: Color(0xFF1A1A1A),
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_add, size: 60, color: Color(0xFFE50914)),
            SizedBox(height: 20),
            Text(
              'Create Account 🎬',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 40),
            TextField(
              controller: usernameController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Username',
                prefixIcon: Icon(Icons.person, color: Color(0xFFB3B3B3)),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Password',
                prefixIcon: Icon(Icons.lock, color: Color(0xFFB3B3B3)),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: confirmController,
              obscureText: true,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Confirm Password',
                prefixIcon: Icon(Icons.lock_outline, color: Color(0xFFB3B3B3)),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                bool success = await authController.register(
                  usernameController.text,
                  passwordController.text,
                  confirmController.text,
                );
                if (success) {
                  Get.offAllNamed('/login');
                }
              },
              child: Text('REGISTER'),
            ),
          ],
        ),
      ),
    );
  }
}