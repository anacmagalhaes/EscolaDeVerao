import 'package:escoladeverao/controllers/sign_up_controllers.dart';
import 'package:flutter/material.dart';
import 'package:escoladeverao/controllers/password_controller.dart';
import 'package:escoladeverao/modals/new_password_modal.dart';
import 'package:escoladeverao/services/api_service.dart';
import 'package:escoladeverao/utils/colors_utils.dart';
import 'package:escoladeverao/utils/fonts_utils.dart';
import 'package:escoladeverao/widgets/custom_app_bar.dart';
import 'package:escoladeverao/widgets/custom_outlined_button.dart';
import 'package:escoladeverao/widgets/custom_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordScreen extends StatefulWidget {
  final String origin;
  const PasswordScreen({Key? key, required this.origin}) : super(key: key);

  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final ApiService apiService = ApiService();

  String? cpfError;
  String? emailError;

  // Validação para formato de e-mail
  bool isValidEmail(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool isValidCPF(String cpf) {
    cpf = cpf.replaceAll(RegExp(r'\D'), '');
    if (cpf.length != 11 || RegExp(r'^(\d)\1*$').hasMatch(cpf)) {
      return false;
    }

    List<int> numbers = cpf.split('').map((e) => int.parse(e)).toList();

    for (int j = 9; j < 11; j++) {
      int sum = 0;
      for (int i = 0; i < j; i++) {
        sum += numbers[i] * ((j + 1) - i);
      }
      int digit = (sum * 10) % 11;
      if (digit == 10) digit = 0;
      if (digit != numbers[j]) return false;
    }

    return true;
  }

  void _recoverPassword() async {
    final cpf = cpfPassController.text.trim().replaceAll(RegExp(r'\D'), '');

    final email = emailPassController.text.trim();

    print('CPF digitado: $cpf');
    print('E-mail digitado: $email');

    // Limpar mensagens de erro antes de validar novamente
    setState(() {
      cpfError = null;
      emailError = null;
    });

    bool hasError = false;

    // Validações dos campos
    if (cpf.isEmpty) {
      setState(() {
        cpfError = 'Por favor, insira o CPF.';
      });
      hasError = true;
    } else if (!isValidCPF(cpf)) {
      setState(() {
        cpfError = 'Por favor, insira um CPF válido.';
      });
      hasError = true;
    }

    if (email.isEmpty) {
      setState(() {
        emailError = 'Por favor, insira o e-mail.';
      });
      hasError = true;
    } else if (!isValidEmail(email)) {
      setState(() {
        emailError = 'Por favor, insira um e-mail válido.';
      });
      hasError = true;
    }

    if (hasError) return;

    try {
      final response = await apiService.resetPasswordWithCpfEmail(cpf, email);

      if (response['success']) {
        // Sucesso: exibir modal e limpar campos
        NewPasswordModal(context, email);
        setState(() {
          cpfPassController.clear();
          emailPassController.clear();
        });
      } else {
        // Erro: tratar mensagem retornada pela API
        setState(() {
          final serverMessage =
              response['data']?['email']?.first ?? response['message'];

          // Mapeamento de mensagens para mensagens amigáveis
          emailError = _mapServerErrorToFriendlyMessage(serverMessage);
        });
      }
    } catch (e) {
      // Erro inesperado (problemas de conexão, etc.)
      setState(() {
        emailError = 'Erro ao se conectar ao servidor. Tente novamente.';
      });
    }
  }

  /// Mapeia mensagens de erro do servidor para mensagens amigáveis
  String _mapServerErrorToFriendlyMessage(String? serverMessage) {
    if (serverMessage == null) return 'Erro desconhecido. Tente novamente.';

    final errorMapping = {
      "O campo email selecionado é inválido.": "E-mail inválido.",
      "O campo cpf selecionado é inválido.": "CPF inválido.",
      // Adicione outros mapeamentos de mensagens conforme necessário
    };

    return errorMapping[serverMessage] ??
        'Erro ao processar a solicitação. Tente novamente.';
  }

  @override
  void dispose() {
    // Limpar os campos ao sair da tela
    cpfPassController.clear();
    emailPassController.clear();
    cpfPassController.dispose();
    emailPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar(
          onBackPressed: () {
            FocusScope.of(context).unfocus();
          },
          fallbackRoute: '/login_screen',
          backgroundColor: AppColors.background,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Fonts(
                    text: 'Recuperação de senha',
                    maxLines: 2,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary),
                SizedBox(height: 8.h),
                const Fonts(
                    text: 'Informe o e-mail cadastrado para recuperação',
                    maxLines: 2,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimary),
                SizedBox(height: 32.h),
                CustomTextField(
                  labelText: 'E-mail',
                  hintText: 'Digite seu e-mail',
                  keyboardType: TextInputType.emailAddress,
                  controller: emailPassController,
                ),
                if (emailError != null)
                  Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(
                      emailError!,
                      style: TextStyle(color: Colors.red, fontSize: 12.sp),
                    ),
                  ),
                SizedBox(height: 16.h),
                CustomTextField(
                  labelText: 'CPF',
                  hintText: 'Digite seu CPF',
                  keyboardType: TextInputType.number,
                  controller: cpfPassController,
                ),
                if (cpfError != null)
                  Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(
                      cpfError!,
                      style: TextStyle(color: Colors.red, fontSize: 12.sp),
                    ),
                  ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomOutlinedButton(
                          text: 'Recuperar senha',
                          height: 56.h,
                          buttonFonts: const Fonts(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.background),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          buttonStyle: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  color: AppColors.orangePrimary),
                              backgroundColor: AppColors.orangePrimary),
                          onPressed: _recoverPassword,
                        ),
                      ),
                      SizedBox(width: 16.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
