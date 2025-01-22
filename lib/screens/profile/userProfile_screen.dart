import 'package:escoladeverao/models/user_model.dart';
import 'package:escoladeverao/screens/settings_screen.dart';
import 'package:escoladeverao/utils/colors.dart';
import 'package:escoladeverao/utils/fonts.dart';
import 'package:escoladeverao/widgets/custom_app_bar.dart';
import 'package:escoladeverao/widgets/custom_outlined_button.dart';
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(147.h),
        child: Container(
          width: double.infinity,
          color: AppColors.orangePrimary,
          child: Padding(
            padding: EdgeInsets.only(left: 10.h, right: 10.h, top: 35.h),
          ),
        ),
      ),
      body: SingleChildScrollView(
        // controller: _scrollController,
        child: Stack(
          children: [
            // Orange background container
            Container(
              height: 200.h,
              color: AppColors.orangePrimary,
            ),

            // White background container with rounded corners
            Container(
              margin: EdgeInsets.only(top: 55.h),
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
                    SizedBox(height: 80.h), // Space for profile image
                    Fonts(
                      text: widget.user.name,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    SizedBox(height: 8.h),
                    Fonts(
                      text: 'ID: ',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blueMarine,
                      additionalSpans: [
                        TextSpan(
                          text: widget.user.id.padLeft(4, '0'),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.blueMarine,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    Column(
                      children: [
                        Fonts(
                          text: 'Informações de contato:',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        SizedBox(height: 16.h),
                        Container(
                            width: 380.h,
                            height: 300.h,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColors.quaternaryGrey, width: 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(
                                        top: 16.h,
                                        left: 16.h,
                                        right: 16.h,
                                      ), // Adicionando padding à direita também
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Fonts(
                                            text: 'E-mail:',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                          ),
                                          Flexible(
                                            child: Fonts(
                                              text: widget.user.email,
                                              maxLines: 4,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.quintennialGrey,
                                              textAlign: TextAlign
                                                  .right, // Alinha o texto à direita
                                            ),
                                          ),
                                        ],
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 16.h,
                                        left: 16.h,
                                        right: 16
                                            .h), // Adicionando padding à direita também
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Fonts(
                                          text: 'Telefone:',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                        ),
                                        Flexible(
                                          child: Fonts(
                                            text: widget.user.telefone,
                                            maxLines: 2,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.quintennialGrey,
                                            textAlign: TextAlign
                                                .right, // Alinha o texto à direita
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: 16.h,
                                          left: 16.h,
                                          right: 16
                                              .h), // Adicionando padding à direita também
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Fonts(
                                            text: 'LinkedIn:',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                          ),
                                          Flexible(
                                            child: Fonts(
                                              text: widget.user.linkedin,
                                              maxLines: 4,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.quintennialGrey,
                                              textAlign: TextAlign
                                                  .right, // Alinha o texto à direita
                                            ),
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: 16.h,
                                          left: 16.h,
                                          right: 16
                                              .h), // Adicionando padding à direita também
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Fonts(
                                            text: 'Github:',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                          ),
                                          Flexible(
                                            child: Fonts(
                                              text: widget.user.github,
                                              maxLines: 4,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.quintennialGrey,
                                              textAlign: TextAlign
                                                  .right, // Alinha o texto à direita
                                            ),
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: 16.h,
                                          left: 16.h,
                                          right: 16
                                              .h), // Adicionando padding à direita também
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Fonts(
                                            text: 'Currículo Lattes:',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                          ),
                                          Flexible(
                                            child: Fonts(
                                              text: widget.user.lattes,
                                              maxLines: 4,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.quintennialGrey,
                                              textAlign: TextAlign
                                                  .right, // Alinha o texto à direita
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ))
                      ],
                    ),
                    SizedBox(height: 30.h),
                    SizedBox(
                      width: double.maxFinite,
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomOutlinedButton(
                              text: 'Compartilhar',
                              height: 56.h,
                              buttonFonts: const Fonts(
                                  fontSize: 15.20,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.background),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              buttonStyle: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      color: AppColors.orangePrimary),
                                  backgroundColor: AppColors.orangePrimary),
                              onPressed: () {},
                            ),
                          ),
                          SizedBox(width: 16.h),
                          Expanded(
                            child: CustomOutlinedButton(
                              text: 'Excluir',
                              height: 56.h,
                              buttonFonts: const Fonts(
                                  fontSize: 15.20,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.background),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              buttonStyle: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: AppColors.red),
                                  backgroundColor: AppColors.red),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h), // Add some bottom padding
                  ],
                ),
              ),
            ),

            // Positioned profile image
            Positioned(
              top: 65.h - 52.h,
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
