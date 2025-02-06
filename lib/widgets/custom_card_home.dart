import 'package:escoladeverao/utils/fonts_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/colors_utils.dart';
import 'package:escoladeverao/services/api_service.dart';

enum CardType { imageOnly, imageAndText, textOnly }

class CustomCardHome extends StatefulWidget {
  final dynamic post;
  final CardType cardType;
  final String? title;
  final String? imagePath;

  const CustomCardHome({
    super.key,
    required this.post,
    this.cardType = CardType.imageAndText,
    this.title,
    this.imagePath,
  });

  @override
  _CustomCardHomeState createState() => _CustomCardHomeState();
}

class _CustomCardHomeState extends State<CustomCardHome> {
  bool isLiked = false; // Para controlar se o post está curtido ou não
  int likesCount = 0; // Contagem de likes

  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    // Inicializa a contagem de likes e o estado do like
    likesCount = widget.post['likes_count'] ?? 0;
    isLiked =
        widget.post['is_liked'] ?? false; // Determina se o post já foi curtido
  }

  Future<void> _toggleLike() async {
    String? token = await apiService.getToken();
    String postId = widget.post['id'].toString();

    if (token == null) {
      print('Erro: Token não encontrado. Usuário não autenticado.');
      return;
    }

    try {
      // Envia a requisição para a API
      var response = await apiService.likePost(postId, token);

      // Se o like foi alternado com sucesso, atualiza a interface
      if (response['success'] == true) {
        setState(() {
          isLiked = !isLiked;
          likesCount = isLiked ? likesCount + 1 : likesCount - 1;
        });

        print(response['message']);
      } else {
        print('Erro ao registrar o like: ${response['message']}');
      }
    } catch (e) {
      print('Erro ao dar like: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userName = widget.post['user']?['name'] ?? 'Usuário';
    final postText = widget.post['texto'] ?? '';

    return Card(
      margin: const EdgeInsets.all(16),
      color: AppColors.background,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: AppColors.quaternaryGrey.withOpacity(0.2))),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Image.asset('assets/images/person.png'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 14.45.h),
                    child: Fonts(
                        text: userName,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black),
                  ),
                ),
              ],
            ),
            // Descrição do post
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 22.91.h),
                Fonts(
                    text: postText,
                    maxLines: 20,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimary)
              ],
            ),
            // Área de Likes
            Column(
              children: [
                SizedBox(height: 22.91.h),
                Row(
                  children: [
                    GestureDetector(
                      onTap: _toggleLike, // Altera o estado do like
                      child: Image.asset(
                        isLiked
                            ? 'assets/icons/like-red-icon.png' // Ícone preenchido
                            : 'assets/icons/like-black-icon.png', // Ícone vazio
                        width: 24.h,
                        height: 24.h,
                      ),
                    ),
                    SizedBox(width: 8.h),
                    Fonts(
                      text: '$likesCount likes',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textPrimary,
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
