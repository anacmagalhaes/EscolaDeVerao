import 'package:escoladeverao/models/user_model.dart';
import 'package:escoladeverao/screens/auth/home_screen.dart';
import 'package:escoladeverao/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String loginScreen = '/login_screen';
  static const String homeScreen = '/home_screen';
  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> getRoutes(User? initialUser) {
    return {
      loginScreen: (context) => const LoginScreen(),
      homeScreen: (context) {
        // Primeiro tenta pegar o user dos arguments da rota
        final routeUser = ModalRoute.of(context)?.settings.arguments as User?;
        // Se não existir, usa o initialUser
        return HomeScreen(user: routeUser ?? initialUser!);
      },
      initialRoute: (context) => const LoginScreen(),
    };
  }
}
