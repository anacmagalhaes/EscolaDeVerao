import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:escoladeverao/controllers/posts_controllers.dart';
import 'package:escoladeverao/models/user_model.dart';
import 'package:escoladeverao/screens/home/home_screen.dart';
import 'package:escoladeverao/screens/modals/checked_modal.dart';
import 'package:escoladeverao/screens/modals/error_modal.dart';
import 'package:escoladeverao/services/api_service.dart';
import 'package:escoladeverao/widgets/custom_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:escoladeverao/utils/colors_utils.dart';
import 'package:escoladeverao/utils/fonts_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PostsScreen extends StatefulWidget {
  final User user;
  const PostsScreen({Key? key, required this.user}) : super(key: key);

  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  ApiService apiService = ApiService();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  String? _imageName;
  String? _imageSize;

  @override
  void initState() {
    super.initState();
    postsController = TextEditingController();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final File file = File(image.path);
      final int fileSize = await file.length();
      final String size = '${(fileSize / 1024).round()}kb';

      setState(() {
        _selectedImage = file;
        _imageName = image.name;
        _imageSize = size;
      });
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _imageName = null;
      _imageSize = null;
    });
  }

  Future<void> _handlePost() async {
    String? token = await apiService.getToken();
    String content = postsController.text.trim();
    String userId = widget.user.id;

    if (token == null) {
      print('Erro: Token não encontrado. Usuário não autenticado.');
      return;
    }

    if (content.isNotEmpty || _selectedImage != null) {
      try {
        var response = await apiService.createPost(
          content: content,
          token: token,
          userId: userId,
          imageFile: _selectedImage,
        );

        if (response['success'] == true) {
          Fluttertoast.showToast(
            msg: response['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.greenAccent,
            textColor: Colors.white,
          );

          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(user: widget.user),
              ),
            );
          });
        } else {
          Fluttertoast.showToast(
            msg: "${response['message']}. Tente novamente!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } catch (e) {
        print("Erro ao criar o post: $e");
      }
    } else {
      ErrorModal(context,
          errorMessage: 'Adicione um texto ou uma imagem!',
          title: 'Erro ao criar o post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(20.h),
      backgroundColor: AppColors.background,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.only(
              left: 24.h,
              top: 31.5.h,
              right: 24.h,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56.h,
                        height: 56.h,
                        child: Image.asset('assets/images/profile.png'),
                      ),
                      SizedBox(width: 10.h),
                      Fonts(
                        text: widget.user.name,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      SizedBox(width: 50.h),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 27.h),
                          child:
                              Image.asset('assets/icons/close-black-icon.png'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 200.h,
                      maxWidth: 320.h,
                    ),
                    child: Container(
                      width: 300.h,
                      decoration: BoxDecoration(
                          color: Color(0xFFF3F3F3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Color(0xFFB4B7C9))),
                      child: TextField(
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textPrimary,
                          fontFamily: 'Montserrat',
                        ),
                        controller: postsController,
                        expands: true,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          hintText: 'Escreva sua mensagem aqui',
                          hintStyle: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w400),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 60.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.orangePrimary),
                        color: AppColors.background,
                      ),
                      child: _selectedImage == null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/icons/gallery-icon.png',
                                    height: 24.h),
                                SizedBox(width: 8.h),
                                Fonts(
                                  text: 'Adicionar mídia',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.orangePrimary,
                                ),
                              ],
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.h, vertical: 8.h),
                              child: Row(
                                children: [
                                  // Miniatura da imagem
                                  Container(
                                    width: 40.h,
                                    height: 40.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: FileImage(_selectedImage!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.h),
                                  // Nome e tamanho do arquivo
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Fonts(
                                          text: _imageName ?? '',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textPrimary,
                                        ),
                                        SizedBox(height: 2.h),
                                        Fonts(
                                          text: _imageSize ?? '',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.septuanaryGrey,
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Ícone de remoção
                                  GestureDetector(
                                    onTap: _removeImage,
                                    child: Icon(Icons.close,
                                        color: AppColors.textPrimary),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Fonts(
                    text: 'Suporta apenas arquivos .jpg e .png',
                    maxLines: 3,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.septuanaryGrey,
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomOutlinedButton(
                            text: 'Enviar',
                            height: 50.h,
                            buttonFonts: const Fonts(
                              fontSize: 14,
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
                            onPressed: _handlePost,
                          ),
                        ),
                        SizedBox(width: 16.h),
                        Expanded(
                          child: CustomOutlinedButton(
                            text: 'Cancelar',
                            height: 50.h,
                            buttonFonts: const Fonts(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            buttonStyle: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  color: AppColors.textPrimary),
                              backgroundColor: AppColors.background,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/home_screen');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
