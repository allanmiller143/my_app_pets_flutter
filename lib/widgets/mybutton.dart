import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final String label;
  final Widget? icon;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final double? raio;
  final MainAxisAlignment alinhamento;

  const CustomIconButton(
      {super.key,
      required this.label,
      this.raio = 0.0,
      this.icon,
      required this.onPressed,
      this.width,
      this.alinhamento = MainAxisAlignment.start,
      this.height});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(raio!), // Define o raio de arredondamento do botão
      child: SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: const Color.fromARGB(255, 250, 63, 6),
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
