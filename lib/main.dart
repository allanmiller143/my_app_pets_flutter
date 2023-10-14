import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'loginPages/my_email_page.dart';
import 'loginPages/my_password_page.dart';
import 'loginPages/my_sign_up_page.dart';
import 'loginPages/myConfirm_page.dart';
import 'services/mongodb.dart';
import 'loginPages/my_forget_pass.dart';
import 'registerPages/my_data_page.dart';
import 'registerPages/My_data_page_ong.dart';
import 'registerPages/my_who_are_you_page.dart';
import 'App_pages/my_principal_app_page.dart';

//import 'exemplo_botao_desativado.dart';

void main() async {
  await MongoDataBase.connect();
  runApp(const MyApp());
}

// para usar roteamento usando o getx preciso retornar um getMaterialApp, definir
//a rota inicial e a lista com as outras páginas
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      getPages: [
        //GetPage(name: '/', page: () => MyPrincipalAppPage()),
        GetPage(name: '/', page: () => MyEmailPage()),
        //GetPage(name: '/', page: () => MyWhoAreYouPage()),
        GetPage(name: '/password', page: () => MyPasswordPage()),
        GetPage(name: '/signUp', page: () => MySignUpPage()),
        GetPage(name: '/confirmPage', page: () => MyConfirmPage()),
        GetPage(name: '/forgetPage', page: () => MyForgetPage()),
        GetPage(name: '/dataPage', page: () => MyDataPage()),
        GetPage(
            name: '/dataOngPage',
            page: () => MyOngDataPage(),
            transition: Transition.leftToRight,
            transitionDuration: Duration(milliseconds: 400)),
        GetPage(
            name: '/whoAreYouPage',
            page: () => MyWhoAreYouPage(),
            transition: Transition.rightToLeft),
        GetPage(name: '/principalAppPage', page: () => MyPrincipalAppPage()),
      ],
    );
  }
}
