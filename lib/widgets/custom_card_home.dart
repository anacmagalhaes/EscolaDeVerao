import 'package:escoladeverao/utils/fonts_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
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
    likesCount = widget.post['likes_count'] ?? 0;
    isLiked = widget.post['is_liked'] ?? false;
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return 'Data desconhecida';
    }

    try {
      DateTime date =
          DateTime.parse(dateString).toLocal(); // Ajusta para o fuso local
      return DateFormat('dd/MM/yyyy - HH:mm')
          .format(date); // Formata para "18/02/2024 14:30"
    } catch (e) {
      print("Erro ao converter data: $e");
      return 'Data inválida';
    }
  }

  @override
  Widget build(BuildContext context) {
    final userName = widget.post['user']?['name'] ?? 'Usuário';
    final postText = widget.post['texto'] ?? '';
    print('Image URL: ${widget.post['imagem']}');

    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
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
                  child: Image.asset('assets/images/orange_simbol.png'),
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
                    color: AppColors.textPrimary),
                if (widget.post['imagem'] != null)
                  Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: GestureDetector(
                        onTap: () {
                          _showFullImage(widget.post['imagem']);
                        },
                        child: Image.network(
                          widget.post['imagem'],
                          width: double.infinity,
                          height: 200.h,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              print(
                                  'Imagem carregada com sucesso: ${widget.post['imagem']}');
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                color: AppColors.orangePrimary,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            print('Erro ao carregar imagem: $error');
                            print('URL que falhou: ${widget.post['imagem']}');
                            return const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.image_not_supported, size: 50),
                                  Text('Não foi possível carregar a imagem'),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // Área de Likes
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Fonts(
                    text: _formatDate(widget.post['created_at']),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryGrey),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showFullImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            onTap: () => Navigator.pop(context), // Fecha ao clicar fora
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.orangeSecond.withOpacity(0.8),
              ),
              padding: EdgeInsets.all(2),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(12), // Define o arredondamento
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  headers: const {
                    'Accept': 'image/*',
                    'ngrok-skip-browser-warning': 'true',
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(
                          12), // Também arredonda a imagem de erro
                      child: Image.asset(
                        'assets/images/profile.png',
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
