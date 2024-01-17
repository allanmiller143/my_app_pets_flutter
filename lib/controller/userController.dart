import 'package:get/get.dart';

class MeuControllerGlobal extends GetxController {
  final nome = ''.obs;
  final email = ''.obs; 
  final id = ''.obs; 
  final pesquisa = ''.obs;
  final imagemPerfil = ''.obs;


  final tipo = ''.obs;
  final data = false.obs;
  var petsPreferidos = [];


  final nomeOng = ''.obs;
  final cnpj = ''.obs;
  final cep = ''.obs;
  final bairro = ''.obs;
  final telefone = ''.obs;
  final rua = ''.obs;
  final numero = ''.obs;
  final estado = ''.obs;
  final cidade = ''.obs;
  final nomeRepresentante = ''.obs;
  final cpfRepresentante = ''.obs;
  final emailRepresentante = ''.obs;
  final bio = ''.obs;
  var pets = [];
  var imagensFeed = [];

  late Map<String,dynamic> usuario;



  void criaUsuario(){
    if(tipo.value == 'ong'){
      usuario = {
        'Id' : id.value,
        'E-mail' : email.value,
        'pets' : pets,
        'Tipo' : tipo.value,
        'Nome ong' : nomeOng.value,
        'cnpj' : cnpj.value,
        'Rua' : rua.value,
        'Numero' : numero.value,
        'Estado' : estado.value,
        'Cidade' : cidade.value,
        'Bairro' : bairro.value,
        'cep' : cep.value,
        'Telefone' : telefone.value,
        'Nome representante' : nomeRepresentante.value,
        'Email representante' : emailRepresentante.value,
        'cpf representante' : cpfRepresentante.value,
        'ImagemPerfil' :imagemPerfil.value,
        'Bio' : bio.value,
        'Imagens feed' : imagensFeed
      };
    }
    


  }


  double tamanhoTela = 0;

  void salvarNome(String dado) {
    nome.value = dado;
  }
  void salvarEmail(String dado) {
    email.value = dado;
  }
  void salvarId(String dado) {
    id.value = dado;
  }
  void salvarPesquisa(String dado) {
    pesquisa.value = dado;
  }
  void salvarImagemPerfil(String dado) {
    imagemPerfil.value = dado;
  }

  void salvarTipo(String dado) {
    tipo.value = dado;
  }

  void salvarData(bool dado) {
    data.value = dado;
  }

  String obterNome() {
    return nome.value;
  }
  String obterEmail() {
    return email.value;
  }
  String obterId() {
    return id.value;
  }
  String obterPesquisa() {
    return pesquisa.value;
  }
  String obterimagemPerfil() {
    return imagemPerfil.value;
  }

  String obterTipo() {
    return tipo.value;
  }

  bool obterData() {
    return data.value;
  }

}