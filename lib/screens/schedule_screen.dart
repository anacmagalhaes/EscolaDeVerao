import 'package:escoladeverao/models/user_model.dart';
import 'package:escoladeverao/widgets/custom_app_bar_error.dart';
import 'package:escoladeverao/widgets/custom_bottom_navigation.dart';
import 'package:escoladeverao/widgets/custom_card_schedule.dart';
import 'package:escoladeverao/widgets/custom_screen_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/colors_utils.dart';

//falta adicionar a mudança de tela de acordo com o botão hoje e cronograma

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key, required this.user});

  final User user;

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
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

  int _currentIndex = 1;
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Navegação com transição suave (Fade)
    if (index != 1) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return getScreenFromIndex(index, widget.user); // Tela de destino
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Animação de fade
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
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  CustomAppBarError(
                      onBackPressed: () {
                        FocusScope.of(context).unfocus();
                        /* Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfileScreen()),
                        );*/
                      },
                      backgroundColor: AppColors.background,
                      leadingIcon:
                          Image.asset('assets/icons/angle-left-orange.png')),
                ],
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 26.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildScrollableButton('Hoje', 100),
                            _buildScrollableButton('Cronograma completo', 150),
                          ],
                        ),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: cronogramas.length,
                        itemBuilder: (context, index) {
                          return CustomCardSchedule(index: index);
                        },
                      ),
                    ],
                  ),
                )
              ],
            )));
  }

  Widget _buildScrollableButton(String text, double width) {
    return GestureDetector(
      onTap: () {
        // Ação ao clicar
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: width.h,
        height: 50.h,
        decoration: BoxDecoration(
          color: AppColors.grey,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              color: AppColors.textPrimary,
              fontSize: 12,
            ),
            softWrap: false,
            overflow: TextOverflow.fade,
          ),
        ),
      ),
    );
  }
}
