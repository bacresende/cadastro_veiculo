import 'dart:ui';

import 'package:cadastro_veiculo/app/data/model/motorista_model.dart';
import 'package:cadastro_veiculo/app/modulos/registrar-entrada/registrar_ponto_controller.dart';
import 'package:cadastro_veiculo/app/modulos/registrar-entrada/widgets/stack_visitante_tile.dart';
import 'package:cadastro_veiculo/app/widgets/custom_button.dart';
import 'package:cadastro_veiculo/app/widgets/custom_dropdown.dart';
import 'package:cadastro_veiculo/app/widgets/info_card.dart';
import 'package:cadastro_veiculo/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistrarPonto extends GetView<RegistrarPontoController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: corAzul,
        centerTitle: true,
        title: Text('Registrar ${controller.registrarPontoModel.tipo}'),
      ),
      body: Container(
        child: Center(
          child: ListView(
            children: [
              InfoCard(
                info: 'Carro',
                text: controller.registrarPontoModel.carro,
                icon: Icons.short_text,
              ),
              InfoCard(
                info: 'Placa',
                text: controller.registrarPontoModel.placa,
                icon: Icons.short_text,
              ),
              Row(
                children: [
                  Expanded(
                    child: Obx(() => InfoCard(
                          info: 'Observação do Veículo',
                          text: controller.observacao,
                          icon: Icons.short_text,
                        )),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: corAzul,
                      ),
                      onPressed: () {
                        controller.abrirModalEditarObservacao();
                      })
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                child: CustomButton(
                  radius: 10,
                  color: corAzul,
                  label: 'Selecionar Visitante',
                  action: () {
                    controller.abrirDialogSelecionarVisitante();
                  },
                ),
              ),
              Obx(() => controller.visitantesSelecionados.isNotEmpty
                  ? Card(
                      margin: EdgeInsets.all(15),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                            runSpacing: 5,
                            spacing: 5,
                            children: controller.visitantesSelecionados
                                .map((visitante) =>
                                    StackVisitanteTile(visitante))
                                .toList()),
                      ),
                    )
                  : Container()),
              Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 30.0),
                    child: TextField(
                      onTap: () {
                        controller.setDataCalendario();
                      },
                      controller: controller.dataEditingController,
                      cursorColor: Colors.white,
                      readOnly: true,
                      autofocus: false,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.white),
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText:
                              "Data de ${controller.registrarPontoModel.tipo}",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32))),
                    ),
                  )),
                  IconButton(
                      icon: Icon(
                        Icons.calendar_today_outlined,
                        color: corAzulEscuro,
                      ),
                      onPressed: () async {
                        await controller.setDataCalendario();
                      }),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: TextField(
                      controller: controller.horaEditingController,
                      onTap: () {
                        controller.setHora();
                      },
                      cursorColor: Colors.white,
                      readOnly: true,
                      autofocus: false,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.white),
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText:
                              "Hora de ${controller.registrarPontoModel.tipo}",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32))),
                    ),
                  )),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: IconButton(
                        icon: Icon(
                          Icons.alarm,
                          color: corAzulEscuro,
                        ),
                        onPressed: () async {
                          await controller.setHora();
                        }),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Obx(() => CustomButton(
              color: corAzul,
              label: 'Salvar',
              action: !controller.isLoading
                  ? () {
                      controller.salvar();
                    }
                  : null,
            )),
      ),
    );
  }
}
