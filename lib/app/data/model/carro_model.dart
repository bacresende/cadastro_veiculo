class CarroModel {
  String carro;
  String placa;
  String idCarro;
  String observacao = 'Sem observação';

  CarroModel();

  CarroModel.fromJson(Map<String, dynamic> json) {
    this.carro = json['carro'];
    this.placa = json['placa'];
    this.idCarro = json['id'];
    this.observacao = json['observacao'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'carro': this.carro,
      'placa': this.placa,
      'id': this.idCarro,
      'observacao': this.observacao
    };

    return map;
  }
}
