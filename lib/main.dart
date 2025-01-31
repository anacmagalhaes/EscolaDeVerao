import 'dart:convert';

import 'package:app_links/app_links.dart';
import 'package:escoladeverao/models/user_model.dart';
import 'package:escoladeverao/models/user_provider_model.dart';
import 'package:escoladeverao/routes/app_routes.dart';
import 'package:escoladeverao/services/auth_service.dart';
import 'package:escoladeverao/utils/colors_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authService = AuthService();
  final savedUser = await authService.loadUser();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => UserProvider())],
      child: MyApp(
        initialUser: savedUser,
      )));
}

class MyApp extends StatefulWidget {
  final User? initialUser;

  const MyApp({super.key, this.initialUser});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppLinks appLinks = AppLinks();

  @override
  void initState() {
    super.initState();
    _initializeDeepLinks();
  }

  // Lógica para processar os deep links
  Future<void> _initializeDeepLinks() async {
    final initialLink = await appLinks.getInitialLink();

    if (initialLink != null) {
      _handleDeepLink(initialLink);
    }

    // Escuta os deep links durante o uso do app
    appLinks.uriLinkStream.listen((uri) {
      if (uri != null) {
        _handleDeepLink(uri);
      }
    });
  }

  // Função que processa o deep link
  void _handleDeepLink(Uri uri) {
    if (uri.path == '/user') {
      final String? jsonData = uri.queryParameters['data'];
      if (jsonData != null) {
        final Map<String, dynamic> userMap = jsonDecode(jsonData);
        final User user = User.fromJson(userMap);

        // Abre a tela de perfil com os dados do usuário
        Navigator.pushNamed(context, '/userProfile', arguments: user);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        ScreenUtil.init(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.background,
          ),
          title: 'Escola de Verão',
          // Começa pela SplashScreen
          initialRoute: AppRoutes.splashScreen,
          routes: AppRoutes.getRoutes(widget.initialUser),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.0),
              ),
              child: child!,
            );
          },
        );
      },
    );
  }
}
