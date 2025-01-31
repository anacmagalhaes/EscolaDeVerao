import 'package:escoladeverao/screens/auth/login_screen.dart';
import 'package:escoladeverao/utils/colors_utils.dart';
import 'package:escoladeverao/utils/fonts_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget CheckedProfileModal(BuildContext context) {
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
                text: 'Perfil atualizado com sucesso!',
                maxLines: 3,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ],
          )
        ],
      ),
    ),
  );
}
