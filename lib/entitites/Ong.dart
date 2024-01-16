class Ong {
  String nomeOng;
  String cnpj;
  String rua;
  String numero;
  String estado;
  String cidade;
  String bairro;
  String cep;
  String telefone;
  String nomeRepresentante;
  String emailRepresentante;
  String cpfRepresentante;

  Ong({
    required this.nomeOng,
    required this.cnpj,
    required this.rua,
    required this.numero,
    required this.estado,
    required this.cidade,
    required this.bairro,
    required this.cep,
    required this.telefone,
    required this.nomeRepresentante,
    required this.emailRepresentante,
    required this.cpfRepresentante,
  });

  Map<String, dynamic> toMap() {
    return {
      'Tipo': 'ong',
      "Nome ong": nomeOng,
      "cnpj": cnpj,
      "Rua": rua,
      "Numero": numero,
      "Estado": estado,
      "Cidade": cidade,
      "Bairro": bairro,
      "cep": cep,
      "Telefone": telefone,
      "Nome representante": nomeRepresentante,
      "Email representante": emailRepresentante,
      "cpf representante": cpfRepresentante,
    };
  }

  bool validarCPF(String cpfRepresentante) {
    cpfRepresentante = this
        .cpfRepresentante
        .replaceAll(RegExp(r'\D'), ''); // Remove caracteres não numéricos

    if (cpfRepresentante.length != 11) {
      return false;
    }

    if (RegExp(r'^(\d)\1+$').hasMatch(cpfRepresentante)) {
      return false;
    }
    

    // Calcula o primeiro dígito verificador
    int soma = 0;
    for (int i = 0; i < 9; i++) {
      soma += int.parse(cpfRepresentante[i]) * (10 - i);
    }
    int digito1 = (soma * 10) % 11;

    if (digito1 == 10) {
      digito1 = 0;
    }

    if (digito1 != int.parse(cpfRepresentante[9])) {
      return false;
    }

    // Calcula o segundo dígito verificador
    soma = 0;
    for (int i = 0; i < 10; i++) {
      soma += int.parse(cpfRepresentante[i]) * (11 - i);
    }
    int digito2 = (soma * 10) % 11;

    if (digito2 == 10) {
      digito2 = 0;
    }

    return digito2 == int.parse(cpfRepresentante[10]);
  }

  bool validarCEP(String cep) {
    cep = cep.replaceAll(
        RegExp(r'\D'), ''); // Remove caracteres não numéricos do CEP
    // Verifica se o CEP tem 8 dígitos
    if (cep.length != 8) {
      return false;
    }
    return true; // O CEP é válido
  }

  bool validarTelefone(String telefone) {
    telefone = telefone.replaceAll(
        RegExp(r'\D'), ''); // Remove caracteres não numéricos do telefone
    // Verifica se o CEP tem 8 dígitos
    if (telefone.length != 11) {
      return false;
    }
    return true; // O teelfone é válido
  }

  bool validarCnpj(String cnpj) {
    // Remove caracteres não numéricos
    cnpj = cnpj.replaceAll(RegExp(r'[^\d]'), '');

    // Verifique se o CNPJ tem 14 dígitos
    if (cnpj.length != 14) {
      return false;
    }

    if (RegExp(r'^(\d)\1+$').hasMatch(cnpj)) {
      return false;
    }

    // Calcula o primeiro dígito verificador
    int soma = 0;
    for (int i = 0; i < 12; i++) {
      soma += int.parse(cnpj[i]) * (i < 4 ? 5 - i : 13 - i);
    }
    int digito1 = (11 - soma % 11) % 11;

    // Calcula o segundo dígito verificador
    soma = 0;
    for (int i = 0; i < 13; i++) {
      soma += int.parse(cnpj[i]) * (i < 5 ? 6 - i : 14 - i);
    }
    int digito2 = (11 - soma % 11) % 11;

    // Verifica se os dígitos verificadores são iguais aos dígitos fornecidos
    return int.parse(cnpj[12]) == digito1 && int.parse(cnpj[13]) == digito2;
  }

  String validaCampos(cpfRepresentante,cnpj,cep,telefone) {
    List<String> camposInvalidos = [];

    if (!validarCEP(cep)) {
      camposInvalidos.add('CEP\n');
    }

    if (!validarCPF(cpfRepresentante)) {
      camposInvalidos.add('CPF do representante\n');
    }

    if (!validarCnpj(cnpj)) {
      camposInvalidos.add('CNPJ\n');
    }

    if (!validarTelefone(telefone)) {
      camposInvalidos.add('Telefone\n');
    }

    if (camposInvalidos.isNotEmpty) {
      return 'Campos inválidos: ${camposInvalidos.join(", ")}';
    }

    return '';
  }
}
