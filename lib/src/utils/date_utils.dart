//--------------------------- Para tratar las fechas ---------------------------

String getDate(){
  DateTime date = DateTime.now();
  return date.toIso8601String();
}

String shortDate(String dateToIso8601String){
  return dateToIso8601String.split('T').first;
}