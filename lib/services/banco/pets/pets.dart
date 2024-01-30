// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/controller/userController.dart';


adicionarPet(Map<String, dynamic> petInfo, String userId) async {
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