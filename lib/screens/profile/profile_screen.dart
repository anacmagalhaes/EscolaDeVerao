import 'dart:math';
import 'package:escoladeverao/models/user_model.dart';
import 'package:escoladeverao/services/api_service.dart';
import 'package:escoladeverao/utils/colors.dart';
import 'package:escoladeverao/utils/fonts.dart';
import 'package:escoladeverao/widgets/custom_bottom_navigation.dart';
import 'package:escoladeverao/widgets/custom_qr_code.dart';
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
  ApiService apiService = ApiService();
  late Future<User> _userFuture;
  int _currentIndex = 3;
  late User currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.user;
    _userFuture = _loadUserData();
  }

  Future<User> _loadUserData() async {
    try {
      final userData = await apiService.fetchUserById(widget.user.id);
      if (mounted) {
        setState(() {
          currentUser = userData;
        });
      }
      return userData;
    } catch (e) {
      print('Erro ao carregar dados do usuário: $e');
      throw e;
    }
  }

  void _onItemTapped(int index) {
    if (index != 3) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return getScreenFromIndex(index, currentUser);
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation.drive(
                Tween(begin: 0.0, end: 1.0)
                    .chain(CurveTween(curve: Curves.easeInOut)),
              ),
              child: child,
            );
          },
        ),
      );
    }
  }

  Widget _buildHeader() {
    return PreferredSize(
      preferredSize: Size.fromHeight(110.h),
      child: Container(
        width: double.maxFinite,
        color: AppColors.orangePrimary,
        child: Padding(
          padding: EdgeInsets.only(left: 24.h, right: 10.h),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: min(48.h, 52)),
                      Fonts(
                        text: currentUser.name,
                        maxLines: 2,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.blueMarine,
                      ),
                      SizedBox(height: min(4.h, 8)),
                      Fonts(
                        text: 'ID: ',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.blueMarine,
                        additionalSpans: [
                          TextSpan(
                            text: currentUser.id.padLeft(4, '0'),
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
    );
  }

  Widget _buildBody() {
    return LayoutBuilder(
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
                      _buildActionButtons(),
                      SizedBox(height: 45.h),
                      const Fonts(
                        text: 'Compartilhe seu perfil!',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      SizedBox(height: 16.h),
                      FutureBuilder<User>(
                        future: _userFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      'Erro ao carregar perfil: ${snapshot.error}'),
                                  ElevatedButton(
                                    onPressed: _loadUserData,
                                    child: const Text('Tentar novamente'),
                                  ),
                                ],
                              ),
                            );
                          }

                          // QR Code Widget
                          return CustomQrCode(
                              user: snapshot.data ?? currentUser);
                        },
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButtons() {
    final actionButtons = [
      {
        'icon': 'assets/icons/person_icon.png',
        'text': 'Minhas \nconexões',
        'onTap': () {
          // Navigator.pushReplacement(...);
        },
      },
      {
        'icon': 'assets/icons/sofa_icon.png',
        'text': 'Meus \neventos',
        'onTap': () {
          // Navigator.pushReplacement(...);
        },
      },
      {
        'icon': 'assets/icons/pen_icon.png',
        'text': 'Editar \nperfil',
        'onTap': () {
          // Navigator.push(...);
        },
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: actionButtons.map((button) {
        return GestureDetector(
          onTap: button['onTap'] as Function(),
          child: Container(
            color: Colors.transparent,
            child: Column(
              children: [
                Image.asset(button['icon'] as String),
                SizedBox(height: 16.h),
                Fonts(
                  text: button['text'] as String,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigation(
        onTap: _onItemTapped,
        currentIndex: _currentIndex,
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(110.h),
        child: _buildHeader(),
      ),
      body: _buildBody(),
    );
  }
}
