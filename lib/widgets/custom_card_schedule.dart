import 'package:escoladeverao/utils/fonts.dart';
import 'package:escoladeverao/widgets/custom_details_dialog.dart';
import 'package:escoladeverao/widgets/custom_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/colors.dart';

class CustomCardSchedule extends StatelessWidget {
  final int index;

  const CustomCardSchedule({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final List<String> cronogramas = [
      'Automação com Python: Do Básico aos Bots',
      'Engenharia de Dados e a Nova era da Análise Preditiva',
      'Machine Learning para Profissionais de TI',
    ];
    final List<String> palestrantes = [
      'Rafael Monteiro Silva',
      'Ana Beatriz Almeida',
      'José Carlos Oliveira',
    ];
    final List<String> dia = [
      '25 Fev',
      '25 Fev',
      '26 Fev',
    ];
    final List<String> hora = [
      '11:00 - 12:00',
      '11:00 - 12:00',
      '11:00 - 12:00',
    ];
    final List<String> local = [
      'Unimontes',
      'IFNMG',
      'Unimontes',
    ];

    return Card(
      margin: const EdgeInsets.all(16),
      color: AppColors.background,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.quaternaryGrey)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Image.asset(
                      'assets/images/person.png'), //puxar de acordo com o bd (se vier pelo bd)
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Fonts(
                          text: cronogramas[index],
                          maxLines: 2,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.blueMarine),
                      const SizedBox(height: 4),
                      Fonts(
                          text: palestrantes[index],
                          maxLines: 2,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.quaternaryGrey),
                    ],
                  ),
                ),
              ],
            ),
            Divider(height: 20.h, color: AppColors.quaternaryGrey),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset('assets/icons/local_icon.png'),
                SizedBox(width: 5.h),
                Fonts(
                    text: local[index],
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.quaternaryGrey),
                SizedBox(width: 30.h),
                Image.asset('assets/icons/calendar_icon.png'),
                SizedBox(width: 5.h),
                Fonts(
                    text: dia[index],
                    maxLines: 2,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.quaternaryGrey),
                SizedBox(width: 30.h),
                Image.asset('assets/icons/clock_icon.png'),
                SizedBox(width: 5.h),
                Fonts(
                    text: hora[index],
                    maxLines: 2,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.quaternaryGrey),
              ],
            ),
            const SizedBox(height: 20),
            CustomOutlinedButton(
              text: 'Detalhes',
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
                CustomDetailsDialog(context, index);
              },
            ),
          ],
        ),
      ),
    );
  }
}
