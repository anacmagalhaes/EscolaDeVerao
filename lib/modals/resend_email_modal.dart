import 'package:escoladeverao/screens/auth/login_screen.dart';
import 'package:escoladeverao/utils/colors_utils.dart';
import 'package:escoladeverao/utils/fonts_utils.dart';
import 'package:escoladeverao/widgets/custom_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void ResendEmailModal(BuildContext context, String email) {
  String maskEmail(String email) {
    // Divide o e-mail em duas partes: antes e depois do '@'
    final parts = email.split('@');
    if (parts.length != 2)
      return email; // Retorna o e-mail original se estiver inválido

    final username = parts[0];
    final domain = parts[1];

    // Mascara o nome de usuário (ex: ex**e)
    final maskedUsername = username.length > 4
        ? '${username.substring(0, 2)}**${username.substring(username.length - 1)}'
        : username;

    // Mascara o domínio (ex: ****.com)
    final maskedDomain = domain.replaceRange(0, domain.indexOf('.'), '****');

    return '$maskedUsername@$maskedDomain';
  }

  final maskedEmail = maskEmail(email);

  showDialog(
    context: context,
    barrierColor:
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
                  GestureDetector(
                    child: Container(
                      width: 60.h,
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle, // Forma circular
                      ),
                      child: Image.asset('assets/icons/close-icon.png'),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Column(
                children: [
                  Fonts(
                    text: 'E-mail não verificado',
                    maxLines: 3,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  SizedBox(height: 4.h),
                  Fonts(
                    text:
                        'Por favor, verifique a caixa de entrada do e-mail ($maskedEmail) para continuar',
                    maxLines: 10,
                    textAlign: TextAlign.center,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimary.withOpacity(0.5),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomOutlinedButton(
                    text: 'Reenviar e-mail',
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
                      //lógica para reenviar e-mail
                    },
                  ),
                  SizedBox(width: 10.h),
                  CustomOutlinedButton(
                    text: 'Ok',
                    buttonFonts: const Fonts(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    buttonStyle: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.textPrimary),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
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
