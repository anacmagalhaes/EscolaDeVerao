import 'package:escoladeverao/controllers/login_controllers.dart';
import 'package:escoladeverao/models/user_model.dart';
import 'package:escoladeverao/screens/home/home_screen.dart';
import 'package:escoladeverao/services/api_service.dart';
import 'package:escoladeverao/utils/colors.dart';
import 'package:escoladeverao/utils/fonts.dart';
import 'package:escoladeverao/widgets/custom_app_bar.dart';
import 'package:escoladeverao/widgets/custom_outlined_button.dart';
import 'package:escoladeverao/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isChecked = false;
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  // Variáveis de erro
  String _emailError = '';
  String _passwordError = '';

  @override
  void initState() {
    super.initState();
    _checkSavedLogin();

    // Limpando os erros ao digitar nos campos
    emailInput.addListener(() {
      if (_emailError.isNotEmpty) {
        setState(() {
          _emailError = '';
        });
      }
    });

    passwordInput.addListener(() {
      if (_passwordError.isNotEmpty) {
        setState(() {
          _passwordError = '';
        });
      }
    });
  }

  Future<void> _checkSavedLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberLogin = prefs.getBool('remember_login') ?? false;
    final savedEmail = prefs.getString('saved_email');
    final savedPassword = prefs.getString('saved_password');

    if (rememberLogin && savedEmail != null && savedPassword != null) {
      setState(() {
        emailInput.text = savedEmail;
        passwordInput.text = savedPassword;
        _isChecked = true;
      });

      // Opcional: fazer login automático
      await _login();
    }
  }

  @override
  void dispose() {
    _apiService.dispose(); // Adicionado para fechar o cliente HTTP
    emailInput.dispose();
    passwordInput.dispose();
    super.dispose();
  }

  // Validação básica de email
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Traduz os erros da API para mensagens amigáveis
  String _getLoginErrorMessage(String apiError) {
    // Mapeamento de erros comuns da API para mensagens amigáveis
    switch (apiError.toLowerCase()) {
      case 'invalid_credentials':
      case 'incorrect password':
      case 'user not found':
        return 'E-mail ou senha incorretos';
      case 'user_inactive':
        return 'Sua conta está inativa. Entre em contato com o suporte';
      case 'too_many_attempts':
        return 'Muitas tentativas de login. Tente novamente mais tarde';
      default:
        return 'Não foi possível fazer login. Verifique suas credenciais e tente novamente.';
    }
  }

  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user_id', user.id);
    prefs.setString('user_name', user.name);
  }

// In login_screen.dart, modify the _login method:
  Future<void> _login() async {
    setState(() {
      _emailError = '';
      _passwordError = '';
      _isLoading = true;
    });

    final email = emailInput.text.trim();
    final password = passwordInput.text;

    if (email.isEmpty) {
      setState(() {
        _emailError = 'O campo e-mail é obrigatório';
        _isLoading = false;
      });
      return;
    }

    if (!_isValidEmail(email)) {
      setState(() {
        _emailError = 'Digite um e-mail válido';
        _isLoading = false;
      });
      return;
    }

    if (password.isEmpty) {
      setState(() {
        _passwordError = 'O campo senha é obrigatório';
        _isLoading = false;
      });
      return;
    }

    try {
      final result = await _apiService.login(email, password);

      if (result != null &&
          result is Map<String, dynamic> &&
          result['success'] == true) {
        final userData = result['data']['data']['user'];
        if (userData != null) {
          final user = User(
            id: userData['id']?.toString() ?? '',
            name: userData['name'] ?? '',
          );

          // Salvar usuário e estado de login nas preferências
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_id', user.id);
          await prefs.setString('user_name', user.name);

          // Salvar estado do checkbox "Lembrar senha"
          if (_isChecked) {
            await prefs.setBool('remember_login', true);
            // Opcional: salvar credenciais de forma segura
            await prefs.setString('saved_email', email);
            // Nota: em produção, considere usar flutter_secure_storage para a senha
            await prefs.setString('saved_password', password);
          }

          if (!mounted) return;

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(user: user),
              settings: RouteSettings(arguments: user),
            ),
            (route) => false,
          );
        } else {
          throw Exception('Dados do usuário não encontrados na resposta');
        }
      } else {
        setState(() {
          _passwordError = _getLoginErrorMessage(result['message'] ?? '');
        });
      }
    } catch (e) {
      setState(() {
        _passwordError =
            'Erro ao conectar ao servidor. Verifique sua conexão e tente novamente.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        onBackPressed: () {
          FocusScope.of(context).unfocus();
          Navigator.pop(context);
        },
        fallbackRoute: '/sign_in_or_sign_up_screen',
        backgroundColor: AppColors.background,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Fonts(
                  text: 'Acessar',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary),
              SizedBox(height: 8.h),
              const Fonts(
                  text: 'Com e-mail e senha para entrar',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textPrimary),
              SizedBox(height: 40.h),
              CustomTextField(
                labelText: 'E-mail',
                hintText: 'Digite seu e-mail',
                keyboardType: TextInputType.emailAddress,
                controller: emailInput,
                errorText: _emailError.isNotEmpty ? _emailError : null,
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                controller: passwordInput,
                labelText: 'Senha',
                hintText: 'Digite sua senha',
                obscureText: true,
                showTogglePasswordIcon: true,
                errorText: _passwordError.isNotEmpty ? _passwordError : null,
              ),
              SizedBox(height: 18.h),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isChecked = !_isChecked;
                      });
                    },
                    child: Container(
                      width: 24.h,
                      height: 24.h,
                      decoration: BoxDecoration(
                        color: _isChecked
                            ? AppColors.orangePrimary
                            : AppColors.background,
                        border: Border.all(color: const Color(0xFFFF9E1B)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: _isChecked
                          ? const Icon(Icons.check,
                              color: Colors.white, size: 18)
                          : null,
                    ),
                  ),
                  SizedBox(width: 8.h),
                  const Fonts(
                    text: 'Lembrar minha senha',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimary,
                  ),
                  const Spacer(),
                  GestureDetector(
                    child: const Fonts(
                      text: 'Esqueci minha senha',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.red,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.red,
                    ),
                    onTap: () {
                      // Implementar recuperação de senha
                    },
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.maxFinite,
                child: Row(
                  children: [
                    Expanded(
                      child: CustomOutlinedButton(
                        text: 'Acessar',
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
                        onPressed: _isLoading ? null : _login,
                      ),
                    ),
                    SizedBox(width: 16.h),
                    Expanded(
                      child: CustomOutlinedButton(
                        text: 'Cadastrar',
                        height: 56.h,
                        width: double.maxFinite,
                        buttonFonts: const Fonts(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        buttonStyle: OutlinedButton.styleFrom(
                            side:
                                const BorderSide(color: AppColors.textPrimary),
                            backgroundColor: AppColors.background),
                        onPressed: () {
                          // Implementar navegação para tela de cadastro
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50.h),
              if (_isLoading)
                Container(
                  width: double
                      .infinity, // Garantindo que o Container ocupe a largura total
                  // A altura da tela
                  color: Colors
                      .transparent, // Cor de fundo com opacidade (um fundo mais claro pode ajudar na visibilidade)
                  child: Center(
                    // O Center vai garantir que o conteúdo seja centralizado
                    child: Column(
                      mainAxisSize: MainAxisSize
                          .min, // Isso garante que o Column ocupe o espaço necessário
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.orangePrimary),
                          strokeWidth: 3,
                        ),
                        SizedBox(height: 12.h),
                        const Fonts(
                          text: 'Verificando suas credenciais...',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textPrimary,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
