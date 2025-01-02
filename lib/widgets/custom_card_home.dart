import 'package:escoladeverao/utils/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/colors.dart';

enum CardType { imageOnly, imageAndText, textOnly }

class CustomCardHome extends StatelessWidget {
  final int index;
  final CardType cardType;
  final String? title;
  final String? description;
  final String? imagePath;

  const CustomCardHome(
      {super.key,
      required this.index,
      this.cardType = CardType.imageAndText,
      this.title,
      this.description,
      this.imagePath});
  @override
  Widget build(BuildContext context) {
    final List<String> palestrantes = [
      'Rafael Monteiro Silva',
      'Ana Beatriz Almeida',
      'José Carlos Oliveira',
    ];

    return Card(
      margin: const EdgeInsets.all(16),
      color: AppColors.background,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.quaternaryGrey)),
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
                  child: Image.asset('assets/images/person.png'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 14.45.h),
                    child: Fonts(
                        text: palestrantes[index],
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Adicione a lógica de detalhes aqui
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: Column(
                      children: [
                        SizedBox(
                            child:
                                Image.asset('assets/icons/rectangle_icon.png')),
                        SizedBox(height: 4.h),
                        SizedBox(
                            child:
                                Image.asset('assets/icons/rectangle_icon.png')),
                        SizedBox(height: 4.h),
                        SizedBox(
                            height: 5.h,
                            child:
                                Image.asset('assets/icons/rectangle_icon.png')),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Descrição movida para antes da imagem
            if (cardType != CardType.imageOnly && description != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 22.91.h),
                  Fonts(
                      text: description!,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textPrimary)
                ],
              ),

            // Imagem (opcional)
            if (cardType != CardType.textOnly && imagePath != null)
              Column(
                children: [
                  SizedBox(height: 16.h),
                  Container(
                    width: 344.h,
                    height: 344.h,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12),
                      ),
                      child: Image.asset(
                        imagePath!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),

            Column(
              children: [
                SizedBox(height: 22.91.h),
                Image.asset('assets/icons/likes_icon.png'),
                SizedBox(height: 8.h),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
