import 'package:escoladeverao/models/user_model.dart';
import 'package:escoladeverao/utils/colors.dart';
import 'package:escoladeverao/utils/fonts.dart';
import 'package:escoladeverao/widgets/custom_bottom_navigation.dart';
import 'package:escoladeverao/widgets/custom_screen_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  int _currentIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index != 2) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return getScreenFromIndex(index, widget.user); // Tela de destino
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = 0.0;
            const end = 1.0;
            const curve = Curves.easeInOut;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var fadeAnimation = animation.drive(tween);

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
        preferredSize: Size.fromHeight(60.h),
        child: Container(
          width: double.maxFinite,
          color: AppColors.orangePrimary,
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColors.orangePrimary,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.only(top: 30.h),
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 33.h, right: 33.h, top: 60.h, bottom: 30.h),
                      child: const Fonts(
                        text: 'Leia o QR Code para se conectar',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Container(
                    width: 250.h,
                    height: 250.h,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.black,
                    ),
                    child: MobileScanner(
                      onDetect: (capture) {},
                    ),
                  ),
                  SizedBox(height: 10.h),
                  // Remove o Expanded aqui e coloca o Container diretamente dentro da Column
                  Center(
                    child: Container(
                      width: 285.h,
                      height: 75.h,
                      decoration: BoxDecoration(
                        color: AppColors.orangePrimary.withOpacity(0.7),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(left: 16.h, right: 16.h),
                          child: Fonts(
                            text:
                                'O QR Code será detectado automaticamente quando você posicioná-lo entre as linhas guias',
                            textAlign: TextAlign.center,
                            maxLines: 4,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textPrimary.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
