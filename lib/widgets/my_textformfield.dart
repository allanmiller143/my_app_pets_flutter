import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final double width;
  final bool enabled;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final void Function(String)? onChanged; // Novo parâmetro onChanged

  CustomTextFormField({
    required this.hintText,
    required this.controller,
    required this.width,
    this.enabled = true,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.onChanged, // Novo parâmetro onChanged
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: Colors.black,
    );

    return Container(
      width: width,
      height: 40, // Aumentei a altura para acomodar o rótulo acima
      decoration: BoxDecoration(
        color: Color.fromARGB(176, 226, 221, 218),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: hintText, // Usando o labelText para o rótulo
          labelStyle: TextStyle(
            color: const Color.fromARGB(255, 27, 27, 27), // Cor do rótulo preto
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
        ),
        controller: controller,
        style: textStyle,
        enabled: enabled,
        validator: validator,
        keyboardType: keyboardType,
        onChanged: onChanged, // Use o parâmetro onChanged aqui
      ),
    );
  }
}
