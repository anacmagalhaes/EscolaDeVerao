import 'package:escoladeverao/controllers/sign_up_controllers.dart';
import 'package:escoladeverao/screens/auth/login_screen.dart';
import 'package:escoladeverao/screens/sign_in_or_sign_up.dart';
import 'package:escoladeverao/services/api_service.dart';
import 'package:escoladeverao/utils/colors.dart';
import 'package:escoladeverao/utils/fonts.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            CustomAppBarError(
              onBackPressed: () {
                FocusScope.of(context).unfocus();
                if (widget.origin == '/login') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                } else if (widget.origin == '/signinorsignup') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignInOrSignUp()),
                  );
                } else {
                  Navigator.pop(context);
                }
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
                        hintText: 'Digite seu nome completo',
                        keyboardType: TextInputType.name,
                        controller: nameController,
                        isRequired: true,
                      ),
                      SizedBox(height: 16.h),
                      CustomTextField(
                        labelText: 'E-mail',
                        hintText: 'Digite seu e-mail',
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        isRequired: true,
                      ),
                      SizedBox(height: 16.h),
                      CustomTextField(
                        labelText: 'CPF',
                        hintText: 'Digite seu CPF',
                        keyboardType: TextInputType.number,
                        controller: cpfController,
                        isRequired: true,
                      ),
                      SizedBox(height: 16.h),
                      CustomTextField(
                        labelText: 'Telefone',
                        hintText: '(99) 99999-9999',
                        keyboardType: TextInputType.phone,
                        controller: phoneController,
                        isRequired: true,
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
                        labelText: 'Link GitHub',
                        hintText: 'https://github.com/seugithub',
                        keyboardType: TextInputType.url,
                        controller: githubController,
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
                      SizedBox(height: 16.h),
                      CustomTextField(
                        labelText: 'Confirme sua senha',
                        hintText: 'Digite novamente sua senha',
                        obscureText: true,
                        showTogglePasswordIcon: true,
                        controller: confirmPassController,
                        isRequired: true,
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
                          onPressed: () async {
                            FocusScope.of(context)
                                .unfocus(); // Fechar o teclado

                            // Verificar se todos os campos obrigatórios estão preenchidos
                            if (nameController.text.isEmpty ||
                                emailController.text.isEmpty ||
                                cpfController.text.isEmpty ||
                                phoneController.text.isEmpty ||
                                passwordController.text.isEmpty ||
                                confirmPassController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Preencha todos os campos obrigatórios.')),
                              );
                              return;
                            }

                            // Verificar se as senhas coincidem
                            if (passwordController.text !=
                                confirmPassController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('As senhas não coincidem.')),
                              );
                              return;
                            }

                            // Montar o mapa de dados para o cadastro
                            final Map<String, dynamic> userData = {
                              'name': nameController.text,
                              'email': emailController.text,
                              'cpf': cpfController.text,
                              'phone': phoneController.text,
                              'linkedin': linkedinController.text,
                              'github': githubController.text,
                              'lattes': lattesController.text,
                              'password': passwordController.text,
                            };

                            // Chamar a API de cadastro
                            final response =
                                await apiService.register(userData);

                            if (response['success']) {
                              // Cadastro realizado com sucesso
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Cadastro realizado com sucesso!')),
                              );

                              // Navegar para a tela de login ou realizar login automático
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                              );
                            } else {
                              // Mostrar erro
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Erro: ${response['message']}')),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
