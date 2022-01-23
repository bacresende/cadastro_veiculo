

import 'package:cadastro_veiculo/app/modulos/registrar-entrada/registrar_ponto_controller.dart';
import 'package:get/get.dart';

class RegistrarPontoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegistrarPontoController());
  }
}