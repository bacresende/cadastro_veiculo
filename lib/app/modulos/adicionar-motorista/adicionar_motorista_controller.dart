import 'package:cadastro_veiculo/app/data/model/motorista_model.dart';
import 'package:cadastro_veiculo/utils/empresas.dart';
import 'package:cadastro_veiculo/utils/preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdicionarMotoristaController extends GetxController {
  final keyForm = GlobalKey<FormState>();
  MotoristaModel motoristaModel;
  RxString _selecionadoEmpresa = ''.obs;
  Firestore _db = Firestore.instance;
  bool isEdit = false;
  RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set isLoading(bool value) => _isLoading.value = value;

  String get selecionadoEmpresa => _selecionadoEmpresa.value;

  set selecionadoEmpresa(String categoria) =>
      _selecionadoEmpresa.value = categoria;

  @override
  void onInit() async {
    // TODO: implement onInit

    super.onInit();

    this.motoristaModel =
        Get.arguments as MotoristaModel ?? new MotoristaModel();

    this.isEdit = this.motoristaModel.nome != null;

    print(motoristaModel.empresa);

    if (this.isEdit) {
      List<String> empresas = [
        'GE',
        'STEAG',
        'MT',
        'QAP',
        'OMEGA',
        'J&R',
        'FLEX WIND'
      ];

      if (empresas.contains(this.motoristaModel.empresa)) {
        this.selecionadoEmpresa = this.motoristaModel.empresa;
      } else {
        this.selecionadoEmpresa = 'OUTROS';
      }
    }
  }

  List<DropdownMenuItem<String>> getEmpresas() {
    return Empresas.getEmpresas();
  }

  void onChangedEmpresa(String nomeEmpresa) {
    this.selecionadoEmpresa = nomeEmpresa;
    
    this.motoristaModel.empresa = '';
    if(nomeEmpresa != 'OUTROS'){
      this.motoristaModel.empresa = nomeEmpresa;
    }
    
    print(this.selecionadoEmpresa);
  }

  void salvar() {
    this.isLoading = true;
    if (this.selecionadoEmpresa.isNotEmpty) {
      if (!this.isEdit) {
        String idmotorista = _db.collection('motoristas').document().documentID;
        this.motoristaModel.idMotorista = idmotorista;
        _db
            .collection('motoristas')
            .document(this.motoristaModel.idMotorista)
            .setData(this.motoristaModel.toMap());
        print(this.motoristaModel.toMap());
        Get.back();
        showDialogInfo(
            titulo: "Visitante Adicionado com Sucesso", cor: corVerde);
      } else {
        _db
            .collection('motoristas')
            .document(this.motoristaModel.idMotorista)
            .updateData(this.motoristaModel.toMap());
        print(this.motoristaModel.toMap());
        Get.back();
        showDialogInfo(
            titulo: "Visitante Atualizado com Sucesso", cor: corVerde);
      }
    } else {
      showDialogInfo(titulo: 'Selecione a Empresa', cor: corVermelha);
    }
  }

  void showDialogInfo({String titulo, Color cor}) {
    this.isLoading = false;

    Get.rawSnackbar(
        message: titulo,
        backgroundColor: cor,
        icon: Icon(
          Icons.info_outline,
          color: Colors.white,
        ));
  }
}
