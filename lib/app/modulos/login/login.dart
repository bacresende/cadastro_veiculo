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
          child: Obx(() => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextFormField(
                      readyOnly: controller.loading,
                      label: 'Digite o seu E-mail',
                      keyboardType: TextInputType.text,
                      padding: EdgeInsets.all(15),
                      onChange: (String valor) {
                        controller.usuario.email = valor;
                      },
                      validator: (String valor) {
                        return valor.isEmpty
                            ? 'Não deixe o campo em branco'
                            : null;
                      }),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                            readyOnly: controller.loading,
                            label: 'Digite a sua Senha',
                            keyboardType: TextInputType.text,
                            obscureText: controller.obscure,
                            padding: EdgeInsets.all(15),
                            onChange: (String valor) {
                              controller.usuario.senha = valor;
                            },
                            validator: (String valor) {
                              return valor.isEmpty
                                  ? 'Não deixe o campo em branco'
                                  : null;
                            }),
                      ),
                      IconButton(
                          onPressed: controller.changeObscure,
                          icon: Icon(
                            controller.obscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: corAzul,
                          ))
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 15),
                    child: CustomButton(
                      color: corAzul,
                      label: !controller.loading ? 'Entrar' : 'Entrando...',
                      action: !controller.loading
                          ? () {
                              controller.validarCampos();
                            }
                          : null,
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
                        onPressed: !controller.loading
                            ? () {
                                controller.enviarEmailParaRecuperacaoDeSenha();
                              }
                            : null),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  FlatButton(
                      child: Text(
                        'Não possui conta? Clique Aqui',
                        style: TextStyle(
                            color: !controller.loading ? corVerde : Colors.grey,
                            fontSize: 18),
                      ),
                      onPressed: !controller.loading
                          ? () {
                              Get.toNamed(Routes.CRIAR_CONTA);
                            }
                          : null)
                ],
              )),
        ),
      ),
    );
  }
}
