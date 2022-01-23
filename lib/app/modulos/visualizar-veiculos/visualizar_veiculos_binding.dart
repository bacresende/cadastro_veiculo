import 'package:cadastro_veiculo/app/modulos/visualizar-veiculos/visualizar_veiculos_controller.dart';
import 'package:get/get.dart';

class VisualizarVeiculosBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => VisualizarVeiculosController());
  }
}