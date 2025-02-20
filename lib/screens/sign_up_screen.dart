import 'dart:convert';

import 'package:escoladeverao/controllers/sign_up_controllers.dart';
import 'package:escoladeverao/modals/verification_email_modal.dart';
import 'package:escoladeverao/modals/verification_error_modal.dart';
import 'package:escoladeverao/services/api_service.dart';
import 'package:escoladeverao/services/error_handler_service.dart';
import 'package:escoladeverao/utils/colors_utils.dart';
import 'package:escoladeverao/utils/fonts_utils.dart';
import 'package:escoladeverao/widgets/custom_app_bar_error.dart';
import 'package:escoladeverao/widgets/custom_outlined_button.dart';
import 'package:escoladeverao/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpScreen extends StatefulWidget {
  final String origin;
  const SignUpScreen({super.key, required this.origin});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final ApiService apiService = ApiService(); // Instância do ApiService
  final ScrollController scrollController = ScrollController();

  String _nameError = '';
  String _emailError = '';
  String _cpfError = '';
  String _phoneError = '';
  String _passwordError = '';
  String _confirmPassError = '';

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

  void _scrollToError(String fieldName) {
    final double position;

    switch (fieldName) {
      case 'name':
        position = 200.0; // ou a posição específica do campo de nome
        break;
      case 'email':
        position = 250.0; // ou a posição específica do campo de email
        break;
      case 'cpf':
        position = 300.0; // ou a posição específica do campo de CPF
        break;
      case 'phone':
        position = 350.0; // ou a posição específica do campo de telefone
        break;
      case 'password':
        position = 450.0; // ou a posição específica do campo de senha
        break;
      case 'confirmPass':
        position =
            500.0; // ou a posição específica do campo de confirmação de senha
        break;
      default:
        position = 0.0;
        break;
    }

    scrollController.animateTo(
      position,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  bool _validateFields() {
    bool isValid = true;

    if (nameController.text.isEmpty) {
      setState(() {
        _nameError = 'Nome é obrigatório';
      });
      isValid = false;
      _scrollToError('name');
    }
    if (emailController.text.isEmpty) {
      setState(() {
        _emailError = 'E-mail é obrigatório';
      });
      isValid = false;
    } else if (!isValidEmail(emailController.text)) {
      setState(() {
        _emailError = 'E-mail inválido';
      });
      isValid = false;
      _scrollToError('email');
    }
    if (cpfController.text.isEmpty) {
      setState(() {
        _cpfError = 'CPF é obrigatório';
      });
      isValid = false;
      _scrollToError('cpf');
    } else if (!isValidCPF(cpfController.text)) {
      setState(() {
        _cpfError = 'CPF inválido';
      });
      isValid = false;
    }
    if (phoneController.text.isEmpty) {
      setState(() {
        _phoneError = 'Telefone é obrigatório';
      });
      isValid = false;
      _scrollToError('phone');
    }
    if (passwordController.text.isEmpty || passwordController.text.length < 6) {
      setState(() {
        _passwordError = 'Senha deve ter pelo menos 6 caracteres';
      });
      isValid = false;
      _scrollToError('password');
    }
    if (confirmPassController.text.isEmpty) {
      setState(() {
        _confirmPassError = 'Por favor, confirme sua senha';
      });
      isValid = false;
      _scrollToError('confirmPass');
    } else if (confirmPassController.text != passwordController.text) {
      setState(() {
        _confirmPassError = 'As senhas não coincidem';
      });
      isValid = false;
    }

    return isValid;
  }

  void _clearFields() {
    nameController.clear();
    emailController.clear();
    cpfController.clear();
    phoneController.clear();
    linkedinController?.clear();
    githubController?.clear();
    lattesController?.clear();
    passwordController.clear();
    confirmPassController.clear();
  }

  @override
  void dispose() {
    _clearFields();
    super.dispose();
  }

  Future<void> _signUp() async {
    setState(() {
      _nameError = '';
      _emailError = '';
      _cpfError = '';
      _phoneError = '';
      _passwordError = '';
      _confirmPassError = '';
    });

    if (!_validateFields()) {
      return;
    }

    final userData = {
      'name': nameController.text,
      'email': emailController.text,
      'cpf': cpfController.text.replaceAll('.', '').replaceAll('-', ''),
      'phone': phoneController.text.replaceAll(RegExp(r'[^0-9]'), ''),
      'linkedin': linkedinController?.text,
      'github': githubController?.text,
      'lattes': lattesController?.text,
      'password': passwordController.text,
    };

    String _extractErrorMessage(Map<String, dynamic> response) {
      return response["message"];
    }

    try {
      final result = await apiService.register(userData);
      if (result['success']) {
        VerificationEmailModal(context, emailController.text);
      } else {
        VerificationErrorModal(context, result['message']);
      }
    } catch (e) {
      ErrorHandler.handleError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            CustomAppBarError(
              onBackPressed: () {
                FocusScope.of(context).unfocus();
                _clearFields();
                Navigator.pop(context);
              },
              backgroundColor: AppColors.background,
              leadingIcon: Image.asset(
                'assets/icons/angle-left-orange.png',
                width: 44.h,
                height: 44.h,
              ),
            ),
          ],
          body: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.h, vertical: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Fonts(
                          text: 'Cadastre-se',
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary),
                      SizedBox(height: 8.h),
                      const Fonts(
                          text: 'Insira suas informações para se cadastrar',
                          maxLines: 1,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textPrimary),
                      SizedBox(height: 45.h),
                      CustomTextField(
                        labelText: 'Nome',
                        hintText: 'Digite seu primeiro nome',
                        keyboardType: TextInputType.name,
                        controller: nameController,
                        isRequired: true,
                      ),
                      SizedBox(height: 8.h),
                      if (_nameError.isNotEmpty)
                        Text(
                          _nameError,
                          style: TextStyle(color: Colors.red, fontSize: 12.sp),
                        ),
                      SizedBox(height: 16.h),
                      CustomTextField(
                        labelText: 'E-mail',
                        hintText: 'Digite seu e-mail',
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        isRequired: true,
                      ),
                      SizedBox(height: 8.h),
                      if (_emailError.isNotEmpty)
                        Text(
                          _emailError,
                          style: TextStyle(color: Colors.red, fontSize: 12.sp),
                        ),
                      SizedBox(height: 16.h),
                      CustomTextField(
                        labelText: 'CPF',
                        hintText: 'Digite seu CPF',
                        keyboardType: TextInputType.number,
                        controller: cpfController,
                        isRequired: true,
                      ),
                      SizedBox(height: 8.h),
                      if (_cpfError.isNotEmpty)
                        Text(
                          _cpfError,
                          style: TextStyle(color: Colors.red, fontSize: 12.sp),
                        ),
                      SizedBox(height: 16.h),
                      CustomTextField(
                        labelText: 'Telefone',
                        hintText: '(99) 99999-9999',
                        keyboardType: TextInputType.phone,
                        controller: phoneController,
                        isRequired: true,
                      ),
                      SizedBox(height: 8.h),
                      if (_phoneError.isNotEmpty)
                        Text(
                          _phoneError,
                          style: TextStyle(color: Colors.red, fontSize: 12.sp),
                        ),
                      SizedBox(height: 16.h),
                      CustomTextField(
                        labelText: 'Link LinkedIn',
                        hintText: 'https://www.linkedin.com/in/seulinkedlin ',
                        keyboardType: TextInputType.url,
                        controller: linkedinController,
                      ),
                      SizedBox(height: 16.h),
                      CustomTextField(
                        labelText: 'Link Currículo Lattes',
                        hintText: 'Adicione seu link do Lattes',
                        keyboardType: TextInputType.url,
                        controller: lattesController,
                      ),
                      SizedBox(height: 16.h),
                      CustomTextField(
                        labelText: 'Senha',
                        hintText: 'Crie sua senha',
                        obscureText: true,
                        showTogglePasswordIcon: true,
                        controller: passwordController,
                        isRequired: true,
                      ),
                      SizedBox(height: 8.h),
                      if (_passwordError.isNotEmpty)
                        Text(
                          _passwordError,
                          style: TextStyle(color: Colors.red, fontSize: 12.sp),
                        ),
                      SizedBox(height: 16.h),
                      CustomTextField(
                        labelText: 'Confirme sua senha',
                        hintText: 'Digite novamente sua senha',
                        obscureText: true,
                        showTogglePasswordIcon: true,
                        controller: confirmPassController,
                        isRequired: true,
                      ),
                      SizedBox(height: 8.h),
                      if (_confirmPassError.isNotEmpty)
                        Text(
                          _confirmPassError,
                          style: TextStyle(color: Colors.red, fontSize: 12.sp),
                        ),
                      SizedBox(height: 15.h),
                      SizedBox(
                        width: double.maxFinite,
                        child: CustomOutlinedButton(
                          text: 'Cadastrar',
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
                          onPressed: _signUp,
                        ),
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
