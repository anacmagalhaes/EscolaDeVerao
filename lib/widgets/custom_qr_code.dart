import 'dart:convert';

import 'package:escoladeverao/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:escoladeverao/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:escoladeverao/models/user_model.dart';

class CustomQrCode extends StatelessWidget {
  const CustomQrCode({Key? key, required this.user}) : super(key: key);

  final User user;

  String generateSecureUrl() {
    return 'https://2025.escoladeverao.com.br';
  }

  @override
  Widget build(BuildContext context) {
    final qrData = generateSecureUrl();
    return QrImageView(
      data: qrData,
      version: QrVersions.auto,
      size: 300.0,
    );
  }
}
