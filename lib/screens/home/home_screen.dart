import 'package:escoladeverao/models/user_model.dart';
import 'package:escoladeverao/services/api_service.dart';
import 'package:escoladeverao/screens/posts_admin/posts_screen.dart';
import 'package:escoladeverao/services/auth_service.dart';
import 'package:escoladeverao/utils/colors_utils.dart';
import 'package:escoladeverao/utils/fonts_utils.dart';
import 'package:escoladeverao/utils/string_utils.dart';
import 'package:escoladeverao/widgets/custom_bottom_navigation.dart';
import 'package:escoladeverao/widgets/custom_card_home.dart';
import 'package:escoladeverao/widgets/custom_screen_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  final String? imageUrl;
  const HomeScreen({Key? key, required this.user, this.imageUrl})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthService authService = AuthService();
  ApiService apiService = ApiService();
  int _currentIndex = 0;
  bool _isAdmin = false;
  List<dynamic> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
    _checkAdminStatus();
  }

  Future<void> _fetchPosts() async {
    try {
      final result = await apiService.fetchPosts();

      if (result['success']) {
        setState(() {
          _posts = result['data']['data'] ??
              []; // Agora os posts são extraídos corretamente
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Erro ao carregar posts'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro de conexão ao carregar posts'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      _checkAdminStatus();
    });

    if (index != 0) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return getScreenFromIndex(index, widget.user);
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
      await authService.logout();
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login_screen',
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao fazer logout. Tente novamente.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _checkAdminStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAdmin = prefs.getBool('is_admin') ?? widget.user.isAdmin ?? false;
    });
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
                                const Spacer(),
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 20.h, right: 10.h),
                                  child: IconButton(
                                    onPressed: _logout,
                                    icon: Image.asset(
                                        'assets/icons/out-icon.png'),
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
                child: Stack(
                  children: [
                    _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: AppColors.orangePrimary,
                          ))
                        : _posts.isEmpty
                            ? const Center(
                                child: Text('Não há posts'),
                              )
                            : SingleChildScrollView(
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 16.h),
                                      ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: _posts.length,
                                        itemBuilder: (context, index) {
                                          return CustomCardHome(
                                            post: _posts[index],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                    if (widget.user.isAdmin) ...[
                      Positioned(
                        right: 17.h,
                        bottom: 17.h,
                        child: FloatingActionButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return PostsScreen(user: widget.user);
                                });
                          },
                          backgroundColor: AppColors.orangePrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Image.asset('assets/icons/post-icon.png'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
