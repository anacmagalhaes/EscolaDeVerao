import 'package:escoladeverao/models/user_model.dart';
import 'package:escoladeverao/screens/auth/login_screen.dart';
import 'package:escoladeverao/utils/colors.dart';
import 'package:escoladeverao/utils/fonts.dart';
import 'package:escoladeverao/widgets/custom_bottom_navigation.dart';
import 'package:escoladeverao/widgets/custom_screen_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _currentIndex = 4;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index != 4) {
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

  Future<void> _verifyLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberLogin = prefs.getBool('remember_login') ?? false;

    if (!rememberLogin) {
      // Se não deve lembrar login, verifica se tem token válido
      // Aqui você pode adicionar sua lógica de verificação de token
      final userId = prefs.getString('user_id');
      if (userId == null) {
        logout();
      }
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    // Se não quiser manter as credenciais salvas após logout:
    await prefs.remove('remember_login');
    await prefs.remove('saved_email');
    await prefs.remove('saved_password');
    // ou para limpar tudo:
    // await prefs.clear();

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    _verifyLoginStatus();
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
            Size.fromHeight(147.h), // Limita o tamanho máximo da AppBar
        child: Container(
          width: double.maxFinite,
          color: AppColors.orangePrimary,
          child: Padding(
            padding: EdgeInsets.only(
                left: 24.h, right: 10.h, top: 40.h), // Limita padding superior
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 12.h, top: 42.h),
                        child: const Fonts(
                            text: 'Configurações',
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary),
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
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10.h, left: 24.h),
                              child: SizedBox(
                                width: 48.h,
                                height: 72.h,
                                child: Image.asset('assets/images/person.png'),
                              ),
                            ),
                            SizedBox(width: 12.h),
                            Padding(
                              padding: EdgeInsets.only(top: 10.h),
                              child: Fonts(
                                  text: widget.user.name,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.black),
                            ),
                            IconButton(
                                onPressed: () {
                                  logout();
                                },
                                icon: Icon(Icons.logout))
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 24.h, right: 24.h, bottom: 24.h),
                          child: Divider(
                            color: AppColors.textPrimary.withOpacity(0.50),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 24.h),
                          child: Column(
                            children: [
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Fonts(
                                    text: 'Configurações da conta',
                                    fontSize: 18.74,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.secondaryGrey),
                              ),
                              SizedBox(height: 23.62.h),
                              GestureDetector(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 60.09.h),
                                  child: Row(
                                    children: [
                                      const Fonts(
                                        text: 'Editar Perfil',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                      const Spacer(), // Usando Spacer para empurrar a seta para a direita
                                      Image.asset(
                                        'assets/icons/angle-rigth.png',
                                        width: 24
                                            .h, // Define o tamanho fixo da seta
                                        height: 24
                                            .h, // Define o tamanho fixo da seta
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  /*Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ProfileEditScreen(
                                              origin: 'settings'),
                                    ),
                                  ); */
                                },
                              ),
                              SizedBox(height: 34.84.h),
                              GestureDetector(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 60.09.h),
                                  child: Row(
                                    children: [
                                      const Fonts(
                                        text: 'Alterar minha senha',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                      const Spacer(), // Usando Spacer para empurrar a seta para a direita
                                      Image.asset(
                                        'assets/icons/angle-rigth.png',
                                        width: 24
                                            .h, // Define o tamanho fixo da seta
                                        height: 24
                                            .h, // Define o tamanho fixo da seta
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  /*Navigator.pushReplacement(
                                    // ignore: use_build_context_synchronously
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const PasswordScreen(
                                                origin: 'settings')),
                                  );*/
                                },
                              ),
                              SizedBox(height: 34.84.h),
                              GestureDetector(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 60.09.h),
                                  child: Row(
                                    children: [
                                      const Fonts(
                                        text: 'Minhas conexões',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                      const Spacer(), // Usando Spacer para empurrar a seta para a direita
                                      Image.asset(
                                        'assets/icons/angle-rigth.png',
                                        width: 24
                                            .h, // Define o tamanho fixo da seta
                                        height: 24
                                            .h, // Define o tamanho fixo da seta
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  /* Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MyConnectionsScreen(
                                              origin: 'settings',
                                            )),
                                  );*/
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 25.54.h, right: 24.h, bottom: 24.h),
                                child: const Divider(
                                  color: AppColors.terciaryGrey,
                                ),
                              ),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Fonts(
                                    text: 'Mais',
                                    fontSize: 18.74,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.secondaryGrey),
                              ),
                              SizedBox(height: 23.62.h),
                              GestureDetector(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 60.09.h),
                                  child: Row(
                                    children: [
                                      const Fonts(
                                        text: 'Sobre nós',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                      const Spacer(), // Usando Spacer para empurrar a seta para a direita
                                      Image.asset(
                                        'assets/icons/angle-rigth.png',
                                        width: 24
                                            .h, // Define o tamanho fixo da seta
                                        height: 24
                                            .h, // Define o tamanho fixo da seta
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  // adicionar ir para a tela editar perfil
                                },
                              ),
                              SizedBox(height: 34.84.h),
                              GestureDetector(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 60.09.h),
                                  child: Row(
                                    children: [
                                      const Fonts(
                                        text: 'Política de privacidade',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                      const Spacer(), // Usando Spacer para empurrar a seta para a direita
                                      Image.asset(
                                        'assets/icons/angle-rigth.png',
                                        width: 24
                                            .h, // Define o tamanho fixo da seta
                                        height: 24
                                            .h, // Define o tamanho fixo da seta
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  // adicionar ir para a tela editar perfil
                                },
                              ),
                              SizedBox(height: 34.84.h),
                              GestureDetector(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 60.09.h),
                                  child: Row(
                                    children: [
                                      const Fonts(
                                        text: 'Termos e condições',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                      const Spacer(), // Usando Spacer para empurrar a seta para a direita
                                      Image.asset(
                                        'assets/icons/angle-rigth.png',
                                        width: 24
                                            .h, // Define o tamanho fixo da seta
                                        height: 24
                                            .h, // Define o tamanho fixo da seta
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  // adicionar ir para a tela editar perfil
                                },
                              ),
                              SizedBox(height: 34.84.h),
                            ],
                          ),
                        )
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
