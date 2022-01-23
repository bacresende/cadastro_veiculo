import 'package:cadastro_veiculo/app/modulos/login/login_controller.dart';
import 'package:cadastro_veiculo/app/routes/routes.dart';
import 'package:cadastro_veiculo/app/widgets/custom_button.dart';
import 'package:cadastro_veiculo/app/widgets/custom_textfield.dart';
import 'package:cadastro_veiculo/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextFormField(
                  //readyOnly: controller.loading,
                  label: 'Digite a Seu E-mail',
                  keyboardType: TextInputType.text,
                  padding: EdgeInsets.all(15),
                  onChange: (String valor) {
                    controller.usuario.email = valor;
                  },
                  validator: (String valor) {
                    return valor.isEmpty ? 'Não deixe o campo em branco' : null;
                  }),
              CustomTextFormField(
                  //readyOnly: controller.loading,
                  //initialValue: controller.lancamento.titulo,
                  label: 'Digite a sua Senha',
                  keyboardType: TextInputType.text,
                  padding: EdgeInsets.all(15),
                  onChange: (String valor) {
                    controller.usuario.senha = valor;
                  },
                  validator: (String valor) {
                    return valor.isEmpty ? 'Não deixe o campo em branco' : null;
                  }),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 15),
                child: CustomButton(
                  color: corAzul,
                  label: 'Entrar',
                  action: () {
                    controller.validarCampos();
                  },
                  
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: FlatButton(
                    child: Text(
                      'Esqueceu a Senha? Clique Aqui',
                      style: TextStyle(color: Colors.grey),
                    ),
                    onPressed: () {
                      controller.enviarEmailParaRecuperacaoDeSenha();
                    }),
              ),
              SizedBox(
                height: 30,
              ),
              FlatButton(
                  child: Text(
                    'Não possui conta? Clique Aqui',
                    style: TextStyle(color: corVerde, fontSize: 18),
                  ),
                  onPressed: () {
                    Get.toNamed(Routes.CRIAR_CONTA);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
