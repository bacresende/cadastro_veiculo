import 'package:cadastro_veiculo/app/modulos/adicionar-carro/adicionar_carro_controller.dart';
import 'package:cadastro_veiculo/app/widgets/custom_button.dart';
import 'package:cadastro_veiculo/app/widgets/custom_textfield.dart';
import 'package:cadastro_veiculo/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AdicionarCarro extends GetView<AdicionarCarroController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: corAzul,
        centerTitle: true,
        title:
            Text(!controller.isEdit ? 'Adicionar Veículo' : 'Editar Veículo'),
      ),
      body: Container(
        child: Center(
          child: Form(
            key: controller.keyForm,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextFormField(
                    //readyOnly: controller.loading,
                    initialValue: controller.carroModel.carro,
                    label: 'Digite o Nome do Carro (Ex: Strada)',
                    keyboardType: TextInputType.text,
                    padding: EdgeInsets.all(15),
                    onChange: (String valor) {
                      controller.carroModel.carro = valor;
                    },
                    validator: (String valor) {
                      return valor.isEmpty
                          ? 'Não deixe o campo em branco'
                          : null;
                    }),
                CustomTextFormField(
                    readyOnly: controller.isEdit,
                    initialValue: controller.carroModel.placa,
                    color: !controller.isEdit ? corAzul : Colors.grey,
                    label: 'Digite a Placa do Carro',
                    keyboardType: TextInputType.text,
                    padding: EdgeInsets.all(15),
                    onChange: (String valor) {
                      controller.carroModel.placa = valor.toUpperCase();
                    },
                    validator: (String valor) {
                      return valor.isEmpty
                          ? 'Não deixe o campo em branco'
                          : null;
                    }),
                if (controller.isEdit)
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.grey),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Não é possível fazer a alteração da placa',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        )),
                  ),
                CustomTextFormField(
                    initialValue: controller.carroModel.observacao,
                    label: 'Alguma Observação? (Opcional)',
                    keyboardType: TextInputType.text,
                    padding: EdgeInsets.all(15),
                    onChange: (String valor) {
                      controller.carroModel.observacao = valor;
                    }),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Obx(() => CustomButton(
              color: corAzul,
              label: !controller.isEdit ? 'Salvar' : 'Atualizar',
              action:  !controller.isLoading ? () async {
                if (controller.keyForm.currentState.validate()) {
                  await controller.salvar();
                }
              } : (){},
            )),
      ),
    );
  }
}
