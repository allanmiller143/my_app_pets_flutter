// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:replica_google_classroom/loginPages/my_password_page.dart';
import '../services/mongodb.dart';
import 'package:replica_google_classroom/widgets/load_widget.dart';

class ConfirmController extends GetxController {
   
  List<TextEditingController> codigoControllers = List.generate(4,(index) =>TextEditingController()); // Lista de controladores para os TextFields
  
  String codigo = "";
  String tela = Get.arguments[0].toString();
  String codigoCorreto = Get.arguments[1];
  String email = Get.arguments[3];
  String senha = Get.arguments[4];
  String nome = Get.arguments[2];

  Future<void> simulador(BuildContext context) async {
    showLoad(context);
    for (TextEditingController controller in codigoControllers) {
      codigo += controller.text;
    }

    if (codigo == codigoCorreto) {
      if (tela == '1') {
        // se for para confirmar o email no cadastro
        await MongoDataBase.insereUser(nome, email, senha);
        Navigator.of(context).pop();
        mySnackBar('Email Confirmado!!!\nHora de concluir seu cadastro', true);
        Get.toNamed('/whoAreYouPage', arguments: [nome, email, senha]);
      } else {
        Navigator.of(context).pop();
        mySnackBar('Email confirmado, redefina sua senha', true);
        Get.toNamed('/forgetPage', arguments: [email, nome]);
      }
      for (TextEditingController controller in codigoControllers) {
        controller.clear();
      }
      codigo = '';
      
    } else {
      Navigator.of(context).pop();
      for (TextEditingController controller in codigoControllers) {
        controller.clear();
      }
      codigo = '';
      mySnackBar('Código Incorreto', false);
    }
  }

  void resetar() {
    tela = '';
    codigoCorreto = '';
    codigo = '';
    email = '';
    senha = '';
    nome = '';
  }
}

class MyConfirmPage extends StatelessWidget {
  MyConfirmPage({super.key});
  final confirmController = Get.put(ConfirmController());
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<ConfirmController>(
        init: ConfirmController(),
        builder: (_) {
          return Scaffold(
            body: Stack(
              children: [
                Image.asset(
                  "assets/fundo.png",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40.0, 10, 40.0, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () {
                              confirmController.resetar();
                              Get.back();
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,
                              size: 30,
                              weight: 80,
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              color: Color.fromRGBO(126, 129, 60, 0.397),
                              height: 250,
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      'Digite o código ',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:MainAxisAlignment.spaceAround,
                                      children: List.generate(4, (index) {
                                        return SizedBox(
                                          width: 60,
                                          height: 80,
                                          child: TextField(
                                            buildCounter: (BuildContext context,{required int currentLength,required bool isFocused,required int? maxLength}) {
                                              return null; // Isso remove o contador de caracteres
                                            },
                                            controller: confirmController.codigoControllers[index],
                                            keyboardType: TextInputType.number,
                                            maxLength: 1,
                                            decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black), // Cor de foco desejada
                                              ),  
                                              border: OutlineInputBorder(),
                                              filled: true,
                                              hintStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0),),
                                              fillColor: Color.fromARGB(255,248,248,248,),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:  Color.fromARGB(255, 236, 71, 6),
                                              
                                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                                
                                          ),
                                          child: Text(
                                            "Confirmar",
                                            style: TextStyle(fontSize: 18,color: const Color.fromARGB(255, 255, 255, 255)),
                                          ),
                                          onPressed: () async {
                                            await confirmController
                                                .simulador(context);
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
