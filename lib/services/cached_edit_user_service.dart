import 'dart:io';

import 'package:escoladeverao/services/cached_user_service.dart';
import 'package:escoladeverao/utils/colors_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditableProfileImage extends StatelessWidget {
  final String userId;
  final File? selectedImage;
  final VoidCallback onEditTap;
  final double size;

  const EditableProfileImage({
    Key? key,
    required this.userId,
    this.selectedImage,
    required this.onEditTap,
    this.size = 104,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Imagem do perfil
        SizedBox(
          width: size,
          height: size,
          child: ClipOval(
            child: selectedImage != null
                ? Image.file(selectedImage!, fit: BoxFit.cover)
                : CachedUserImage(
                    userId: userId,
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        // Ícone de edição
        Positioned(
          bottom: 2.h,
          right: 2.h,
          child: GestureDetector(
            onTap: onEditTap,
            child: Container(
              width: 27,
              height: 27,
              decoration: const BoxDecoration(
                color: AppColors.orangePrimary,
                shape: BoxShape.circle,
              ),
              child: Image.asset('assets/icons/pen_black_icon.png'),
            ),
          ),
        ),
      ],
    );
  }
}
