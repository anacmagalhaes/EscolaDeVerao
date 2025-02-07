import 'package:escoladeverao/controllers/sign_up_controllers.dart';
import 'package:escoladeverao/models/user_model.dart';
import 'package:escoladeverao/screens/modals/resend_email_modal.dart';
import 'package:escoladeverao/screens/password/password_screen.dart';
import 'package:escoladeverao/screens/home/home_screen.dart';
import 'package:escoladeverao/services/api_service.dart';
import 'package:escoladeverao/services/auth_service.dart';
import 'package:escoladeverao/utils/colors_utils.dart';
import 'package:escoladeverao/utils/fonts_utils.dart';
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
  final AuthService authService = AuthService();

  // Variáveis de erro
  String _emailError = '';
  String _passwordError = '';
  final emailInput = TextEditingController();
  final passwordInput = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkExistingUser();
    emailInput.clear();
    passwordInput.clear();
    _loadSavedCredentials();

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

  _checkExistingUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final isAdmin = prefs.getBool('is_admin') ?? false;

    if (token != null) {
      User? user = await authService.loadUser();
      if (user != null) {
        // Use fromJson with overrideAdminStatus
        user = User.fromJson(user.toJson(), overrideAdminStatus: isAdmin);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(user: user!)),
        );
      }
    }
  }

  @override
  void dispose() {
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

  Future<void> _loadSavedCredentials() async {
    final hasRemember = await authService.hasRememberLogin();
    final credentials = await authService.loadCredentials();

    if (mounted) {
      setState(() {
        _isChecked = hasRemember;

        // Only load credentials if 'remember' is explicitly checked
        if (hasRemember) {
          emailInput.text = credentials['email'] ?? '';
          passwordInput.text = credentials['password'] ?? '';
        } else {
          emailInput.clear();
          passwordInput.clear();
        }
      });
    }
  }

  // Função de login
// Função de login
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

      if (!mounted) return;

      if (result['success'] == true) {
        final userData = result['data']['user'];
        final token = result['data']['token'];

        if (userData != null && token != null) {
          final user = User.fromJson(userData);

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);

          await authService.saveUser(user);

          if (!_isChecked) {
            await authService.clearSavedCredentials();
          } else {
            await authService.saveCredentials(email, password);
          }

          if (!mounted) return;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(user: user),
            ),
          );
        } else {
          setState(() {
            _passwordError = 'Dados de usuário inválidos';
          });
        }
      } else {
        if (result['message'] == 'email_not_verified') {
          ResendEmailModal(context, emailController.text);
        } else {
          setState(() {
            _passwordError = _getLoginErrorMessage(
                result['message'] ?? 'Erro ao fazer login');
          });
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _passwordError = 'Erro ao conectar ao servidor: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
                        if (!_isChecked) {
                          // Clear credentials when checkbox is unchecked
                          emailInput.clear();
                          passwordInput.clear();
                        }
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
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const PasswordScreen(origin: 'login')));
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
                          Navigator.pushNamed(context, '/sign_up_screen');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
