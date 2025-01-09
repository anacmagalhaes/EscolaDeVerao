import 'package:escoladeverao/controllers/password_change_controller.dart';
import 'package:escoladeverao/screens/auth/password_change_completed_screen.dart';
import 'package:escoladeverao/utils/colors.dart';
import 'package:escoladeverao/utils/fonts.dart';
import 'package:escoladeverao/widgets/custom_app_bar.dart';
import 'package:escoladeverao/widgets/custom_outlined_button.dart';
import 'package:escoladeverao/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordChangeScreen extends StatefulWidget {
  const PasswordChangeScreen({Key? key}) : super(key: key);

  @override
  _PasswordChangeScreenState createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        onBackPressed: () {
          FocusScope.of(context).unfocus();
          Navigator.pop(context);
        },
        fallbackRoute: '/code_screen',
        backgroundColor: AppColors.background,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Fonts(
                  text: 'Crie uma nova senha',
                  maxLines: 2,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary),
              SizedBox(height: 32.h),
              CustomTextField(
                labelText: 'Nova senha',
                hintText: 'Digite sua nova senha',
                keyboardType: TextInputType.visiblePassword,
                controller: passChangeController,
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                labelText: 'Confirme a nova senha',
                hintText: 'Repita a senha',
                keyboardType: TextInputType.visiblePassword,
                controller: passChangeController,
              ),
              SizedBox(height: 16.h),
              SizedBox(
                width: double.maxFinite,
                child: Row(
                  children: [
                    Expanded(
                      child: CustomOutlinedButton(
                        text: 'Alterar senha',
                        height: 56.h,
                        buttonFonts: const Fonts(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.background),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        buttonStyle: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                color: AppColors.orangePrimary),
                            backgroundColor: AppColors.orangePrimary),
                        onPressed: () {
                          Navigator.pushReplacement(
                            // ignore: use_build_context_synchronously
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const PasswordChangeCompletedScreen()),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 16.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
