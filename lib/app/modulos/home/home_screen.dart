import 'package:cadastro_veiculo/app/modulos/home/home_controller.dart';
import 'package:cadastro_veiculo/app/routes/routes.dart';
import 'package:cadastro_veiculo/app/widgets/custom_button.dart';
import 'package:cadastro_veiculo/app/widgets/custom_textfield.dart';
import 'package:cadastro_veiculo/utils/gerar_excel.dart';
import 'package:cadastro_veiculo/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class HomeScreen extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Row(
              children: [
                IconButton(
                    icon: Icon(Icons.exit_to_app_outlined), 
                    tooltip: 'Sair do App',
                    onPressed: () {
                      controller.sairDoAplicativo();
                    }
                    ),
                Expanded(child: Text('Olá, ${controller.usuario.nome ?? ''}')),
              ],
            )),
        backgroundColor: corAzul,
        actions: [
          Obx(() => controller.usuario.isAdmin
              ? Row(
                  children: [
                    IconButton(
                        icon: Icon(Icons.visibility),
                        tooltip: 'Editar Visitante/Carros',
                        onPressed: () async {
                          controller.abrirDialogVisualizarCarroseVisitantes();
                        }),
                    IconButton(
                        icon: Icon(Icons.people),
                        tooltip: 'Ver Usuários',
                        onPressed: () async {
                          Get.toNamed(Routes.USUARIOS);
                        }),
                    IconButton(
                        icon: Icon(Icons.donut_large_sharp),
                        tooltip: 'Gerar Excel',
                        onPressed: () async {
                          await controller.dialogGerarOuExcluirDados();
                          print('clicado');
                        }),
                  ],
                )
              : Container())
        ],
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextFormField(
                  //readyOnly: controller.loading,
                  //initialValue: controller.lancamento.titulo,
                  label: 'Digite a Placa do Veículo',
                  keyboardType: TextInputType.text,
                  padding: EdgeInsets.all(15),
                  onChange: (String valor) {
                    controller.registrarPontoModel.idCarro =
                        valor.toUpperCase();
                  },
                  validator: (String valor) {
                    return valor.isEmpty ? 'Não deixe o campo em branco' : null;
                  }),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Obx(() => CustomButton(
                      color: corAzul,
                      label: 'Registrar Ponto',
                      action: !controller.isLoading
                          ? () {
                              controller.abrirDialogRegistro();
                            }
                          : null,
                    )),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.add),
          label: Text('Adicionar'),
          backgroundColor: corAzul,
          onPressed: () {
            controller.abrirDialogAdd();
          }),
    );
  }
}
