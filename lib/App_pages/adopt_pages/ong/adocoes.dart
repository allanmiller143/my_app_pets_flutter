// ignore_for_file: unnecessary_string_escapes, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:replica_google_classroom/App_pages/adopt_pages/ong/todasAdocoes.dart';
import 'package:replica_google_classroom/App_pages/app_widgets/sem_internet.dart';
import 'package:replica_google_classroom/controller/userController.dart';
import 'package:replica_google_classroom/services/banco/firebase.dart';
import 'package:replica_google_classroom/services/banco/firebase_notification.dart';

class AdocaoController extends GetxController {
  late MeuControllerGlobal meuControllerGlobal;
  List<Widget> listaAdocoes = [];
  var listaDeIds = [];
  RxInt atualiza = 0.obs;
  String filtro = Get.arguments[0]; 

  Stream<QuerySnapshot<Map<String, dynamic>>>? stream;

  getChatrooms(context) async {
      stream = (await BancoDeDados.getAdocoes(meuControllerGlobal.usuario['Id'])) as Stream<QuerySnapshot<Map<String, dynamic>>>?;
      stream?.listen((QuerySnapshot<Map<String, dynamic>> snapshot) async {
      listaAdocoes.clear();
      listaDeIds.clear();
      if (snapshot.docs.isNotEmpty) {
        for (DocumentSnapshot<Map<String, dynamic>> ds in snapshot.docs) {
          var idContato = '${ds.data()?['Id usuario']}-${ds.data()?['Id animal']}'; 
          var user = await BancoDeDados.getUsuarioPorId(ds.data()?['Id usuario']);

          var pet;
          if( ds.data()?['Status'] == 'Finalizada'){
            pet = await BancoDeDados.getPetPorIdAdotado(ds.data()?['Id ong'],ds.data()?['Id animal']);
          }else{
            pet = await BancoDeDados.getPetPorId(ds.data()?['Id ong'],ds.data()?['Id animal']);
          }

          

          Timestamp timestamp = ds.data()?['Hora adoção'] as Timestamp;
          // Converter Timestamp para DateTime
          DateTime dateTime = timestamp.toDate();
          // Formatar a hora como uma string (você pode ajustar o formato conforme necessário)
          String data = DateFormat('dd/MM/yyyy').format(dateTime);
          // Remover a parte do fuso horário
          data = data.replaceAll(' UTC-3', '');
          var info = {
            'Nome usuario': user.docs[0]['Nome'],
            'Rua': user.docs[0]['Rua'],
            'Nome completo': user.docs[0]['Nome completo'],
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
            'Hora adoção': data,
            'Id usuario': ds.data()?['Id usuario'],
            'Status': ds.data()?['Status'],
            'Id adoção': ds.data()?['Id adoção'],
            'Id ong': ds.data()?['Id ong'],
            'Token': user.docs[0]['Token'],
          };
        
          if(filtro == 'Todas adoções'){
            if(!listaDeIds.contains(idContato)){
              listaAdocoes.add(cardAdocao(info,context));
              listaDeIds.add(idContato);
            }
          }else if(filtro == 'Aguardando avalição dos dados'){
              if(!listaDeIds.contains(idContato) && ds.data()?['Status'] == 'Aguardando avalição dos dados'){
                listaAdocoes.add(cardAdocao(info,context));
                listaDeIds.add(idContato);
              }
          }else if(filtro == 'Aguardando usuário'){
            if(!listaDeIds.contains(idContato) && ds.data()?['Status'] == 'Domentação aprovada'){
              listaAdocoes.add(cardAdocao(info,context));
              listaDeIds.add(idContato);
            }
          }else if(filtro == 'Negadas'){
            if(!listaDeIds.contains(idContato) && ds.data()?['Status'] == 'Adoção negada'){
              listaAdocoes.add(cardAdocao(info,context));
              listaDeIds.add(idContato);
            }
          }else{
            if(!listaDeIds.contains(idContato)&& ds.data()?['Status'] == 'Finalizada'){
              listaAdocoes.add(cardAdocao(info,context));
              listaDeIds.add(idContato);
            }  
          }
          
          atualiza.value += 1;
        }
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
  Widget cardAdocao (info,context){
    return Column(
      children: [
        Material(
          borderRadius: BorderRadius.circular(5),
          elevation: 5,
          child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(15)
              ),
              padding: const  EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(info['Status'],style: const TextStyle(fontWeight: FontWeight.w200,fontSize: 10),),
                      Text(info['Hora adoção'],style:const  TextStyle(fontWeight: FontWeight.w200,fontSize: 10),),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 45,
                            height: 45,
                            decoration:  BoxDecoration(
                              color: Colors.black12,
                              borderRadius:const BorderRadius.all(Radius.circular(30),
                            ),
                            image: DecorationImage(image: NetworkImage(info['Imagem']),fit: BoxFit.cover)
                            ),
                          ),
                          const SizedBox(width: 10,),
                           Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 150,
                                child: Text('${info['Nome animal']} - ${info['Idade']}',style:const  TextStyle(overflow: TextOverflow.ellipsis),)
                                ),
                              Text(info['Raça'],style:const  TextStyle(fontWeight: FontWeight.w300, fontSize: 10),),
                                  
                            ],
                          ),
                        ],
                      ),
                      IconButton(onPressed: () async{
                        var chatRoomId = getChatRoomByUserName(meuControllerGlobal.usuario['Id'],info['Id usuario']); // quem envia e quem recebe 
                        Map<String, dynamic> chatRoomInfoMap = {
                          'users' : [meuControllerGlobal.usuario['Id'],info['Id usuario']],
                        };
                        await BancoDeDados.criaChatRoom(chatRoomId, chatRoomInfoMap);
                        Get.toNamed('/chatConversa',arguments: [info['Id usuario'], info['Nome usuario']]);
                      }, icon:const  Icon(Icons.chat,size: 18,))
                    ],
                  ),
                 const  Divider(),
                  Text(info['Nome-numero'], 
                    style: const TextStyle(
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis,
                      
                      ),
                    ),
                  Text('${info['Localizacao']}, ${info['Rua']}',
                  style: const TextStyle(
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w300
                    ),
                  ),
                  const SizedBox(height: 5,),
                  const Divider(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: (){
                          showBottomSheet(context,info);
                        },
                        child: const Text('Ver detalhes',style: TextStyle(color: Colors.blueAccent),)
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ( filtro != 'Todas adoções' && filtro != 'Finalizada'&& filtro != 'Negadas')?
                      
                      GestureDetector(
                        onTap: () async {
                          String id = getChatRoomByUserName(info['Id usuario'],'${meuControllerGlobal.usuario['Id']}-${info['Id animal']}');
                          String status = '';
                          TodasAdocoesController todasAdocoesController;
                          todasAdocoesController = Get.find();

                          if(filtro == 'Aguardando avalição dos dados'){
                            status = 'Domentação aprovada';
                            todasAdocoesController.aguardandoAvaliacao.value -= 1;
                            todasAdocoesController.aguardandoUsuario.value += 1;    
                          }else {
                            status = 'Finalizada';
                            todasAdocoesController.aguardandoUsuario.value -= 1;                             
                            
                            for(var animal in  meuControllerGlobal.usuario['Pets']){
                              if(animal['Id animal'] == info['Id animal']){
                                meuControllerGlobal.usuario['Pets'].remove(animal);
                                break;
                              }

                            }
                            
                            await BancoDeDados.moverPetParaPetsAdotados(info['Id ong'], info['Id animal'], info['Imagem']);

                          }
                          await FirebaseNotification().send(info['Token'], 'Atualização de status de adoção', status);
                          await BancoDeDados.AlterarStatusAdocao(id,status);
                        },
                        child: const Text('Confirmar adoção',style: TextStyle(color: Colors.blueAccent)
                        )
                      ):
                      const SizedBox(),
                      ( filtro != 'Todas adoções' && filtro != 'Finalizada' && filtro != 'Negadas')?
                      GestureDetector(
                        onTap: () async {
                          String id = getChatRoomByUserName(info['Id usuario'],'${meuControllerGlobal.usuario['Id']}-${info['Id animal']}');
                          String status = '';

                          if(filtro == 'Aguardando avalição dos dados'){
                            status = 'Adoção negada';
                          }

                          await FirebaseNotification().send(info['Token'], 'Atualização de status de adoção', status);
                          await BancoDeDados.AlterarStatusAdocao(id,status);
                          await BancoDeDados.alterarPetInfo({'Em processo de adoção': false}, meuControllerGlobal.usuario['Id'], info['Id animal']);
                        },
                        child: const Text('Negar adoção',style: TextStyle(color: Color.fromARGB(255, 255, 68, 68))
                        )
                      ):
                      const SizedBox(),
                    ],
                  )
                ],
              ),
            
          ),
        ),
        const SizedBox(height: 15,)
      ],
    );
       
  }

  void showBottomSheet(BuildContext context,Map<String,dynamic>info) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          // Conteúdo do BottomSheet
          child: Column(
            children: [
              const ListTile(
                title: Text(
                  'Detalhes',
                  style: TextStyle(
                      fontSize: 25,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'AsapCondensed-Medium'),
                ),
              ),
              ListTile(
                title:const  Text(
                  'Informações do pet',
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'AsapCondensed-Medium'),
                ),
                leading: const Icon(
                  Icons.pets,
                  color: Color.fromARGB(255, 255, 84, 16),
                ),
                onTap: () {
                  var infoPet = {
                    'Imagem': info['Imagem'],
                    'Id animal': info['Id animal'],
                    'Nome animal': info['Nome animal'],
                    'Idade': info['Idade'],
                    'Raça': info['Raça'],
                    'Sexo': info['Sexo'],
                    'Porte': info['Porte'],
                  };
                  Get.toNamed('detalhesAdocao',arguments: [infoPet,'pet']);
                }   
           
              ),
              ListTile(
                title: const Text(
                  'Informações do adotador',
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'AsapCondensed-Medium'),
                ),
                leading:const  Icon(
                  Icons.person,
                  color: Color.fromARGB(255, 255, 84, 16),
                ),
                onTap: () {
                  var infoUser = {
                    'Nome completo': info['Nome completo'],
                    'Rua': info['Rua'],
                    'Bairro': info['Bairro'],
                    'Cidade': info['Cidade'],
                    'Numero': info['Numero'],
                    'Estado': info['Estado'],
                    'Telefone': info['Telefone'],
                  };
                  Get.toNamed('detalhesAdocao',arguments: [infoUser,'usuario']);
                },
              ),
            ],
          ),
        );
      },
    );
  }




  func(context) async {
    meuControllerGlobal = Get.find();
    if(meuControllerGlobal.internet.value){
      await getChatrooms(context);
      return stream;
    }
    
    
  }

 
}

// ignore: must_be_immutable
class AdocaoPage extends StatelessWidget {
  AdocaoPage({super.key});
  var adocaoController = Get.put(AdocaoController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<AdocaoController>(
        init: AdocaoController(),
        builder: (_) {
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: MediaQuery.of(context).size.height * 0.1,
              backgroundColor: const Color.fromARGB(255, 250, 63, 6),
              centerTitle: true,
              title:  Text(
                adocaoController.filtro,
                style: const TextStyle(fontSize: 20,fontFamily: 'AsapCondensed-Medium', fontWeight: FontWeight.w500, color: Color.fromARGB(255, 255, 255, 255)),
              ),
              leading: IconButton(onPressed: (){Get.back();}, icon: const Icon(Icons.arrow_back_ios),color: const Color.fromARGB(255, 255, 255, 255),),
              
            ),
            body: FutureBuilder(
              future: adocaoController.func(context),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Container(
                      margin: const EdgeInsets.all(15),
                      child: Obx(
                        () => SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: adocaoController.atualiza.value != 0 ? adocaoController.listaAdocoes : adocaoController.listaAdocoes
                               
                          ),
                        ),
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
