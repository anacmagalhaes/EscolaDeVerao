import 'package:escoladeverao/screens/auth/login_screen.dart';
import 'package:escoladeverao/utils/colors_utils.dart';
import 'package:escoladeverao/utils/fonts_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void VerificationErrorModal(
  BuildContext context,
  String errorMessage,
) {
  showDialog(
    context: context,
    barrierColor:
        AppColors.background.withOpacity(0.3), // Fundo semi-transparente
    barrierDismissible: false, // Permite fechar o dialog tocando fora
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    alignment: Alignment
                        .center, // Centraliza o círculo interno no externo
                    children: [
                      Container(
                        width: 60.h,
                        height: 60.h,
                        decoration: BoxDecoration(
                          color: AppColors.red.withOpacity(0.15),
                          shape: BoxShape.circle, // Forma circular
                        ),
                      ),
                      Container(
                        width: 40.h, // Menor que o círculo externo
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: AppColors.red.withOpacity(0.20),
                          shape: BoxShape.circle, // Forma circular
                        ),
                        child: GestureDetector(
                          child: Image.asset('assets/icons/error-icon.png'),
                        ),
                      ),
                    ],
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
                    text: 'Erro ao tentar cadastrar!',
                    maxLines: 3,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  SizedBox(height: 4.h),
                  Fonts(
                    text: errorMessage,
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimary.withOpacity(0.5),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
