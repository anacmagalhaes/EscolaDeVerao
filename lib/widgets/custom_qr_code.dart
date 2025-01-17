import 'dart:convert';

import 'package:escoladeverao/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CustomQrCode extends StatelessWidget {
  const CustomQrCode({Key? key, required this.user}) : super(key: key);

  final User user;

  String generateUserData() {
    // Mantendo exatamente os mesmos campos e valores da API
    final Map<String, dynamic> userData = {
      'id': user.id,
      'name': user.name,
      'sobrenome': user.sobrenome,
      'email': user.email,
      'cpf': user.cpf,
      'telefone': user.telefone,
      'github': user.github,
      'linkedin': user.linkedin,
      'lattes': user.lattes,
    };

    print('Dados do usuário para QR code: $userData');
    return jsonEncode(userData);
  }

  @override
  Widget build(BuildContext context) {
    final qrData = generateUserData();
    print('QR Code data: $qrData');
    return QrImageView(
      data: qrData, // Gera o texto formatado
      version: QrVersions.auto,
      size: 300.0,
    );
  }
}
