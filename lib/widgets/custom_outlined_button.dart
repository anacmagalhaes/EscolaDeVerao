import 'package:escoladeverao/utils/fonts_utils.dart';
import 'package:flutter/material.dart';

// Classe para botões personalizados
class CustomOutlinedButton extends StatelessWidget {
  // Propriedades da classe
  final String text; // Texto do botão
  final VoidCallback? onPressed; // Ação do botão
  final ButtonStyle? buttonStyle; // Estilo do botão
  final Fonts? buttonFonts; // Componente Fonts para estilo do texto
  final double? height; // Altura do botão
  final double? width; // Largura do botão
  final BoxDecoration? decoration; // Decoração externa

  // Construtor da classe
  const CustomOutlinedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.buttonStyle,
    this.buttonFonts,
    this.height,
    this.width,
    this.decoration,
  });

  // Interface do botão
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: decoration,
      child: OutlinedButton(
        style: buttonStyle,
        onPressed: onPressed,
        child: buttonFonts != null
            ? Text(
                text,
                style: TextStyle(
                  fontFamily: buttonFonts!.primaryFont,
                  fontSize: buttonFonts!.fontSize,
                  fontWeight: buttonFonts!.fontWeight,
                  color: buttonFonts!.color,
                ),
              )
            : Text(text), // Texto padrão caso buttonFonts seja null
      ),
    );
  }
}
