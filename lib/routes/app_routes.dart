import 'package:escoladeverao/models/user_model.dart';
import 'package:escoladeverao/screens/auth/login_screen.dart';
import 'package:escoladeverao/screens/auth/password_screen.dart';
import 'package:escoladeverao/screens/home/home_screen.dart';
import 'package:escoladeverao/screens/sign_in_or_sign_up.dart';
import 'package:escoladeverao/screens/sign_up_screen.dart';
import 'package:escoladeverao/screens/splash_screen.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AppRoutes {
  static const String splashScreen = '/splash_screen';
  static const String signInOrSignUpScreen = '/sign_in_or_sign_up_screen';
  static const String loginScreen = '/login_screen';
  static const String homeScreen = '/home_screen';
  static const String signUpScreen = '/sign_up_screen';
  static const String passwordScreen = '/password_screen';
  static const String initialRoute = '/initialRoute';

  // Adicionando o método para verificar o status de login
  static Future<User?> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    final userName = prefs.getString('user_name');

    if (userId != null && userName != null) {
      // Retorna um usuário com os dados armazenados
      return User(id: userId, name: userName);
    }
    return null; // Caso não tenha dados salvos, retorna null
  }

  static Map<String, WidgetBuilder> getRoutes(User? initialUser) {
    return {
      splashScreen: (context) => const SplashScreen(),
      signInOrSignUpScreen: (context) => const SignInOrSignUp(),
      loginScreen: (context) => const LoginScreen(),
      homeScreen: (context) {
        final routeUser = ModalRoute.of(context)?.settings.arguments as User?;
        return HomeScreen(user: routeUser ?? initialUser!);
      },
      signUpScreen: (context) => const SignUpScreen(origin: '/signup'),
      passwordScreen: (__) => const PasswordScreen(origin: 'password_screen'),
      initialRoute: (context) => initialUser != null
          ? HomeScreen(user: User(id: '', name: ''))
          : const LoginScreen(),
    };
  }
}
