// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:ui';
import '../services/mongodb.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/widgets/load_widget.dart';

class EmailController extends GetxController {
  static EmailController get to =>
      Get.find(); // serve para acessar a variável de forma mais simples

  String email = '';

  
  

  Future<void> emailfunc(BuildContext context) async {
    showLoad(context);
    if (await MongoDataBase.verificaUser(email)) {
      var nome = await MongoDataBase.retornaNome(email);
      await resetar(emailx: email);
      Navigator.of(context).pop();
      Get.toNamed('/password', arguments: [email, nome]);
    } else {
      await resetar(emailx: "");
      Navigator.of(context).pop();
      Get.toNamed('/signUp');
    }
  }

  Future<void> resetar({String? emailx}) async {
    email = emailx!;
  }
}

class MyEmailPage extends StatelessWidget {
  MyEmailPage({super.key});
  final emailController = Get.put(EmailController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<EmailController>(
        init: EmailController(),
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
                  padding: EdgeInsets.fromLTRB(40.0, 10, 40.0, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Olá !",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ],
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Container(
                          color: Color.fromRGBO(126, 129, 60, 0.397),
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                          height: 180,
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextField(
                                  onChanged: (text) {
                                    emailController.email = text;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    border: OutlineInputBorder(),
                                    filled: true,
                                    hintStyle: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                    hintText: "Email",
                                    fillColor:
                                        Color.fromARGB(255, 248, 248, 248),
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(255, 236, 71, 6),
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 20, 10, 20),
                                      ),
                                      child: Text(
                                        'Confirmar',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      onPressed: () async {
                                        emailController.emailfunc(context);
                                      },
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Não possui conta?  ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        emailController.email = '';
                                        Get.toNamed('/signUp');
                                      },
                                      child: Text(
                                        'Cadastre-se',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: const Color.fromARGB(
                                              255, 236, 71, 6),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
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
