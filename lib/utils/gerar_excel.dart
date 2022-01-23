import 'dart:io';
import 'package:cadastro_veiculo/app/data/model/motorista_model.dart';
import 'package:cadastro_veiculo/app/data/model/registrar_ponto_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Alignment;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:open_file/open_file.dart' as open_file;

class GerarExcel {
  Worksheet sheet;
  Firestore _db = Firestore.instance;
  List<RegistrarPontoModel> registros = [];

  Future<void> createExcel() async {
    //Pegar dados do banco de dados
    QuerySnapshot querySnapshot =
        await _db.collection('registros').getDocuments();

    this.registros = querySnapshot.documents
        .map((DocumentSnapshot doc) => RegistrarPontoModel.fromDocument(doc))
        .toList();

    this.registros.sort((RegistrarPontoModel a, RegistrarPontoModel b)=> a.horaRegistro.compareTo(b.horaRegistro));

    print(this.registros);

    List<int> qtdeVisitantes = [];

    for (RegistrarPontoModel registro in this.registros) {
      qtdeVisitantes.add(registro.motoristasModel.length);
    }

    qtdeVisitantes.sort((int a, int b) => b.compareTo(a));

    int qtdeMaiorDeVisitante = qtdeVisitantes.first;

    int valorFinalDaColuna = (qtdeMaiorDeVisitante * 4) + 6;

    //Create an Excel document.

    //Creating a workbook.
    final Workbook workbook = Workbook();

    //Accessing via index
    sheet = workbook.worksheets[0];
    configuracoesIniciais(valorFinalDaColuna);

    colunaRegistro(); //1
    colunaData(); //2
    colunaHora(); //3
    colunaPlaca(); //4
    colunaCarro(); //5
    colunaNumeroVisitantes(); //6
    colunaNome(); //7       juntar
    colunaEmpresa(); //8    juntar
    colunaContato(); //9    juntar
    colunaNumeroCNH(); //10 juntar

    rodape(valorFinalDaColuna);

    //Save and launch the excel.
    final List<int> bytes = workbook.saveAsStream();
    //Dispose the document.
    workbook.dispose();

    //Get the storage folder location using path_provider package.
    final Directory directory =
        await path_provider.getApplicationDocumentsDirectory();
    final String path = directory.path;
    final File file = File('$path/output.xlsx');
    await file.writeAsBytes(bytes);

    //Launch the file (used open_file package)
    await open_file.OpenFile.open('$path/output.xlsx');
  }

  void configuracoesIniciais(int valorFinalDaColuna) {
    sheet.showGridlines = true;

    // Enable calculation for worksheet.
    sheet.enableSheetCalculations();

    sheet.getRangeByIndex(1, 1, 1, valorFinalDaColuna).cellStyle.backColor =
        '#3980ff'; //+7
  }

  void linhasRoxas(String celulas) {
    Range rangeTop = sheet.getRangeByName(celulas);

    rangeTop.cellStyle.backColor = '#3980ff';
    rangeTop.merge();
  }

  void colunaRegistro() {
    //1
    sheet.getRangeByName('A1').setText('Registro');
    sheet.getRangeByName('A1').cellStyle.fontColor = '#ffffff';
    sheet.getRangeByName('A1').cellStyle.bold = true;

    for (int i = 0; i < this.registros.length; i++) {
      int linha = i + 2;
      RegistrarPontoModel registro = this.registros[i];
      sheet.getRangeByName('A$linha').setText(registro.tipo ?? '');
    }
  }

  void colunaData() {
    // 2
    sheet.getRangeByName('B1').setText('Data');
    sheet.getRangeByName('B1').cellStyle.fontColor = '#ffffff';
    sheet.getRangeByName('B1').cellStyle.bold = true;

    for (int i = 0; i < this.registros.length; i++) {
      int linha = i + 2;
      RegistrarPontoModel registro = this.registros[i];
      sheet.getRangeByName('B$linha').setText(registro.getData ?? '');
    }
  }

  void colunaHora() {
    //3
    sheet.getRangeByName('C1').setText('Hora');
    sheet.getRangeByName('C1').cellStyle.fontColor = '#ffffff';
    sheet.getRangeByName('C1').cellStyle.bold = true;

    for (int i = 0; i < this.registros.length; i++) {
      int linha = i + 2;
      RegistrarPontoModel registro = this.registros[i];
      sheet.getRangeByName('C$linha').setText(registro.getHoras ?? '');
    }
  }

  void colunaPlaca() {
    // 4
    sheet.getRangeByName('D1').setText('Placa');
    sheet.getRangeByName('D1').cellStyle.fontColor = '#ffffff';
    sheet.getRangeByName('D1').cellStyle.bold = true;

    for (int i = 0; i < this.registros.length; i++) {
      int linha = i + 2;
      RegistrarPontoModel registro = this.registros[i];
      sheet.getRangeByName('D$linha').setText(registro.placa ?? '');
    }
  }

