// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:random_string/random_string.dart';
import 'package:replica_google_classroom/App_pages/ongPages/perfilOng.dart';
import 'package:replica_google_classroom/controller/userController.dart';
import 'package:replica_google_classroom/widgets/load_widget.dart';

class BancoDeDados{

  static Future<bool> verificarCpfExistente(String cpf,String campo) async {
    // Consulta se existe algum usuário com o mesmo CPF
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .where(campo, isEqualTo: cpf)
        .get();

    return query.docs.isNotEmpty;
  }
  static Future<bool> verificarEmailExistente(String email) async {
    // Consulta se existe algum usuário com o mesmo CPF
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .where('Email representante', isEqualTo: email)
        .get();

    return query.docs.isNotEmpty;
  }
  static Future<bool> verificarTelefoneExistente(String telefone) async {
    // Consulta se existe algum usuário com o mesmo CPF
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .where('Telefone', isEqualTo: telefone)
        .get();

    return query.docs.isNotEmpty;
  }

  //adiciona informações sobre um usuario no firebase firestore
  static Future addUsuarioDetalhes(Map<String,dynamic> infoMap, String id)async{
    try{
      return await FirebaseFirestore.instance
      .collection("users")
      .doc(id)
      .set(infoMap); 
    } catch(e){
      print('Erro ao cadastrar usuário: $e');
    }
  }
  static adicionarInformacoesUsuario(Map<String, dynamic> novasInformacoes,String id,) async {
    try {
     
      await FirebaseFirestore.instance.collection('users').doc(id).update(novasInformacoes);
     
      print('Informações do usuário atualizadas com sucesso!');
    } catch (e) {
      print('Erro ao atualizar informações do usuário: $e');
    }
  }
  static adicionarPet(Map<String, dynamic> petInfo, String userId) async {
    try {
      // cria um id unico para a foto
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      // Referência ao local no Firebase Storage onde o arquivo será armazenado
      Reference storageReference = FirebaseStorage.instance.ref().child('pets/$userId/$fileName');
      // Upload do arquivo
      await storageReference.putFile(petInfo['Imagem']);
      // Obter a URL do arquivo no Firebase Storage
      String downloadURL = await storageReference.getDownloadURL();

      petInfo['Imagem'] = downloadURL;


      // Adiciona o novo pet à coleção 'pets' dentro do documento do usuário
      MeuControllerGlobal meuControllerGlobal;
      meuControllerGlobal = Get.find();
      meuControllerGlobal.usuario['Pets'].add(petInfo);
      
      await FirebaseFirestore
      .instance
      .collection('users')
      .doc(userId)
      .collection('pets').doc(petInfo['Id animal']).set(petInfo);
      
      print('Pet adicionado com sucesso!');
    } catch (e) {
      print('Erro ao adicionar pet: $e');
    }
  }
  static Future<void> removerPet(String userId, String petId, String url) async {
    try {
      // apagar a foto do storage
      Reference oldStorageReference = FirebaseStorage.instance.refFromURL(url);
      await oldStorageReference.delete();

      // Referência ao documento do pet dentro da coleção 'pets' do usuário
      DocumentReference petReference = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('pets')
          .doc(petId);

      // Exclui o documento do pet
      await petReference.delete();

      print('Pet removido com sucesso!');
    } catch (e) {
      print('Erro ao remover pet: $e');
    }
  }



  static Future<void> removerFotoFeed(String userId, String idImagem, String url) async {
    try {
      // apagar a foto do storage
      Reference oldStorageReference = FirebaseStorage.instance.refFromURL(url);
      await oldStorageReference.delete();

      // Referência ao documento do pet dentro da coleção 'pets' do usuário
      DocumentReference feedReference = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('feed')
          .doc(idImagem);

      // Exclui o documento do pet
      await feedReference.delete();

      print('imagem removida com sucesso!');
    } catch (e) {
      print('Erro ao remover imagem: $e');
    }
  }




