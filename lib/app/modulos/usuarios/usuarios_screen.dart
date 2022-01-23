import 'package:cadastro_veiculo/app/data/model/usuario_model.dart';
import 'package:cadastro_veiculo/app/modulos/usuarios/usuarios_controller.dart';
import 'package:cadastro_veiculo/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class Usuarios extends GetView<UsuariosController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text('Usuários ${controller.usuarios.length}')),
        centerTitle: true,
        backgroundColor: corAzul,
      ),
      body: Container(
        child: Obx(() => controller.usuarios.isNotEmpty
            ? ListView.separated(
                separatorBuilder: (_, i) => Divider(),
                itemCount: controller.usuarios.length,
                itemBuilder: (_, index) {
                  Usuario usuario = controller.usuarios[index];
                  return ListTile(
                    title: Text(
                      usuario.nome,
                      style: TextStyle(
                          color: corAzul,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                    subtitle: Text(usuario.email),
                    trailing: Text(
                      usuario.isAdmin ? 'Admin' : 'Não Admin',
                      style: TextStyle(
                          color: usuario.isAdmin ? corVerde : corVermelha,
                          fontWeight: FontWeight.w600),
                    ),
                    onTap: () {
                      controller.dialogAlterarTipoUsuario(usuario);
                    },
                    onLongPress: (){
                      controller.dialogExcluirUsuario(usuario);
                    },
                  );
                },
              )
            : CircularProgressIndicator()),
      ),
    );
  }
}
