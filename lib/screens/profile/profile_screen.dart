import 'dart:math';
import 'package:escoladeverao/models/user_model.dart';
import 'package:escoladeverao/utils/colors.dart';
import 'package:escoladeverao/utils/fonts.dart';
import 'package:escoladeverao/widgets/custom_bottom_navigation.dart';
import 'package:escoladeverao/widgets/custom_screen_index.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index != 3) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return getScreenFromIndex(index, widget.user);
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var fadeAnimation = animation.drive(
              Tween(begin: 0.0, end: 1.0)
                  .chain(CurveTween(curve: Curves.easeInOut)),
            );
            return FadeTransition(opacity: fadeAnimation, child: child);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigation(
        onTap: _onItemTapped,
        currentIndex: _currentIndex,
      ),
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(110.h), // Limita o tamanho máximo da AppBar
        child: Container(
          width: double.maxFinite,
          color: AppColors.orangePrimary,
          child: Padding(
            padding: EdgeInsets.only(
                left: 24.h, right: 10.h), // Limita padding superior
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 12.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 10.h),
                            SizedBox(height: min(8.h, 12)),
                            Padding(
                              padding: EdgeInsets.only(top: 40.h),
                              child: Fonts(
                                text: widget.user.name,
                                maxLines: 2,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.blueMarine,
                              ),
                            ),
                            SizedBox(height: min(4.h, 8)),
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.h),
                  child: SizedBox(
                    width: 96.h,
                    height: 96.h,
                    child: Image.asset('assets/images/person.png'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Container(color: AppColors.orangePrimary),
              Container(
                height: constraints.maxHeight,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.h),
                    child: Column(
                      children: [
                        SizedBox(height: 32.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              child: Container(
                                color: Colors
                                    .transparent, // Torna o espaço clicável
                                child: Column(
                                  children: [
                                    Image.asset('assets/icons/person_icon.png'),
                                    SizedBox(height: 16.h),
                                    const Fonts(
                                      text: 'Minhas \nconexões',
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                /*Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const MyConnectionsScreen(
                                      origin: 'profile',
                                    ),
                                  ),
                                );*/
                              },
                            ),
                            GestureDetector(
                              child: Container(
                                color: Colors
                                    .transparent, // Torna o espaço clicável
                                child: Column(
                                  children: [
                                    Image.asset('assets/icons/sofa_icon.png'),
                                    SizedBox(height: 16.h),
                                    const Fonts(
                                        text: 'Meus \neventos',
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary),
                                  ],
                                ),
                              ),
                              onTap: () {
                                /*Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ScheduleScreen()),
                                );*/
                              },
                            ),
                            GestureDetector(
                              child: Container(
                                color: Colors
                                    .transparent, // Torna o espaço clicável
                                child: Column(
                                  children: [
                                    Image.asset('assets/icons/pen_icon.png'),
                                    SizedBox(height: 16.h),
                                    const Fonts(
                                        text: 'Editar \nperfil',
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary),
                                  ],
                                ),
                              ),
                              onTap: () {
                                /*Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ProfileEditScreen(
                                            origin: 'profile'),
                                  ),
                                );*/
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 45.h),
                        const Fonts(
                            text: 'Compartilhe seu perfil!',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary),
                        SizedBox(height: 16.h),
                        Image.asset('assets/images/qrcode.png'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
