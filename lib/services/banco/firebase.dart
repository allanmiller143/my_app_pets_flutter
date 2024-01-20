// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:random_string/random_string.dart';
import 'package:replica_google_classroom/App_pages/ongPages/perfilOng.dart';
import 'package:replica_google_classroom/controller/userController.dart';

class BancoDeDados{

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
      .collection('pets').doc(petInfo['Id']).set(petInfo);
      
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
          if (settingsController.usuario['Pets'][i]['Id'] == petId) {
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
      meuControllerGlobal.salvarImagemPerfil(downloadURL);

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
      SettingsPageController settingsController;
      meuControllerGlobal = Get.find();
      settingsController = Get.find();

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

    
}

