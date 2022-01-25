import 'package:cadastro_veiculo/app/data/model/carro_model.dart';
import 'package:cadastro_veiculo/app/data/model/motorista_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrarPontoModel extends CarroModel {
  String id;
  DateTime horaRegistro;
  List<dynamic> motoristasModel = [];
  String tipo;

  RegistrarPontoModel();

  String get getDataCompleta =>
      '${this.horaRegistro.day}/${this.horaRegistro.month}/${this.horaRegistro.year}';

  String get getMesAno =>
      '${this.horaRegistro.month}/${this.horaRegistro.year}';    

  String get getHoras => '${this.horaRegistro.hour}:${this.horaRegistro.minute}';

  RegistrarPontoModel.fromDocument(DocumentSnapshot doc) {
    this.id = doc.documentID;
    this.horaRegistro = (doc.data['hora'] as Timestamp).toDate();
    super.carro = doc.data['carro'];
    super.placa = doc.data['placa'];
    super.idCarro = doc.data['idCarro'];
    this.motoristasModel = (doc.data['motoristas'] as List<dynamic> ?? [])
        .map((map) => MotoristaModel.fromJson(map))
        .toList();

    this.tipo = doc.data['tipo'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'hora': DateTime.now(),
      'carro': super.carro,
      'placa': super.placa,
      'idCarro': super.idCarro,
      'motoristas': this
          .motoristasModel
          .map((motoristaModel) => motoristaModel.toMap())
          .toList(),
      'tipo': this.tipo,
      'observacao': super.observacao
    };

    return map;
  }

  Map<String, dynamic> toMapTeste() {
    Map<String, dynamic> map = {
      'horaEntrada': DateTime.now(),
      'carro': super.carro,
      'placa': super.placa,
      'idCarro': super.idCarro,
      'tipo': this.tipo,
      'observacao': super.observacao
    };

    return map;
  }
}
