
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class CustomDropdownButton extends StatelessWidget {
  final List<String> items;
  final RxString controller;

  const CustomDropdownButton({super.key, required this.items, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => SizedBox(
          width: 90,
          height: 40,
          child: DropdownButton<String>(
            isExpanded: true,
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            borderRadius: BorderRadius.circular(15),
            value: controller.value,
            onChanged: (String? newValue) {
              if (newValue != null) {
                controller.value = newValue;
              }
            },
            elevation: 8,
            menuMaxHeight: 200,

            style: const TextStyle(color: Colors.black), // Estilo do texto
            underline: Container(
              color: Colors.transparent,
            ),
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'AsapCondensed-Bold',
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ));
  }
}