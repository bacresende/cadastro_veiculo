import 'package:cadastro_veiculo/app/modulos/usuarios/usuarios_controller.dart';
import 'package:get/get.dart';

class UsuariosBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => UsuariosController());
  }

}