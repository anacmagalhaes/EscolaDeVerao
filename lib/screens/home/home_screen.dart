import 'package:escoladeverao/models/user_model.dart';
import 'package:escoladeverao/services/auth_service.dart';
import 'package:escoladeverao/utils/colors.dart';
import 'package:escoladeverao/utils/fonts.dart';
import 'package:escoladeverao/widgets/custom_bottom_navigation.dart';
import 'package:escoladeverao/widgets/custom_card_home.dart';
import 'package:escoladeverao/widgets/custom_screen_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthService authService = AuthService();

  final List<String> palestrantes = [
    'Rafael Monteiro Silva',
    'Ana Beatriz Almeida',
    'José Carlos Oliveira',
  ];

  int _currentIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index != 0) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return getScreenFromIndex(index, widget.user);
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

  void _logout() async {
    try {
      await authService.logout(); // Limpa todos os dados salvos

      if (!mounted) return;

      // Remove todas as rotas da pilha e navega para a tela de login
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login_screen', // ou '/login_screen' dependendo da sua rota
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      // Tratamento de erro opcional
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao fazer logout. Tente novamente.'),
          backgroundColor: Colors.red,
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
            Size.fromHeight(90.h), // Limita o tamanho máximo da AppBar
        child: Container(
          width: double.maxFinite,
          color: AppColors.orangePrimary,
          child: Padding(
            padding: EdgeInsets.only(
                left: 24.h, right: 10.h, top: 19.h), // Limita padding superior
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
                          mainAxisSize: MainAxisSize
                              .min, // Garante que o conteúdo não extrapole
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                    height:
                                        16.h), // Limita espaçamento vertical
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 24.h,
                                  ), // Limita espaçamento superior do avatar
                                  child: SizedBox(
                                    width: 56
                                        .h, // Define tamanho máximo para avatar
                                    height: 56.h,
                                    child:
                                        Image.asset('assets/images/person.png'),
                                  ),
                                ),
                                SizedBox(width: 8.h),
                                Padding(
                                  padding: EdgeInsets.only(top: 24.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Fonts(
                                        text: 'Oi, ${widget.user.name}',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.white,
                                      ),
                                      Fonts(
                                        text: 'ID: ',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.white,
                                        additionalSpans: [
                                          TextSpan(
                                            text:
                                                widget.user.id.padLeft(4, '0'),
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      _logout();
                                    },
                                    icon: Icon(Icons.logout))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
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
                margin: EdgeInsets.only(top: 2.h),
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
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            switch (index) {
                              case 0:
                                return CustomCardHome(
                                    index: index,
                                    cardType: CardType.imageOnly,
                                    imagePath: 'assets/images/peoples.png');
                              case 1:
                                return CustomCardHome(
                                    index: index,
                                    cardType: CardType.imageAndText,
                                    description:
                                        'Descrição detalhada do conteúdo',
                                    imagePath: 'assets/images/peoples.png');
                              case 2:
                                return CustomCardHome(
                                    index: index,
                                    cardType: CardType.textOnly,
                                    description:
                                        'Descrição detalhada do conteúdo');
                              default:
                                return Container(); // Caso padrão, se necessário
                            }
                          },
                        ),
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
