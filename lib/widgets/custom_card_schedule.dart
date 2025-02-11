import 'package:escoladeverao/utils/fonts_utils.dart';
import 'package:escoladeverao/widgets/custom_details_dialog.dart';
import 'package:escoladeverao/widgets/custom_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/colors_utils.dart';

class CustomCardSchedule extends StatelessWidget {
  final Map<String, dynamic> event;

  const CustomCardSchedule({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    // Format date and time strings
    DateTime startDate = DateTime.parse(event['data_inicio']);
    DateTime endDate = DateTime.parse(event['data_fim']);

    String dia = '${startDate.day} ${_getMonthAbbreviation(startDate.month)}';
    String hora = '${_formatTime(startDate)} - ${_formatTime(endDate)}';

    return Card(
      margin: EdgeInsets.all(16.h),
      color: AppColors.background,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
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
                  child: event['imagem'] != null && event['imagem'].isNotEmpty
                      ? Image.network(event['link_completo'])
                      : Image.asset('assets/images/person.png'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Fonts(
                          text: event['titulo'],
                          maxLines: 2,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.blueMarine),
                      const SizedBox(height: 4),
                      Fonts(
                          text: event['palestrante'],
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/icons/local_icon.png'),
                SizedBox(width: 5.h),
                Fonts(
                    text: event['local'],
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.quaternaryGrey),
                SizedBox(width: 20.h),
                Image.asset('assets/icons/calendar_icon.png'),
                SizedBox(width: 5.h),
                Fonts(
                    text: dia,
                    maxLines: 2,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.quaternaryGrey),
                SizedBox(width: 20.h),
                Image.asset('assets/icons/clock_icon.png'),
                SizedBox(width: 5.h),
                Fonts(
                    text: hora,
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
                CustomDetailsDialog(context, event);
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthAbbreviation(int month) {
    const months = [
      'Jan',
      'Fev',
      'Mar',
      'Abr',
      'Mai',
      'Jun',
      'Jul',
      'Ago',
      'Set',
      'Out',
      'Nov',
      'Dez'
    ];
    return months[month - 1];
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
