import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:replica_google_classroom/controller/userController.dart';

class NeteworkCntroller extends GetxController {
  final Connectivity connectivity = Connectivity();
  late MeuControllerGlobal meuControllerGlobal;

  @override
  void onInit(){
    super.onInit();
    connectivity.onConnectivityChanged.listen(atualizaStatusConexao);
    meuControllerGlobal = Get.find();
    
  }

  void atualizaStatusConexao(ConnectivityResult connectivityResult){
    if(connectivityResult == ConnectivityResult.none){
      meuControllerGlobal.internet.value = false;
      Get.rawSnackbar(
        messageText: const Text('Parece que você está sem internet'),
        isDismissible: false,
        duration: const Duration(days: 1),
        backgroundColor:const  Color.fromARGB(255, 255, 51, 0),
      );
    }else{
      meuControllerGlobal.internet.value = true;
      if(Get.isSnackbarOpen){
          Get.closeCurrentSnackbar();
      }
    }

  }


 
}

