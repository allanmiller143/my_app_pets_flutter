import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final String label;
  final Widget? icon;
  final VoidCallback onPressed;
  final double? width;
  final MainAxisAlignment alinhamento;

  const CustomIconButton(
      {super.key,
      required this.label,
      this.icon,
      required this.onPressed,
      this.width,
      this.alinhamento = MainAxisAlignment.start});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
          30.0), // Define o raio de arredondamento do botão
      child: SizedBox(
        width: width,
        height: 50,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor:const Color.fromARGB(255, 255, 109, 55),
                // Cor do texto do botão
            padding: const EdgeInsets.all(15.0),
          ),
          child: Row(
            mainAxisAlignment: alinhamento,
            children: [
              Center(child: icon), // Coloca o ícone à esquerda
              const SizedBox(width: 8.0), // Espaço entre o ícone e o texto
              Text(
                label,
                style: const TextStyle(
                    fontSize: 16, color: Color.fromARGB(255, 255, 255, 255)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
