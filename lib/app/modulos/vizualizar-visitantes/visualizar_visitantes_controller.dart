import 'package:cadastro_veiculo/app/data/model/motorista_model.dart';
import 'package:cadastro_veiculo/app/routes/routes.dart';
import 'package:cadastro_veiculo/app/widgets/info_card.dart';
import 'package:cadastro_veiculo/utils/preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VisualizarVisitantesController extends GetxController {
  Firestore _db = Firestore.instance;
  RxList<MotoristaModel> visitantes = <MotoristaModel>[].obs;

  RxString _filtro = ''.obs;

  set filtro(String value) => this._filtro.value = value;

  String get filtro => _filtro.value;

  void setFiltro(String nome) {
    this.filtro = nome;
  }

  void apagarFiltro() {
    this.filtro = '';
  }

  RxList<MotoristaModel> get listVisitantesFiltrada {
    if (this.filtro.isEmpty) {
      return visitantes;
    } else {
      return visitantes
          .where((MotoristaModel visitante) =>
              visitante.nome.toUpperCase().contains(this.filtro.toUpperCase()))
          .toList()
          .obs;
    }
  }

  @override
  void onInit() async {
    // TODO: implement onInit

    super.onInit();

    _db
        .collection('motoristas')
        .snapshots()
        .listen((QuerySnapshot querySnapshot) {
      this.visitantes.clear();
      for (DocumentSnapshot doc in querySnapshot.documents) {
        MotoristaModel motoristaModel = MotoristaModel.fromJson(doc.data);

        this.visitantes.add(motoristaModel);
      }

      this.visitantes.sort(
          (MotoristaModel a, MotoristaModel b) => a.nome.compareTo(b.nome));
    });
  }

  void editarVisitante(MotoristaModel visitante) {
    Get.toNamed(Routes.ADICIONAR_MOTORISTA, arguments: visitante);
  }

  void removerVisitante(MotoristaModel visitante) {
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
                            'Remover Visitante',
                            style: TextStyle(
                                color: corVermelha,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          Divider(),
                          Text(
                            'Deseja remover ${visitante.nome}?',
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
                              print(visitante.idMotorista);

                              await _db
                                  .collection('motoristas')
                                  .document(visitante.idMotorista)
                                  .delete();

                              Get.back();
                              Get.rawSnackbar(
                                  message: "Visitante removido com sucesso!",
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

  void abrirDetalheVisitante(MotoristaModel visitante) {
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
                            'Info Visitante',
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
                  InfoCard(text: visitante.nome, info: 'Nome', icon: Icons.person),
                  InfoCard(text: visitante.empresa, info: 'Empresa', icon: Icons.person),
                  InfoCard(text: visitante.numeroContato, info: 'Telefone', icon: Icons.person),
                  InfoCard(text: visitante.numeroDoc, info: 'Documento', icon: Icons.person),
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
}
