
// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/widgets/mybutton.dart';

/* 
// ignore: must_be_immutable
class StatusPage extends StatelessWidget {
  StatusPage({super.key});
  var statusPageController = Get.put(StatusPageController());
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height * 0.1,
          backgroundColor: const Color.fromARGB(255, 250, 63, 6),
          centerTitle: true,
          title: const Text(
            'Status da adoção',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 255, 255, 255)),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Color.fromARGB(255, 255, 255, 255)),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height *0.85,
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stepper(steps:const  [
                Step(title: Text('em analise'), content: Text('Aguardando a ong analisar o pedido')),
                Step(title: Text('em analise'), content: Text('Aguardando a ong analisar o pedido')),
                Step(title: Text('em analise'), content: Text('Aguardando a ong analisar o pedido'))
              ]),
              
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: CustomIconButton(
                  label: 'Continuar',
                  onPressed: () {
                  },
                  width: 250,
                  alinhamento: MainAxisAlignment.center,
                ),
              )
            ],
          ),
        ),  
      ),
    );
  }
}

*/
