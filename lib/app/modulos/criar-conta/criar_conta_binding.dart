import 'package:cadastro_veiculo/app/modulos/criar-conta/criar_conta_controller.dart';
import 'package:get/instance_manager.dart';

class CriarContaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CriarContaController());
  }

}