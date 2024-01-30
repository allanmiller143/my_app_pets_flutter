
// ignore_for_file: use_key_in_widget_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/App_pages/adopt_pages/ong/adocoes.dart';
import 'package:replica_google_classroom/App_pages/adopt_pages/ong/detalhesAdocao.dart';
import 'package:replica_google_classroom/App_pages/adopt_pages/ong/todasAdocoes.dart';
import 'package:replica_google_classroom/App_pages/adopt_pages/user/Status_page.dart';
import 'package:replica_google_classroom/App_pages/adopt_pages/user/adocoes.dart';
import 'package:replica_google_classroom/App_pages/adopt_pages/user/confirm_page.dart';
import 'package:replica_google_classroom/App_pages/adopt_pages/user/data_page.dart';
import 'package:replica_google_classroom/App_pages/adopt_pages/user/insert_user_data_page.dart';
import 'package:replica_google_classroom/App_pages/chat/chat_conversa.dart';
import 'package:replica_google_classroom/App_pages/ongPages/componentesOngPerfil/OngInfoEditPage.dart';
import 'package:replica_google_classroom/App_pages/ongPages/my_principal_ong_page.dart';
import 'package:replica_google_classroom/App_pages/ongPages/perfilOng.dart';
import 'package:replica_google_classroom/App_pages/usuarioPages/x.dart';
import 'package:replica_google_classroom/controller/userController.dart';
import 'package:replica_google_classroom/firebase_options.dart';
import 'App_pages/ongPages/componentesOngPerfil/ImageViewerPage.dart';
import 'loginPages/signIn.dart';
import 'loginPages/signUp.dart';
import 'servicos/mongodb.dart';
import 'loginPages/esqueciSenha.dart';
import 'registerPages/My_data_page_ong.dart';
import 'registerPages/my_who_are_you_page.dart';
import 'App_pages/usuarioPages/my_principal_app_page.dart';
import 'App_pages/usuarioPages/test.dart';
import 'App_pages/usuarioPages/animal_detail_page.dart';
import 'App_pages/usuarioPages/favorits.dart';
import 'App_pages/ongPages/componentesOngPerfil/ongEditBioProfilePage.dart';
import 'App_pages/ongPages/componentesOngPerfil/editarCampo.dart';
import 'App_pages/ongPages/componentesOngPerfil/editarIdade.dart';
import 'App_pages/ongPages/componentesOngPerfil/editarImagem.dart';
import 'App_pages/ongPages/componentesOngPerfil/editarEndereco.dart';
//import 'exemplo_botao_desativado.dart';

void main() async {
  //await MongoDataBase.connect(); // esperar conectar com o mongodb
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  Get.put(MeuControllerGlobal());
  runApp(const MyApp());
}

