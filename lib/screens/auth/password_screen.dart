import 'package:escoladeverao/controllers/password_controller.dart';
import 'package:escoladeverao/screens/auth/code_screen.dart';
import 'package:escoladeverao/utils/colors.dart';
import 'package:escoladeverao/utils/fonts.dart';
import 'package:escoladeverao/widgets/custom_app_bar.dart';
import 'package:escoladeverao/widgets/custom_outlined_button.dart';
import 'package:escoladeverao/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordScreen extends StatefulWidget {
  final String origin;
  const PasswordScreen({Key? key, required this.origin}) : super(key: key);

  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        onBackPressed: () {
          FocusScope.of(context).unfocus();
          // if (widget.origin == 'settings') {
          //   Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(builder: (context) => const SettingsScreen()),
          //   );
          // } else if (widget.origin == 'login') {
          //   Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(builder: (context) => const LoginScreen()),
          //   );
          // } else {
          //   Navigator.pop(context); // Fallback para outras telas
          // }
        },
        backgroundColor: AppColors.background,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Fonts(
                  text: 'Recuperação de senha',
                  maxLines: 2,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary),
              SizedBox(height: 8.h),
              const Fonts(
                  text: 'Informe o e-mail cadastrado para recuperação',
                  maxLines: 2,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textPrimary),
              SizedBox(height: 32.h),
              CustomTextField(
                labelText: 'E-mail',
                hintText: 'Digite seu e-mail',
                keyboardType: TextInputType.emailAddress,
                controller: emailPassController,
              ),
              SizedBox(height: 16.h),
              SizedBox(
                width: double.maxFinite,
                child: Row(
                  children: [
                    Expanded(
                      child: CustomOutlinedButton(
                        text: 'Enviar código',
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
                          //lógica de enviar código
                          Navigator.pushReplacement(
                            // ignore: use_build_context_synchronously
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CodeScreen()),
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
