import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

TextEditingController nameEditController = TextEditingController();
TextEditingController emailEditController = TextEditingController();
TextEditingController phoneEditController =
    MaskedTextController(mask: '(00) 00000-0000');
TextEditingController linkedinEditController = TextEditingController();
TextEditingController githubEditController = TextEditingController();
TextEditingController latesEditController = TextEditingController();
ScrollController scrollController = ScrollController();