// para usar roteamento usando o getx preciso retornar um getMaterialApp, definir
//a rota  e a lista com as outras páginas
class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      getPages: [
        //GetPage(name: '/',page: () => TodasAdocoesPage(),transition: Transition.rightToLeft,transitionDuration: const Duration(milliseconds: 400)),

        //GetPage(name: '/',page: () => StatusAdocaoPage(),transition: Transition.rightToLeft,transitionDuration: const Duration(milliseconds: 400)),
        //GetPage(name: '/',page: () => DetalhesAdocaoPage(),transition: Transition.rightToLeft,transitionDuration: const Duration(milliseconds: 400)),
        //GetPage(name: '/',page: () => StatusPage(),transition: Transition.rightToLeft,transitionDuration: const Duration(milliseconds: 400)),
        // GetPage(name: '/',page: () => EditarCampoPage(),transition: Transition.rightToLeft,transitionDuration: const Duration(milliseconds: 400)),
        // GetPage(name: '/', page: () => MyPrincipalAppPage()),
        GetPage(name: '/', page: () => MyEmailPage()),
        // GetPage(name: '/', page: () => AnimalInsertPage()),
        GetPage(name: '/signUp', page: () => MySignUpPage(),transition: Transition.rightToLeft,transitionDuration: const Duration(milliseconds: 400)),
        GetPage(name: '/esqueciSenha', page: () => EsqueciSenhaPage(),transition: Transition.rightToLeft,transitionDuration: const Duration(milliseconds: 400)),
        GetPage(name: '/profilePage', page: () => PetsAuxPage()),
        GetPage(name: '/dataOngPage',page: () => MyOngDataPage(),transition: Transition.leftToRight,transitionDuration: const Duration(milliseconds: 400)),   
        GetPage(name: '/whoAreYouPage',page: () => MyWhoAreYouPage(),transition: Transition.rightToLeft),  
        GetPage(name: '/principalAppPage', page: () => MyPrincipalAppPage()),
        GetPage(name: '/principalOngAppPage', page: () => const MyPrincipalOngAppPage()),        
        GetPage(name: '/animalDetail', page: () => AnimalInsertPage()),
        GetPage(name: '/favorits', page: () => FavoritsPage()),
        GetPage(name: '/ongProfilePage', page: () => SettingsPage()),
        //GetPage(name: '/', page: () => OngProfilePage()),
        GetPage(name: '/ongEditBioProfilePage', page: () => OngEditBioProfilePage()),
        GetPage(name: '/imageViewerPage', page: () => ImageViewerPage(),transition: Transition.downToUp,transitionDuration: const Duration(milliseconds: 400)),
        GetPage(name: '/OngInfoEditPage',page: () => OngInfoEditPage(),transition: Transition.downToUp,transitionDuration: const Duration(milliseconds: 400)),
        GetPage(name: '/editarCampo',page: () => EditarCampoPage(),transition: Transition.downToUp,transitionDuration: const Duration(milliseconds: 400)),
        GetPage(name: '/editarIdade',page: () => EditarCampoIdadePage(),transition: Transition.downToUp,transitionDuration: const Duration(milliseconds: 400)),
        GetPage(name: '/editarImagem',page: () => EditarCampoImagemPage(),transition: Transition.downToUp,transitionDuration: const Duration(milliseconds: 400)),
        GetPage(name: '/editarEndereco',page: () => EditarEnderecoPage(),transition: Transition.downToUp,transitionDuration: const Duration(milliseconds: 400)),
        GetPage(name: '/adoptConfirmPage',page: () => AdoptConfirmPage(),transition: Transition.downToUp,transitionDuration: const Duration(milliseconds: 400)),
        //GetPage(name: '/',page: () => AdoptConfirmPage(),transition: Transition.downToUp,transitionDuration: const Duration(milliseconds: 400)),
        GetPage(name: '/insertUserDataPage',page: () => InsertUserDataPage(),transition: Transition.rightToLeft,transitionDuration: const Duration(milliseconds: 400)),
        GetPage(name: '/userDataPage',page: () => UserDataPage(),transition: Transition.rightToLeft,transitionDuration: const Duration(milliseconds: 400)),
        //GetPage(name: '/',page: () => UserDataPage(),transition: Transition.rightToLeft,transitionDuration: const Duration(milliseconds: 400)),
        GetPage(name: '/xPage',page: () => XPage(),transition: Transition.rightToLeft,transitionDuration: const Duration(milliseconds: 400)),
        GetPage(name: '/chatConversa',page: () => ChatConversaPage(),transition: Transition.rightToLeft,transitionDuration: const Duration(milliseconds: 400)),
        GetPage(name: '/statusPage',page: () => StatusAdocaoPage(),transition: Transition.rightToLeft,transitionDuration: const Duration(milliseconds: 400)),
        GetPage(name: '/detalhesAdocao',page: () => DetalhesAdocaoPage(),transition: Transition.rightToLeft,transitionDuration: const Duration(milliseconds: 400)),
        GetPage(name: '/todasAdocoes',page: () => TodasAdocoesPage(),transition: Transition.rightToLeft,transitionDuration: const Duration(milliseconds: 400)),
        GetPage(name: '/adocoes',page: () => AdocaoPage(),transition: Transition.rightToLeft,transitionDuration: const Duration(milliseconds: 400)),
        GetPage(name: '/adocoesUsuario',page: () => UsuarioAdocoesPage(),transition: Transition.rightToLeft,transitionDuration: const Duration(milliseconds: 400)),




      ],
    );
  }
}


