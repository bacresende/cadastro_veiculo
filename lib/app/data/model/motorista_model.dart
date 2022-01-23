class MotoristaModel {
  String nome;
  String numeroDoc;
  String empresa;
  String numeroContato;
  String idMotorista;

  MotoristaModel();

  MotoristaModel.fromJson(Map<String, dynamic> json) {
    this.nome = json['nome'];
    this.numeroDoc = json['numeroCNH'];
    this.empresa = json['empresa'];
    this.numeroContato = json['numeroContato'];
    this.idMotorista = json['idMotorista'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'nome': this.nome,
      'numeroCNH': this.numeroDoc,
      'empresa': this.empresa,
      'numeroContato': this.numeroContato,
      'idMotorista': this.idMotorista,
    };

    return map;
  }

/*
  MotoristaModel.fromJson(Map<String, dynamic> json) {
    this.nome = json['nome'];
    this.numeroCNH = json['numeroCNH'];
    this.empresa = json['empresa'];
    this.carro = json['carro'];
    this.placa = json['placa'];
    this.numeroContato = json['numeroContato'];
    this.horaEntrada = json['horaEntrada'];
    this.idMotorista = json['idMotorista'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'nome': this.nome,
      'numeroCNH': this.numeroCNH,
      'empresa': this.empresa,
      'carro': this.carro,
      'placa': this.placa,
      'numeroContato': this.numeroContato,
      'horaEntrada': this.horaEntrada,
      'idMotorista': this.idMotorista,
    };

    return map;
  }*/
}
