import 'package:escoladeverao/controllers/posts_controllers.dart';
import 'package:escoladeverao/models/user_model.dart';
import 'package:escoladeverao/screens/modals/checked_modal.dart';
import 'package:escoladeverao/screens/modals/error_modal.dart';
import 'package:escoladeverao/services/api_service.dart';
import 'package:escoladeverao/widgets/custom_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:escoladeverao/utils/colors_utils.dart';
import 'package:escoladeverao/utils/fonts_utils.dart';

class PostsScreen extends StatefulWidget {
  final User user;
  const PostsScreen({Key? key, required this.user}) : super(key: key);

  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    postsController = TextEditingController();
  }

  Future<void> _handlePost() async {
    String? token = await apiService.getToken();
    String content = postsController.text.trim();

    if (token == null) {
      print('Erro: Token não encontrado. Usuário não autenticado.');
      return;
    }

    if (content.isNotEmpty) {
      try {
        // Chama a função da API e captura a resposta
        var response = await apiService.createPost(content, token);

        if (response['success'] == true) {
          // Exibe a mensagem da API no modal de sucesso
          CheckedModal(context, checkedMessage: response['message']);
        } else {
          ErrorModal(context,
              errorMessage: response['message'], title: 'Erro ao criar o post');
          print("Erro ao criar o post: ${response['message']}");
        }
      } catch (e) {
        print("Erro ao criar o post: $e");
      }
    } else {
      ErrorModal(context,
          errorMessage: 'O campo de texto está vazio!',
          title: 'Erro ao criar o post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.background,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.only(
              left: 24.h,
              top: 31.5.h,
              right: 24.h,
              bottom:
                  MediaQuery.of(context).viewInsets.bottom, // Ajuste dinâmico
            ),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(), // Garante rolagem suave
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 56.h,
                        height: 56.h,
                        child: Image.asset('assets/images/person.png'),
                      ),
                      Fonts(
                        text: widget.user.name,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context), // Fecha o Dialog
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
                        maxHeight: 200.h // Limita altura do campo
                        ),
                    child: Container(
                      width: 332.h,
                      decoration: BoxDecoration(
                        color: AppColors.sextennialGrey.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: postsController,
                        expands: true,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          hintText: 'Escreva aqui sua mensagem',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        child: Container(
                          height: 40.h,
                          width: 157.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.orange)),
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.h, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset('assets/icons/gallery-icon.png'),
                                Fonts(
                                    text: 'Adicionar mídia',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.orangePrimary)
                              ],
                            ),
                          ),
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Fonts(
                      text: 'Suporta apenas arquivos .jpg e .png',
                      maxLines: 3,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.septuanaryGrey),
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
                                color: AppColors.background),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            buttonStyle: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: AppColors.orangePrimary),
                                backgroundColor: AppColors.orangePrimary),
                            onPressed: () {
                              _handlePost();
                            },
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
                                color: AppColors.textPrimary),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            buttonStyle: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: AppColors.textPrimary),
                                backgroundColor: AppColors.background),
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
