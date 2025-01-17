import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

TextEditingController nameController = TextEditingController();
TextEditingController sobrenomeController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController cpfController =
    MaskedTextController(mask: '000.000.000-00');
TextEditingController phoneController =
    MaskedTextController(mask: '(00) 00000-0000');
TextEditingController? linkedinController = TextEditingController();
TextEditingController? githubController = TextEditingController();
TextEditingController? lattesController = TextEditingController();
TextEditingController confirmPassController = TextEditingController();
