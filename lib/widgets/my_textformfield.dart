import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final double width;
  final bool enabled;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final void Function(String)? onChanged; // Novo parâmetro onChanged

   const CustomTextFormField({super.key, 
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
    const textStyle = TextStyle(
      color: Colors.black,
    );

    return Container(
      padding:const  EdgeInsets.fromLTRB(0, 0, 0, 3),
      width: width,
      height: 42, // Aumentei a altura para acomodar o rótulo acima
      decoration: BoxDecoration(
        color: const Color.fromARGB(176, 226, 221, 218),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextFormField(
        
        decoration: InputDecoration(
          
          labelText: hintText, // Usando o labelText para o rótulo
          labelStyle: const TextStyle(
            color:  Color.fromARGB(255, 27, 27, 27), // Cor do rótulo preto
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
