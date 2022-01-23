import 'package:cadastro_veiculo/app/modulos/registrar-entrada/registrar_ponto_controller.dart';
import 'package:cadastro_veiculo/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class StackVisitanteTile extends GetView<RegistrarPontoController> {
  final dynamic visitante;

  StackVisitanteTile(this.visitante);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: corAzul,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 15, 8, 8),
              child: Text(
                visitante.nome,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )),
        GestureDetector(
          child: Icon(Icons.remove_circle, color: Colors.red),
          onTap: () {
            controller.removeVisitante(visitante);
          },
        ),
      ],
    );
  }
}
