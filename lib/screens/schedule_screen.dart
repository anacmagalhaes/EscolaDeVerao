import 'package:escoladeverao/models/user_model.dart';
import 'package:escoladeverao/services/api_service.dart';
import 'package:escoladeverao/services/cached_user_service.dart';
import 'package:escoladeverao/utils/fonts_utils.dart';
import 'package:escoladeverao/utils/string_utils.dart';
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
  final ApiService _apiService = ApiService();
  List<dynamic> events = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadEvents(); // Adicione esta linha
  }

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

  Future<void> _loadEvents() async {
    try {
      setState(() {
        isLoading = true;
        error = null; // Limpa erros anteriores
      });

      // Verifica se os eventos já estão em cache
      final cachedEvents = await CachedUserService.getCachedEvents();
      if (cachedEvents != null && cachedEvents.isNotEmpty) {
        setState(() {
          events = cachedEvents;
          isLoading = false;
        });
        return; // Evita chamar a API se já houver eventos armazenados
      }

      print('Carregando eventos da API...');
      final result = await _apiService.fetchEvents();

      if (result['success']) {
        events = result['data'];
        await CachedUserService.saveCachedEvents(events); // Salva no cache
      } else {
        error = result['message'] ?? 'Erro desconhecido ao carregar eventos';
      }
    } catch (e) {
      error = 'Erro ao carregar eventos: $e';
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    return _loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CustomBottomNavigation(
          onTap: _onItemTapped,
          currentIndex: _currentIndex,
        ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(90.h),
          child: Container(
            width: double.maxFinite,
            color: AppColors.orangePrimary,
            child: Padding(
              padding: EdgeInsets.only(left: 24.h, right: 10.h, top: 19.h),
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
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 24.h),
                                    child: SizedBox(
                                      width: 56.h,
                                      height: 56.h,
                                      child: Image.asset(
                                          'assets/images/profile.png'),
                                      // child: CachedUserImage(
                                      //   userId: widget.user.id,
                                      //   width: 48,
                                      //   height: 48,
                                      // )
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
                                          text:
                                              'Oi, ${StringUtils.formatUserName(widget.user.name)}',
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
                                              text: widget.user.id
                                                  .padLeft(4, '0'),
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
        body: RefreshIndicator(
          backgroundColor: AppColors.orangePrimary,
          color: AppColors.background,
          onRefresh: _onRefresh,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Padding(
                    //   padding: EdgeInsets.only(left: 26.h),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     children: [
                    //       _buildScrollableButton('Hoje', 100),
                    //       _buildScrollableButton('Cronograma completo', 150),
                    //     ],
                    //   ),
                    // ),
                    if (isLoading && events.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(
                            color: AppColors.orangePrimary,
                          ),
                        ),
                      )
                    else if (error != null)
                      Center(
                        child: Text(
                          error!,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    else if (events.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            'Não existem eventos',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.quaternaryGrey,
                            ),
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          return CustomCardSchedule(event: events[index]);
                        },
                      ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
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
