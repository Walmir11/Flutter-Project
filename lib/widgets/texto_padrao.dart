import 'package:flutter/material.dart';

class TextoPadrao extends StatelessWidget {
  final String texto;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final TextAlign? textAlign;

  const TextoPadrao(
    this.texto, {
    super.key,
    this.fontSize = 16,
    this.fontWeight = FontWeight.normal,
    this.color,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      textAlign: textAlign,
      style: TextStyle(
        color: color ?? const Color(0xFF1F2937),
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
