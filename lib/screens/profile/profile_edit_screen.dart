import 'package:escoladeverao/controllers/edit_profile_controllers.dart';
import 'package:escoladeverao/models/user_model.dart';
import 'package:escoladeverao/screens/modals/checked_profile_modal.dart';
import 'package:escoladeverao/screens/modals/error_profile_modal.dart';
import 'package:escoladeverao/screens/profile/profile_screen.dart';
import 'package:escoladeverao/screens/settings_screen.dart';
import 'package:escoladeverao/services/api_service.dart';
import 'package:escoladeverao/utils/colors.dart';
import 'package:escoladeverao/utils/fonts.dart';
import 'package:escoladeverao/widgets/custom_outlined_button.dart';
import 'package:escoladeverao/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileEditScreen extends StatefulWidget {
  final String origin;
  final User user;

  const ProfileEditScreen({Key? key, required this.origin, required this.user})
      : super(key: key);

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late ScrollController _scrollController;
  bool _showAppBar = true;
  bool _isLoading = false;
  final _apiService = ApiService();
  bool _initialized = false;

  final TextEditingController nameEditController = TextEditingController();
  final TextEditingController emailEditController = TextEditingController();
  final TextEditingController phoneEditController = TextEditingController();
  final TextEditingController linkedinEditController = TextEditingController();
  final TextEditingController githubEditController = TextEditingController();
  final TextEditingController latesEditController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    // Agenda a inicialização dos controllers para depois do build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_initialized) {
        _initializeControllers();
      }
    });
  }

  void _initializeControllers() {
    if (!mounted) return;

    setState(() {
      nameEditController.text = widget.user.name;
      emailEditController.text = widget.user.email ?? '';
      phoneEditController.text = widget.user.telefone ?? '';
      linkedinEditController.text = widget.user.linkedin ?? '';
      githubEditController.text = widget.user.github ?? '';
      latesEditController.text = widget.user.lattes ?? '';
      _initialized = true;
    });
  }

  void _scrollListener() {
    if (_scrollController.offset > 50 && _showAppBar) {
      setState(() {
        _showAppBar = false;
      });
    } else if (_scrollController.offset <= 50 && !_showAppBar) {
      setState(() {
        _showAppBar = true;
      });
    }
  }

  Future<void> _handleUpdateProfile() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final phone = phoneEditController.text.replaceAll(RegExp(r'[^0-9]'), '');

      // Prepare update data
      final updateData = {
        'name': nameEditController.text.trim(),
        'email': emailEditController.text.trim(),
        'phone': phone,
        'linkedin': linkedinEditController.text.trim(),
        'github': githubEditController.text.trim(),
        'lattes': latesEditController.text.trim(),
      };

      // Log the update data for debugging
      print('Dados atualizados: $updateData');

      // Validate if any changes were made
      if (nameEditController.text.trim() == widget.user.name &&
          emailEditController.text.trim() == widget.user.email &&
          phone == widget.user.telefone &&
          linkedinEditController.text.trim() == widget.user.linkedin &&
          githubEditController.text.trim() == widget.user.github &&
          latesEditController.text.trim() == widget.user.lattes) {
        if (!mounted) return;

        ErrorProfileModal(
          context,
          errorMessage: 'Nenhuma alteração foi feita no perfil!',
        );
        return;
      }

      final result =
          await _apiService.updateProfile(widget.user.id, updateData);

      // Log the API response
      print('Resultado do servidor: $result');

      if (result['success']) {
        if (!mounted) return;

        // Show success modal
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CheckedProfileModal(context);
          },
        );

        // Wait a bit before navigation
        await Future.delayed(const Duration(seconds: 2));

        // Navigate based on origin
        if (widget.origin == 'settings') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SettingsScreen(
                user: User.fromJson(result['data']),
              ),
            ),
          );
        } else if (widget.origin == 'profile') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(
                user: User.fromJson(result['data']),
              ),
            ),
          );
        }
      } else {
        if (!mounted) return;

        ErrorProfileModal(
          context,
          errorMessage: result['message'] ?? 'Erro ao atualizar perfil',
        );
      }
    } catch (e) {
      if (!mounted) return;

      ErrorProfileModal(
        context,
        errorMessage: 'Erro ao atualizar perfil: $e',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    nameEditController.dispose();
    emailEditController.dispose();
    phoneEditController.dispose();
    linkedinEditController.dispose();
    githubEditController.dispose();
    latesEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(147.h),
        child: Container(
          width: double.infinity,
          color: AppColors.orangePrimary,
          child: Padding(
            padding: EdgeInsets.only(left: 10.h, right: 10.h, top: 35.h),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (widget.origin == 'settings') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsScreen(
                                  user: widget.user,
                                )),
                      );
                    } else if (widget.origin == 'profile') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProfileScreen(user: widget.user)),
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: SizedBox(
                    width: 44.h,
                    height: 44.h,
                    child: Image.asset('assets/icons/angle-left-white.png'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Stack(
          children: [
            Container(
              height: 200.h,
              color: AppColors.orangePrimary,
            ),
            Container(
              margin: EdgeInsets.only(top: 120.h),
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.h),
                child: Column(
                  children: [
                    SizedBox(height: 80.h),
                    Fonts(
                      text: widget.user.name,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    SizedBox(height: 8.h),
                    Fonts(
                      text: 'ID: ',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blueMarine,
                      additionalSpans: [
                        TextSpan(
                          text: widget.user.id.padLeft(4, '0'),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.blueMarine,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    CustomTextField(
                      labelText: 'Nome',
                      hintText: 'Edite seu nome',
                      keyboardType: TextInputType.name,
                      controller: nameEditController,
                      leadingIcon:
                          Image.asset('assets/icons/pen-edit-icon.png'),
                    ),
                    SizedBox(height: 20.h),
                    CustomTextField(
                      labelText: 'E-mail',
                      hintText: 'Edite seu e-mail',
                      keyboardType: TextInputType.emailAddress,
                      controller: emailEditController,
                      leadingIcon:
                          Image.asset('assets/icons/pen-edit-icon.png'),
                    ),
                    SizedBox(height: 20.h),
                    CustomTextField(
                      labelText: 'Telefone',
                      hintText: 'Edite seu telefone',
                      keyboardType: TextInputType.phone,
                      controller: phoneEditController,
                      leadingIcon:
                          Image.asset('assets/icons/pen-edit-icon.png'),
                    ),
                    SizedBox(height: 20.h),
                    CustomTextField(
                      labelText: 'LinkedIn',
                      hintText: 'Edite seu LinkedIn',
                      keyboardType: TextInputType.url,
                      controller: linkedinEditController,
                      leadingIcon:
                          Image.asset('assets/icons/pen-edit-icon.png'),
                    ),
                    SizedBox(height: 20.h),
                    CustomTextField(
                      labelText: 'GitHub',
                      hintText: 'Edite seu GitHub',
                      keyboardType: TextInputType.url,
                      controller: githubEditController,
                      leadingIcon:
                          Image.asset('assets/icons/pen-edit-icon.png'),
                    ),
                    SizedBox(height: 20.h),
                    CustomTextField(
                      labelText: 'Currículo Lattes',
                      hintText: 'Edite seu Lattes',
                      keyboardType: TextInputType.url,
                      controller: latesEditController,
                      leadingIcon:
                          Image.asset('assets/icons/pen-edit-icon.png'),
                    ),
                    SizedBox(height: 22.h),
                    CustomOutlinedButton(
                      text: _isLoading ? 'Salvando...' : 'Salvar alterações',
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
                        side: const BorderSide(color: AppColors.orangePrimary),
                        backgroundColor: _isLoading
                            ? AppColors.orangePrimary.withOpacity(0.7)
                            : AppColors.orangePrimary,
                      ),
                      onPressed: _isLoading ? null : _handleUpdateProfile,
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 120.h - 52.h,
              left: MediaQuery.of(context).size.width / 2 - 52.h,
              child: SizedBox(
                width: 104.h,
                height: 104.h,
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/person.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 120.h + 24.h,
              left: MediaQuery.of(context).size.width / 2 + 24.h,
              child: GestureDetector(
                onTap: () {
                  // Image edit action
                },
                child: Container(
                  width: 27.h,
                  height: 27.h,
                  decoration: const BoxDecoration(
                    color: AppColors.orangePrimary,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset('assets/icons/pen_black_icon.png'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
