
import 'package:flutter/material.dart';

// esse arquivo exibe imagems na aba do feed e de pets de uma Ong. 

// coloquei dois parametros para o o widget, so uma foto do feed comum, e as informações do pet
// ignore: must_be_immutable
class PicFeed extends StatelessWidget {
  dynamic image; // imagem que pega quando insere no app uma foto no feed.
  dynamic petInfo; //  informacoes de um pet
  int? tipo;

  PicFeed({this.image, this.petInfo});

  // Recupera a imagem do bd
  ImageProvider<Object> getImageProvider() {
    // se vier um pet.
    if(petInfo != null){   
      return NetworkImage(petInfo['Imagem']);
    }
    // se vier uma imagem de feed
    else{
      return NetworkImage(image);
    }  
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = getImageProvider();
    return 
    Container(
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.height / 6,
      decoration: BoxDecoration(
        image: DecorationImage(image: imageProvider,fit: BoxFit.cover),
        border: Border.all(color: Colors.black, width: 0.1),
      ),
    );
  }
}
