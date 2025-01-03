import 'package:escoladeverao/models/user_model.dart';
import 'package:escoladeverao/routes/app_routes.dart';
import 'package:escoladeverao/screens/auth/home_screen.dart';
import 'package:escoladeverao/screens/auth/login_screen.dart';
import 'package:escoladeverao/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Verifica se existe um usuário salvo
  final prefs = await SharedPreferences.getInstance();
  final rememberLogin = prefs.getBool('remember_login') ?? false;
  User? savedUser;

  if (rememberLogin) {
    final userId = prefs.getString('user_id');
    final userName = prefs.getString('user_name');

    if (userId != null && userName != null) {
      savedUser = User(
        id: userId,
        name: userName,
      );
    }
  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp(initialUser: savedUser));
}

Future<User?> getSavedUser() async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('user_id')) {
    return User(
      id: prefs.getString('user_id')!,
      name: prefs.getString('user_name') ?? '',
      sobrenome: prefs.getString('user_sobrenome') ?? '',
    );
  }
  return null;
}

class MyApp extends StatelessWidget {
  final User? initialUser;

  const MyApp({super.key, this.initialUser});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        ScreenUtil.init(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.background,
          ),
          title: 'Escola de Verão',
          initialRoute: initialUser != null
              ? AppRoutes.homeScreen
              : AppRoutes.loginScreen,
          // Passa o initialUser para as rotas
          routes: AppRoutes.getRoutes(initialUser),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.0),
              ),
              child: child!,
            );
          },
        );
      },
    );
  }
}
