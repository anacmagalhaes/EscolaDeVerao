import 'package:android_intent_plus/android_intent.dart';
import 'package:escoladeverao/models/user_model.dart';
import 'package:escoladeverao/screens/my_connections_screen.dart';
import 'package:escoladeverao/screens/scan_screen.dart';
import 'package:escoladeverao/utils/colors_utils.dart';
import 'package:escoladeverao/utils/fonts_utils.dart';
import 'package:escoladeverao/widgets/custom_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen(
      {Key? key,
      required this.user,
      required this.scannedUser,
      required this.origin})
      : super(key: key);
  final User user;
  final User scannedUser;
  final String origin;

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Future<void> _launchURL(String? url) async {
    if (url == null || url.isEmpty) {
      debugPrint('URL inválida ou nula.');
      return;
    }

    try {
      // Ensure URL starts with https://
      String formattedUrl = url;
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        formattedUrl = 'https://$url';
      }

      final Uri uri = Uri.parse(formattedUrl);

      // Try launching with platform default browser
      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: '_blank',
      );

      if (!launched) {
        // If external application fails, try launching in app
        final bool inAppLaunched = await launchUrl(
          uri,
          mode: LaunchMode.inAppWebView,
          webViewConfiguration: const WebViewConfiguration(
            enableJavaScript: true,
            enableDomStorage: true,
          ),
        );

        if (!inAppLaunched) {
          throw 'Could not launch $formattedUrl';
        }
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      throw 'Não foi possível abrir o link: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(35.h),
        child: Container(
          width: double.infinity,
          color: AppColors.orangePrimary,
          child: Padding(
            padding: EdgeInsets.only(left: 16.h, right: 10.h, top: 35.h),
            child: Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  switch (widget.origin) {
                    case 'scan':
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ScanScreen(
                                  user: widget.user,
                                )),
                      );
                      break;
                    case 'connections':
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyConnectionsScreen(
                                  user: widget.scannedUser,
                                  scannedUser: widget.scannedUser,
                                  origin: 'connections',
                                )),
                      );
                      break;
                    default:
                      Navigator.pop(context);
                  }
                },
                child: Image.asset('assets/icons/angle-left-white.png'),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 200.h,
              color: AppColors.orangePrimary,
            ),
            Container(
              margin: EdgeInsets.only(top: 55.h),
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.h),
                child: Column(
                  children: [
                    SizedBox(height: 80.h),
                    Fonts(
                      text: widget.scannedUser.name,
                      maxLines: 2,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    SizedBox(height: 8.h),
                    Fonts(
                      text: 'ID: ',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blueMarine,
                      additionalSpans: [
                        TextSpan(
                          text: widget.scannedUser.id.padLeft(4, '0'),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.blueMarine,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Fonts(
                          text: 'Informações de contato:',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        SizedBox(height: 16.h),
                        Container(
                            width: 380.h,
                            height: 300.h,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColors.quaternaryGrey, width: 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 16.h,
                                      left: 16.h,
                                      right: 16.h,
                                    ), // Adicionando padding à direita também
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Fonts(
                                          text: 'E-mail:',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                        ),
                                        Flexible(
                                          child: Fonts(
                                            text: widget.scannedUser.email,
                                            maxLines: 4,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.quintennialGrey,
                                            textAlign: TextAlign
                                                .right, // Alinha o texto à direita
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 16.h, left: 16.h, right: 16.h),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Fonts(
                                          text: 'Telefone:',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                        ),
                                        Flexible(
                                          child: Fonts(
                                            text: widget.scannedUser.telefone,
                                            maxLines: 2,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.quintennialGrey,
                                            textAlign: TextAlign
                                                .right, // Alinha o texto à direita
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  GestureDetector(
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 16.h,
                                            left: 16.h,
                                            right: 16
                                                .h), // Adicionando padding à direita também
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Fonts(
                                              text: 'LinkedIn:',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textPrimary,
                                            ),
                                            Flexible(
                                              child: Fonts(
                                                text:
                                                    widget.scannedUser.linkedin,
                                                maxLines: 4,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.blue,
                                                textAlign: TextAlign
                                                    .right, // Alinha o texto à direita
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationColor: AppColors.blue,
                                              ),
                                            ),
                                          ],
                                        )),
                                    onTap: () async {
                                      try {
                                        await _launchURL(
                                            widget.scannedUser.linkedin);
                                      } catch (e) {
                                        if (mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(e.toString()),
                                              backgroundColor: Colors.red,
                                              duration:
                                                  const Duration(seconds: 3),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                  SizedBox(height: 20.h),
                                  GestureDetector(
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 16.h,
                                            left: 16.h,
                                            right: 16
                                                .h), // Adicionando padding à direita também
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Fonts(
                                              text: 'Github:',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textPrimary,
                                            ),
                                            Flexible(
                                              child: Fonts(
                                                text: widget.scannedUser.github,
                                                maxLines: 4,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.blue,
                                                textAlign: TextAlign.right,
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationColor: AppColors
                                                    .blue, // Alinha o texto à direita
                                              ),
                                            ),
                                          ],
                                        )),
                                    onTap: () {
                                      _launchURL(widget.scannedUser.github!);
                                    },
                                  ),
                                  SizedBox(height: 20.h),
                                  GestureDetector(
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 16.h,
                                            left: 16.h,
                                            right: 16
                                                .h), // Adicionando padding à direita também
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Fonts(
                                              text: 'Currículo Lattes:',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textPrimary,
                                            ),
                                            Flexible(
                                              child: Fonts(
                                                text: widget.scannedUser.lattes,
                                                maxLines: 4,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.blue,
                                                textAlign: TextAlign.right,
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationColor: AppColors
                                                    .blue, // Alinha o texto à direita
                                              ),
                                            ),
                                          ],
                                        )),
                                    onTap: () {
                                      _launchURL(widget.scannedUser.lattes!);
                                    },
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      width: double.maxFinite,
                      child: CustomOutlinedButton(
                          text: 'Salvar Contato',
                          height: 56.h,
                          buttonFonts: const Fonts(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.background,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          buttonStyle: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                color: AppColors.orangePrimary),
                            backgroundColor: AppColors.orangePrimary,
                          ),
                          onPressed: () async {
                            final AndroidIntent intent = AndroidIntent(
                              action: 'android.intent.action.INSERT',
                              type: 'vnd.android.cursor.dir/contact',
                              arguments: <String, dynamic>{
                                // Use `arguments` ao invés de `extras`
                                'name': widget.scannedUser.name,
                                'phone': widget.scannedUser.telefone,
                              },
                            );
                            try {
                              await intent.launch();
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Não foi possível adicionar o contato.')),
                              );
                            }
                          }),
                    ),
                    SizedBox(height: 20.h), // Add some bottom padding
                  ],
                ),
              ),
            ),
            Positioned(
              top: 65.h - 52.h,
              left: MediaQuery.of(context).size.width / 2 - 52.h,
              child: SizedBox(
                width: 104.h,
                height: 104.h,
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/profile.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
