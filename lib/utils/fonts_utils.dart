import 'package:flutter/material.dart';

class Fonts extends StatelessWidget {
  final String? text; // Texto principal
  final String primaryFont;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final List<InlineSpan>? additionalSpans; // Novos spans opcionais

  const Fonts({
    Key? key,
    this.text,
    this.primaryFont = 'Montserrat',
    required this.fontSize,
    required this.fontWeight,
    required this.color,
    this.maxLines,
    this.textAlign,
    this.decoration,
    this.decorationColor,
    this.additionalSpans, // Lista de spans extras
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Cria lista de spans com o texto principal
    List<InlineSpan> textSpans = [
      TextSpan(
        text: text ?? '',
        style: TextStyle(
          fontFamily: primaryFont,
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          decoration: decoration ?? TextDecoration.none,
          decorationColor: decorationColor,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ];

    // Adiciona spans extras se fornecidos
    if (additionalSpans != null) {
      textSpans.addAll(additionalSpans!);
    }

    return Text.rich(
      TextSpan(children: textSpans),
      maxLines: maxLines,
      textAlign: textAlign ?? TextAlign.start,
      overflow: TextOverflow.ellipsis,
    );
  }
}
