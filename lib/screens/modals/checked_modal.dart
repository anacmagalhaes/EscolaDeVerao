import 'package:escoladeverao/screens/auth/login_screen.dart';
import 'package:escoladeverao/utils/colors.dart';
import 'package:escoladeverao/utils/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void CheckedModal(BuildContext context, {required String checkedMessage}) {
  showDialog(
    context: context,
    barrierColor:
        AppColors.background.withOpacity(0.3), // Fundo semi-transparente
    barrierDismissible: true, // Permite fechar o dialog tocando fora
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent, // Fundo do dialog transparente
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white, // Cor do conteúdo do dialog
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: Stack(
                      alignment: Alignment
                          .center, // Centraliza o círculo interno no externo
                      children: [
                        Container(
                          width: 60.h,
                          height: 60.h,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryGreen,
                            shape: BoxShape.circle, // Forma circular
                          ),
                        ),
                        Container(
                          width: 40.h, // Menor que o círculo externo
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen,
                            shape: BoxShape.circle, // Forma circular
                          ),
                          child: GestureDetector(
                            child: Image.asset('assets/icons/check-icon.png'),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(), // Fecha o modal
                    child: Container(
                      width: 60.h,
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle, // Forma circular
                      ),
                      child: Image.asset('assets/icons/close-icon.png'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Column(
                children: [
                  Fonts(
                    text: 'Sucesso!',
                    maxLines: 3,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  SizedBox(height: 4.h),
                  Fonts(
                    text: checkedMessage,
                    maxLines: 4,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimary.withOpacity(0.5),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
