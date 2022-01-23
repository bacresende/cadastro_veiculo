import 'package:cadastro_veiculo/app/modulos/adicionar-carro/adicionar_carro.dart';
import 'package:cadastro_veiculo/app/modulos/adicionar-carro/adicionar_carro_binding.dart';
import 'package:cadastro_veiculo/app/modulos/adicionar-motorista/adicionar_motorista.dart';
import 'package:cadastro_veiculo/app/modulos/adicionar-motorista/adicionar_motorista_binding.dart';
import 'package:cadastro_veiculo/app/modulos/criar-conta/criar_conta.dart';
import 'package:cadastro_veiculo/app/modulos/criar-conta/criar_conta_binding.dart';
import 'package:cadastro_veiculo/app/modulos/home/home_binding.dart';
import 'package:cadastro_veiculo/app/modulos/home/home_screen.dart';
import 'package:cadastro_veiculo/app/modulos/login/login.dart';
import 'package:cadastro_veiculo/app/modulos/login/login_binding.dart';
import 'package:cadastro_veiculo/app/modulos/registrar-entrada/registrar_ponto.dart';
import 'package:cadastro_veiculo/app/modulos/registrar-entrada/registrar_ponto_binding.dart';
import 'package:cadastro_veiculo/app/modulos/usuarios/usuarios_binding.dart';
import 'package:cadastro_veiculo/app/modulos/usuarios/usuarios_screen.dart';
import 'package:cadastro_veiculo/app/modulos/visualizar-veiculos/visualizar_veiculos.dart';
import 'package:cadastro_veiculo/app/modulos/visualizar-veiculos/visualizar_veiculos_binding.dart';
import 'package:cadastro_veiculo/app/modulos/vizualizar-visitantes/visualizar_visitantes.dart';
import 'package:cadastro_veiculo/app/modulos/vizualizar-visitantes/visualizar_visitantes_binding.dart';
import 'package:cadastro_veiculo/app/routes/routes.dart';
import 'package:get/get.dart';

class AppPages {
  static final List<GetPage> routes = <GetPage>[
    GetPage(name: Routes.INITIAL, page: () => Login(), binding: LoginBinding()),
    GetPage(
        name: Routes.HOME, page: () => HomeScreen(), binding: HomeBinding()),
    GetPage(
        name: Routes.CRIAR_CONTA,
        page: () => CriarConta(),
        binding: CriarContaBinding()),
    GetPage(
        name: Routes.ADICIONAR_MOTORISTA,
        page: () => AdicionarMotorista(),
        binding: AdicionarMotoristaBinding()),
    GetPage(
        name: Routes.ADICIONAR_CARRO,
        page: () => AdicionarCarro(),
        binding: AdicionarCarroBinding()),
    GetPage(
        name: Routes.REGISTRAR_PONTO,
        page: () => RegistrarPonto(),
        binding: RegistrarPontoBinding()),
    GetPage(
        name: Routes.USUARIOS,
        page: () => Usuarios(),
        binding: UsuariosBinding()),
    GetPage(
        name: Routes.VISUALIZAR_VISITANTES,
        page: () => VisualizarVisitantes(),
        binding: VisualizarVisitantesBindings()),
    GetPage(
        name: Routes.VISUALIZAR_VEICULOS,
        page: () => VisualizarVeiculos(),
        binding: VisualizarVeiculosBinding()),
  ];
}
