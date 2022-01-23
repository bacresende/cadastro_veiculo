import 'package:cadastro_veiculo/app/data/manager.dart/user_manager.dart';
import 'package:get/get.dart';

class UserBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserManager());
  }
}