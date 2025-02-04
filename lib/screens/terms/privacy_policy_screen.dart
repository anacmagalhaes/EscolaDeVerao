import 'package:escoladeverao/models/user_model.dart';
import 'package:escoladeverao/screens/settings_screen.dart';
import 'package:escoladeverao/utils/colors_utils.dart';
import 'package:escoladeverao/utils/fonts_utils.dart';
import 'package:escoladeverao/widgets/custom_app_bar_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  final User user;
  final User scannedUser;
  const PrivacyPolicyScreen(
      {Key? key, required this.scannedUser, required this.user})
      : super(key: key);

  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          CustomAppBarError(
              onBackPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(
                        user: widget.user, scannedUser: widget.scannedUser),
                  ),
                );
              },
              leadingIcon: Image.asset('assets/icons/angle-left-orange.png')),
        ],
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(left: 23.h, right: 25.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Fonts(
                        text: 'Política de Privacidade',
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary),
                    SizedBox(height: 15.85.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Fonts(
                            text: '1. Coleta de Informações',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary),
                        SizedBox(height: 6.85.h),
                        const Fonts(
                            text:
                                'O aplicativo coleta as seguintes informações dos usuários: ',
                            maxLines: 10,
                            textAlign: TextAlign.justify,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textPrimary),
                        SizedBox(height: 10.h),
                        Padding(
                          padding: EdgeInsets.only(left: 10.h),
                          child: Column(
                            children: [
                              const Fonts(
                                text: '- Informações de Cadastro: ',
                                maxLines: 10,
                                textAlign: TextAlign.justify,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                                additionalSpans: [
                                  TextSpan(
                                    text:
                                        'Nome, e-mail, senha, número de telefone e outros dados fornecidos durante o registro.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              const Fonts(
                                text: '- Dados de uso: ',
                                maxLines: 10,
                                textAlign: TextAlign.justify,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                                additionalSpans: [
                                  TextSpan(
                                    text:
                                        'Informações relacionadas ao uso do aplicativo, como data e hora de acesso e interações com o feed',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              const Fonts(
                                text: '- Informações de Dispositivo: ',
                                maxLines: 10,
                                textAlign: TextAlign.justify,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                                additionalSpans: [
                                  TextSpan(
                                    text:
                                        'Tipo de dispositivo, sistema operacional e identificadores exclusivos, como endereços IP.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15.85.h),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Fonts(
                            text: '2. Uso das Informações',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary),
                        SizedBox(height: 6.85.h),
                        const Fonts(
                            text: 'As informações coletadas são usadas para:',
                            maxLines: 10,
                            textAlign: TextAlign.justify,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textPrimary),
                        SizedBox(height: 10.h),
                        Padding(
                          padding: EdgeInsets.only(left: 10.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Fonts(
                                text:
                                    '- Permitir login, cadastro e acesso a câmera, galeria e feed; ',
                                maxLines: 10,
                                textAlign: TextAlign.justify,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textPrimary,
                              ),
                              SizedBox(height: 10.h),
                              const Fonts(
                                text:
                                    '- Melhorar a experiência do usuário e a funcionalidade do aplicativo; ',
                                maxLines: 10,
                                textAlign: TextAlign.justify,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textPrimary,
                              ),
                              SizedBox(height: 10.h),
                              const Fonts(
                                text:
                                    '- Garantir a segurança dos dados e prevenir fraudes; ',
                                maxLines: 10,
                                textAlign: TextAlign.justify,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textPrimary,
                              ),
                              SizedBox(height: 10.h),
                              const Fonts(
                                text:
                                    '- Comunicar atualizações ou mudanças nos serviços. ',
                                maxLines: 10,
                                textAlign: TextAlign.justify,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textPrimary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.85.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Fonts(
                            text: '3. Compartilhamento de Informações',
                            maxLines: 10,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary),
                        SizedBox(height: 6.85.h),
                        const Fonts(
                            text:
                                'Não compartilhamos informações pessoais dos usuários com terceiros, exceto em caso de:',
                            maxLines: 10,
                            textAlign: TextAlign.justify,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textPrimary),
                        SizedBox(height: 10.h),
                        Padding(
                          padding: EdgeInsets.only(left: 10.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Fonts(
                                text:
                                    '- Permitir login, cadastro e acesso a câmera, galeria e feed; ',
                                maxLines: 10,
                                textAlign: TextAlign.justify,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textPrimary,
                              ),
                              SizedBox(height: 10.h),
                              const Fonts(
                                text:
                                    '- Cumprimento de exigências legais ou regulatórias; ',
                                maxLines: 10,
                                textAlign: TextAlign.justify,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textPrimary,
                              ),
                              SizedBox(height: 10.h),
                              const Fonts(
                                text:
                                    '- Necessidade de proteger direitos ou propriedades do aplicativo. ',
                                maxLines: 10,
                                textAlign: TextAlign.justify,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textPrimary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.85.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Fonts(
                            text: '4. Armazenamento e Proteção de Dados',
                            maxLines: 10,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary),
                        SizedBox(height: 6.85.h),
                        const Fonts(
                            text:
                                'Os dados coletados são armazenados de forma segura, utilizando criptografia e outras medidas de segurança apropriadas.',
                            maxLines: 10,
                            textAlign: TextAlign.justify,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textPrimary),
                      ],
                    ),
                    SizedBox(height: 15.85.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Fonts(
                            text: '5. Direitos dos Usuários',
                            maxLines: 10,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary),
                        SizedBox(height: 6.85.h),
                        const Fonts(
                            text:
                                'Os usuários têm o direito de acessar, corrigir ou excluir suas informações pessoais. Para exercer esses direitos, entre em contato conosco através do e-mail [seu-email@dominio.com].',
                            maxLines: 10,
                            textAlign: TextAlign.justify,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textPrimary),
                      ],
                    ),
                    SizedBox(height: 15.85.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Fonts(
                            text: '6. Alterações na Política de Privacidade',
                            maxLines: 10,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary),
                        SizedBox(height: 6.85.h),
                        const Fonts(
                            text:
                                'Podemos atualizar esta política periodicamente. Notificaremos os usuários sobre mudanças significativas.',
                            maxLines: 10,
                            textAlign: TextAlign.justify,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textPrimary),
                        SizedBox(height: 15.h),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
