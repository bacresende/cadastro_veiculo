import 'package:cadastro_veiculo/app/data/model/carro_model.dart';
import 'package:cadastro_veiculo/app/data/model/registrar_ponto_model.dart';
import 'package:cadastro_veiculo/app/data/model/usuario_model.dart';
import 'package:cadastro_veiculo/app/routes/routes.dart';
import 'package:cadastro_veiculo/app/widgets/custom_button.dart';
import 'package:cadastro_veiculo/app/widgets/elegant_dropdown.dart';
import 'package:cadastro_veiculo/utils/data_util.dart';
import 'package:cadastro_veiculo/utils/gerar_excel.dart';
import 'package:cadastro_veiculo/utils/intervalo_datas.dart';
import 'package:cadastro_veiculo/utils/preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RegistrarPontoModel registrarPontoModel = new RegistrarPontoModel();
  Firestore _db = Firestore.instance;
  RxBool isAdmin = false.obs;
  FirebaseAuth _auth = FirebaseAuth.instance;
  RxString _dataInicialSelecionada = ''.obs;
  List<String> datasIntervalo = [];
  List<String> listaIntervalada = [];
  RxBool _mostrarCampoDataFinal = false.obs;
  RxString _dataFinalSelecionada = ''.obs;
  List<RegistrarPontoModel> registros = [];
  RxBool _loadingRegistrosExcel = false.obs;

  bool get loadingRegistrosExcel => _loadingRegistrosExcel.value;

  set loadingRegistrosExcel(bool value) => _loadingRegistrosExcel.value = value;

  bool get mostrarCampoDataFinal => _mostrarCampoDataFinal.value;

  set mostrarCampoDataFinal(bool value) => _mostrarCampoDataFinal.value = value;

  String get dataFinalSelecionada => _dataFinalSelecionada.value;

  set dataFinalSelecionada(String value) => _dataFinalSelecionada.value = value;

  String get dataInicialSelecionada => _dataInicialSelecionada.value;

  set dataInicialSelecionada(String value) =>
      _dataInicialSelecionada.value = value;

  Rx<Usuario> _usuario = new Usuario().obs;

  Usuario get usuario => _usuario.value;

  set usuario(Usuario value) => _usuario.value = value;

  RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set isLoading(bool value) => _isLoading.value = value;

  @override
  void onInit() async {
    super.onInit();
    print('home controller init');

    this.setUsuario();
    print(usuario.toMap());
  }

  Future<void> setUsuario() async {
    FirebaseUser firebaseUser = await _auth.currentUser();
    print(firebaseUser.uid);
    _db
        .collection('usuarios')
        .document(firebaseUser.uid)
        .snapshots()
        .listen((DocumentSnapshot doc) {
      usuario = Usuario.fromJson(doc.data);
    });
  }

  Future<void> dialogGerarOuExcluirDados() async {
    showModalBottomSheet(
        context: Get.context,
        backgroundColor: Colors.transparent,
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: Obx(
                  () => !this.loadingRegistrosExcel
                      ? Column(
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
                                      'Selecione o que deseja fazer',
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
                            ListTile(
                              title: Text('Gerar Excel',
                                  style: TextStyle(
                                      color: corAzul,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600)),
                              onTap: () async {
                                this.dialogSelecionarOpcaoIntervaloDados(
                                    'Gerar');
                              },
                            ),
                            Divider(
                              color: corAzul,
                            ),
                            ListTile(
                              title: Text(
                                  'Excluir Dados em um Intervalo de Tempo',
                                  style: TextStyle(
                                      color: corAzul,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600)),
                              onTap: () {
                                this.dialogSelecionarOpcaoIntervaloDados(
                                    'Excluir');
                              },
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 5, bottom: 8.0),
                              child: FloatingActionButton.extended(
                                backgroundColor: corAzul,
                                elevation: 0,
                                icon: Icon(Icons.arrow_back_ios,
                                    color: Colors.white),
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
                            )
                          ],
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Carregando, aguarde...',
                                  style: TextStyle(
                                      color: corAzul,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600)),
                              SizedBox(
                                height: 20,
                              ),
                              CircularProgressIndicator()
                            ],
                          ),
                        ),
                )),
          );
        });
  }

  Future<void> dialogSelecionarOpcaoIntervaloDados(String tipo) async {
    this.loadingRegistrosExcel = true;
    this.registros.clear();
    QuerySnapshot querySnapshot =
        await _db.collection('registros').getDocuments();

    this.registros = querySnapshot.documents
        .map((DocumentSnapshot doc) => RegistrarPontoModel.fromDocument(doc))
        .toList();

    this.registros.sort((RegistrarPontoModel a, RegistrarPontoModel b) =>
        a.horaRegistro.compareTo(b.horaRegistro));

    print('tamanho de registros ');
    print(registros.length);
    this.loadingRegistrosExcel = false;

    showModalBottomSheet(
        context: Get.context,
        backgroundColor: Colors.transparent,
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Obx(() => !this.loadingRegistrosExcel
                  ? Column(
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
                                  'Selecione o que deseja fazer',
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
                        ListTile(
                          title: Text(
                              tipo == 'Gerar'
                                  ? 'Gerar Excel Completo'
                                  : 'Excluir Dados Completos',
                              style: TextStyle(
                                  color: corAzul,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600)),
                          onTap: () async {
                            this.loadingRegistrosExcel = true;
                            Get.back();
                            Get.back();
                            Get.back();
                            if (tipo == 'Gerar') {
                              await GerarExcel().createExcel(this.registros);
                            } else {
                              //Excluir toda a lista
                              print(this.registros.length);
                              for (RegistrarPontoModel registro
                                  in this.registros) {
                                print(registro.id);
                                _db
                                    .collection('registros')
                                    .document(registro.id)
                                    .delete();
                              }
                            }

                            this.loadingRegistrosExcel = false;
                          },
                        ),
                        Divider(
                          color: corAzul,
                        ),
                        ListTile(
                          title: Text(
                              tipo == 'Gerar'
                                  ? 'Gerar Excel em um Intervalo de Tempo'
                                  : 'Excluir Dados em um Intervalo de Tempo',
                              style: TextStyle(
                                  color: corAzul,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600)),
                          subtitle: Text(
                            '(De uma data à outra)',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600),
                          ),
                          onTap: () {
                            abrirDialogIntervaloInicialExcel(tipo);
                          },
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 5, bottom: 8.0),
                          child: FloatingActionButton.extended(
                            backgroundColor: corAzul,
                            elevation: 0,
                            icon:
                                Icon(Icons.arrow_back_ios, color: Colors.white),
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
                        )
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Carregando, aguarde...',
                              style: TextStyle(
                                  color: corAzul,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600)),
                          SizedBox(
                            height: 20,
                          ),
                          CircularProgressIndicator()
                        ],
                      ),
                    )),
            ),
          );
        });
  }

  void abrirDialogIntervaloInicialExcel(String tipo) {
    this.listaIntervalada = [];
    this.datasIntervalo = [];
    this.dataInicialSelecionada = null;
    this.dataFinalSelecionada = null;
    this.mostrarCampoDataFinal = false;

    List<String> listMesAno = [];

    for (RegistrarPontoModel registro in this.registros) {
      print(registro.getDataCompleta);

      List<String> datasSeparadas = registro.getDataCompleta.split('/');

      String mesAno = datasSeparadas[1] + '/' + datasSeparadas[2];

      listMesAno.add(mesAno);
    }

    listMesAno = listMesAno.toSet().toList();
    print(listMesAno);

    showModalBottomSheet(
        context: Get.context,
        backgroundColor: Colors.transparent,
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.all(15),
            child: Obx(() => Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Obx(
                        () => !this.loadingRegistrosExcel
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, bottom: 10),
                                        child: Text(
                                          'Selecione o Primeiro Intervalo',
                                          style: TextStyle(
                                              color: corAzul,
                                              fontSize: 25,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      ElegantDropdown(
                                        cor: corAzul,
                                        value:
                                            this.dataInicialSelecionada ?? null,
                                        hint: 'Selecione o Primero Intervalo',
                                        items: IntervaloDatas.getDatasIniciais(
                                            listMesAno),
                                        onChanged: (String value) {
                                          onChangedDataInicial(
                                              value, listMesAno);
                                        },
                                      ),
                                    ],
                                  ),
                                  mostrarCampoDataFinal
                                      ? SizedBox(
                                          height: 20,
                                          child: Divider(color: corAzul),
                                        )
                                      : Container(),
                                  mostrarCampoDataFinal
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0, bottom: 10),
                                              child: Text(
                                                'Selecione o Segundo Intervalo',
                                                style: TextStyle(
                                                    color: corAzul,
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            ElegantDropdown(
                                              cor: corAzul,
                                              value:
                                                  this.dataFinalSelecionada ??
                                                      null,
                                              hint:
                                                  'Selecione o Segundo Intervalo',
                                              items:
                                                  IntervaloDatas.getDatasFinais(
                                                      datasIntervalo),
                                              onChanged: onChangedDatafinal,
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  mostrarCampoDataFinal
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              top: 16,
                                              bottom: 10,
                                              left: 8,
                                              right: 8),
                                          child: CustomButton(
                                            color: corAzul,
                                            label: tipo == 'Gerar'
                                                ? 'Gerar Excel'
                                                : 'Excluir Dados',
                                            action: () async {
                                              print(listaIntervalada);
                                              this.loadingRegistrosExcel = true;
                                              await this.selecionarDataDoBanco(
                                                  listaIntervalada, tipo);

                                              Get.back();
                                              Get.back();
                                              Get.back();
                                              Get.back();
                                              this.loadingRegistrosExcel =
                                                  false;
                                            },
                                          ),
                                        )
                                      : Container(),
                                ],
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Carregando, aguarde...',
                                        style: TextStyle(
                                            color: corAzul,
                                            fontSize: 30,
                                            fontWeight: FontWeight.w600)),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    CircularProgressIndicator()
                                  ],
                                ),
                              ),
                      )),
                )),
          );
        });
  }

  void onChangedDataInicial(String value, List<String> listMesAno) {
    this.dataInicialSelecionada = value;
    datasIntervalo = List.from(listMesAno);

    int index = datasIntervalo.indexOf(this.dataInicialSelecionada);

    for (int i = 0; i < index; i++) {
      datasIntervalo.removeAt(0);
    }

    mostrarCampoDataFinal = true;
    this.dataFinalSelecionada = null;
  }

  void onChangedDatafinal(String value) {
    listaIntervalada.clear();
    this.dataFinalSelecionada = value;

    int index = datasIntervalo.indexOf(this.dataFinalSelecionada);

    for (int i = 0; i <= index; i++) {
      listaIntervalada.add(datasIntervalo[i]);
    }

    //listaIntervalada.insert(0, this.dataInicialSelecionada);
  }

  Future<void> selecionarDataDoBanco(
      List<String> listaIntervalada, String tipo) async {
    List<RegistrarPontoModel> registrosLocal = [];
    if (listaIntervalada.first == listaIntervalada.last) {
      //pegar apenas o mês em questão
      print('pegar apenas o mês em questão');
      print(listaIntervalada);

      registrosLocal = this
          .registros
          .where((RegistrarPontoModel registro) =>
              registro.getMesAno.contains(listaIntervalada.first))
          .toList();
    } else {
      //pegar os meses selecionados
      print('pegar os meses selecionados');
      print(listaIntervalada);

      for (String intervalo in listaIntervalada) {
        registrosLocal.addAll(registros
            .where((RegistrarPontoModel registro) =>
                registro.getMesAno.contains(intervalo))
            .toList());
      }
    }

    if (tipo == 'Gerar') {
      await GerarExcel().createExcel(registrosLocal);
    } else {
      //Excluir dados com base nos ids da lista de registros;
      for (RegistrarPontoModel registro in registrosLocal) {
        print(registro.id);
        _db.collection('registros').document(registro.id).delete();
      }
    }
  }

  Future<void> abrirDialogRegistro() async {
    if (registrarPontoModel.idCarro != null) {
      DocumentSnapshot documentSnapshot = await _db
          .collection('veiculos')
          .document(registrarPontoModel.idCarro)
          .get();

      if (documentSnapshot.exists) {
        showModalBottomSheet(
            context: Get.context,
            backgroundColor: Colors.transparent,
            builder: (_) {
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: Column(
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
                                'Selecione qual ação deseja realizar',
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
                      ListTile(
                        title: Text('Registrar Entrada',
                            style: TextStyle(
                                color: corAzul,
                                fontSize: 30,
                                fontWeight: FontWeight.w600)),
                        onTap: () async {
                          Get.back();
                          await this
                              .registrarPonto('Entrada', documentSnapshot);
                        },
                      ),
                      Divider(
                        color: corAzulEscuro,
                      ),
                      ListTile(
                        title: Text('Registrar Saída',
                            style: TextStyle(
                                color: corAzul,
                                fontSize: 30,
                                fontWeight: FontWeight.w600)),
                        onTap: () async {
                          Get.back();
                          await this.registrarPonto('Saída', documentSnapshot);
                        },
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 5, bottom: 8.0),
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
                      )
                    ],
                  ),
                ),
              );
            });
      } else {
        showDialogAddVeiculo();
      }
    } else {
      Get.rawSnackbar(
          message: "Ops! Digite a Placa do Veículo",
          backgroundColor: corVermelha,
          icon: Icon(
            Icons.info_outline,
            color: Colors.white,
          ));
    }
  }

  Future<void> registrarPonto(
      String tipo, DocumentSnapshot documentSnapshot) async {
    print(registrarPontoModel.idCarro);
    this.isLoading = true;

    CarroModel carroExistente = new CarroModel.fromJson(documentSnapshot.data);

    registrarPontoModel.carro = carroExistente.carro;
    registrarPontoModel.placa = carroExistente.placa;
    registrarPontoModel.observacao = carroExistente.observacao;
    registrarPontoModel.tipo = tipo;

    Get.toNamed(Routes.REGISTRAR_PONTO, arguments: registrarPontoModel);
    this.isLoading = false;
  }

  void showDialogAddVeiculo() {
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
                            'Ops! Veículo não cadastrado',
                            style: TextStyle(
                                color: corAzulEscuro,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          Divider(),
                          Text(
                            'Deseja adicionar o veículo?',
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
                            backgroundColor: corVerde,
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
                            onPressed: () {
                              Get.back();
                              Get.toNamed(Routes.ADICIONAR_CARRO);
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

  void abrirDialogVisualizarCarroseVisitantes() async {
    showModalBottomSheet(
        context: Get.context,
        backgroundColor: Colors.transparent,
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Column(
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
                            'Selecione o que deseja fazer',
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
                  ListTile(
                    title: Text('Ver Visitantes',
                        style: TextStyle(
                            color: corAzul,
                            fontSize: 30,
                            fontWeight: FontWeight.w600)),
                    onTap: () {
                      Get.back();
                      Get.toNamed(Routes.VISUALIZAR_VISITANTES);
                    },
                  ),
                  Divider(
                    color: corAzulEscuro,
                  ),
                  ListTile(
                    title: Text('Ver Veículos',
                        style: TextStyle(
                            color: corAzul,
                            fontSize: 30,
                            fontWeight: FontWeight.w600)),
                    onTap: () {
                      Get.back();
                      Get.toNamed(Routes.VISUALIZAR_VEICULOS);
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 5, bottom: 8.0),
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
                  )
                ],
              ),
            ),
          );
        });
  }

  void abrirDialogAdd() {
    showModalBottomSheet(
        context: Get.context,
        backgroundColor: Colors.transparent,
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Column(
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
                            'Selecione o que deseja adicionar',
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
                  ListTile(
                    title: Text('Adicionar Visitante',
                        style: TextStyle(
                            color: corAzul,
                            fontSize: 30,
                            fontWeight: FontWeight.w600)),
                    onTap: () {
                      Get.back();
                      Get.toNamed(Routes.ADICIONAR_MOTORISTA);
                    },
                  ),
                  Divider(
                    color: corAzulEscuro,
                  ),
                  ListTile(
                    title: Text('Adicionar Veículo',
                        style: TextStyle(
                            color: corAzul,
                            fontSize: 30,
                            fontWeight: FontWeight.w600)),
                    onTap: () {
                      Get.back();
                      Get.toNamed(Routes.ADICIONAR_CARRO);
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 5, bottom: 8.0),
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
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> sairDoAplicativo() async {
    await _auth.signOut();
    Get.offAllNamed(Routes.INITIAL);
  }
}
