import 'package:escoladeverao/utils/fonts_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/colors_utils.dart';

enum CardType { imageOnly, imageAndText, textOnly }

class CustomCardHome extends StatelessWidget {
  final dynamic post;
  final CardType cardType;
  final String? title;
  final String? imagePath;

  const CustomCardHome({
    super.key,
    required this.post,
    this.cardType = CardType.imageAndText,
    this.title,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    print('Post data: $post');
    // Safely extract user name with a default value

    final userName =
        post['user']?['name']?.split('-')[0].toUpperCase() ?? 'Usuário';
    final postText = post['texto'] ?? '';
    final likesCount = post['likes_count'] ?? 0;

    return Card(
      margin: const EdgeInsets.all(16),
      color: AppColors.background,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: AppColors.quaternaryGrey.withOpacity(0.2))),
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
                        text: userName,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black),
                  ),
                ),
                // Rest of the code remains the same...
              ],
            ),

            // Descrição do post
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 22.91.h),
                Fonts(
                    text: postText,
                    maxLines: 20,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimary)
              ],
            ),

            Column(
              children: [
                SizedBox(height: 22.91.h),
                Row(
                  children: [
                    Image.asset('assets/icons/likes_icon.png'),
                    SizedBox(width: 8.h),
                    Fonts(
                      text: '$likesCount likes',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textPrimary,
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
