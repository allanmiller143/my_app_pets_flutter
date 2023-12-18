// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
class FeedDetail extends StatelessWidget {


  dynamic imagembd; // imsgem que puxa do banco de dados
  int? tipo;

  FeedDetail({required this.imagembd, this.tipo = 2});

  ImageProvider<Object> getImageProvider() {
      final Uint8List bytes = base64.decode(imagembd);
      return MemoryImage(Uint8List.fromList(bytes));
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = getImageProvider();
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
         
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
