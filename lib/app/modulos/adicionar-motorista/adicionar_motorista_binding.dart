import 'package:cadastro_veiculo/app/modulos/adicionar-motorista/adicionar_motorista_controller.dart';
import 'package:get/get.dart';

class AdicionarMotoristaBinding extends Bindings {
  @override
  void dependencies() {
    print('entrou no binding add mot');
    Get.lazyPut(() => AdicionarMotoristaController());
  }
  
}