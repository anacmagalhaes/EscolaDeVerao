import 'dart:convert';

import 'package:escoladeverao/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CustomQrCode extends StatelessWidget {
  const CustomQrCode({Key? key, required this.user}) : super(key: key);

  final User user;

  String _generateUserData() {
    // Criando um Map com os dados do usuário
    final userData = {
      'id': user.id,
      'name': user.name,
      'sobrenome': user.sobrenome,
      'email': user.email,
      'phone': user.phone,
      'github': user.github,
      'linkedin': user.linkedin,
      'lattes': user.lattes,
    };

    // Convertendo para JSON
    final jsonData = jsonEncode(userData);
    return 'escoladeverao://app/user?data=$jsonData';
  }

  @override
  Widget build(BuildContext context) {
    return QrImageView(
        data: _generateUserData(), version: QrVersions.auto, size: 300.0);
  }
}
