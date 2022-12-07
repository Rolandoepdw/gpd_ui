//--------------------------- Para tratar las fechas ---------------------------
String shortDate(DateTime date){
  return '${date.day}/${date.month}/${date.year}';
}

String longDate(DateTime date){
  return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
}