//--------------------------- Para tratar las fechas ---------------------------

String getDate(){
  DateTime date = DateTime.now();
  return date.toIso8601String();
}

String shortDate(DateTime date){
  return '${date.day}/${date.month}/${date.year}';
}