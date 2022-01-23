import 'package:cadastro_veiculo/app/data/model/usuario_model.dart';
import 'package:cadastro_veiculo/app/routes/routes.dart';
import 'package:cadastro_veiculo/utils/preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CriarContaController extends GetxController {
  Usuario usuario = new Usuario();
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _db = Firestore.instance;

  RxBool _loading = false.obs;

  bool get loading => _loading.value;

  set loading(bool value) => _loading.value = value;

  validarCampos() {
    if (usuario.isSamePassword) {
      if (usuario.senha.length >= 6) {
        loading = true;
        criarUsuario();
        Get.rawSnackbar(
            messageText: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(),
                ),
                SizedBox(width: 15),
                Text(
                  "Criando...",
                  style: TextStyle(color: corAzulEscuro),
                ),
              ],
            ),
            backgroundColor: Colors.white,
            duration: Duration(seconds: 2));
      } else {
        onFalha('Digite uma senha com mais de 5 digitos');
      }
    } else {
      onFalha('As senhas estão diferentes');
    }
  }

  void criarUsuario() async {
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: usuario.email, password: usuario.senha);
      FirebaseUser firebaseUser = authResult.user;

      usuario.id = firebaseUser.uid;

      _db.collection('usuarios').document(usuario.id).setData(usuario.toMap());

      onSucesso();
    } catch (error) {
      onFalha(error.code);
    }
  }

  void onSucesso() {
    Get.offAllNamed(Routes.HOME);
    Get.rawSnackbar(
        title: 'Usuario criado com sucesso!',
        message: ' ',
        backgroundColor: corVerde,
        duration: Duration(seconds: 5));
  }

  void onFalha(String erro) {
    loading = false;
    if (erro == 'ERROR_EMAIL_ALREADY_IN_USE') {
      Get.rawSnackbar(
          title: 'Falha ao criar usuário',
          message: 'O e-mail já está em uso',
          backgroundColor: corVermelha,
          duration: Duration(seconds: 5));
    } else {
      Get.rawSnackbar(
          title: 'Falha ao criar usuário',
          message: erro,
          backgroundColor: corVermelha,
          duration: Duration(seconds: 5));
    }
  }

}
