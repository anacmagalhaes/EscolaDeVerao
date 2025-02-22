import 'dart:convert';

import 'package:escoladeverao/models/user_model.dart';
import 'package:escoladeverao/modals/error_modal.dart';
import 'package:escoladeverao/screens/profile/user_profile_screen.dart';
import 'package:escoladeverao/services/api_service.dart';
import 'package:escoladeverao/services/error_handler_service.dart';
import 'package:escoladeverao/utils/colors_utils.dart';
import 'package:escoladeverao/utils/fonts_utils.dart';
import 'package:escoladeverao/widgets/custom_bottom_navigation.dart';
import 'package:escoladeverao/widgets/custom_screen_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  int _currentIndex = 2;
  bool _isProcessing = false;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index != 2) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return getScreenFromIndex(index, widget.user);
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = 0.0;
            const end = 1.0;
            const curve = Curves.easeInOut;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var fadeAnimation = animation.drive(tween);

            return FadeTransition(opacity: fadeAnimation, child: child);
          },
        ),
      );
    }
  }

  Future<Map<String, dynamic>?> processQRCode(String qrData) async {
    try {
      if (qrData.trim().isEmpty) {
        throw FormatException("O QR Code está vazio.");
      }

      String cleanedRawValue = qrData.trim();
      Map<String, dynamic>? userData;

      if (cleanedRawValue.startsWith('{')) {
        // Caso seja JSON puro
        userData = jsonDecode(cleanedRawValue);
      } else {
        // Caso seja uma URL com parâmetro 'q'
        Uri? uri = Uri.tryParse(cleanedRawValue);
        if (uri != null && uri.hasQuery) {
          String? jsonPart = uri.queryParameters['q'];
          if (jsonPart != null) {
            // Ajusta o padding do Base64 se necessário
            int mod4 = jsonPart.length % 4;
            if (mod4 > 0) {
              jsonPart += '=' * (4 - mod4);
            }

            try {
              // Tenta decodificar como Base64 primeiro
              String decodedString = utf8.decode(base64Url.decode(jsonPart));
              userData = jsonDecode(decodedString);
            } catch (e) {
              // Se falhar, tenta decodificar como URI encoded
              final decodedJson = Uri.decodeFull(jsonPart);
              userData = jsonDecode(decodedJson);
            }
          }
        }
      }

      return userData;
    } catch (e) {
      print("❌ Erro ao processar o QR Code: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigation(
        onTap: _onItemTapped,
        currentIndex: _currentIndex,
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: Container(
          width: double.maxFinite,
          color: AppColors.orangePrimary,
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColors.orangePrimary,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.only(top: 30.h),
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 33.h, right: 33.h, top: 60.h, bottom: 30.h),
                      child: const Fonts(
                        text: 'Leia o QR Code para se conectar',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Container(
                    width: 250.h,
                    height: 250.h,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.black,
                    ),
                    child: MobileScanner(
                      onDetect: (capture) async {
                        if (_isProcessing) return;

                        setState(() {
                          _isProcessing = true;
                        });

                        try {
                          final List<Barcode> barcodes = capture.barcodes;

                          if (barcodes.isNotEmpty) {
                            final barcode = barcodes.first;
                            final String? rawValue = barcode.rawValue;

                            if (rawValue != null) {
                              final userData = await processQRCode(rawValue);

                              if (userData != null) {
                                final scannedUser = User(
                                  id: userData['id'],
                                  name: userData['name'],
                                  sobrenome: userData['sobrenome'],
                                  email: userData['email'],
                                  cpf: userData['cpf'],
                                  telefone: userData['telefone'],
                                  github: userData['github'],
                                  linkedin: userData['linkedin'],
                                  lattes: userData['lattes'],
                                  roles: [],
                                );

                                final apiService = ApiService();
                                final result = await apiService.saveConnection(
                                    widget.user.id, scannedUser.id);

                                if (result['success']) {
                                  if (mounted) {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UserProfileScreen(
                                          user: widget.user,
                                          scannedUser: scannedUser,
                                          origin: 'user_profile',
                                        ),
                                      ),
                                    );
                                  }
                                } else {
                                  if (mounted) {
                                    if (result['needsReauth'] == true) {
                                      Navigator.of(context)
                                          .pushReplacementNamed('/login');
                                    }
                                    ErrorHandler();
                                  }
                                }
                              } else {
                                if (mounted) {
                                  ErrorHandler();
                                }
                              }
                            }
                          }
                        } catch (e) {
                          print("Erro ao escanear QR Code: $e");
                          if (mounted) {
                            ErrorHandler();
                          }
                        } finally {
                          setState(() {
                            _isProcessing = false;
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Center(
                    child: Container(
                      width: 285.h,
                      height: 75.h,
                      decoration: BoxDecoration(
                        color: AppColors.orangePrimary.withOpacity(0.7),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(left: 16.h, right: 16.h),
                          child: Fonts(
                            text:
                                'O QR Code será detectado automaticamente quando você posicioná-lo entre as linhas guias',
                            textAlign: TextAlign.center,
                            maxLines: 4,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textPrimary.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
