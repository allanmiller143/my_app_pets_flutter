
// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class TipoAnimalButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String imagePath;
  final String tipo;
  final RxString selectedType;

   TipoAnimalButton({
    required this.onPressed,
    required this.imagePath,
    required this.tipo,
    required this.selectedType,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Obx(() {
        final isSelected = selectedType.value == tipo;
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              color: isSelected
                  ? const Color.fromARGB(255, 255, 94, 0)
                  : Colors.transparent,
              width: 1.0,
            ),
          ),
          elevation: 8,
          child: Container(
            width: 41,
            height: 45,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              image: DecorationImage(
                image: AssetImage('assets/card3.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: SizedBox(
                width: isSelected ? 35 : 30,
                height: isSelected ? 35 : 30,
                child: Image.asset(
                  imagePath,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}