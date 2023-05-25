import 'package:brasil_fields/formatter/telefone_input_formatter.dart';
import 'package:cadastro_veiculo/app/modulos/adicionar-motorista/adicionar_motorista_controller.dart';
import 'package:cadastro_veiculo/app/widgets/custom_button.dart';
import 'package:cadastro_veiculo/app/widgets/custom_dropdown.dart';
import 'package:cadastro_veiculo/app/widgets/custom_textfield.dart';
import 'package:cadastro_veiculo/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AdicionarMotorista extends GetView<AdicionarMotoristaController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: corAzul,
        centerTitle: true,
        title: Text(
            !controller.isEdit ? 'Adicionar Visitante' : 'Editar Visitante'),
      ),
      body: Container(
        child: Center(
          child: Form(
            key: controller.keyForm,
            child: ListView(
              children: [
                CustomTextFormField(
                    //readyOnly: controller.loading,
                    initialValue: controller.motoristaModel.nome,
                    label: 'Digite o Nome do Visitante',
                    keyboardType: TextInputType.text,
                    padding: EdgeInsets.all(15),
                    onChange: (String valor) {
                      controller.motoristaModel.nome = valor;
                    },
                    validator: (String valor) {
                      return valor.isEmpty
                          ? 'Não deixe o campo em branco'
                          : null;
                    }),
                CustomTextFormField(
                    //readyOnly: controller.loading,
                    initialValue: controller.motoristaModel.numeroDoc,
                    label: 'Digite o Número do Documento',
                    keyboardType: TextInputType.number,
                    padding: EdgeInsets.all(15),
                    onChange: (String valor) {
                      controller.motoristaModel.numeroDoc = valor;
                    },
                    validator: (String valor) {
                      return valor.isEmpty
                          ? 'Não deixe o campo em branco'
                          : null;
                    }),
                Obx(
                  () => CustomDropdown(
                    cor: corAzul,
                    value: controller.selecionadoEmpresa != ''
                        ? controller.selecionadoEmpresa
                        : null,
                    hint: 'Selecione a Empresa',
                    items: controller.getEmpresas(),
                    onChanged: controller.onChangedEmpresa,
                  ),
                ),
                Obx(
                  () => controller.selecionadoEmpresa == 'OUTROS'
                      ? CustomTextFormField(
                          //readyOnly: controller.loading,
                          initialValue: controller.motoristaModel.empresa,
                          label: 'Digite o Nome da Empresa',
                          keyboardType: TextInputType.text,
                          padding: EdgeInsets.all(15),
                          onChange: (String valor) {
                            controller.motoristaModel.empresa = valor;
                          },
                          validator: (String valor) {
                            return valor.isEmpty
                                ? 'Não deixe o campo em branco'
                                : null;
                          })
                      : Container(),
                ),
                CustomTextFormField(
                  //readyOnly: controller.loading,
                  initialValue: controller.motoristaModel.numeroContato,
                  label: 'Digite o Número Para Contato',
                  keyboardType: TextInputType.number,
                  padding: EdgeInsets.all(15),
                  onChange: (String valor) {
                    controller.motoristaModel.numeroContato = valor;
                  },
                  validator: (String valor) {
                    return valor.isEmpty ? 'Não deixe o campo em branco' : null;
                  },
                ),
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
              action: !controller.isLoading
                  ? () {
                      if (controller.keyForm.currentState.validate()) {
                        controller.salvar();
                      }
                    }
                  : () {},
            )),
      ),
    );
  }
}
