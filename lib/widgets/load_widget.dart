import 'package:flutter/material.dart';
import 'package:get/get.dart';
Future<void> showLoad(BuildContext context) async {
  showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      });
}

void mySnackBar(text,positivo) {
  if(positivo){
    Get.snackbar(
      "Alerta",
      text,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(20),
      backgroundColor:  Color.fromARGB(255, 18, 139, 2),
      colorText: Colors.white,
      maxWidth: 300 
    ); 
  }else{
    Get.snackbar(
      "Alerta",
      text,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(20),
      backgroundColor:  Color.fromARGB(181, 236, 71, 6),
      colorText: Colors.white,
      maxWidth: 300 
    ); 
  }
                                                                                    
}
