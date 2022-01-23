import 'package:cadastro_veiculo/app/data/model/carro_model.dart';
import 'package:cadastro_veiculo/utils/preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdicionarCarroController extends GetxController {
  CarroModel carroModel;
  Firestore _db = Firestore.instance;
  final keyForm = GlobalKey<FormState>();
  bool isEdit = false;
  RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set isLoading(bool value) => _isLoading.value = value;

  @override
  void onInit() async {
    // TODO: implement onInit

    super.onInit();

    this.carroModel = Get.arguments as CarroModel ?? new CarroModel();

    this.isEdit = this.carroModel.carro != null;
  }

  Future<void> salvar() async {
    this.isLoading = true;
    if (!this.isEdit) {
      await gerarIdESalvar();
    } else {
      await atualizarVeiculo();
    }
  }

  Future<void> gerarIdESalvar() async {
    carroModel.idCarro = carroModel.placa;

    QuerySnapshot querySnapshot =
        await _db.collection("veiculos").getDocuments();

    List<String> listaPlacas = [];

    for (DocumentSnapshot item in querySnapshot.documents) {
      String codigo = item.documentID;

      listaPlacas.add(codigo);
    }

    if (!listaPlacas.contains(carroModel.idCarro)) {
      await salvarVeiculo();
    } else {
      this.isLoading = false;
      DocumentSnapshot doc =
          await _db.collection('veiculos').document(carroModel.idCarro).get();
          CarroModel carroModelExistente = new CarroModel.fromJson(doc.data);

      showDialogVeiculoCadastrado(carroModelExistente);
    }
  }

  Future<void> salvarVeiculo() async {
    await _db
        .collection('veiculos')
        .document(carroModel.idCarro)
        .setData(carroModel.toMap());

    showDialogIdVeiculo();
  }

  Future<void> atualizarVeiculo() async {
    await _db
        .collection('veiculos')
        .document(carroModel.idCarro)
        .updateData(carroModel.toMap());

    showDialogVeiculoAtualizado();
  }

  void showDialogIdVeiculo() {
    Get.defaultDialog(
      barrierDismissible: false,
      backgroundColor: corAzul,
      title: 'Esse é o código do veiculo, anote para consultas futuras',
      titleStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 17,
      ),
      middleText: carroModel.idCarro,
      middleTextStyle: TextStyle(
          color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold),
      confirm: Align(
        alignment: Alignment.topRight,
        child: FloatingActionButton.extended(
          onPressed: () {
            this.isLoading = false;
            Get.back();
            Get.back();
          },
          backgroundColor: Colors.white,
          icon: Icon(
            Icons.check,
            color: corAzulEscuro,
          ),
          label: Text(
            'Concluir',
            style: TextStyle(color: corAzulEscuro),
          ),
        ),
      ),
    );
  }

  void showDialogVeiculoAtualizado() {
    this.isLoading = false;
    Get.back();
    Get.rawSnackbar(
        message: 'Veículo Atualizado com Sucesso',
        backgroundColor: corVerde,
        icon: Icon(
          Icons.info_outline,
          color: Colors.white,
        ));
  }

  void showDialogVeiculoCadastrado(CarroModel carroModelExistente) {

    Get.defaultDialog(
      barrierDismissible: false,
      backgroundColor: corVermelha,
      title: 'Ops! Esse veículo, já se encontra cadastrado',
      titleStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 17,
      ),
      middleText: '${carroModelExistente.carro} - ${carroModelExistente.placa}',
      middleTextStyle: TextStyle(
          color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
      confirm: Align(
        alignment: Alignment.topRight,
        child: FloatingActionButton.extended(
          onPressed: () {
            Get.back();
          },
          backgroundColor: Colors.white,
          icon: Icon(
            Icons.check,
            color: corAzulEscuro,
          ),
          label: Text(
            'Voltar',
            style: TextStyle(color: corAzulEscuro),
          ),
        ),
      ),
    );
  }
}
