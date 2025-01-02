import 'package:escoladeverao/models/user_model.dart';
import 'package:escoladeverao/screens/auth/home_screen.dart';
import 'package:escoladeverao/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String loginScreen = '/login_screen';
  static const String homeScreen = '/home_screen';
  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> routes = {
    loginScreen: (context) => const LoginScreen(),
    homeScreen: (context) {
      final User user = ModalRoute.of(context)?.settings.arguments as User;
      return HomeScreen(user: user);
    },
    initialRoute: (context) => const LoginScreen(),
  };
}
