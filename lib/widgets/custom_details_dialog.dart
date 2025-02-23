import 'package:escoladeverao/utils/colors_utils.dart';
import 'package:escoladeverao/utils/fonts_utils.dart';
import 'package:escoladeverao/widgets/custom_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void CustomDetailsDialog(BuildContext context, Map<String, dynamic> event) {
  showDialog(
    context: context,
    barrierColor: AppColors.background.withOpacity(0.9),
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  Fonts(
                      text: event['titulo']?.isNotEmpty == true
                          ? event['titulo']
                          : 'Título não disponível',
                      fontSize: 24,
                      textAlign: TextAlign.center,
                      maxLines: 4,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blueMarine),
                  SizedBox(height: 20.h),
                  Fonts(
                      text: event['descricao']?.isNotEmpty == true
                          ? event['descricao']
                          : 'Descrição não disponível',
                      fontSize: 16,
                      textAlign: TextAlign.center,
                      maxLines: 10,
                      fontWeight: FontWeight.w400,
                      color: AppColors.blueMarine),
                ],
              ),
              SizedBox(height: 20.h),
              CustomOutlinedButton(
                text: 'Fechar',
                height: 56.h,
                width: double.maxFinite,
                buttonFonts: const Fonts(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.background,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                buttonStyle: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.orangePrimary),
                  backgroundColor: AppColors.orangePrimary,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
