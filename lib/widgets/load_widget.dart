import 'package:flutter/material.dart';
import 'package:get/get.dart';


Future<void> showLoad(BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false, // Impede o fechamento ao tocar fora do diálogo
    builder: (context) {
      return const Center(
        child: CircularProgressIndicator(color:Color.fromARGB(255, 250, 63, 6),)
      );
    },
  );
}

void mySnackBar(text,positivo) {
  if(positivo){
    Get.snackbar(
      "Alerta",
      text,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(20),
      backgroundColor: const  Color.fromARGB(255, 18, 139, 2),
      colorText: Colors.white,
      maxWidth: 300 
    ); 
  }else{
    Get.snackbar(
      "Alerta",
      text,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(20),
      backgroundColor: const  Color.fromARGB(181, 236, 71, 6),
      colorText: Colors.white,
      maxWidth: 300 
    ); 
  }
                                                                                    
}
