import 'package:cadastro_veiculo/app/data/model/carro_model.dart';
import 'package:cadastro_veiculo/app/modulos/visualizar-veiculos/visualizar_veiculos_controller.dart';
import 'package:cadastro_veiculo/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class VisualizarVeiculos extends GetView<VisualizarVeiculosController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => TextField(
              cursorColor: Colors.white,
              onChanged: controller.setFiltro,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.white54),
                  hintText: 'Pesquisar Veículo ${controller.carros.length}')),
        ),
        backgroundColor: corAzul,
      ),
      body: Obx(
        () => controller.carros.isNotEmpty
            ? ListView.separated(
                separatorBuilder: (_, __) => Divider(),
                itemCount: controller.listCarrosFiltrada.length,
                itemBuilder: (_, index) {
                  CarroModel carroModel = controller.listCarrosFiltrada[index];
                  return ListTile(
                    title: Text(carroModel.carro.toUpperCase()),
                    subtitle: Text(carroModel.idCarro),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: corAzul,
                            ),
                            onPressed: () {
                              controller.editarVeiculo(carroModel);
                            }),
                        IconButton(
                            icon: Icon(
                              Icons.remove_circle,
                              color: corVermelha,
                            ),
                            onPressed: () {
                              controller.removerVeiculo(carroModel);
                            }),
                      ],
                    ),
                    onTap: () {
                      controller.abrirDetalheVeiculo(carroModel);
                    },
                  );
                },
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
