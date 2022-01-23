import 'package:cadastro_veiculo/app/data/model/usuario_model.dart';
import 'package:cadastro_veiculo/utils/preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsuariosController extends GetxController {
  Firestore _db = Firestore.instance;
  RxList<Usuario> usuarios = <Usuario>[].obs;
  

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    await setarUsuarios();
  }

  Future<void> setarUsuarios() async {
    _db
        .collection('usuarios')
        .snapshots()
        .listen((QuerySnapshot querySnapshot) {
      usuarios.value = querySnapshot.documents
          .map((DocumentSnapshot doc) => Usuario.fromJson(doc.data))
          .toList();

      usuarios.sort((Usuario a, Usuario b) => a.nome.compareTo(b.nome));
    });
  }

  void dialogAlterarTipoUsuario(Usuario usuario) {
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
                            'Alterar Tipo Usuario',
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
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        '${usuario.isAdmin ? 'Tirar' : 'Tornar'} Admin ${usuario.nome} ?',
                        style: TextStyle(
                            color: corAzul,
                            fontSize: 22,
                            fontWeight: FontWeight.w600),
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
                            backgroundColor: corVermelha,
                            elevation: 0,
                            label: Text(
                              'Não',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () async {
                              Get.back();
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 5, bottom: 8.0, right: 20),
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
                            onPressed: () async {
                              await salvarAlteracao(usuario);
                              Get.back();
                              Get.rawSnackbar(
                                  message: 'Alteração Realizada!',
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

  void dialogExcluirUsuario(Usuario usuario) {
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
                            'Deletar Usuario',
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
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Deseja excluir ${usuario.nome} ?',
                        style: TextStyle(
                            color: corAzul,
                            fontSize: 22,
                            fontWeight: FontWeight.w600),
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
                            backgroundColor: corVermelha,
                            elevation: 0,
                            label: Text(
                              'Não',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () async {
                              Get.back();
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 5, bottom: 8.0, right: 20),
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
                            onPressed: () async {
                              await deletarUsuario(usuario);
                              Get.back();
                              Get.rawSnackbar(
                                  message: '${usuario.nome} deletado!',
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

  Future<void> salvarAlteracao(Usuario usuario) async {
    await _db
        .collection('usuarios')
        .document(usuario.id)
        .updateData({'isAdmin': !usuario.isAdmin});
  }

  Future<void> deletarUsuario(Usuario usuario) async {
    await _db.collection('usuarios').document(usuario.id).delete();
    
  }
}
