// ignore_for_file: avoid_print, unused_catch_clause

import 'package:mongo_dart/mongo_dart.dart';
import 'dart:developer';
class MongoDataBase {
  static Db? db;
  static late DbCollection collection;
  static Future<void> connect() async {
    try{
      db = await Db.create( "mongodb+srv://allanmiller:32172528@cluster0.d8cxwn6.mongodb.net/"); 
      await db!.open();
      collection = db!.collection('users');
      print('Conexão com o MongoDB estabelecida com sucesso.');
    }catch (e){
      print('Erro ao conectar ao MongoDB: $e');
      //Você pode lidar com o erro de conexão aqui.
    }
  }

  static Future<void> insereUser(
    nome,
    email,
    password,
  ) async {
    await collection.insertOne({
      'userName': nome,
      'email': email,
      'password': password,
      'data': false,
      'petList': [],
      'preferedPetsList':[],
      'Tipo': '-1'
    });
  }

  static Future<bool> verificaUser(email) async {
    if (email != null && email != '') {
      var consulta = where.eq('email', email);
      var user = await collection.findOne(consulta);
      if (user != null) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  static Future<bool> verificaUserESenha(email, senha) async {
    if (email != null && email != '') {
      var consultaEmail = where.eq('email', email);
      var user = await collection.findOne(consultaEmail);
      if (user != null && user['password'] == senha) {
        return true; // Email e senha correspondem a um registro no banco de dados.
      } else {
        return false; // Email ou senha estão incorretos ou não correspondem.
      }
    }
    return false;
  }

  static Future<String> retornaNome(email) async {
    var consultaEmail = where.eq('email', email);
    var user = await collection.findOne(consultaEmail);
    return user!['userName'].toString();
  }

  static Future<String> retornaCpf(email) async {
    var consultaEmail = where.eq('email', email);
    var user = await collection.findOne(consultaEmail);
    return user!['cpf'].toString();
  }
  
  static Future<String> retornaTipo(email) async {
    var consultaEmail = where.eq('email', email);
    var user = await collection.findOne(consultaEmail);
    return user!['Tipo'].toString();
  }

  static Future<void> trocaSenha(email, novaSenha) async {
    var consultaEmail = where.eq('email', email);
    var user = await collection.findOne(consultaEmail);

    var updatedUser = user;
    updatedUser!['password'] = novaSenha; // Substitua 'password' pelo campo apropriado em seu documento de usuário.
    
    await collection.update(consultaEmail, updatedUser);
  }

  static Future<void> insertUserData(String email, Map<String, dynamic> newData) async {
    var consultaEmail = where.eq('email', email);
    var user = await collection.findOne(consultaEmail);

    if (user != null) {
      // Atualize o documento com as novas informações
      newData.forEach((key, value) {
        user[key] = value;
      });
      user['data'] = true;
      await collection.update(consultaEmail, user);
    } else {
      print('nao achei!');
    }
  }





  static Future<void> insertData(String email, Map<String, dynamic> newData) async {
    var consultaEmail = where.eq('email', email);
    var user = await collection.findOne(consultaEmail);

    if (user != null) {
      // Atualize o documento com as novas informações
      newData.forEach((key, value) {
        user[key] = value;
      });
      await collection.update(consultaEmail, user);
      print('info inserida com sucesso');
    } else {
      print('nao achei!');
    }
  }

  static Future<bool> verificaUserData(String email) async {
    var consultaEmail = where.eq('email', email);
    var user = await collection.findOne(consultaEmail);
    if (user!['data'] == false) {
      return false;
    }
    return true;
  }

static Future<void> inserePet(String ongCnpj, Map<String, dynamic> petData) async {
  try {
    var uuid = Uuid(); // Crie uma instância de Uuid para gerar IDs únicos.
    String petId = uuid.v4(); // Gere um novo ID único para o pet.

    // Adicione o ID único ao objeto de dados do pet.
    petData['id'] = petId;

    var consultaOng = where.eq('cnpj', ongCnpj);
    var ong = await collection.findOne(consultaOng);

    if (ong != null) {
      List<dynamic> petList = ong['petList'] ?? [];
      petList.add(petData);
      ong['petList'] = petList;
      await collection.update(consultaOng, ong);
      print('Pet inserido com sucesso na lista de pets da Ong. ID: $petId');
    } else {
      print('Ong não encontrada com o CNPJ fornecido.');
    }
  } catch (e) {
    print('Erro ao inserir o pet na lista de pets da Ong: $e');
  }
}


static Future<List<Map<String, dynamic>>> retornaListaPets() async {
  final ongs = await collection.find(where.eq('Tipo', '2')).toList();
  final List<Map<String, dynamic>> allPets = [];

  for (var ong in ongs) {
    final petList = ong['petList'] as List<dynamic>;
    String endereco = '${ong['cidade']}, ${ong['estado']}';

    Map<String,dynamic> ongInfo = {
      'userName' : ong['userName'],
      'email' : ong['email'],
      'password' : ong['password'],
      'data' : ong['data'],
      'petList' : ong['petList'],
      'preferedPetsList' : ong['preferedPetsList'],
      'Tipo' : ong['Tipo'],
      'nomeOng' : ong['nomeOng'],
      'cnpj' : ong['cnpj'],
      'rua' : ong['rua'],
      'numero' : ong['numero'],
      'estado' : ong['estado'],
      'cidade' : ong['cidade'],
      'bairro' : ong['bairro'],
      'cep' : ong['cep'],
      'localizacao' : endereco,
      'telefone' : ong['telefone'],
      'nome representante' : ong['nome representante'],
      'email representante' : ong['email representante'],
      'cpf representante' : ong['cpf representante'],
      'imagemPerfil' : ong['imagemPerfil'],
      'bio' : ong['bio'],
      'feedImagens' : ong['feedImagens'],

    };
    for (var pet in petList) {
      Map<String, dynamic> petInfo = {      
        //pet info
        'tipo': pet['tipo'],
        'nome': pet['nome'],
        'idade': pet['idade'],
        'sexo': pet['sexo'],
        'porte': pet['porte'],
        'raca': pet['raca'],
        'imagem': pet['imagem'],
        'id':pet['id']
      };
      petInfo.addAll(ongInfo);

      allPets.add(petInfo);
    }
  }
  return allPets;
}



static Future<void> favoritaPet(email,inserir_retirar,petId) async {
  var consultaEmail = where.eq('email', email);
  var user = await collection.findOne(consultaEmail);

  if(inserir_retirar){
    if (user != null) {
        List<dynamic> petList = user['preferedPetsList'] ?? []; // Obtenha a lista atual de pets ids
        petList.add(petId);// Adicione o pet id à lista
        user['preferedPetsList'] = petList;// Atualize a lista de pets 
        await collection.update(consultaEmail, user);// Atualize o documento 
        print('Pet inserido com sucesso na lista de pets preferido.');
      } else {
        print('usuario nao encontrato ou falta de informcacos');
        // Lide com a situação onde a Ong não é encontrada com o CNPJ.
      }
  }
  else{
     if (user != null) {
      List<dynamic> petList = user['preferedPetsList'] ?? [];
      petList.remove(petId); // Remove o petId da lista
      user['preferedPetsList'] = petList;
      await collection.update(consultaEmail, user);
      print('Pet removido com sucesso da lista de pets preferidos.');
    } else {
      print('Usuário não encontrado ou falta de informações');
      // Lide com a situação onde o usuário não é encontrado.
    }
  }
}


static Future<List<String>> retornaPetIds(cpf) async {
   var consultaCpf = where.eq('cpf', cpf);
   var user = await collection.findOne(consultaCpf);
   var petIds = user!['preferedPetsList'];
   List<String> allPetsIds = [];

   for(var id in petIds){
      String novoId = id;
      allPetsIds.add(novoId);
   }
  print(allPetsIds);
  return allPetsIds;
}

static Future<List<Map<String, dynamic>>> retornaListaPetsOng(String cnpj) async {
  final startTime = DateTime.now(); // Marca o tempo de início

  final ong = await collection.findOne(where.eq('cnpj', cnpj)); // Use findOne para obter apenas uma ONG com o CNPJ fornecido
  final List<Map<String, dynamic>> allPets = [];

  if (ong != null) { // Verifique se a ONG foi encontrada
    final petList = ong['petList'] as List<dynamic>;
    String endereco = '${ong['cidade']}, ${ong['estado']}';

    for (var pet in petList) {
      Map<String, dynamic> petInfo = {
        'userName' : ong['userName'],
        'email' : ong['email'],
        'password' : ong['password'],
        'data' : ong['data'],
        'nomeOng' : ong['nomeOng'],
        'cnpj' : ong['cnpj'],
        'rua' : ong['rua'],
        'numero' : ong['numero'],
        'estado' : ong['estado'],
        'cidade' : ong['cidade'],
        'bairro' : ong['bairro'],
        'cep' : ong['cep'],
        'telefone' : ong['telefone'],
        'nome representante' : ong['nome representante'],
        'email representante' : ong['email representante'],
        'cpf representante' : ong['cpf representante'],
        'imagemPerfil' : ong['imagemPerfil'],
        'bio' : ong['bio'],
        'localizacao' : endereco,
        'petList' : ong['petList'],
        //pet info
        'tipo': pet['tipo'],
        'nome': pet['nome'],
        'idade': pet['idade'],
        'sexo': pet['sexo'],
        'porte': pet['porte'],
        'raca': pet['raca'],
        'imagem': pet['imagem'],
        'id':pet['id']
        
      };

      allPets.add(petInfo);
    }
  }

  final endTime = DateTime.now(); // Marca o tempo de fim
  final elapsedTime = endTime.difference(startTime);
  log('Tempo de execução de retornaListaPetsOng: $elapsedTime');

  return allPets;
}



static Future<void> insereImagemPerfil(email,imagem) async {
  var consultaEmail = where.eq('email', email);
  var ong = await collection.findOne(consultaEmail);
  ong!['imagemPerfil'] = imagem;
  await collection.update(consultaEmail, ong);
}

static Future<void> insereImagemFeed(String email, dynamic imagem) async {
  
 
  var consultaEmail = where.eq('email', email);
  var ong = await collection.findOne(consultaEmail);


  List<dynamic> feedImagens = ong!['feedImagens'] ?? [];
  feedImagens.add(imagem);
  ong['feedImagens'] = feedImagens;
  await collection.update(consultaEmail, ong);

  
}


static Future<void> insereBioPerfil(email,bio) async {
  var consultaEmail = where.eq('email', email);
  var ong = await collection.findOne(consultaEmail);
  ong!['bio'] = bio;
  await collection.update(consultaEmail, ong);

}



static Future<String> retornaOng(email) async {
  var consultaEmail = where.eq('email', email);
  var ong = await collection.findOne(consultaEmail);
  return ong!['imagemPerfil'];
}


static Future<Map<String,dynamic>> retornaOngCompleta(email) async {
  var consultaEmail = where.eq('email', email);
  var ong = await collection.findOne(consultaEmail);

   var ongInfo = {
    'userName' : ong!['userName'],
    'email' : ong['email'],
    'password' : ong['password'],
    'data' : ong['data'],
    'petList' : ong['petList'],
    'preferedPetsList' : ong['preferedPetsList'],
    'Tipo' : ong['Tipo'],
    'nomeOng' : ong['nomeOng'],
    'cnpj' : ong['cnpj'],
    'rua' : ong['rua'],
    'numero' : ong['numero'],
    'estado' : ong['estado'],
    'cidade' : ong['cidade'],
    'bairro' : ong['bairro'],
    'cep' : ong['cep'],
    'telefone' : ong['telefone'],
    'nome representante' : ong['nome representante'],
    'email representante' : ong['email representante'],
    'cpf representante' : ong['cpf representante'],
    'imagemPerfil' : ong['imagemPerfil'],
    'bio' : ong['bio'],
    'feedImagens' : ong['feedImagens']
   };
   
  return ongInfo;
}

static Future<Map<String,dynamic>> retornaUsuarioCompleto(email) async {
  var consultaEmail = where.eq('email', email);
  var user = await collection.findOne(consultaEmail);

  Map<String,dynamic> usuario = {};
  if(user!['Tipo'] == '1'){
    usuario = {
      'userName' : user['userName'],
      'email' : user['email'],
      'password' : user['password'],
      'data' : user['data'],
      'petList' : user['petList'],
      'nome completo' : user['nome completo'],
      'preferedPetsList' : user['preferedPetsList'],
      'Tipo' : user['Tipo'],
      'primeiroNome' : user['primeiroNome'],
      'sobrenome' : user['sobrenome'],
      'rua' : user['rua'],
      'numero' : user['numero'],
      'estado' : user['estado'],
      'cidade' : user['cidade'],
      'bairro' : user['bairro'],
      'cep' : user['cep'],
      'telefone' : user['telefone'],
      'dataNascimento' : user['dataNascimento'],
      'cpf' : user['cpf'],
    }; 
  }
  else{
    usuario = {
    'userName' : user['userName'],
    'email' : user['email'],
    'password' : user['password'],
    'data' : user['data'],
    'petList' : user['petList'],
    'preferedPetsList' : user['preferedPetsList'],
    'Tipo' : user['Tipo'],
    'nomeOng' : user['nomeOng'],
    'cnpj' : user['cnpj'],
    'rua' : user['rua'],
    'numero' : user['numero'],
    'estado' : user['estado'],
    'cidade' : user['cidade'],
    'bairro' : user['bairro'],
    'cep' : user['cep'],
    'telefone' : user['telefone'],
    'nome representante' : user['nome representante'],
    'email representante' : user['email representante'],
    'cpf representante' : user['cpf representante'],
    'imagemPerfil' : user['imagemPerfil'],
    'bio' : user['bio'],
    'feedImagens' : user['feedImagens']
   };
    

  }
  return usuario;
}


static Future<void> apagaDocumento(String campo, dynamic documento, String email) async {
  // encontrar o usuario
  var consultaEmail = where.eq('email', email);
  var ong = await collection.findOne(consultaEmail);

  // Verificar se o usuário foi encontrado
  if (ong != null) {
    // Construir o filtro para remover o elemento do array
    var filtro = where.eq('email', email);
    var update = modify.pull(campo, documento);

    // Aplicar a atualização
    await collection.update(filtro, update);

    print('Elemento removido com sucesso do array!');
  } else {
    print('Usuário não encontrado com o email fornecido.');
  }
}


static Future<void> alteraDocumento(String campo, dynamic documento, String email) async {
  // encontrar o usuario
  var consultaEmail = where.eq('email', email);
  var ong = await collection.findOne(consultaEmail);

  // Verificar se o usuário foi encontrado
  if (ong != null) {
    ong[campo] = documento;

    // Aplicar a atualização
    await collection.update(consultaEmail, ong);

    print('Elemento removido com sucesso do array!');
  } else {
    print('Usuário não encontrado com o email fornecido.');
  }
}

static Future<void> alteraDocumentos(Map<String,dynamic> dados, String email) async {
  // encontrar o usuario
  var consultaEmail = where.eq('email', email);
  var ong = await collection.findOne(consultaEmail);

  // Verificar se o usuário foi encontrado
  if (ong != null) {

    dados.forEach((String key, dynamic item) async{
      ong[key] = item;
      await collection.update(consultaEmail, ong);
    });
  
    

    // Aplicar a atualização
    

    print('elementos alterados');
  } else {
    print('Usuário não encontrado com o email fornecido.');
  }
}

static Future<void> alteraPet(String campo,String novoNome, String email, String petId) async {
  var consultaEmail = where.eq('email', email);
  var ong = await collection.findOne(consultaEmail);

  // Verificar se a ONG foi encontrada
  if (ong != null) {
    // Encontrar o índice do pet na lista de pets da ONG
    int indicePet = -1;
    for (int i = 0; i < ong['petList'].length; i++) {
      if (ong['petList'][i]['id'] == petId) {
        indicePet = i;
        break;
      }
    }

    // Verificar se o pet foi encontrado
    if (indicePet != -1) {
      // Modificar o nome do pet
      ong['petList'][indicePet][campo] = novoNome;

      // Aplicar a atualização
      await collection.update(consultaEmail, ong);

      print('$campo do pet atualizado com sucesso!');
    } else {
      print('Pet não encontrado com o ID fornecido.');
    }
  } else {
    print('Usuário não encontrado com o email fornecido.');
  }
}

static Future<void> removePet(String email, String petId) async {
  var consultaEmail = where.eq('email', email);
  var ong = await collection.findOne(consultaEmail);

  // Verificar se a ONG foi encontrada
  if (ong != null) {
    // Remover o pet da lista com base no id
    ong['petList'].removeWhere((pet) => pet['id'] == petId);

    // Aplicar a atualização
    await collection.update(consultaEmail, ong);

    print('Pet removido com sucesso!');
  } else {
    print('Usuário não encontrado com o email fornecido.');
  }
}



}
