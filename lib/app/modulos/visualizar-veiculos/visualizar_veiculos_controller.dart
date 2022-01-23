import 'package:cadastro_veiculo/app/data/model/carro_model.dart';
import 'package:cadastro_veiculo/app/data/model/motorista_model.dart';
import 'package:cadastro_veiculo/app/routes/routes.dart';
import 'package:cadastro_veiculo/app/widgets/info_card.dart';
import 'package:cadastro_veiculo/utils/preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class VisualizarVeiculosController extends GetxController {

  Firestore _db = Firestore.instance;
  RxList<CarroModel> carros = <CarroModel>[].obs;

  RxString _filtro = ''.obs;

  set filtro (String value)=> this._filtro.value = value;

  String get filtro => _filtro.value;



  void setFiltro(String nome){
    this.filtro = nome;
  }
  
  void apagarFiltro(){
    this.filtro = '';
  }

  RxList<CarroModel> get listCarrosFiltrada {
    if (this.filtro.isEmpty) {
      return this.carros;
    } else {
      return carros
          .where((CarroModel carroModel) =>
              carroModel.carro.toUpperCase().contains(this.filtro.toUpperCase()))
          .toList()
          .obs;
    }
  }

  @override
  void onInit() async {
    // TODO: implement onInit

    super.onInit();

    _db
        .collection('veiculos')
        .snapshots()
        .listen((QuerySnapshot querySnapshot) {
      this.carros.clear();
      for (DocumentSnapshot doc in querySnapshot.documents) {
        CarroModel carroModel = CarroModel.fromJson(doc.data);

        this.carros.add(carroModel);
      }

      this.carros.sort(
          (CarroModel a, CarroModel b) => a.carro.compareTo(b.carro));
    });
  }

  void editarVeiculo(CarroModel carroModel) {
    Get.toNamed(Routes.ADICIONAR_CARRO, arguments: carroModel);
  }

  void abrirDetalheVeiculo(CarroModel carroModel){
    showModalBottomSheet(
        isScrollControlled: true,
        context: Get.context,
        backgroundColor: Colors.transparent,
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Column(
                        children: [
                          Text(
                            'Info Veículo',
                            style: TextStyle(
                                color: corAzulEscuro,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          Divider()
                        ],
                      ),
                    ),
                  ),
                  InfoCard(text: carroModel.carro, info: 'Carro', icon: Icons.person),
                  InfoCard(text: carroModel.placa, info: 'Placa', icon: Icons.person),
                  InfoCard(text: carroModel.observacao, info: 'Observação', icon: Icons.person),
                 SizedBox(
                    height: 50,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 5, bottom: 8.0, right: 20),
                          child: FloatingActionButton.extended(
                            backgroundColor: corAzul,
                            elevation: 0,
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                            label: Text(
                              'Voltar',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  void removerVeiculo(CarroModel carroModel) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: Get.context,
        backgroundColor: Colors.transparent,
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Column(
                        children: [
                          Text(
                            'Remover Veículo',
                            style: TextStyle(
                                color: corVermelha,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          Divider(),
                          Text(
                            'Deseja remover ${carroModel.carro} - ${carroModel.placa}?',
                            style: TextStyle(
                                color: corAzul,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 5, bottom: 8.0, right: 20),
                          child: FloatingActionButton.extended(
                            backgroundColor: corAzul,
                            elevation: 0,
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                            label: Text(
                              'Não',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(
                              right: 5, bottom: 8.0, left: 20),
                          child: FloatingActionButton.extended(
                            backgroundColor: corVermelha,
                            elevation: 0,
                            icon: Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                            label: Text(
                              'Sim',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () async {
                              print(carroModel.idCarro);

                              await _db
                                  .collection('veiculos')
                                  .document(carroModel.idCarro)
                                  .delete();

                              Get.back();
                              Get.rawSnackbar(
                                  message: "Veículo removido com sucesso!",
                                  backgroundColor: corVerde,
                                  icon: Icon(
                                    Icons.info_outline,
                                    color: Colors.white,
                                  ));
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

}