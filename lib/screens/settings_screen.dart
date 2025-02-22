import 'package:escoladeverao/models/user_model.dart';
import 'package:escoladeverao/models/user_provider_model.dart';
import 'package:escoladeverao/screens/password/change_password_screen.dart';
import 'package:escoladeverao/screens/my_connections_screen.dart';
import 'package:escoladeverao/screens/profile/profile_edit_screen.dart';
import 'package:escoladeverao/services/auth_service.dart';
import 'package:escoladeverao/services/cached_user_service.dart';
import 'package:escoladeverao/utils/colors_utils.dart';
import 'package:escoladeverao/utils/fonts_utils.dart';
import 'package:escoladeverao/utils/string_utils.dart';
import 'package:escoladeverao/widgets/custom_bottom_navigation.dart';
import 'package:escoladeverao/widgets/custom_screen_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen(
      {Key? key, required this.user, required this.scannedUser})
      : super(key: key);

  final User user;
  final User scannedUser;

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  AuthService authService = AuthService();

  int _currentIndex = 4;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<UserProvider>(context, listen: false)
            .updateUser(widget.user);
      });
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

  void _logout() async {
    try {
      await authService.logout();
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login_screen',
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      Fluttertoast.showToast(
        msg: 'Erro ao fazer logout. Tente novamente.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );

      Future.delayed(const Duration(seconds: 5));
    }
  }

  Future<void> _launchURL(String? url) async {
    if (url == null || url.isEmpty) {
      debugPrint('URL inválida ou nula.');
      return;
    }

    try {
      // Ensure URL starts with https://
      String formattedUrl = url;
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        formattedUrl = 'https://$url';
      }

      final Uri uri = Uri.parse(formattedUrl);

      // Try launching with platform default browser
      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: '_blank',
      );

      if (!launched) {
        // If external application fails, try launching in app
        final bool inAppLaunched = await launchUrl(
          uri,
          mode: LaunchMode.inAppWebView,
          webViewConfiguration: const WebViewConfiguration(
            enableJavaScript: true,
            enableDomStorage: true,
          ),
        );

        if (!inAppLaunched) {
          throw 'Could not launch $formattedUrl';
        }
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      throw 'Não foi possível abrir o link: $url';
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, UserProvider, child) {
      final displayUser = UserProvider.currentUser ?? widget.user;

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
                  left: 24.h,
                  right: 10.h,
                  top: 40.h), // Limita padding superior
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
                                    height: 48.h,
                                    child: Image.asset('assets/images/profile.png'),
                                    // child: CachedUserImage(
                                    //   userId: widget.user.id,
                                    //   width: 48,
                                    //   height: 48,
                                    // )
                                    ),
                              ),
                              SizedBox(width: 12.h),
                              Padding(
                                padding: EdgeInsets.only(top: 10.h),
                                child: Fonts(
                                    text: StringUtils.formatUserName(
                                        widget.user.name),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.black),
                              ),
                              const Spacer(),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: 20.h, right: 15.h),
                                child: IconButton(
                                  onPressed: _logout,
                                  icon: SizedBox(
                                    width: 32,
                                    height: 32,
                                    child: Image.asset(
                                        'assets/icons/logout-icon.png'),
                                  ),
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 24.h, right: 24.h, bottom: 24.h),
                            child: Divider(
                              // ignore: deprecated_member_use
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
                                  behavior: HitTestBehavior.translucent,
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
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProfileEditScreen(
                                          origin: 'settings',
                                          user: widget.user,
                                          scannedUser: widget.scannedUser,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 34.84.h),
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
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
                                    Navigator.pushReplacement(
                                      // ignore: use_build_context_synchronously
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChangePasswordScreen(
                                                user: widget.user,
                                                scannedUser: widget.scannedUser,
                                              )),
                                    );
                                  },
                                ),
                                SizedBox(height: 34.84.h),
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
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
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MyConnectionsScreen(
                                          origin: 'settings',
                                          scannedUser: widget.scannedUser,
                                          user: widget.user,
                                        ),
                                      ),
                                    );
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
                                  behavior: HitTestBehavior.translucent,
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
                                        const Spacer(),
                                        Image.asset(
                                          'assets/icons/angle-rigth.png',
                                          width: 24.h,
                                          height: 24.h,
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    _launchURL(
                                        'https://2025.escoladeverao.com.br/');
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
    });
  }
}
