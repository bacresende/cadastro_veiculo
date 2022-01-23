import 'package:cadastro_veiculo/app/modulos/login/login_controller.dart';
import 'package:get/get.dart';

class LoginBinding extends Bindings{
  @override
  void dependencies() {
    print('iniciou o bing');
    Get.lazyPut(() => LoginController());
  }
}