import 'package:cadastro_veiculo/app/modulos/criar-conta/criar_conta_controller.dart';
import 'package:cadastro_veiculo/app/widgets/custom_button.dart';
import 'package:cadastro_veiculo/app/widgets/custom_textfield.dart';
import 'package:cadastro_veiculo/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class CriarConta extends GetView<CriarContaController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crie Sua Conta'),
        centerTitle: true,
        backgroundColor: corAzul,
      ),
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextFormField(
                    //readyOnly: controller.loading,
                    label: 'Digite o Seu Nome',
                    keyboardType: TextInputType.text,
                    padding: EdgeInsets.all(15),
                    onChange: (String valor) {
                      controller.usuario.nome = valor;
                    },
                    validator: (String valor) {
                      return valor.isEmpty ? 'Não deixe o campo em branco' : null;
                    }),
                CustomTextFormField(
                    //readyOnly: controller.loading,
                    //initialValue: controller.lancamento.titulo,
                    label: 'Digite o Seu E-mail',
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
                    CustomTextFormField(
                    //readyOnly: controller.loading,
                    //initialValue: controller.lancamento.titulo,
                    label: 'Confirme a sua Senha',
                    keyboardType: TextInputType.text,
                    padding: EdgeInsets.all(15),
                    onChange: (String valor) {
                      controller.usuario.confirmarSenha = valor;
                    },
                    validator: (String valor) {
                      return valor.isEmpty ? 'Não deixe o campo em branco' : null;
                    }),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 15),
                  child: CustomButton(
                    color: corAzul,
                    label: 'Criar Conta',
                    action: () {
                      controller.validarCampos();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      
    );
  }
}