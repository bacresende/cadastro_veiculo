import 'package:cadastro_veiculo/app/data/model/usuario_model.dart';
import 'package:cadastro_veiculo/app/routes/routes.dart';
import 'package:cadastro_veiculo/utils/preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class LoginController extends GetxController {
  Usuario usuario = new Usuario();
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _db = Firestore.instance;

  RxBool _loading = false.obs;

  bool get loading => _loading.value;

  set loading(bool value) => _loading.value = value;

  RxBool _obscure = true.obs;

  bool get obscure => _obscure.value;

  set obscure(bool value) => _obscure.value = value;

  @override
  void onInit() async {
    super.onInit();

    print('onInit do Login');
    print('Id Usuário');

    verificarUsuario();
  }

  Future<void> verificarUsuario() async {
    FirebaseUser user = await _auth.currentUser();

    if (user != null) {
      Get.offAllNamed(Routes.HOME);
      infoSnackbar(titulo: 'Que bom ter você de volta!', cor: corVerde);
    }
  }

  void changeObscure() {
    obscure = !obscure;
  }

  validarCampos() {
    loading = true;
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
              "Entrando...",
              style: TextStyle(color: corVerde),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        duration: Duration(seconds: 2));

    Future.delayed(Duration(seconds: 2), () {
      logarUsuario();
    });
  }

  Future<void> enviarEmailParaRecuperacaoDeSenha() async {
    if (usuario.email != null) {
      await _auth.sendPasswordResetEmail(email: usuario.email);
      infoSnackbar(
          titulo: 'E-mail de Redefinição enviado para você', cor: corVerde);
    } else {
      infoSnackbar(titulo: 'Preencha o Campo de E-mail', cor: corVermelha);
    }
  }

  void infoSnackbar({String titulo, Color cor}) {
    Get.rawSnackbar(
        message: titulo,
        backgroundColor: cor,
        icon: Icon(
          Icons.info_outline,
          color: Colors.white,
        ));
  }

  void logarUsuario() async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: usuario.email, password: usuario.senha);

      Get.offAllNamed(Routes.HOME);
    } catch (error) {
      onFalha(error.code);
    }

    loading = false;
  }

  void onFalha(String erro) {
    switch (erro) {
      case "ERROR_INVALID_EMAIL":
        Get.rawSnackbar(
            message: "E-mail inválido!",
            backgroundColor: corVermelha,
            icon: Icon(
              Icons.info_outline,
              color: Colors.white,
            ));
        break;
      case "ERROR_WRONG_PASSWORD":
        Get.rawSnackbar(
            message: "Senha incorreta!",
            backgroundColor: corVermelha,
            icon: Icon(Icons.info_outline, color: Colors.white));

        break;
      case "ERROR_USER_NOT_FOUND":
        Get.rawSnackbar(
            message: "E-mail não existe!",
            backgroundColor: corVermelha,
            icon: Icon(
              Icons.info_outline,
              color: Colors.white,
            ));

        break;
      case "ERROR_USER_DISABLED":
        Get.rawSnackbar(
            message: "Conta desativada!",
            backgroundColor: corVermelha,
            icon: Icon(
              Icons.info_outline,
              color: Colors.white,
            ));

        break;
      case "ERROR_TOO_MANY_REQUESTS":
        Get.rawSnackbar(
            message: "Muitas requisições, tente novamente mais tarde!",
            backgroundColor: corVermelha,
            icon: Icon(
              Icons.info_outline,
              color: Colors.white,
            ));

        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        Get.rawSnackbar(
            message: "Login indisponível!",
            backgroundColor: corVermelha,
            icon: Icon(
              Icons.info_outline,
              color: Colors.white,
            ));

        break;
      default:
        Get.rawSnackbar(
            message: "Ocorreu um erro, tente novamente mais tarde! #$erro",
            backgroundColor: corVermelha,
            icon: Icon(
              Icons.info_outline,
              color: Colors.white,
            ));
    }
  }
}
