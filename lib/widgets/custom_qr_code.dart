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

    final encodedJson = base64Url
        .encode(utf8.encode(jsonData))
        .replaceAll('+', '-')
        .replaceAll('/', '_')
        .replaceAll('=', ''); // Remove "=" para evitar problemas na URL

    return "https://2025.escoladeverao.com.br?q=$encodedJson";
  }

  @override
  Widget build(BuildContext context) {
    final qrData = generateUserData();
    return QrImageView(
      data: qrData,
      version: QrVersions.auto,
      size: 300.0,
      backgroundColor: Colors.white,
      padding: const EdgeInsets.all(20),
    );
  }
}
