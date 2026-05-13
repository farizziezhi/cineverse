import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  var isLogin = false.obs;
  var username = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  // Cek status login dari SharedPreferences
  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    isLogin.value = prefs.getBool('isLogin') ?? false;
    username.value = prefs.getString('username') ?? '';
  }

  // Fungsi Register
  Future<bool> register(String user, String pass, String confirmPass) async {
    if (user.isEmpty || pass.isEmpty) {
      Get.snackbar('Error', 'Username dan password tidak boleh kosong',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    if (pass != confirmPass) {
      Get.snackbar('Error', 'Password tidak cocok',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    final prefs = await SharedPreferences.getInstance();
    
    // Simpan ke SharedPreferences
    await prefs.setString('username', user);
    await prefs.setString('password', pass);
    await prefs.setBool('isLogin', false);
    
    isLogin.value = false;
    username.value = '';
    
    Get.snackbar('Berhasil', 'Register berhasil, silakan login',
        backgroundColor: Colors.green, colorText: Colors.white);
    return true;
  }

  // Fungsi Login
  Future<bool> login(String user, String pass) async {
    if (user.isEmpty || pass.isEmpty) {
      Get.snackbar('Error', 'Username dan password tidak boleh kosong',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    final prefs = await SharedPreferences.getInstance();
    
    // Ambil data yang tersimpan
    String? savedUser = prefs.getString('username');
    String? savedPass = prefs.getString('password');
    
    // Kalau belum pernah register, bisa register dulu
    if (savedUser == null) {
      Get.snackbar('Info', 'Silakan register terlebih dahulu',
          backgroundColor: Colors.orange, colorText: Colors.white);
      return false;
    }
    
    if (user == savedUser && pass == savedPass) {
      await prefs.setBool('isLogin', true);
      isLogin.value = true;
      username.value = user;
      Get.snackbar('Berhasil', 'Login berhasil',
          backgroundColor: Colors.green, colorText: Colors.white);
      return true;
    } else {
      Get.snackbar('Error', 'Username atau password salah',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
  }

  // Fungsi Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLogin', false);
    isLogin.value = false;
    username.value = '';
    Get.offAllNamed('/login');
    Get.snackbar('Berhasil', 'Logout berhasil',
        backgroundColor: Colors.green, colorText: Colors.white);
  }
}