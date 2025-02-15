import 'package:escoladeverao/models/user_model.dart';
import 'package:escoladeverao/models/user_provider_model.dart';
import 'package:escoladeverao/services/api_service.dart';
import 'package:escoladeverao/screens/posts_admin/posts_screen.dart';
import 'package:escoladeverao/services/auth_service.dart';
import 'package:escoladeverao/services/cached_user_service.dart';
import 'package:escoladeverao/utils/colors_utils.dart';
import 'package:escoladeverao/utils/fonts_utils.dart';
import 'package:escoladeverao/utils/string_utils.dart';
import 'package:escoladeverao/widgets/custom_bottom_navigation.dart';
import 'package:escoladeverao/widgets/custom_card_home.dart';
import 'package:escoladeverao/widgets/custom_screen_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
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
  static List<dynamic> _posts = []; // Tornamos a lista de posts estática
  bool _isLoading = false;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  bool _hasMorePosts = true;
  final ScrollController _scrollController = ScrollController();
  late User currentUser;
  static bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    currentUser = widget.user;
    _checkAdminStatus();
    _fetchUserData();
    _setupScrollController();

    if (_isFirstLoad) {
      setState(() {
        _isLoading = true;
      });
      _fetchPosts();
      _isFirstLoad = false;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _setupScrollController() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoadingMore &&
          _hasMorePosts) {
        _loadMorePosts();
      }
    });
  }

  Future<void> _fetchUserData() async {
    try {
      final result = await apiService.fetchUserById(widget.user.id);
      if (result != null) {
        if (!mounted) return;
        Provider.of<UserProvider>(context, listen: false).updateUser(result);
      }
    } catch (e) {
      print('Erro ao buscar dados do usuário: $e');
    }
  }

  Future<void> _fetchPosts() async {
    if (!_hasMorePosts && _currentPage > 1) return;

    try {
      final result = await apiService.fetchPosts(page: _currentPage);

      if (result['success'] != false) {
        final newPosts = result['data']['data'] as List;
        final currentPage = result['data']['current_page'] as int;
        final lastPage = result['data']['last_page'] as int;

        if (mounted) {
          setState(() {
            if (_currentPage == 1) {
              _posts = newPosts;
            } else {
              _posts.addAll(newPosts);
            }
            _hasMorePosts = currentPage < lastPage;
            _isLoading = false;
            _isLoadingMore = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _isLoadingMore = false;
          });

          Fluttertoast.showToast(
            msg: result['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
        });
        Fluttertoast.showToast(
          msg: 'Erro de conexão ao carregar posts',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  Future<void> _loadMorePosts() async {
    if (!_hasMorePosts || _isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    _currentPage++;
    await _fetchPosts();
  }

  Future<void> _refreshPosts() async {
    setState(() {
      _currentPage = 1;
      _hasMorePosts = true;
      _posts.clear();
      _isLoading = true;
    });
    await _fetchPosts();
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

  void _checkAdminStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAdmin = prefs.getBool('is_admin') ?? widget.user.isAdmin ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, UserProvider, child) {
      final user = UserProvider.currentUser ?? widget.user;

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
                                        child: CachedUserImage(
                                          userId: user.id,
                                          width: 48,
                                          height: 48,
                                        )),
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
                      _isLoading && _posts.isEmpty
                          ? const Center(
                              child: CircularProgressIndicator(
                              color: AppColors.orangePrimary,
                            ))
                          : _posts.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Não há posts',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                )
                              : RefreshIndicator(
                                  backgroundColor: AppColors.orangePrimary,
                                  color: AppColors.background,
                                  onRefresh: _refreshPosts,
                                  child: SingleChildScrollView(
                                    controller: _scrollController,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.h),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 16.h),
                                          if (_isLoading && _posts.isEmpty)
                                            const Center(
                                              child: CircularProgressIndicator(
                                                color: AppColors.orangePrimary,
                                              ),
                                            )
                                          else if (_posts.isEmpty)
                                            const Center(
                                              child: Text(
                                                'Não há posts',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey),
                                              ),
                                            )
                                          else
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: _posts.length +
                                                  (_hasMorePosts ? 1 : 0),
                                              itemBuilder: (context, index) {
                                                if (index == _posts.length) {
                                                  return _isLoadingMore
                                                      ? Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  16.h),
                                                          child: const Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                              color: AppColors
                                                                  .orangePrimary,
                                                            ),
                                                          ),
                                                        )
                                                      : const SizedBox();
                                                }
                                                return CustomCardHome(
                                                  post: _posts[index],
                                                );
                                              },
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                      if (_isAdmin) ...[
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
    });
  }
}
