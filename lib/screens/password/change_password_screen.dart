import 'package:escoladeverao/screens/modals/checked_modal.dart';
import 'package:escoladeverao/screens/modals/new_password_modal.dart';
import 'package:escoladeverao/services/api_service.dart';
import 'package:escoladeverao/utils/colors_utils.dart';
import 'package:escoladeverao/utils/fonts_utils.dart';
import 'package:escoladeverao/widgets/custom_app_bar.dart';
import 'package:escoladeverao/widgets/custom_outlined_button.dart';
import 'package:escoladeverao/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final ApiService apiService = ApiService();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? passwordError;
  String? confirmPasswordError;

  void _changePassword() async {
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    // Limpa mensagens de erro antes de validar novamente
    setState(() {
      passwordError = null;
      confirmPasswordError = null;
    });

    bool isValid = true;

    // Validações
    if (password.isEmpty || password.length < 6) {
      setState(() {
        passwordError = 'A senha deve ter pelo menos 6 caracteres.';
      });
      isValid = false;
    }
    if (confirmPassword.isEmpty) {
      setState(() {
        confirmPasswordError = 'Por favor, confirme sua senha.';
      });
      isValid = false;
    } else if (confirmPassword != password) {
      setState(() {
        confirmPasswordError = 'As senhas não coincidem.';
      });
      isValid = false;
    }

    if (!isValid) return;

    try {
      final response =
          await apiService.changePassword(password, confirmPassword);

      if (response['success']) {
        // Senha alterada com sucesso: exibir modal
        CheckedModal(context,
            checkedMessage: 'Sua senha foi alterada com sucesso!');
        passwordController.clear();
        confirmPasswordController.clear();
      } else {
        // Se a API retornar erro, exibir mensagem adequada
        setState(() {
          final serverMessage = response['message'] ?? 'Erro desconhecido.';
          passwordError = _mapServerErrorToFriendlyMessage(serverMessage);
        });
      }
    } catch (e) {
      setState(() {
        passwordError = 'Erro ao se conectar ao servidor. Tente novamente.';
      });
    }
  }

  /// Mapeia mensagens de erro da API para mensagens amigáveis
  String _mapServerErrorToFriendlyMessage(String? serverMessage) {
    if (serverMessage == null) return 'Erro desconhecido.';

    final errorMapping = {
      "password_too_short": "A senha deve ter pelo menos 6 caracteres.",
      "password_mismatch": "As senhas informadas não coincidem.",
      "A senha não pode ser a mesma!":
          "A nova senha deve ser diferente da anterior.",
    };

    return errorMapping[serverMessage] ??
        'Erro ao processar a solicitação. Tente novamente.';
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        onBackPressed: () {
          FocusScope.of(context).unfocus();
        },
        fallbackRoute: '/settings_screen',
        backgroundColor: AppColors.background,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Fonts(
                text: 'Alteração de senha',
                maxLines: 2,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              SizedBox(height: 8.h),
              const Fonts(
                text: 'Digite uma nova senha para sua conta.',
                maxLines: 2,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
              ),
              SizedBox(height: 32.h),
              CustomTextField(
                labelText: 'Nova Senha',
                hintText: 'Crie sua nova senha',
                obscureText: true,
                showTogglePasswordIcon: true,
                controller: passwordController,
                isRequired: true,
              ),
              SizedBox(height: 8.h),
              if (passwordError != null)
                Text(
                  passwordError!,
                  style: TextStyle(color: Colors.red, fontSize: 12.sp),
                ),
              SizedBox(height: 16.h),
              CustomTextField(
                labelText: 'Confirme a Senha',
                hintText: 'Digite novamente sua nova senha',
                obscureText: true,
                showTogglePasswordIcon: true,
                controller: confirmPasswordController,
                isRequired: true,
              ),
              SizedBox(height: 8.h),
              if (confirmPasswordError != null)
                Text(
                  confirmPasswordError!,
                  style: TextStyle(color: Colors.red, fontSize: 12.sp),
                ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: CustomOutlinedButton(
                  text: 'Alterar Senha',
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
                    side: const BorderSide(color: AppColors.orangePrimary),
                    backgroundColor: AppColors.orangePrimary,
                  ),
                  onPressed: _changePassword,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
