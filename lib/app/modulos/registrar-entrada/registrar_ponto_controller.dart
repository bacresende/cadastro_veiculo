import 'package:cadastro_veiculo/app/data/model/motorista_model.dart';
import 'package:cadastro_veiculo/app/data/model/registrar_ponto_model.dart';
import 'package:cadastro_veiculo/app/widgets/custom_textfield.dart';
import 'package:cadastro_veiculo/utils/preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistrarPontoController extends GetxController {
  RxString _selecionadoPessoa = ''.obs;
  RegistrarPontoModel registrarPontoModel;
  RxList<MotoristaModel> visitantesSelecionados = <MotoristaModel>[].obs;

  RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set isLoading(bool value)=> _isLoading.value = value;

  RxString _observacao = 'sem observação'.obs;

  String get observacao => _observacao.value;

  set observacao(String value) => _observacao.value = value;

  String observacaoGlobal = '';

  Firestore _db = Firestore.instance;
  RxList<MotoristaModel> motoristasModel = <MotoristaModel>[].obs;
  MotoristaModel motoristaModelGlobal;

  String get selecionadoPessoa => _selecionadoPessoa.value;

  set selecionadoPessoa(String categoria) =>
      _selecionadoPessoa.value = categoria;

  RxString _filtro = ''.obs;

  String get filtro => _filtro.value;

  set filtro(String value) => _filtro.value = value;

  void setFiltro(String nome) {
    this.filtro = nome;
  }

  RxList<MotoristaModel> get listaVisitantesFiltrada {
    if (this.filtro.isEmpty) {
      return this.motoristasModel;
    } else {
      return this
          .motoristasModel
          .where((MotoristaModel motoristaModel) => motoristaModel.nome
              .toUpperCase()
              .contains(this.filtro.toUpperCase()))
          .toList()
          .obs;
    }
  }

  @override
  void onInit() async {
    super.onInit();
    print('on init');

    this.registrarPontoModel = Get.arguments as RegistrarPontoModel;
    this.observacao = this.registrarPontoModel.observacao;

    await setPessoas();
  }

  Future<void> setPessoas() async {
    QuerySnapshot querySnapshot =
        await _db.collection('motoristas').getDocuments();

    for (DocumentSnapshot doc in querySnapshot.documents) {
      MotoristaModel motoristaModel = MotoristaModel.fromJson(doc.data);

      motoristasModel.add(motoristaModel);
    }
  }

  void abrirModalEditarObservacao() {
    this.observacaoGlobal = '';
    print('olha aqui');
    print(this.observacaoGlobal);
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
                            'Editar observação',
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
                  CustomTextFormField(
                    //readyOnly: controller.loading,
                    //initialValue: controller.lancamento.titulo,
                    label: 'Digite uma Observação',
                    keyboardType: TextInputType.text,
                    padding: EdgeInsets.all(15),
                    onChange: (String valor) {
                      print(valor);
                      this.observacaoGlobal = valor;
                    },
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
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(
                              right: 5, bottom: 8.0, left: 20),
                          child: FloatingActionButton.extended(
                            backgroundColor: corVerde,
                            elevation: 0,
                            icon: Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                            label: Text(
                              'Concluir',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              if (observacaoGlobal.isNotEmpty) {
                                this.observacao = this.observacaoGlobal;
                                this.registrarPontoModel.observacao =
                                    this.observacao;

                                print(this.registrarPontoModel.toMapTeste());
                              } else {
                                print('entrou');
                                this.observacao = 'Sem observação';
                                this.registrarPontoModel.observacao =
                                    this.observacao;
                              }

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

  void abrirDialogSelecionarVisitante() {
    showDialog(
        context: Get.context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                    child: Card(
                      color: corAzul,
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, top: 8.0, bottom: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                cursorColor: Colors.white,
                                onChanged: this.setFiltro,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    hintStyle: TextStyle(color: Colors.white),
                                    hintText: 'Pesquisar Visitante'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Obx(() => ListView.separated(
                            separatorBuilder: (_, __) => Divider(),
                            itemCount: listaVisitantesFiltrada.length,
                            itemBuilder: (context, i) {
                              MotoristaModel visitante =
                                  listaVisitantesFiltrada[i];
                              return ListTile(
                                title: Text(
                                  visitante.nome,
                                  style: TextStyle(
                                      color: corAzul,
                                      fontWeight: FontWeight.w500),
                                ),
                                subtitle: Text(visitante.empresa),
                                onTap: (){
                                  
                                  this.visitantesSelecionados.add(visitante);
                                  this.filtro = '';
                                  Get.back();
                                },
                              );
                            },
                          ))),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 5, bottom: 8.0),
                    child: FloatingActionButton.extended(
                      backgroundColor: corAzul,
                      elevation: 0,
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                      label: Text(
                        'Voltar',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        this.filtro = '';
                        Get.back();
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }


  void removeVisitante(MotoristaModel visitante) {
    this.visitantesSelecionados.remove(visitante);
  }

  void salvar() async {
    if (this.visitantesSelecionados.isNotEmpty) {
      this.isLoading = true;
      this.registrarPontoModel.motoristasModel =
          this.visitantesSelecionados.value;

      await _db.collection('registros').add(registrarPontoModel.toMap());
      await _db
          .collection('veiculos')
          .document(registrarPontoModel.idCarro)
          .updateData({'observacao': registrarPontoModel.observacao});

      Get.back();
      this.isLoading = false;

      Get.rawSnackbar(
          message: "${this.registrarPontoModel.tipo} Registrada com Sucesso!",
          backgroundColor: corVerde,
          icon: Icon(
            Icons.info_outline,
            color: Colors.white,
          ));
    } else {
      Get.rawSnackbar(
          message: "Ops! Selecione um Visitante",
          backgroundColor: corVermelha,
          icon: Icon(
            Icons.info_outline,
            color: Colors.white,
          ));
    }
  }
}
