import 'package:escoladeverao/utils/colors.dart';
import 'package:escoladeverao/utils/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void VerificationErrorModal(BuildContext context) {
  showDialog(
    context: context,
    barrierColor:
        // ignore: deprecated_member_use
        AppColors.background.withOpacity(0.3), // Fundo semi-transparente
    barrierDismissible: true, // Permite fechar o dialog tocando fora
    builder: (context) {
      return Dialog(
        backgroundColor:
            Colors.transparent, // Tornar o fundo do dialog transparente
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white, // Cor do conteúdo do dialog
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  Fonts(
                      text: 'error',
                      fontSize: 24,
                      textAlign: TextAlign.center,
                      maxLines: 4,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blueMarine),
                  SizedBox(height: 20.h),
                  Fonts(
                      text: 'error',
                      fontSize: 16,
                      textAlign: TextAlign.center,
                      maxLines: 10,
                      fontWeight: FontWeight.w400,
                      color: AppColors.blueMarine),
                ],
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      );
    },
  );
}
