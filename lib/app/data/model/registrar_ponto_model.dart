import 'package:cadastro_veiculo/app/data/model/carro_model.dart';
import 'package:cadastro_veiculo/app/data/model/motorista_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrarPontoModel extends CarroModel {
  String id;
  //DateTime horaRegistro;
  List<dynamic> motoristasModel = [];
  String tipo;
  DateTime data;
  String hora = '';

  RegistrarPontoModel();

  String get getDataCompleta =>
      '${this.data.day}/${this.data.month}/${this.data.year}';

  String get getMesAno => '${this.data.month}/${this.data.year}';

  String get getHoras => this.hora;

  RegistrarPontoModel.fromDocument(DocumentSnapshot doc) {
    this.id = doc.documentID;
    this.data = (doc.data['data'] as Timestamp)?.toDate() ?? DateTime.now();

    if (doc.data['hora'].runtimeType == String) {
      this.hora = doc.data['hora'];
    } else {
      this.hora = 'Erro de App Antigo';
    }

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
      'data': this.data,
      'hora': this.hora,
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
