// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/App_pages/app_widgets/sem_internet.dart';
import 'package:replica_google_classroom/controller/userController.dart';

class DetalhesAdocaoController extends GetxController {
  late MeuControllerGlobal meuControllerGlobal;
  Map<String,dynamic> listInfo = Get.arguments[0];
  String titulo = Get.arguments[1];

  func() async {
    meuControllerGlobal = Get.find();
    if(meuControllerGlobal.internet.value){
      return 'allan';
    }
    
  }

  List<Widget> construirInfo(){
    List<Widget> list = [];
    listInfo.forEach((String key, dynamic item) {
      if(key != 'Imagem'){
        Widget widget =  ListTile(
          title: Text(
            '$key: ',
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontFamily: 'AsapCondensed-Medium',
              fontSize: 18
            ),
          ),
          subtitle: Text(
            item,
          ),
        );
        list.add(widget);
      }else{
        Widget widget = Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            image: DecorationImage(image: NetworkImage(item),fit: BoxFit.cover)
          ),
          
        );
        list.add(widget);

      }
    });
    return list; 
  }

}

    




    


 


// ignore: must_be_immutable
class DetalhesAdocaoPage extends StatelessWidget {
  DetalhesAdocaoPage({super.key});
  var detalhesAdocaoController = Get.put(DetalhesAdocaoController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<DetalhesAdocaoController>(
        init: DetalhesAdocaoController(),
        builder: (_) {
          return Scaffold(
             appBar: AppBar(
              toolbarHeight: MediaQuery.of(context).size.height * 0.1,
              backgroundColor: const Color.fromARGB(255, 250, 63, 6),
              centerTitle: true,
              title: Text(
                'Detalhes do ${detalhesAdocaoController.titulo}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 255, 255, 255)),
              ),
              leading: IconButton(
                onPressed: () { Get.back(); },
                icon: Icon(Icons.arrow_back_ios, color: Color.fromARGB(255, 255, 255, 255),)
              ),
              
            ),
            body: FutureBuilder(
              future: detalhesAdocaoController.func(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: detalhesAdocaoController.construirInfo()
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
