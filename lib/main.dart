import 'package:escoladeverao/models/user_model.dart';
import 'package:escoladeverao/routes/app_routes.dart';
import 'package:escoladeverao/services/auth_service.dart';
import 'package:escoladeverao/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authService = AuthService();
  final savedUser = await authService.loadUser();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp(initialUser: savedUser));
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
          // Começa pela SplashScreen
          initialRoute: AppRoutes.splashScreen,
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
