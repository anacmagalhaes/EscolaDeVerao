import 'package:escoladeverao/utils/colors_utils.dart';
import 'package:escoladeverao/utils/fonts_utils.dart';
import 'package:escoladeverao/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCardConnections extends StatelessWidget {
  final Connection connection;

  CustomCardConnections({required this.connection});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(color: Color(0xFFE8E8E8), width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: connection.imageUrl != null &&
                      connection.imageUrl!.isNotEmpty
                  ? Image.network(
                      connection.imageUrl!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      headers: const {
                        'Accept': 'image/*',
                        'ngrok-skip-browser-warning': 'true',
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColors.orangePrimary,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        print('Erro ao carregar imagem: $error');
                        return Image.asset(
                          'assets/images/profile.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      'assets/images/profile.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
            ),
            SizedBox(height: 8.0),
            Fonts(
              text: StringUtils.formatUserName(connection.name),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.0),
            Fonts(
              text: 'ID: ',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.blueMarine,
              additionalSpans: [
                TextSpan(
                  text: connection.id.padLeft(4, '0'),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.blueMarine,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Connection {
  final String? imageUrl;
  final String name;
  final String id;

  Connection({
    this.imageUrl,
    required this.name,
    required this.id,
  });
}
