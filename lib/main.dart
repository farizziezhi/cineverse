import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/splash_screen.dart';
import 'views/login_screen.dart';
import 'views/register_screen.dart';
import 'views/home_screen.dart';
import 'views/detail_screen.dart';
import 'views/add_movie_screen.dart';
import 'views/edit_movie_screen.dart';
import 'views/profile_screen.dart';
import 'controllers/auth_controller.dart';
import 'controllers/movie_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inisialisasi controller
  Get.put(AuthController());
  Get.put(MovieController());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CineVerse',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFFE50914),
        scaffoldBackgroundColor: Color(0xFF0F0F0F),
        fontFamily: 'Poppins',
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF1A1A1A),
          elevation: 0,
          centerTitle: true,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF1A1A1A),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          hintStyle: TextStyle(color: Color(0xFFB3B3B3)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFE50914),
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => SplashScreen()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/register', page: () => RegisterScreen()),
        GetPage(name: '/home', page: () => HomeScreen()),
        GetPage(name: '/detail/:id', page: () => DetailScreen(id: Get.parameters['id']!)),
        GetPage(name: '/add-movie', page: () => AddMovieScreen()),
        GetPage(name: '/edit-movie/:id', page: () => EditMovieScreen(id: Get.parameters['id']!)),
        GetPage(name: '/profile', page: () => ProfileScreen()),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}