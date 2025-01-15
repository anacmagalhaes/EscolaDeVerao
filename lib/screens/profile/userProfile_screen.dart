import 'package:escoladeverao/models/user_model.dart';
import 'package:escoladeverao/utils/colors.dart';
import 'package:escoladeverao/utils/fonts.dart';
import 'package:escoladeverao/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onBackPressed: () {
          FocusScope.of(context).unfocus();
        },
        backgroundColor: AppColors.background,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.only(top: 65.h),
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.h),
                child: Column(
                  children: [
                    // Space for profile image

                    SizedBox(height: 80.h),
                    Fonts(
                        text: 'Nome',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary),
                    SizedBox(height: 10.5.h),
                    Fonts(
                        text: widget.user.name,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textPrimary),
                    SizedBox(height: 20.h), // Add some bottom padding
                    Fonts(
                        text: 'ID',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary),
                    SizedBox(height: 10.5.h),
                    Fonts(
                        text: widget.user.id.padLeft(4, '0'),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textPrimary),
                    SizedBox(height: 20.h),
                    Fonts(
                        text: 'Telefone',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary),
                    SizedBox(height: 10.5.h),
                    Fonts(
                        text: widget.user.phone,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textPrimary),
                    SizedBox(height: 20.h),
                    Fonts(
                        text: 'Email',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary),
                    SizedBox(height: 10.5.h),
                    Fonts(
                        text: widget.user.email,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textPrimary),
                    SizedBox(height: 20.h),
                    Fonts(
                        text: 'GitHub',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary),
                    SizedBox(height: 10.5.h),
                    Fonts(
                        text: widget.user.github,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textPrimary),
                    SizedBox(height: 20.h),
                    Fonts(
                        text: 'LinkedIn',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary),
                    SizedBox(height: 10.5.h),
                    Fonts(
                        text: widget.user.linkedin,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textPrimary),
                    SizedBox(height: 20.h),
                    Fonts(
                        text: 'Currículo Lattes',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary),
                    SizedBox(height: 10.5.h),
                    Fonts(
                        text: widget.user.lattes,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textPrimary),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),

            // Positioned profile image
            Positioned(
              top: 60.h - 52.h,
              left: MediaQuery.of(context).size.width / 2 - 52.h,
              child: SizedBox(
                width: 104.h,
                height: 104.h,
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/person.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
