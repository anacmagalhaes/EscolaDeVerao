import 'dart:convert';

import 'package:escoladeverao/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<User?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user.toJson()));
  }

  Future<void> saveCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_email', email);
    await prefs.setString('saved_password', password);
    await prefs.setBool('remember_login', true);
  }

  Future<Map<String, String>> loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberLogin = prefs.getBool('remember_login') ?? false;

    if (rememberLogin) {
      return {
        'email': prefs.getString('saved_email') ?? '',
        'password': prefs.getString('saved_password') ?? '',
      };
    }
    return {'email': '', 'password': ''};
  }

  Future<bool> hasRememberLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('remember_login') ?? false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberLogin = prefs.getBool('remember_login') ?? false;
    final savedEmail = prefs.getString('saved_email');
    final savedPassword = prefs.getString('saved_password');

    // Limpa todos os dados
    await prefs.clear();

    // Se "Lembrar minha senha" estava ativo, restaura as credenciais
    if (rememberLogin && savedEmail != null && savedPassword != null) {
      await prefs.setBool('remember_login', true);
      await prefs.setString('saved_email', savedEmail);
      await prefs.setString('saved_password', savedPassword);
    }
  }

  Future<void> clearSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('saved_email');
    await prefs.remove('saved_password');
    await prefs.remove('remember_login');
  }
}
