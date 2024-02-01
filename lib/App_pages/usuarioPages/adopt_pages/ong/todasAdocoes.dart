import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/controller/userController.dart';


class TodasAdocoesController extends GetxController {
  late MeuControllerGlobal meuControllerGlobal;
  List<Widget> listaAdocoes = [];
  var listaDeIds = [];
  RxInt atualiza = 0.obs;


  Future<String> func(context) async {
    meuControllerGlobal = Get.find();
    return'allan';
  }

 
}

// ignore: must_be_immutable
class TodasAdocoesPage extends StatelessWidget {
  TodasAdocoesPage({super.key});
  var todasAdocoesController = Get.put(TodasAdocoesController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<TodasAdocoesController>(
        init: TodasAdocoesController(),
        builder: (_) {
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: MediaQuery.of(context).size.height * 0.1,
              backgroundColor: const Color.fromARGB(255, 250, 63, 6),
              centerTitle: true,
              title: const Text(
                'Adoções',
                style: TextStyle(fontSize: 20,fontFamily: 'AsapCondensed-Medium', fontWeight: FontWeight.w500, color: Color.fromARGB(255, 255, 255, 255)),
              ),
              
            ),
            body: FutureBuilder(
              future: todasAdocoesController.func(context),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Container(
                      margin: const EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10,),
                          const Text('Gerencie suas adoções aqui',style: TextStyle( fontFamily: 'AsapCondensed-Medium',fontWeight: FontWeight.w300,fontSize: 20),),
                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Get.toNamed('/adocoes', arguments: ['Aguardando avalição dos dados']);
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: MediaQuery.of(context).size.width *0.3,
                                      width: MediaQuery.of(context).size.width *0.3,
                                      decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius: BorderRadius.circular(15)
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *0.28,
                                      height: MediaQuery.of(context).size.width *0.1,
                                      child: const Text('Aguardando avaliação',style: TextStyle(fontFamily: 'AsapCondensed-Medium',fontWeight: FontWeight.w300),)
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  Get.toNamed('/adocoes',arguments: ['Aguardando usuário']);
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: MediaQuery.of(context).size.width *0.3,
                                      width: MediaQuery.of(context).size.width *0.3,
                                      decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius: BorderRadius.circular(15)
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *0.28,
                                      height: MediaQuery.of(context).size.width *0.1,
                                      child: const Text('Aguardando usuário',style: TextStyle(fontFamily: 'AsapCondensed-Medium',fontWeight: FontWeight.w300),)
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  Get.toNamed('/adocoes',arguments: ['Finalizada']);
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: MediaQuery.of(context).size.width *0.3,
                                      width: MediaQuery.of(context).size.width *0.3,
                                      decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius: BorderRadius.circular(15)
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *0.28,
                                      height: MediaQuery.of(context).size.width *0.1,
                                      child: const Text('Finalizada',style: TextStyle(fontFamily: 'AsapCondensed-Medium',fontWeight: FontWeight.w300),)
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Get.toNamed('/adocoes',arguments: ['Todas adoções']);
                                },
                                child: Column(
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context).size.width *0.3,
                                          width: MediaQuery.of(context).size.width *0.3,
                                          decoration: BoxDecoration(
                                            color: Colors.black12,
                                            borderRadius: BorderRadius.circular(15)
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width *0.28,
                                          height: MediaQuery.of(context).size.width *0.1,
                                          child: const Text('Todas',style: TextStyle(fontFamily: 'AsapCondensed-Medium',fontWeight: FontWeight.w300),)
                                        
                                        ),
                                      ],
                                    ),
                              ),
                                  const SizedBox(width: 15,),
                              GestureDetector(
                                onTap: (){
                                  Get.toNamed('/adocoes',arguments: ['Negadas']);
                                },
                                child: Column(
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context).size.width *0.3,
                                          width: MediaQuery.of(context).size.width *0.3,
                                          decoration: BoxDecoration(
                                            color: Colors.black12,
                                            borderRadius: BorderRadius.circular(15)
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width *0.28,
                                          height: MediaQuery.of(context).size.width *0.1,
                                          child: const Text('Adoções negadas',style: TextStyle(fontFamily: 'AsapCondensed-Medium',fontWeight: FontWeight.w300),)
                                        
                                        ),
                                      ],
                                    ),
                              ),

                                ],
                              ),
                          
                         
                        ],
                      ),
                    );
                  } else {
                    return const Text('Nenhum pet disponível');
                  }
                } else if (snapshot.hasError) {
                  return Text(
                      'Erro ao carregar a lista de pets: ${snapshot.error}');
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 253, 72, 0),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}