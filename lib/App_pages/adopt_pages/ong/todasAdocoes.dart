import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/App_pages/app_widgets/sem_internet.dart';
import 'package:replica_google_classroom/controller/userController.dart';
import 'package:replica_google_classroom/services/banco/firebase.dart';


class TodasAdocoesController extends GetxController {
  late MeuControllerGlobal meuControllerGlobal;
  List<Widget> listaAdocoes = [];
  var listaDeIds = [];
  RxInt atualiza = 0.obs;
  RxInt aguardandoAvaliacao = 0.obs;
  RxInt aguardandoUsuario = 0.obs;

  func(context) async {
    meuControllerGlobal = Get.find();
    if(meuControllerGlobal.internet.value){
      aguardandoAvaliacao.value = await BancoDeDados.numeroDeAdocoes(meuControllerGlobal.usuario['Id'],'Aguardando avalição dos dados');
      aguardandoUsuario.value = await BancoDeDados.numeroDeAdocoes(meuControllerGlobal.usuario['Id'],'Domentação aprovada');
      return'allan';
    }
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
                                        borderRadius: BorderRadius.circular(15),
                                        image:const DecorationImage(image:
                                          AssetImage(
                                            "assets/aguardandoAvaliacao.png",
                                          ),
                                          fit: BoxFit.cover
                                        )
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            width: 20,
                                            height: 20,
                                            decoration:const  BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                       
                                                topLeft: Radius.circular(5)
                                              ),
                                              color: Color.fromARGB(255, 255, 98, 0)

                                            ),
                                            child: Obx(
                                            () => Center(
                                                child: Text(
                                                  '${todasAdocoesController.aguardandoAvaliacao.value}',style:const  TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                                                )
                                              )
                                            ),
                                          )
                                        ],
                                      )
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
                                        borderRadius: BorderRadius.circular(15),
                                         image:const DecorationImage(image:
                                          AssetImage(
                                            "assets/esperandoUsuario.png",
                                          ),
                                          fit: BoxFit.cover
                                        )
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            width: 20,
                                            height: 20,
                                            decoration:const  BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5)
                                              ),
                                              color: Color.fromARGB(255, 255, 98, 0)

                                            ),
                                            child: Obx(
                                            () => Center(
                                                child: Text(
                                                  '${todasAdocoesController.aguardandoUsuario.value}',style:const  TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                                                )
                                              )
                                            ),
                                          )
                                        ],
                                      )
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *0.28,
                                      height: MediaQuery.of(context).size.width *0.1,
                                      child:const  Text('Aguardando usuário',style: TextStyle(fontFamily: 'AsapCondensed-Medium',fontWeight: FontWeight.w300),)
                                    
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
                                        borderRadius: BorderRadius.circular(15),
                                         image:const DecorationImage(image:
                                          AssetImage(
                                            "assets/finalizada.png",
                                          ),
                                          fit: BoxFit.cover
                                        )
                                        
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
                                            borderRadius: BorderRadius.circular(15),
                                            image:const DecorationImage(image:
                                              AssetImage(
                                                "assets/fundo.png",
                                              ),
                                              fit: BoxFit.cover
                                            )
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
                                 const  SizedBox(width: 15,),
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
                                            borderRadius: BorderRadius.circular(15),
                                            image:const DecorationImage(image:
                                              AssetImage(
                                                "assets/fundoOngProfile.png",
                                              ),
                                              fit: BoxFit.cover
                                            )
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
                    return const SemInternetWidget();
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
