import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/controller/userController.dart';
import 'package:replica_google_classroom/services/banco/firebase.dart';


class UsuarioAdocoesController extends GetxController {
  late MeuControllerGlobal meuControllerGlobal;

  Stream<QuerySnapshot<Map<String, dynamic>>>? stream;
  List<Widget>  listaAdocoes = [];
  var listaDeIds = [];
  RxInt atualiza = 0.obs;

  getAdocoes() async {
      stream = (await BancoDeDados.getAdocoesUsuario(meuControllerGlobal.usuario['Id'])) as Stream<QuerySnapshot<Map<String, dynamic>>>?;
      stream?.listen((QuerySnapshot<Map<String, dynamic>> snapshot) async {
      listaAdocoes.clear();
      listaDeIds.clear();
      if (snapshot.docs.isNotEmpty) {
        for (DocumentSnapshot<Map<String, dynamic>> ds in snapshot.docs) {
          var idContato = '${ds.data()?['Id usuario']}-${ds.data()?['Id animal']}'; 
          var user = await BancoDeDados.getUsuarioPorId(ds.data()?['Id usuario']);

          QuerySnapshot<Object?> pet;
          if(ds.data()?['Status'] == 'Finalizada'){
             pet = await BancoDeDados.getPetPorIdAdotado(ds.data()?['Id ong'],ds.data()?['Id animal']);
             print(pet.docs[0]);
          }
          else{
             pet = await BancoDeDados.getPetPorId(ds.data()?['Id ong'],ds.data()?['Id animal']);
          }
            
        
          var info = {
            'Nome usuario': user.docs[0]['Nome'],
            'Rua': user.docs[0]['Rua'],
            'Nome completo': 'Allan Miller Silva Lima',
            'Bairro': user.docs[0]['Bairro'],
            'Cidade' : user.docs[0]['Cidade'],
            'Numero' : user.docs[0]['Numero'],
            'Estado': user.docs[0]['Estado'],
            'Telefone': user.docs[0]['Telefone'],
            'Localizacao': '${user.docs[0]['Cidade']}, ${user.docs[0]['Estado']}- ${user.docs[0]['cep']}',
            'Nome-numero' :  '${user.docs[0]['Nome completo']} - ${user.docs[0]['Telefone']}',
            'Imagem': pet.docs[0]['Imagem'],
            'Id animal': pet.docs[0]['Id animal'],
            'Nome animal': pet.docs[0]['Nome animal'],
            'Idade': pet.docs[0]['Idade'],
            'Raça': pet.docs[0]['Raça'],
            'Sexo': pet.docs[0]['Sexo'],
            'Porte': pet.docs[0]['Porte'],
            'Tipo': pet.docs[0]['Tipo animal'],
            'Id usuario': ds.data()?['Id usuario'],
            'Status': ds.data()?['Status'],
            'Id adoção':  ds.data()?['Id adoção'],
          };
        

            if(!listaDeIds.contains(idContato)){
              listaAdocoes.add(cardAdocao(info));
              listaDeIds.add(idContato);
            }
         
          atualiza.value += 1;
        }
      }
      else{
        print('tinha nada');
      }
    });
  }
  getChatRoomByUserName(String a,String b){
    if(a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)){
      return "$b\_$a";
    }else{
      return "$a\_$b";
    }
  }

  Widget cardAdocao(info){

    String textoDeApoio = '';

    if(info[ 'Status'] == 'Domentação aprovada'){
      textoDeApoio = 'Você já pode ir buscar seu pet!';
    }else if(info[ 'Status'] == 'Finalizada'){
      textoDeApoio = 'Adoção finalizada, Cuide muito bem do seu peludo';
    }else{
      textoDeApoio = 'Aguarde a ong avaliar os dados';
    }  

    return GestureDetector(
      onTap: (){
        Get.toNamed('/statusPage',arguments: [info]);
      },
      child: Column(
        children: [
          Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(5),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Text('Situação: ${info['Status']}',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 12),)
                      ],
                    ),
                    Divider()
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                          image: DecorationImage(image: NetworkImage(info['Imagem']),fit: BoxFit.cover)
                      ),
                    ),
                    SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${info['Nome animal']}, ${info['Raça']}',
                          style: TextStyle(
                            fontSize: 14,fontWeight: FontWeight.bold, color: Color.fromARGB(235, 0, 0, 0),overflow: TextOverflow.ellipsis
                          ),
                        ),
                        Container(
                          width: 200,
                          child: Text(
                            textoDeApoio,
                            style: TextStyle(fontSize: 9,fontWeight: FontWeight.w200, color: Color.fromARGB(235, 0, 0, 0),overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text('Ver detalhes',
                        style: TextStyle(fontSize: 10,fontWeight: FontWeight.w400, color: Colors.blue,overflow: TextOverflow.ellipsis),
      
                        )
                      ],
                    )
                  ],
                ),
                
                ],
              ),
            ),
          ),
          SizedBox(height: 15,),
        ],
      ),
    );
  }



  Future<Stream<QuerySnapshot<Map<String, dynamic>>>?>func() async {
    meuControllerGlobal = Get.find();
    //await imprimirValoresDaConsulta();
    await getAdocoes();
    return stream;
    
  }

 
}

// ignore: must_be_immutable
class UsuarioAdocoesPage extends StatelessWidget {
  UsuarioAdocoesPage({super.key});
  var usuarioAdocoesController = Get.put(UsuarioAdocoesController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<UsuarioAdocoesController>(
        init: UsuarioAdocoesController(),
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
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Color.fromARGB(255, 255, 255, 255)),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
            body: FutureBuilder(
              future: usuarioAdocoesController.func(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Obx(
                      ()=>
                      usuarioAdocoesController.atualiza.value != -1 ?
                       Padding(
                         padding: const EdgeInsets.fromLTRB(20,20,20,0),
                         child: SingleChildScrollView(
                           child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: usuarioAdocoesController.listaAdocoes
                                                 ),
                         ),
                       ): SizedBox()
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
