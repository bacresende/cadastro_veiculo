class DataUtil {
  static String getAnoMes(String data) {
    List<String> diaMesAno = data.split('/');
    String anoMes = diaMesAno[2] + '-' + diaMesAno[1];
    return anoMes;
  }

  static String getAnoMesDia(String data) {
    List<String> listaData = data.split('/');
    String anoMesDia = listaData[2] + listaData[1] + listaData[0];
    return anoMesDia;
  }

  static bool isValidDate(String input) {
    final date = DateTime.parse(input);
    final originalFormatString = toOriginalFormatString(date);
    return input == originalFormatString;
  }

  static String toOriginalFormatString(DateTime dateTime) {
    final a = dateTime.year.toString().padLeft(4, '0');
    final m = dateTime.month.toString().padLeft(2, '0');
    final d = dateTime.day.toString().padLeft(2, '0');
    return "$a$m$d";
  }

  static String getMesAbreviado(String mes) {
    String mesAbrv;
    switch (mes) {
      case '1':
        mesAbrv = 'JAN';  
        break;
      case '2':
        mesAbrv = 'FEV';
        break;
      case '3':
        mesAbrv = 'MAR';
        break;
      case '4':
        mesAbrv = 'ABR';
        break;
      case '5':
        mesAbrv = 'MAI';
        break;
      case '6':
        mesAbrv = 'JUN';
        break;
      case '7':
        mesAbrv = 'JUL';
        break;
      case '8':
        mesAbrv = 'AGO';
        break;
      case '9':
        mesAbrv = 'SET';
        break;
      case '10':
        mesAbrv = 'OUT';
        break;
      case '11':
        mesAbrv = 'NOV';
        break;
      case '12':
        mesAbrv = 'DEZ';
        break;
    }

    return mesAbrv;
  }

  static String getMostrarMesAtual(String anoMes) {
    
    List<String> listaMesAno = anoMes.split('/');
    String mes = getMesAbreviado(listaMesAno[0]);


    return mes + '/' + listaMesAno[1];
  }
}
