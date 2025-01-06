import 'package:escoladeverao/services/auth_service.dart';
import 'package:escoladeverao/widgets/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:escoladeverao/routes/app_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  _checkLoginStatus() async {
    final authService = AuthService();
    final savedUser = await authService.loadUser();

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    if (savedUser != null) {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.homeScreen,
        arguments: savedUser,
      );
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.signInOrSignUpScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.maxFinite,
        height: screenHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(1, 1),
            end: Alignment(0, 0.05),
            colors: [Colors.orange, Colors.orangeAccent],
          ),
        ),
        child: Center(
          child: CustomImageView.whiteLogo(
              width: double.maxFinite, height: 70.h, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
