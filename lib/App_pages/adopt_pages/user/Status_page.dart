
// ignore_for_file: avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/App_pages/app_widgets/sem_internet.dart';
import 'package:replica_google_classroom/controller/userController.dart';
import 'package:replica_google_classroom/services/banco/firebase.dart';

class StatusAdocaoController extends GetxController {
  late MeuControllerGlobal meuControllerGlobal;
  RxInt atualiza = 0.obs;
  var info = Get.arguments[0];
  List<Widget> listaStatus = [];
  int etapa = 1;
  Stream<QuerySnapshot<Map<String, dynamic>>>? stream;
  
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>?>func(context) async {
    meuControllerGlobal = Get.find();
    if(meuControllerGlobal.internet.value){
      await getAdaocao(context);
      return stream;
    }
  
    
  }

  void mostrarDialogoDeConfirmacao(context,idAdocao,idOng,idAnimal) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:const  Text('Cancelar Adoção'),
          content: const Text('Tem certeza que deseja cancelar a adoção?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async{
                await BancoDeDados.AlterarStatusAdocao(idAdocao,'Cancelada por usuário');
                await BancoDeDados.alterarPetInfo({'Em processo de adoção': false},idOng,idAnimal);
                
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop(); // Fecha o dialogo
              },
              child: const  Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  

  getAdaocao(context) async {
    if(info['Id adoção'] != null ) {
      stream = (await BancoDeDados.getAdocaoUsuario(info['Id adoção'])) as Stream<QuerySnapshot<Map<String, dynamic>>>?;
      stream?.listen((QuerySnapshot<Map<String, dynamic>> snapshot) async {
      listaStatus.clear();
      if (snapshot.docs.isNotEmpty) {
        for (DocumentSnapshot<Map<String, dynamic>> ds in snapshot.docs) {  

          // exibir a informação de status certa

          if(ds.data()?['Status'] == "Aguardando avalição dos dados"){
            etapa = 0;
          }else if(ds.data()?['Status'] == "Domentação aprovada"){
            etapa = 1;
          }
          else if(ds.data()?['Status'] == "Finalizada"){
            etapa = 2;
          }
          
          // exibir a tela de status baseada no status da adoção

          (ds.data()?['Status'] != 'Adoção negada' && ds.data()?['Status'] != 'Cancelada por usuário') ?
          listaStatus.add(
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text('Aqui você pode acompanhar o andamento da adoção do/a ${info['Nome animal']}',
                  style: const TextStyle(),
                  ),
                ),
                Stepper(
                  currentStep: etapa,
                  controlsBuilder: (context, details) {
                    return Container();      
                  },
                  steps:
                  [
                    Step(title: const Text('Em análise',style: TextStyle(fontFamily: 'AsapCondensed-Bold',fontSize: 18),), content: const Text('Aguardando a ong analisar o pedido',style: TextStyle(fontFamily: 'AsapCondensed-Medium'),),isActive: etapa == 0 ? true:false),
                    Step(title: const Text('Dados analisados',style: TextStyle(fontFamily: 'AsapCondensed-Bold',fontSize: 18),), content: const Text('Você ja pode ir buscar seu peludo na ong',style: TextStyle(fontFamily: 'AsapCondensed-Medium'),),isActive: etapa == 1 ? true:false),
                    Step(title: const Text('Finalizada',style: TextStyle(fontFamily: 'AsapCondensed-Bold',fontSize: 18),), content: const Text('Adoção finalizada, Cuide Muito bem do seu pet',style: TextStyle(fontFamily: 'AsapCondensed-Medium'),),isActive: etapa == 2? true:false)
                  ]
                ),
                const SizedBox(height: 20,),

                ds.data()?['Status'] != 'Finalizada' ?

                GestureDetector(
                  onTap: () async {
                    print('cancelar adocao');
                    mostrarDialogoDeConfirmacao(context,ds.data()?['Id adoção'],ds.data()?['Id ong'],ds.data()?['Id animal']);
                  },
                  child: Material(
                    color: const Color.fromARGB(255, 250, 63, 6),
                    elevation: 4,
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 250, 63, 6),
                        borderRadius: BorderRadius.circular(5)
                      ),
                      
                      child: const Text('Cancelar processo de adoção',style: TextStyle(color:  Color.fromARGB(255, 255, 255, 255)),),
                    ),
                  ),
                ):const SizedBox()

                
              ],
            ),
          )
          :

          ds.data()?['Status'] != 'Cancelada por usuário' ?

          listaStatus.add(
            const SizedBox(
              width: double.infinity,
              child: Text('Sua adoção foi negada, infelizmente voçe não pode adotar esse pet'),
            )

          ):
          listaStatus.add(
            const SizedBox(
              width: double.infinity,
              child: Text('Você cancelou esse processo!!!'),
            )
          );

          
          atualiza.value += 1;
        }
      }
      else{
        print('tinha nada');
      }

    });
  }

 }
}

// ignore: must_be_immutable
class StatusAdocaoPage extends StatelessWidget {
  StatusAdocaoPage({super.key});
  var statusAdocaoController = Get.put(StatusAdocaoController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<StatusAdocaoController>(
        init: StatusAdocaoController(),
        builder: (_) {
          return Scaffold(
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
            body: FutureBuilder(
              future: statusAdocaoController.func(context),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
                      child: Obx(
                        () =>
                        statusAdocaoController.atualiza.value != -1 ?
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: statusAdocaoController.listaStatus
                        ):
                        const SizedBox(),
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


























