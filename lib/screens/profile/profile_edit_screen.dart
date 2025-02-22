import 'dart:io';

import 'package:escoladeverao/controllers/profile_edit_controller.dart';
import 'package:escoladeverao/models/user_model.dart';
import 'package:escoladeverao/models/user_provider_model.dart';
import 'package:escoladeverao/screens/profile/profile_screen.dart';
import 'package:escoladeverao/screens/settings_screen.dart';
import 'package:escoladeverao/services/api_service.dart';
import 'package:escoladeverao/services/cached_edit_user_service.dart';
import 'package:escoladeverao/services/error_handler_service.dart';
import 'package:escoladeverao/utils/colors_utils.dart';
import 'package:escoladeverao/utils/fonts_utils.dart';
import 'package:escoladeverao/utils/string_utils.dart';
import 'package:escoladeverao/widgets/custom_outlined_button.dart';
import 'package:escoladeverao/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

//verificar por quê não está enviando o telefone

class ProfileEditScreen extends StatefulWidget {
  final String origin;
  final User user;
  final User scannedUser;
  const ProfileEditScreen(
      {Key? key,
      required this.origin,
      required this.scannedUser,
      required this.user})
      : super(key: key);

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final apiService = ApiService();
  late ScrollController _scrollController;
  bool _showAppBar = true;
  bool _isLoading = false;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    initializeControllers();
  }

  void initializeControllers() {
    // Initialize with user data
    nameEditController.text = widget.user.name ?? '';
    emailEditController.text = widget.user.email ?? '';
    phoneEditController.text = widget.user.telefone ?? '';
    linkedinEditController.text = widget.user.linkedin ?? '';
    githubEditController.text = widget.user.github ?? '';
    latesEditController.text = widget.user.lattes ?? '';
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

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      print("Imagem selecionada: ${pickedFile.path}");
    }
  }

  Future<void> _updateProfile() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final updateData = {
        'name': nameEditController.text,
        'email': emailEditController.text,
        'phone': phoneEditController.text,
        'linkedin': linkedinEditController.text,
        'github': githubEditController.text,
        'lattes': latesEditController.text,
      };

      final result = await apiService.updateProfile(
        widget.user.id ?? '',
        updateData,
        imageFile: _selectedImage,
      );

      if (result['success'] == true) {
        // Fetch the updated user data immediately after update
        final updatedUser =
            await apiService.fetchUserById(widget.user.id ?? '');

        if (mounted) {
          Fluttertoast.showToast(
            msg: "Perfil atualizado",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );

          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(user: updatedUser),
              ),
            );
          });
        }
      } else {
        ErrorHandler();
      }
    } catch (e, stackTrace) {
      print('Erro: $e\nStack trace: $stackTrace');
      ErrorHandler();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool _hasUnsavedChanges() {
    return nameEditController.text != widget.user.name ||
        phoneEditController.text != widget.user.telefone ||
        linkedinEditController.text != widget.user.linkedin ||
        latesEditController.text != widget.user.lattes ||
        _selectedImage != null;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true, //Impede a saída direta se houver mudanças não salvas
      onPopInvoked: (didPop) {
        if (didPop) return; // Se a navegação já ocorreu, não faz nada

        if (Navigator.canPop(context)) {
          Navigator.pop(context); // Volta normalmente se houver telas na pilha
        } else {
          // Se não houver telas, redireciona para a tela apropriada
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
                builder: (context) => ProfileScreen(
                  user: widget.user,
                ),
              ),
            );
          }
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
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
                                      scannedUser: widget.scannedUser,
                                    )),
                          );
                        } else if (widget.origin == 'profile') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                      user: widget.user,
                                    )),
                          );
                        } else {
                          Navigator.pop(context); // Fallback para outras telas
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
                // Orange background container
                Container(
                  height: 200.h,
                  color: AppColors.orangePrimary,
                ),

                // White background container with rounded corners
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
                        SizedBox(height: 80.h), // Space for profile image
                        Fonts(
                          text: StringUtils.formatUserName(widget.user.name),
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
                        ),

                        SizedBox(height: 20.h),
                        CustomTextField(
                          labelText: 'Telefone',
                          hintText: 'Edite seu telefone',
                          keyboardType: TextInputType.phone,
                          controller: phoneEditController,
                        ),
                        SizedBox(height: 20.h),
                        CustomTextField(
                          labelText: 'LinkedIn',
                          hintText: 'Edite seu LinkedIn',
                          keyboardType: TextInputType.url,
                          controller: linkedinEditController,
                        ),
                        SizedBox(height: 20.h),
                        CustomTextField(
                          labelText: 'Currículo Lattes',
                          hintText: 'Edite seu Lattes',
                          keyboardType: TextInputType.url,
                          controller: latesEditController,
                        ),
                        SizedBox(height: 22.h),
                        CustomOutlinedButton(
                          text:
                              _isLoading ? 'Salvando...' : 'Salvar alterações ',
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
                            side: const BorderSide(
                                color: AppColors.orangePrimary),
                            backgroundColor: AppColors.orangePrimary,
                          ),
                          onPressed: () {
                            if (!_isLoading) {
                              _updateProfile(); // Apenas chama a função, sem navegar ainda
                            }
                          },
                        ),
                        SizedBox(height: 20.h), // Add some bottom padding
                      ],
                    ),
                  ),
                ),

                // Positioned profile image
                // Replace the existing image widget with this:
                Positioned(
                  top: 120.h - 52.h,
                  left: MediaQuery.of(context).size.width / 2 - 40.h,
                  child: Image.asset('assets/images/profile.png'),
                  // child: EditableProfileImage(
                  //   userId: widget.user.id ?? '',
                  //   selectedImage: _selectedImage,
                  //   onEditTap: _pickImage,
                  //   size: 104.h,
                  // ),
                ),
                // Edit profile image icon
                // Positioned(
                //   top: 120.h + 24.h,
                //   left: MediaQuery.of(context).size.width / 2 + 24.h,
                //   child: GestureDetector(
                //     onTap: _pickImage,
                //     child: Container(
                //       width: 27.h,
                //       height: 27.h,
                //       decoration: const BoxDecoration(
                //         color: AppColors.orangePrimary,
                //         shape: BoxShape.circle,
                //       ),
                //       child: Image.asset('assets/icons/pen_black_icon.png'),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
