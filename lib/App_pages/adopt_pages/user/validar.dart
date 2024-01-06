








bool validarCPF(String cpf) {
    cpf = cpf.replaceAll(RegExp(r'\D'), ''); // Remove caracteres não numéricos
   
    if (cpf.length != 11) {
      return false;
    }
    
    if (RegExp(r'^(\d)\1+$').hasMatch(cpf)) {
      return false;
    }

    // Calcula o primeiro dígito verificador
    int soma = 0;
    for (int i = 0; i < 9; i++) {
      soma += int.parse(cpf[i]) * (10 - i);
    }
    int digito1 = (soma * 10) % 11;

    if (digito1 == 10) {
      digito1 = 0;
    }

    if (digito1 != int.parse(cpf[9])) {
      return false;
    }

    // Calcula o segundo dígito verificador
    soma = 0;
    for (int i = 0; i < 10; i++) {
      soma += int.parse(cpf[i]) * (11 - i);
    }
    int digito2 = (soma * 10) % 11;

    if (digito2 == 10) {
      digito2 = 0;
    }

    return digito2 == int.parse(cpf[10]);
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