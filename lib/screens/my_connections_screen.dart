import 'package:escoladeverao/models/user_model.dart';
import 'package:escoladeverao/screens/profile/profile_screen.dart';
import 'package:escoladeverao/screens/profile/user_profile_screen.dart';
import 'package:escoladeverao/screens/settings_screen.dart';
import 'package:escoladeverao/services/api_service.dart';
import 'package:escoladeverao/utils/colors_utils.dart';
import 'package:escoladeverao/utils/fonts_utils.dart';
import 'package:escoladeverao/widgets/custom_app_bar_error.dart';
import 'package:escoladeverao/widgets/custom_card_connections.dart';
import 'package:escoladeverao/widgets/custom_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyConnectionsScreen extends StatefulWidget {
  final String origin;
  final User user;
  final User scannedUser;
  const MyConnectionsScreen({
    Key? key,
    required this.origin,
    required this.scannedUser,
    required this.user,
  }) : super(key: key);

  @override
  _MyConnectionsScreenState createState() => _MyConnectionsScreenState();
}

class _MyConnectionsScreenState extends State<MyConnectionsScreen> {
  final ApiService _apiService = ApiService();
  Map<String, List<User>> groupedConnections = {};
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadConnections();
  }

  Future<void> _loadConnections() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final connections =
          await _apiService.fetchUserConnections(widget.user.id);

      if (connections.isEmpty) {
        setState(() {
          isLoading = false;
          groupedConnections = {}; // Lista vazia, sem erro
        });
        print('Nenhuma conexão encontrada.');
        return;
      }

      // Agrupar conexões
      final grouped = <String, List<User>>{};
      for (var connection in connections) {
        if (connection.name.isEmpty) continue;
        final firstLetter = connection.name[0].toUpperCase();
        grouped.putIfAbsent(firstLetter, () => []).add(connection);
      }

      // Ordenar
      final sortedGrouped = Map.fromEntries(
          grouped.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));

      setState(() {
        groupedConnections = sortedGrouped;
        isLoading = false;
      });
    } catch (e) {
      print('Erro ao carregar conexões: $e');
      setState(() {
        error = '$e';
        isLoading = false;
      });
    }
  }

  Widget _buildErrorWidget() {
    // Verifique se a variável `error` contém uma mensagem específica
    String errorMessage = error ?? 'Erro desconhecido';

    // Define a cor e o texto baseados no tipo de erro
    Color errorColor;
    String errorTitle;
    String errorSubtitle;
    String imagePath = 'assets/images/error_505.png';

    // Exemplos de diferentes tipos de erro
    if (errorMessage.contains('SocketException') ||
        errorMessage.contains('No Internet')) {
      errorColor = AppColors.orangePrimary;
      errorTitle = 'Sem Conexão';
      errorSubtitle = 'Nenhuma conexão com a internet foi encontrada.';
      imagePath = 'assets/images/error_conection.png';
    }
    // Verifica outros tipos de erro, como timeout ou 404
    else if (errorMessage.contains('Timeout')) {
      errorColor = Colors.red;
      errorTitle = 'Tempo de espera excedido';
      errorSubtitle = 'Por favor, tente novamente mais tarde.';
    } else if (errorMessage.contains('404')) {
      errorColor = Colors.blue;
      errorTitle = 'Página não encontrada';
      errorSubtitle = 'O recurso solicitado não está disponível.';
    } else {
      errorColor = Colors.grey;
      errorTitle = 'Erro desconhecido';
      errorSubtitle = 'Algo deu errado, por favor, tente novamente.';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 23.h, right: 25.h),
            child: Column(
              children: [
                SizedBox(
                  width: 380.h,
                  height: 271.03.h,
                  child: Image.asset(imagePath),
                ),
                SizedBox(height: 20.h),
                Fonts(
                  text: errorTitle,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: errorColor,
                ),
                SizedBox(height: 23.h),
                Fonts(
                  text: errorSubtitle,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                SizedBox(height: 8.h),
                SizedBox(height: 35.h),
                CustomOutlinedButton(
                  text: 'Recarregar',
                  height: 56.h,
                  width: double.maxFinite,
                  buttonFonts: const Fonts(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.background,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  buttonStyle: OutlinedButton.styleFrom(
                    side: BorderSide(color: errorColor),
                    backgroundColor: errorColor,
                  ),
                  onPressed: () {
                    _loadConnections();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomAppBarError(
            onBackPressed: () {
              switch (widget.origin) {
                case 'settings':
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SettingsScreen(
                              user: widget.user,
                              scannedUser: widget.scannedUser,
                            )),
                  );
                  break;
                case 'profile':
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileScreen(user: widget.user)),
                  );
                  break;
                default:
                  Navigator.pop(context);
              }
            },
            leadingIcon: Image.asset('assets/icons/angle-left-orange.png'),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Fonts(
                    text: 'Minhas Conexões',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  if (isLoading)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.orangePrimary,
                          ),
                        ),
                      ),
                    )
                  else if (error != null)
                    _buildErrorWidget()
                  else if (groupedConnections.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_off,
                                size: 80, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'Nenhuma conexão encontrada.',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (!isLoading && error == null)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  String letter = groupedConnections.keys.elementAt(index);
                  List<User> connections = groupedConnections[letter]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: Text(
                          letter,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.orangePrimary,
                          ),
                        ),
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio: 0.8,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: connections.length,
                        itemBuilder: (context, index) {
                          final user = connections[index];
                          final connection = Connection(
                            image: AssetImage('assets/images/person.png'),
                            name: user.name,
                            id: user.id,
                          );
                          return GestureDetector(
                            child:
                                CustomCardConnections(connection: connection),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserProfileScreen(
                                    user: widget.user,
                                    scannedUser: user,
                                    origin:
                                        'user_profile', // Este é o usuário do card que foi clicado
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  );
                },
                childCount: groupedConnections.keys.length,
              ),
            ),
        ],
      ),
    );
  }
}
