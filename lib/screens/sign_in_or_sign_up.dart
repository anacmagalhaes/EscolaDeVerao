import 'package:escoladeverao/screens/auth/login_screen.dart';
import 'package:escoladeverao/screens/sign_up_screen.dart';
import 'package:escoladeverao/utils/colors_utils.dart';
import 'package:escoladeverao/utils/fonts_utils.dart';
import 'package:escoladeverao/widgets/custom_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignInOrSignUp extends StatelessWidget {
  const SignInOrSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              left: 24.h, right: 24.h, bottom: 165.h, top: 116.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  width: 200.h,
                  height: 200.h,
                  child: Image.asset(
                    'assets/images/orange_simbol.png',
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Fonts(
                    text: 'Bem-vindo(a) \nà Escola de Verão!',
                    maxLines: 2,
                    fontSize: 34,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
              SizedBox(height: 30.h),
              CustomOutlinedButton(
                text: 'Acessar minha conta',
                height: 56.h,
                width: double.maxFinite,
                buttonFonts: const Fonts(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.background),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                buttonStyle: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.orangePrimary),
                    backgroundColor: AppColors.orangePrimary),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
              ),
              SizedBox(height: 16.h),
              CustomOutlinedButton(
                text: 'Cadastrar',
                height: 56.h,
                width: double.maxFinite,
                buttonFonts: const Fonts(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                buttonStyle: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.textPrimary),
                    backgroundColor: AppColors.background),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignUpScreen(
                              origin: 'sign_in_or_sign_up_screen',
                            )),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
