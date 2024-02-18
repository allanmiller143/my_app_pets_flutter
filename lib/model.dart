import 'package:flutter/material.dart';
import 'package:get/get.dart';

class XController extends GetxController {

  Future<String> func() async {
    return 'allan';
  }

 
}
class UserProfilPage extends StatelessWidget {
  UserProfilPage({Key? key}) : super(key: key);
  var xController = Get.put(XController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<XController>(
        init: XController(),
        builder: (_) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black38,
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const UserAccountsDrawerHeader(
                    accountName:  Text('Allan Miller Silva Lima'),
                    accountEmail:  Text('milerallan17@gmail.com'),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: AssetImage('assets/eu.png'),
                      radius: 30, // ajuste conforme necessário
                    ),
                    currentAccountPictureSize:  Size(60, 60),
                    
                  ),
                  ListTile(
                    leading:const Icon(Icons.favorite),
                    title: const Text('Favoritos'),
                    onTap: () {
                      Get.toNamed('/favorits');
                     
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo),
                    title: const Text('Inserir Foto de Perfil'),
                    onTap: () {
                      // Implementar a lógica para inserir foto de perfil
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.pets),
                    title: const Text('Suas adoções'),
                    onTap: () {
                      // Navegar para a tela de doações
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => DoacoesPage()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: const  Text('Alterar Informações'),
                    onTap: () {
                      // Implementar a lógica para alterar informações
                    },
                  ),
                  ListTile(
                    leading:const  Icon(Icons.delete,color: Colors.red,),
                    title:const  Text('Excluir Conta',style: TextStyle(color: Colors.red),),
                    onTap: () {
                      // Implementar a lógica para excluir conta
                    },
                  ),
                ],
              ),
            ),
            body: FutureBuilder(
              future: xController.func(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Text('data');
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
