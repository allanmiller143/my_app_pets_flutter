// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:ui';
import 'package:replica_google_classroom/widgets/mybutton.dart';
import '../services/mongodb.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/widgets/load_widget.dart';

class EmailController extends GetxController {
  dynamic usuario;
  var email = TextEditingController();
  
  Future<void> emailfunc(BuildContext context) async {
    showLoad(context);
    if (await MongoDataBase.verificaUser(email.text)) {
      usuario = await MongoDataBase.retornaUsuarioCompleto(email.text);
      Navigator.of(context).pop();
      Get.toNamed('/password', arguments: [usuario]);
    } else {
      Navigator.of(context).pop();
      Get.toNamed('/signUp');
    }
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
                          width: 400,
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextFormField(
                                  controller: emailController.email,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black), // Cor de foco desejada
                                    ),  
                                    contentPadding:EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    border: OutlineInputBorder(),
                                    filled: true,
                                    hintStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                    hintText: "Email",
                                    fillColor:Color.fromARGB(255, 248, 248, 248), 
                                  ),
                                ),
                                CustomIconButton(
                                  label: 'Confirmar',
                                  onPressed: () {emailController.emailfunc(context);  },
                                  width: double.infinity,
                                  height: 60,
                                  alinhamento: MainAxisAlignment.center),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Não possui conta?  ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: const Color.fromARGB(255, 255, 255, 255),      
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Get.toNamed('/signUp');
                                      },
                                      child: Text(
                                        'Cadastre-se',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: const Color.fromARGB(255, 236, 71, 6),    
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
