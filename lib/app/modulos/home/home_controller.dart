import 'package:cadastro_veiculo/app/data/model/carro_model.dart';
import 'package:cadastro_veiculo/app/data/model/registrar_ponto_model.dart';
import 'package:cadastro_veiculo/app/data/model/usuario_model.dart';
import 'package:cadastro_veiculo/app/routes/routes.dart';
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

  Rx<Usuario> _usuario = new Usuario().obs;

  Usuario get usuario => _usuario.value;

  set usuario(Usuario value) => _usuario.value = value;

  RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set isLoading(bool value)=> _isLoading.value = value;

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

  void abrirDialogVisualizarCarroseVisitantes() async{
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
}
