import 'package:escoladeverao/models/user_model.dart';
import 'package:escoladeverao/screens/profile/profile_screen.dart';
import 'package:escoladeverao/screens/profile/user_profile_screen.dart';
import 'package:escoladeverao/screens/settings_screen.dart';
import 'package:escoladeverao/services/api_service.dart';
import 'package:escoladeverao/services/error_handler_service.dart';
import 'package:escoladeverao/utils/colors_utils.dart';
import 'package:escoladeverao/utils/fonts_utils.dart';
import 'package:escoladeverao/widgets/custom_app_bar_error.dart';
import 'package:escoladeverao/widgets/custom_card_connections.dart';
import 'package:escoladeverao/widgets/custom_outlined_button.dart';
import 'package:flutter/material.dart';

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
          groupedConnections = {};
        });
        print('Nenhuma conexão encontrada.');
        return;
      }

      final grouped = <String, List<User>>{};
      for (var connection in connections) {
        if (connection.name.isEmpty) continue;
        final firstLetter = connection.name[0].toUpperCase();
        grouped.putIfAbsent(firstLetter, () => []).add(connection);
      }

      final sortedGrouped = Map.fromEntries(
          grouped.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));

      setState(() {
        groupedConnections = sortedGrouped;
        isLoading = false;
      });
    } catch (e) {
      print('Erro ao carregar conexões: $e');

      String errorMessage = 'Ocorreu um erro inesperado';
      String imagePath = 'assets/images/error_505.png';
      String? details;

      if (e.toString().contains('SocketException')) {
        errorMessage = 'Sem conexão com a Internet';
        imagePath = 'assets/images/error_conection.png';
      } else if (e.toString().contains('Timeout')) {
        errorMessage = 'Tempo de resposta excedido';
        imagePath = 'assets/images/error_404.png';
      } else if (e.toString().contains('500')) {
        errorMessage = 'Erro Interno do Servidor (500)';
        imagePath = 'assets/images/error_505.png';
        details = e.toString(); // Exibe a mensagem detalhada
      }

      ErrorHandler.showFullScreenError(
        context,
        errorMessage,
        imagePath,
        onRetry: _loadConnections,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
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
                          builder: (context) =>
                              ProfileScreen(user: widget.user)),
                    );
                    break;
                  default:
                    Navigator.pop(context);
                }
              },
              leadingIcon: Image.asset('assets/icons/angle-left-orange.png'),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Fonts(
                      text: 'Minhas Conexões',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
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
                  if (groupedConnections.isEmpty && !isLoading)
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
            if (!isLoading && groupedConnections.isNotEmpty)
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
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 0.9,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
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
                                      origin: 'user_profile',
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
      ),
    );
  }
}
