import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class CustomPickPet extends StatelessWidget {
  final VoidCallback onPressed;
  final String tipo;
  final RxString controller;
  final String text;
  final String imagePath;

  CustomPickPet({
    required this.onPressed,
    required this.tipo,
    required this.controller,
    required this.text,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
      child: GestureDetector(
        onTap: onPressed,
        child: Obx(() {
          final isSelected = controller.value == tipo;
          return Container(
            height: 50,
            decoration: isSelected
                ? BoxDecoration(
                    color: Color.fromARGB(255, 255, 51, 0),
                    borderRadius: BorderRadius.circular(30))
                : BoxDecoration(
                    color: Color.fromARGB(255, 221, 231, 231),
                    borderRadius: BorderRadius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(3, 0, 2, 0),
              child: Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(50),
                      image: DecorationImage(
                        image: AssetImage(imagePath),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
                    child: Text(
                      text,
                      style: TextStyle(
                        color: isSelected
                            ? Color.fromARGB(255, 255, 255, 255)
                            : Color.fromARGB(255, 0, 0, 0),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}