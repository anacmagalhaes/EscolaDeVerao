import 'dart:convert';

import 'package:escoladeverao/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CustomQrCode extends StatelessWidget {
  const CustomQrCode({Key? key, required this.user}) : super(key: key);

  final User user;

  String generateUserData() {
    final jsonData = jsonEncode({
      "id": user.id,
      "name": user.name,
      "sobrenome": user.sobrenome,
      "email": user.email,
      "cpf": user.cpf,
      "telefone": user.telefone,
      "github": user.github,
      "linkedin": user.linkedin,
      "lattes": user.lattes,
    });

    return "https://2025.escoladeverao.com.br\n$jsonData"; // Link primeiro, depois JSON
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
