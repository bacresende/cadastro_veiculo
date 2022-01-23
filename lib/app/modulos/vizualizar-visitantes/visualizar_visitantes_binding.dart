import 'package:cadastro_veiculo/app/modulos/vizualizar-visitantes/visualizar_visitantes_controller.dart';
import 'package:get/get.dart';

class VisualizarVisitantesBindings extends Bindings{
  @override
  void dependencies() {
    print('Binding visistantes ver');
    // TODO: implement dependencies
    Get.lazyPut(() => VisualizarVisitantesController());
  }

}