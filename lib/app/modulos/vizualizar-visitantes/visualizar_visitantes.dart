import 'package:cadastro_veiculo/app/data/model/motorista_model.dart';
import 'package:cadastro_veiculo/app/modulos/vizualizar-visitantes/visualizar_visitantes_controller.dart';
import 'package:cadastro_veiculo/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class VisualizarVisitantes extends GetView<VisualizarVisitantesController> {
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
                    hintText:
                        'Pesquisar Visitante ${controller.visitantes.length}')),
          ),
          backgroundColor: corAzul,
        ),
        body: Obx(
          () => controller.visitantes.isNotEmpty
              ? ListView.separated(
                  separatorBuilder: (_, __) => Divider(),
                  itemCount: controller.listVisitantesFiltrada.length,
                  itemBuilder: (_, index) {
                    MotoristaModel visitante =
                        controller.listVisitantesFiltrada[index];
                    return ListTile(
                      title: Text(visitante.nome.toUpperCase()),
                      subtitle: Text(visitante.empresa),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: corAzul,
                              ),
                              onPressed: () {
                                controller.editarVisitante(visitante);
                              }),
                          IconButton(
                              icon: Icon(
                                Icons.remove_circle,
                                color: corVermelha,
                              ),
                              onPressed: () {
                                controller.removerVisitante(visitante);
                              }),
                        ],
                      ),
                      onTap: () {
                        controller.abrirDetalheVisitante(visitante);
                      },
                    );
                  },
                )
              : Center(child: CircularProgressIndicator()),
        ));
  }
}
