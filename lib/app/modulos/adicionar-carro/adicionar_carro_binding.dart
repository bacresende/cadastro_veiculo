import 'package:cadastro_veiculo/app/modulos/adicionar-carro/adicionar_carro_controller.dart';
import 'package:get/get.dart';

class AdicionarCarroBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AdicionarCarroController());
  }
  
}