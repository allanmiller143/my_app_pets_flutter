// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/App_pages/app_widgets/sem_internet.dart';
import 'package:replica_google_classroom/controller/userController.dart';
import 'package:replica_google_classroom/services/banco/firebase.dart';
import 'package:replica_google_classroom/widgets/load_widget.dart';


class EditarExluirController extends GetxController {
  late MeuControllerGlobal meuControllerGlobal;

  
  void mostrarDialogoDeConfirmacao(context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:const  Text('Excluir conta'),
            content: const Text('Tem certeza que deseja excluir a conta?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); 
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async{
                  await BancoDeDados.excluirConta(meuControllerGlobal.usuario['Id']);
                  
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop(); // Fecha o dialogo

                  Get.toNamed('/');
                },
                child: const  Text('Confirmar'),
              ),
            ],
          );
        },
      );
    }

  func() async {
    meuControllerGlobal = Get.find();
    if(meuControllerGlobal.internet.value){
      return 'allan';
    }
    
  }

 
}

// ignore: must_be_immutable
class EditarExluirPage extends StatelessWidget {
  EditarExluirPage({super.key});
  var editarExluirController = Get.put(EditarExluirController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<EditarExluirController>(
        init: EditarExluirController(),
        builder: (_) {
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: MediaQuery.of(context).size.height * 0.1,
              backgroundColor: const Color.fromARGB(255, 250, 63, 6),
              centerTitle: true,
              title: const Text(
                'Edite ou exclua seus dados',
                style: TextStyle(fontSize: 20,fontFamily: 'AsapCondensed-Medium', fontWeight: FontWeight.w500, color: Color.fromARGB(255, 255, 255, 255)),
              ),
              leading: IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back_ios_new,size: 18, color: Color.fromARGB(255, 255, 255, 255))),  
              
            ),
            
            body: FutureBuilder(
              future: editarExluirController.func(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(15,30,15,0),
                      child: Column(
                        children: [
                          ExcluirWidget(
                            onPressed: (){
                              editarExluirController.mostrarDialogoDeConfirmacao(context);
                            }
                          ),
                          SizedBox(height: 30,),
                          AlterarWidget(
                            onPressed: (){
                              if(editarExluirController.meuControllerGlobal.usuario['Data'] == true){
                                Get.toNamed('/alterarPage');
                              }
                              else{
                                mySnackBar('Você ainda não cadastrou suas informações', false);
                              }
                              print('object');
})
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


class ExcluirWidget extends StatelessWidget {
  final VoidCallback onPressed;
  const ExcluirWidget({super.key,required this.onPressed,}); // Novo parâmetro onChanged
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(5),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10)
          ),
          child: const Center(child:Text('Excluir conta',style: TextStyle(color: Color.fromARGB(241, 255, 0, 0),fontWeight: FontWeight.bold,fontSize: 16),)),
        ),
      ),
    ); 
  }
}

class AlterarWidget extends StatelessWidget {
  final VoidCallback onPressed;
  const AlterarWidget({super.key,required this.onPressed,}); 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(5),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10)
          ),
          child: const Center(child:Text('Alterar dados',style: TextStyle(color: Color.fromARGB(240, 0, 0, 0),fontWeight: FontWeight.bold,fontSize: 16),)),
        ),
      ),
    ); 
  }
}



