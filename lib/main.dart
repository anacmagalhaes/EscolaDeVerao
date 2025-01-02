import 'package:escoladeverao/routes/app_routes.dart';
import 'package:escoladeverao/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sizer/sizer.dart';

void main() {
  //garante que o Flutter está inicializado
  WidgetsFlutterBinding.ensureInitialized();
  //configurações das orientações de tela. Apenas orientação vertical
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    //pacote para responsividade que recebe o contexto, a orientação e o tipo do dispositivo
    return Sizer(builder: (context, orientation, deviceType) {
      ScreenUtil.init(context);
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.background,
        ),
        title: 'Escola de Verão',
        initialRoute: AppRoutes.initialRoute, //inicia e define a rota inicial
        routes: AppRoutes.routes, //define as rotas
        builder: (context, child) {
          return MediaQuery(
            //modifica as informações, garantindo que o texto não sofra alterações
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: child!,
          );
        },
      );
    });
  }
}
