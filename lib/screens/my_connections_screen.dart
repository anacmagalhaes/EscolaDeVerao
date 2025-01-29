import 'package:escoladeverao/models/user_model.dart';
import 'package:escoladeverao/screens/profile/profile_screen.dart';
import 'package:escoladeverao/screens/profile/user_profile_screen.dart';
import 'package:escoladeverao/screens/settings_screen.dart';
import 'package:escoladeverao/services/api_service.dart';
import 'package:escoladeverao/utils/colors.dart';
import 'package:escoladeverao/utils/fonts.dart';
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

      print(
          'Iniciando carregamento de conexões para usuário: ${widget.user.id}');
      final connections =
          await _apiService.fetchUserConnections(widget.user.id);
      print('Conexões carregadas: ${connections.length}');

      if (connections.isEmpty) {
        setState(() {
          isLoading = false;
          error = 'Nenhuma conexão encontrada';
        });
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
        error = 'Erro ao carregar conexões. Tente novamente.';
        isLoading = false;
      });
    }
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            error ?? 'Erro desconhecido',
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          CustomOutlinedButton(
            text: 'Acessar',
            height: 56.h,
            buttonFonts: const Fonts(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.background),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
            ),
            buttonStyle: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.orangePrimary),
                backgroundColor: AppColors.orangePrimary),
            onPressed: _loadConnections,
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
              if (widget.origin == 'settings') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(
                      user: widget.user,
                      scannedUser: widget.scannedUser,
                    ),
                  ),
                );
              } else if (widget.origin == 'profile') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(user: widget.user),
                  ),
                );
              } else {
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
                    ),
                  if (!isLoading && error != null) _buildErrorWidget(),
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
                                    scannedUser:
                                        user, // Este é o usuário do card que foi clicado
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