  static Future<List<Map<String, dynamic>>> obterPetsDoUsuario(String userId) async {
    try {
      QuerySnapshot petsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('pets')
          .get();

      List<Map<String, dynamic>> petsList = [];

      petsSnapshot.docs.forEach((DocumentSnapshot document) {
        petsList.add(document.data() as Map<String, dynamic>);
      });

      return petsList;
    } catch (e) {
      print('Erro ao obter pets do usuário: $e');
      return [];
    }
  }
  static Future<List<Map<String, dynamic>>> obterPets() async {
  try {
    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('Tipo', isEqualTo: 'ong')
        .get();

    List<Map<String, dynamic>> petsList = [];

    for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
      // Obtenha a coleção de pets para cada usuário do tipo "ong"
      QuerySnapshot petsSnapshot = await userDoc.reference.collection('pets').get();

      // Adicione os dados dos pets à lista
      petsSnapshot.docs.forEach((DocumentSnapshot petDoc) {
        Map<String, dynamic> petData = petDoc.data() as Map<String, dynamic>;
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        userData['Tipo'];

        // Adicione todas as chaves e valores de userDoc.data() a petData
        petData.addAll(userData);
        petsList.add(petData);
      });
    }

    return petsList;
  } catch (e) {
    print('Erro ao obter pets: $e');
    return [];
  }
}

   static Future<List<Map<String, dynamic>>> petsPreferidos(String userId) async {
    try {
      QuerySnapshot petsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('pets preferidos')
          .get();

      List<Map<String, dynamic>> petsList = [];

      petsSnapshot.docs.forEach((DocumentSnapshot document) {
        petsList.add(document.data() as Map<String, dynamic>);
      });

      return petsList;
    } catch (e) {
      print('Erro ao obter pets do usuário: $e');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> obterImagensFeedDoUsuario(String userId) async {
    try {
      QuerySnapshot petsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('feed')
          .get();

      List<Map<String, dynamic>> feedList = [];

      petsSnapshot.docs.forEach((DocumentSnapshot document) {
        feedList.add(document.data() as Map<String, dynamic>);
      });

      return feedList;
    } catch (e) {
      print('Erro ao obter as imagens do feed do usuário: $e');
      return [];
    }
  }
  static alterarPetInfo(Map<String, dynamic> novasInformacoes,String userId,String petId,) async {
    try {
      if(novasInformacoes['Imagem'] != null){

        MeuControllerGlobal meuControllerGlobal;
        SettingsPageController settingsController;
        settingsController = Get.find();
        meuControllerGlobal = Get.find();

        Reference oldStorageReference = FirebaseStorage.instance.refFromURL(novasInformacoes['url']);
        await oldStorageReference.delete();


        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        // Referência ao local no Firebase Storage onde o arquivo será armazenado
        Reference storageReference = FirebaseStorage.instance.ref().child('pets/$userId/$fileName');
        // Upload do arquivo
        await storageReference.putFile(novasInformacoes['Imagem']);
        // Obter a URL do arquivo no Firebase Storage
        String downloadURL = await storageReference.getDownloadURL();


        for (int i = 0; i < settingsController.usuario['Pets'].length; i++) {
          if (settingsController.usuario['Pets'][i]['Id animal'] == petId) {
            settingsController.usuario['Pets'][i]['Imagem'] = downloadURL;
            meuControllerGlobal.usuario['Pets'][i]['Imagem'] = downloadURL;
            break;
          }
         }
         
         novasInformacoes = {'Imagem' : downloadURL};
        // alterar a imagem do storage
      }
      


      await FirebaseFirestore.instance.collection('users').doc(userId).collection('pets').doc(petId).update(novasInformacoes);
      print('Informações do Pet atualizadas com sucesso!');
    } catch (e) {
      print('Erro ao atualizar informações do Pet: $e');
    }
  }
  static Future saveImageToFirestore(File imageFile, String userId, String urlAntiga) async {
    try {
      //apagar a antiga   
      if (urlAntiga != '') {
        Reference oldStorageReference = FirebaseStorage.instance.refFromURL(urlAntiga);
        await oldStorageReference.delete();
      }
      // cria um id unico para a foto
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      // Referência ao local no Firebase Storage onde o arquivo será armazenado
      Reference storageReference = FirebaseStorage.instance.ref().child('profile_images/$userId/$fileName');
      // Upload do arquivo
      await storageReference.putFile(imageFile);
      // Obter a URL do arquivo no Firebase Storage
      String downloadURL = await storageReference.getDownloadURL();
      // crio uma instancia no controlador global para salvar o dado da foto de perfil do usuario 
      MeuControllerGlobal meuControllerGlobal;
      meuControllerGlobal = Get.find();
      meuControllerGlobal.usuario['ImagemPerfil'] = downloadURL;

      // insire os dados no firesrtore
      await FirebaseFirestore
      .instance
      .collection('users')
      .doc(userId)
      .update({'ImagemPerfil': downloadURL});
    } catch (e) {
      print('Erro ao salvar a imagem no Firestore: $e');
    }
  }
  static Future saveFeedImageToFirestore(File imageFile, String userId) async {
    try {
      // cria um id unico para a foto
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      // Referência ao local no Firebase Storage onde o arquivo será armazenado
      Reference storageReference = FirebaseStorage.instance.ref().child('feed/$userId/$fileName');
      // Upload do arquivo
      await storageReference.putFile(imageFile);
      // Obter a URL do arquivo no Firebase Storage
      String downloadURL = await storageReference.getDownloadURL();
      String id = randomAlphaNumeric(10);

      var feedImagem = {
        'Id': id,
        'Imagem' : downloadURL
      };

      // crio uma instancia no controlador global para salvar o dado da foto de perfil do usuario 
      MeuControllerGlobal meuControllerGlobal;
      meuControllerGlobal = Get.find();
      meuControllerGlobal.usuario['Imagens feed'].add(feedImagem);

      await FirebaseFirestore
      .instance
      .collection('users')
      .doc(userId)
      .collection('feed')
      .doc(id)
      .set(feedImagem);

    } catch (e) {
      print('Erro ao salvar a imagem no Firestore: $e');
    }
  }
  //retorna as informações de um usuario que forneceu um email
  static Future<QuerySnapshot> getUsuarioPorEmail(String email)async{
    return await FirebaseFirestore.instance.collection('users').where('E-mail', isEqualTo: email).get();
  }

  static Future<QuerySnapshot> getUsuarioPorId(String id)async{
    return await FirebaseFirestore.instance.collection('users').where('Id', isEqualTo: id).get();
  }


  // retorna uma lista com todos os usuarios que comecam uma letra especifica.
  
  static Future<QuerySnapshot>pesquisa(String nome) async {
    return await FirebaseFirestore.instance.collection('users').where('Pesquisa', isEqualTo: nome[0]).get();
  }

  static Future<QuerySnapshot> getPetPorId(String ongId, String petId) async {
  return await FirebaseFirestore.instance
      .collection('users')
      .doc(ongId)
      .collection('pets')
      .where('Id animal', isEqualTo: petId)  
      .get();
}


  static Future<QuerySnapshot> getPetPorIdAdotado(String ongId, String petId) async {
  return await FirebaseFirestore.instance
      .collection('users')
      .doc(ongId)
      .collection('pets adotados')
      .where('Id animal', isEqualTo: petId)  
      .get();
}




  static criaChatRoom(String chatRoomId,Map<String,dynamic> chatRoomInfoMap) async{
    // cria uma chat novo se nao existe.

    print('----------------------------------');
    print('chatRoomId: $chatRoomId\nchatRoomInfoMap: $chatRoomInfoMap');
    final snapshot = await FirebaseFirestore.instance.collection('chatrooms').doc(chatRoomId).get();
    print(snapshot.data());
    if(snapshot.exists){
      print('Chat ja existe');
      return true;
    }else{
      print('nao existe');
      return FirebaseFirestore.instance.collection('chatrooms').doc(chatRoomId).set(chatRoomInfoMap);
    }
  }

  static Future addMensagem(String chatRoomId,String idMensagem,Map<String,dynamic> infoMensagemMap) async{ 
    return FirebaseFirestore.instance
    .collection('chatrooms')
    .doc(chatRoomId)
    .collection('chats')
    .doc(idMensagem)
    .set(infoMensagemMap);
  }

  static atualizaUltimaMensagem(String chatRoomId,Map<String,dynamic> ultimaMensagemEnviadaMap) async {
    return await FirebaseFirestore.instance.collection('chatrooms').doc(chatRoomId).update(ultimaMensagemEnviadaMap);
  }

  static Future<Stream<QuerySnapshot>> getChatRooms(String id) async {
    return FirebaseFirestore
        .instance
        .collection('chatrooms')
        .orderBy('time',descending: true)
        .where('users', arrayContains: id)
        .snapshots();
}

  static Future<Stream<QuerySnapshot>> getMensagens(String chatRoomId) async {
    return FirebaseFirestore
    .instance
    .collection('chatrooms')
    .doc(chatRoomId)
    .collection('chats')
    .orderBy('time',descending: false)
    .snapshots();
  }



 
static adotar(String idAdocao, Map<String,dynamic> info) async {
  // Cria uma adoção nova se não existe.
  final snapshot = await FirebaseFirestore.instance.collection('adocoes').where('Id adoção',isEqualTo: idAdocao).get();
  final querySnapshot = await FirebaseFirestore.instance.collection('adocoes').where('Id animal', isEqualTo: info['Id animal']).get();
         
  if (snapshot.docs.isNotEmpty ) {
    if(snapshot.docs[0]['Status'] == "Cancelada por usuário"){
      if(querySnapshot.docs.isNotEmpty){
        bool alguem = false;
        querySnapshot.docs.forEach((QueryDocumentSnapshot doc) {
        print('entrei');
        if(doc['Status'] != "Cancelada por usuário"){
          alguem = true;
        }
      });
      if(alguem){
        mySnackBar('Um usuário já abriu um processo de adoção para esse pet', false);
        return true;
      }else{
        FirebaseFirestore.instance.collection('users').doc(info['Id ong']).collection('pets').doc(info['Id animal']).update({'Em processo de adoção': true});
        mySnackBar('Processo de adoção reaberto, aguarde a ong analisar seu pedido', true);
        return FirebaseFirestore.instance.collection('adocoes').doc(idAdocao).set(info);
      }

      }

    }
    else{
      mySnackBar('Você já abriu um processo de adoção nesse pet', false);
      return true;
    }
 
  } else if (querySnapshot.docs.isNotEmpty) {
    bool alguem = false;
    querySnapshot.docs.forEach((QueryDocumentSnapshot doc) {
      print('entrei');
      if(doc['Status'] != "Cancelada por usuário" && doc['Status'] != "Adoção negada" ){
        alguem = true;
      }
    });

    if(alguem){
      mySnackBar('Um usuário já abriu um processo de adoção para esse pet', false);
      return true;
    }
    else{
      mySnackBar('Aguarde a ONG analisar o seu pedido', true);
      FirebaseFirestore.instance.collection('users').doc(info['Id ong']).collection('pets').doc(info['Id animal']).update({'Em processo de adoção': true});
      return FirebaseFirestore.instance.collection('adocoes').doc(idAdocao).set(info);

    }
    // Verifica se a consulta não está vazia (ou seja, se já existe uma adoção para o mesmo pet).
    
  } else {
    mySnackBar('Aguarde a ONG analisar o seu pedido', true);
    FirebaseFirestore.instance.collection('users').doc(info['Id ong']).collection('pets').doc(info['Id animal']).update({'Em processo de adoção': true});
    return FirebaseFirestore.instance.collection('adocoes').doc(idAdocao).set(info);
    
  }
}


  static Future<Stream<QuerySnapshot>> getAdocoes(String id) async {
    print(id);
    return FirebaseFirestore
        .instance
        .collection('adocoes')    
        .where('Id ong', isEqualTo: id)
        .orderBy('Hora adoção',descending: true)
        .snapshots();
}

  // ignore: non_constant_identifier_names
  static AlterarStatusAdocao(String id,String status) async {
    try {
      print(id);
      await FirebaseFirestore.instance.collection('adocoes').doc(id).update({'Status': status});
     
      print('Informações da adocao atualizadas com sucesso!');
    } catch (e) {
      print('Erro ao atualizar informações da adoção: $e');
    }
  }




  static Future<Stream<QuerySnapshot>> getAdocoesUsuario(String id) async {
    return FirebaseFirestore
        .instance
        .collection('adocoes')    
        .where('Id usuario', isEqualTo: id)

        .snapshots();
}

  static Future<Stream<QuerySnapshot>> getAdocaoUsuario(String id) async {
    return FirebaseFirestore
        .instance
        .collection('adocoes')    
        .where('Id adoção', isEqualTo: id)
        .snapshots();
}



static Future<int> numeroDeAdocoes(String idOng, String valor) async {
  int quantidade = 0;

  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('adocoes')
    .where('Id ong', isEqualTo: idOng)
    .where('Status', isEqualTo: valor)
    .get();

  quantidade = querySnapshot.docs.length;

  return quantidade;
}



static Future<void> moverPetParaPetsAdotados(String userId, String petId, String url) async {
  try {
    // Referência ao documento do pet dentro da coleção 'pets' do usuário
    DocumentReference petReference = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('pets')
        .doc(petId);

    // Obtém os dados do pet
    DocumentSnapshot petSnapshot = await petReference.get();

    if (petSnapshot.exists) {
      // Move o pet para a coleção 'pets adotados' do usuário
      await FirebaseFirestore
          .instance
          .collection('users')
          .doc(userId)
          .collection('pets adotados')
          .doc(petId)
          .set(petSnapshot.data() as Map<String, dynamic>);



      // Exclui o documento do pet da coleção 'pets'
      await petReference.delete();

      print('Pet movido para "pets adotados" com sucesso!');
    } else {
      print('Pet não encontrado na coleção "pets".');
    }
  } catch (e) {
    print('Erro ao mover pet: $e');
  }
}




static Future<void> favoritaPet(String idUsuario, bool inserirRetirar, String petId) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  if (inserirRetirar) {
    await users.doc(idUsuario).update({
      'Pets preferidos': FieldValue.arrayUnion([petId]),
    });
  } else {
    await users.doc(idUsuario).update({
      'Pets preferidos': FieldValue.arrayRemove([petId]),
    });
  }
}

static Future<void> excluirConta(String idUsuario) async {
  try {
    // Excluir usuário do Firebase Authentication
    

    // Verificar se o usuário tem adoções pendentes
    QuerySnapshot adocoesSnapshot = await FirebaseFirestore.instance
        .collection('adocoes')
        .where('Id usuario', isEqualTo: idUsuario)
        .get();

    // Verificar se o usuário tem chats
    QuerySnapshot chatsSnapshot = await FirebaseFirestore.instance
        .collection('chatrooms')
        .where('users', arrayContains: idUsuario)
        .get();

    // Iniciar uma transação Firestore
    WriteBatch batch = FirebaseFirestore.instance.batch();
    WriteBatch batch2 = FirebaseFirestore.instance.batch();

    // Atualizar o status das adoções pendentes para "Cancelada por Usuário"
    adocoesSnapshot.docs.forEach((adocaoDoc) async {
      // Pegar o ID da ONG e o ID do animal
      String ongId = adocaoDoc['Id ong'];
      String petId = adocaoDoc['Id animal'];

      // Alterar o estado do pet para false
      DocumentReference petReference = FirebaseFirestore.instance
          .collection('users')
          .doc(ongId)
          .collection('pets')
          .doc(petId);

      batch.update(petReference, {'Em processo de adoção': false});

      // Excluir a adoção
      batch.delete(adocaoDoc.reference);
    });

    // Excluir os chats relacionados ao usuário
    chatsSnapshot.docs.forEach((chatDoc) {
      batch2.delete(chatDoc.reference);
    });

    // Executar as transações
    await batch.commit();
    await batch2.commit();
    print(idUsuario);
    FirebaseFirestore.instance.collection('users').doc(idUsuario).delete();
    await FirebaseAuth.instance.currentUser?.delete();
  } catch (e) {
    print("Erro ao excluir conta: $e");
    // Lide com erros aqui
  }
}


static Future<void> excluirContaOng(String idUsuario,imagemPerfil) async {
  try {

    // Verificar se o usuário tem adoções pendentes
    QuerySnapshot adocoesSnapshot = await FirebaseFirestore.instance.collection('adocoes').where('Id ong', isEqualTo: idUsuario).get();
        
    // Verificar se o usuário tem chats
    QuerySnapshot chatsSnapshot = await FirebaseFirestore.instance.collection('chatrooms').where('users', arrayContains: idUsuario).get();
            
    // verificar se o usuario tem fotos no feed
    QuerySnapshot feed = await FirebaseFirestore.instance.collection('users').doc(idUsuario).collection('feed').get();
    QuerySnapshot pets = await FirebaseFirestore.instance.collection('users').doc(idUsuario).collection('pets').get();

    // apagar as fotos do feed    
    print('--------------------------');  
    feed.docs.forEach((DocumentSnapshot document) async {
      var url = document['Imagem']; 
      print(url);
      Reference oldStorageReference = FirebaseStorage.instance.refFromURL(url);
      await oldStorageReference.delete();
    });
    print('--------------------------'); 



    pets.docs.forEach((DocumentSnapshot document) async {
      
      var url = document['Imagem']; 
      print(url);
      Reference oldStorageReference = FirebaseStorage.instance.refFromURL(url);
      await oldStorageReference.delete();
    });

    print('--------------------------');  


    // Iniciar uma transação Firestore
    WriteBatch batch = FirebaseFirestore.instance.batch();
    WriteBatch batch2 = FirebaseFirestore.instance.batch();

    adocoesSnapshot.docs.forEach((adocaoDoc) async {
      batch.delete(adocaoDoc.reference);
    });
    // Excluir os chats relacionados ao usuário
    chatsSnapshot.docs.forEach((chatDoc) {
      batch2.delete(chatDoc.reference);
    });

    // Executar as transações
    await batch.commit();
    await batch2.commit();

    print(imagemPerfil);
    if(imagemPerfil != ''){
      Reference oldStorageReference = FirebaseStorage.instance.refFromURL(imagemPerfil);
      await oldStorageReference.delete();

    }
    

    FirebaseFirestore.instance.collection('users').doc(idUsuario).delete();
    await FirebaseAuth.instance.currentUser?.delete();
  } catch (e) {
    print("Erro ao excluir conta: $e");
    // Lide com erros aqui
  }
}










    
}

