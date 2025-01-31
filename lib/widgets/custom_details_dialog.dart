import 'package:escoladeverao/utils/colors_utils.dart';
import 'package:escoladeverao/utils/fonts_utils.dart';
import 'package:escoladeverao/widgets/custom_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void CustomDetailsDialog(BuildContext context, int index) {
  final List<String> texto = [
    'Rafael Monteiro Silva - Nesta palestra, serão exploradas as principais tendências de IA na educação, incluindo plataformas de aprendizado adaptativo e análise de dados educacionais.Nesta palestra, serão exploradas as principais tendências de IA na educação.',
    'Ana Beatriz Almeida - Nesta palestra, serão exploradas as principais tendências de IA na educação, incluindo plataformas de aprendizado adaptativo e análise de dados educacionais.Nesta palestra, serão exploradas as principais tendências de IA na educação.',
    'José Carlos Oliveira - Nesta palestra, serão exploradas as principais tendências de IA na educação, incluindo plataformas de aprendizado adaptativo e análise de dados educacionais.Nesta palestra, serão exploradas as principais tendências de IA na educação.',
  ];
  final List<String> titulo = [
    'Automação com Python: Do Básico aos Bots',
    'Engenharia de Dados e a Nova era da Análise Preditiva',
    'Machine Learning para Profissionais de TI',
  ];

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
              Column(
                children: [
                  Fonts(
                      text: titulo[index],
                      fontSize: 24,
                      textAlign: TextAlign.center,
                      maxLines: 4,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blueMarine),
                  SizedBox(height: 20.h),
                  Fonts(
                      text: texto[index],
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