  void colunaCarro() {
    //5
    sheet.getRangeByName('E1').setText('Carro');
    sheet.getRangeByName('E1').cellStyle.fontColor = '#ffffff';
    sheet.getRangeByName('E1').cellStyle.bold = true;

    for (int i = 0; i < this.registros.length; i++) {
      int linha = i + 2;
      RegistrarPontoModel registro = this.registros[i];
      sheet.getRangeByName('E$linha').setText(registro.carro ?? '');
    }
  }

  void colunaNumeroVisitantes() {
    //6
    sheet.getRangeByName('F1').setText('Visitantes');
    sheet.getRangeByName('F1').cellStyle.fontColor = '#ffffff';
    sheet.getRangeByName('F1').cellStyle.bold = true;

    for (int i = 0; i < this.registros.length; i++) {
      int linha = i + 2;
      RegistrarPontoModel registro = this.registros[i];
      sheet
          .getRangeByName('F$linha')
          .setText(registro.motoristasModel.length.toString() ?? '');
    }
  }

  void colunaNome() {
    //7

    for (int i = 0; i < this.registros.length; i++) {
      int linha = i + 2;
      RegistrarPontoModel registro = this.registros[i];

      int contador = 7;

      for (int j = 0; j < registro.motoristasModel.length; j++) {
        sheet.getRangeByIndex(1, contador).setText('Nome ${j + 1}');
        sheet.getRangeByIndex(1, contador).cellStyle.fontColor = '#ffffff';
        sheet.getRangeByIndex(1, contador).cellStyle.bold = true;

        MotoristaModel motoristaModel =
            registro.motoristasModel[j] as MotoristaModel;

        sheet
            .getRangeByIndex(linha, contador)
            .setText(motoristaModel.nome ?? '');

        contador = contador + 4;
      }
    }
  }

  void colunaEmpresa() {
    //8

    for (int i = 0; i < this.registros.length; i++) {
      int linha = i + 2;
      RegistrarPontoModel registro = this.registros[i];

      int contador = 8;

      for (int j = 0; j < registro.motoristasModel.length; j++) {
        sheet.getRangeByIndex(1, contador).setText('Empresa ${j + 1}');
        sheet.getRangeByIndex(1, contador).cellStyle.fontColor = '#ffffff';
        sheet.getRangeByIndex(1, contador).cellStyle.bold = true;

        MotoristaModel motoristaModel =
            registro.motoristasModel[j] as MotoristaModel;

        sheet
            .getRangeByIndex(linha, contador)
            .setText(motoristaModel.empresa ?? '');

        contador = contador + 4;
      }
    }
  }

  void colunaContato() {
    //9

    for (int i = 0; i < this.registros.length; i++) {
      int linha = i + 2;
      RegistrarPontoModel registro = this.registros[i];

      int contador = 9;

      for (int j = 0; j < registro.motoristasModel.length; j++) {
        sheet.getRangeByIndex(1, contador).setText('Contato ${j + 1}');
        sheet.getRangeByIndex(1, contador).cellStyle.fontColor = '#ffffff';
        sheet.getRangeByIndex(1, contador).cellStyle.bold = true;

        MotoristaModel motoristaModel =
            registro.motoristasModel[j] as MotoristaModel;

        sheet
            .getRangeByIndex(linha, contador)
            .setText(motoristaModel.numeroContato ?? '');

        contador = contador + 4;
      }
    }
  }

  void colunaNumeroCNH() {
    //10
    for (int i = 0; i < this.registros.length; i++) {
      int linha = i + 2;
      RegistrarPontoModel registro = this.registros[i];

      int contador = 10;

      for (int j = 0; j < registro.motoristasModel.length; j++) {
        sheet.getRangeByIndex(1, contador).setText('Doc. ${j + 1}');
        sheet.getRangeByIndex(1, contador).cellStyle.fontColor = '#ffffff';
        sheet.getRangeByIndex(1, contador).cellStyle.bold = true;

        MotoristaModel motoristaModel =
            registro.motoristasModel[j] as MotoristaModel;

        sheet
            .getRangeByIndex(linha, contador)
            .setText(motoristaModel.numeroDoc ?? '');

        contador = contador + 4;
      }
    }
  }

  void rodape(int valorFinalDaColuna) {
    int linhaRodape = this.registros.length + 15;

    sheet.getRangeByIndex(linhaRodape, 1, linhaRodape, valorFinalDaColuna).cellStyle.backColor =
        '#3980ff';

  }
}
