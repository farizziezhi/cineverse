import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  // --- STATE REAKTIF (dipertahankan agar UI/View yang ada tidak perlu diubah) ---
  var isLogin = false.obs;
  var username = ''.obs;
  var currentRole = 'user'.obs; // RBAC: 'user' | 'admin'

  final SupabaseClient _supabase = Supabase.instance.client;
  StreamSubscription<AuthState>? _authSub;

  @override
  void onInit() {
    super.onInit();

    // Cek state awal (restore session kalau user sudah login sebelumnya)
    checkLoginStatus();

    // Sinkronisasi reaktif dengan perubahan auth dari Supabase.
    _authSub = _supabase.auth.onAuthStateChange.listen((data) async {
      final user = data.session?.user;
      if (user == null) {
        _resetState();
      } else {
        isLogin.value = true;
        await _loadProfileFromUsersTable(user.id);
      }
    });
  }

  @override
  void onClose() {
    _authSub?.cancel();
    super.onClose();
  }

  // ---------------------------------------------------------------------------
  // CHECK LOGIN STATUS
  // Restore state dari session + tabel public.users saat aplikasi dibuka.
  // ---------------------------------------------------------------------------
  Future<void> checkLoginStatus() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      _resetState();
      return;
    }

    isLogin.value = true;
    await _loadProfileFromUsersTable(user.id);
  }

  /// Ambil username & role dari tabel public.users berdasarkan UUID user.
  Future<void> _loadProfileFromUsersTable(String uid) async {
    try {
      final data = await _supabase
          .from('users')
          .select('username, role')
          .eq('id', uid)
          .single();

      username.value = (data['username'] as String?) ?? '';
      currentRole.value = (data['role'] as String?) ?? 'user';
    } catch (e) {
      // Kalau row belum ada (misal: dibuat di dashboard tanpa row users),
      // fallback aman tanpa menggagalkan login.
      username.value = '';
      currentRole.value = 'user';
    }
  }

  void _resetState() {
    isLogin.value = false;
    username.value = '';
    currentRole.value = 'user';
  }

  // ---------------------------------------------------------------------------
  // REGISTER
  // Pola: username -> email dummy "<username>@dummy.com".
  // Role otomatis 'admin' jika username == 'admin' (case-insensitive).
  // ---------------------------------------------------------------------------
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

    try {
      // 1) Buat akun di auth.users
      final response = await _supabase.auth.signUp(
        email: '$user@dummy.com',
        password: pass,
      );

      if (response.user == null) {
        Get.snackbar('Error', 'Registrasi gagal, coba lagi',
            backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }

      // 2) Insert row profil ke tabel public.users
      await _supabase.from('users').insert({
        'id': response.user!.id,
        'username': user,
        'role': user.toLowerCase() == 'admin' ? 'admin' : 'user',
      });

      Get.snackbar('Berhasil', 'Register berhasil, silakan login',
          backgroundColor: Colors.green, colorText: Colors.white);
      return true;
    } on AuthException catch (e) {
      Get.snackbar('Error', e.message,
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    } on PostgrestException catch (e) {
      Get.snackbar('Error', 'Gagal menyimpan profil: ${e.message}',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // LOGIN
  // ---------------------------------------------------------------------------
  Future<bool> login(String user, String pass) async {
    if (user.isEmpty || pass.isEmpty) {
      Get.snackbar('Error', 'Username dan password tidak boleh kosong',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    try {
      // 1) Sign in pakai email dummy
      final response = await _supabase.auth.signInWithPassword(
        email: '$user@dummy.com',
        password: pass,
      );

      if (response.user == null) {
        Get.snackbar('Error', 'Username atau password salah',
            backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }

      // 2) Ambil profil dari tabel public.users
      final data = await _supabase
          .from('users')
          .select('username, role')
          .eq('id', response.user!.id)
          .single();

      username.value = (data['username'] as String?) ?? user;
      currentRole.value = (data['role'] as String?) ?? 'user';
      isLogin.value = true;

      Get.snackbar('Berhasil', 'Login berhasil',
          backgroundColor: Colors.green, colorText: Colors.white);
      return true;
    } on AuthException catch (e) {
      Get.snackbar('Error', e.message,
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    } on PostgrestException catch (e) {
      Get.snackbar('Error', 'Gagal mengambil profil: ${e.message}',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // LOGOUT
  // ---------------------------------------------------------------------------
  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
      _resetState();

      Get.offAllNamed('/login');
      Get.snackbar('Berhasil', 'Logout berhasil',
          backgroundColor: Colors.green, colorText: Colors.white);
    } on AuthException catch (e) {
      Get.snackbar('Error', e.message,
          backgroundColor: Colors.red, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Gagal logout: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // ---------------------------------------------------------------------------
  // HELPER RBAC — untuk guard/menu admin di view
  // ---------------------------------------------------------------------------
  bool get isAdmin => currentRole.value == 'admin';
}
