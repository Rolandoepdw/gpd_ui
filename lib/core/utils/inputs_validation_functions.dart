//Name
String? validateName(value, label) {
  if (value.isEmpty) return 'Introduce algun $label';
  RegExp rex = RegExp(r"^[\p{L} ,.'-]*$",
      caseSensitive: false, unicode: true, dotAll: true);
  if (!rex.hasMatch(value)) return 'Introduce un $label válido';
  return null;
}

//Password
String? validatePassword(value) {
  if (value.isEmpty) return 'Introduzca una contraseña';
  if(value.length < 1) return 'Introduzca almenos ocho caracteres';
  return null;
}

//Password & Confirm
String? validatePasswordYConfirm(password, confirm){
  if(password.isEmpty) return 'Introdusca una contraseña.';
  if(password.length < 1) return 'Introduzca almenos ocho caracteres';
  if(confirm.isEmpty) return 'Confirme su contrseña.';
  if(confirm.length < 1) return 'Introduzca almenos ocho caracteres';
  if(password != confirm) return 'Las contraseñas deben de ser iguales.';
}

//Label
String? validateText(value, label) {
  if (value.isEmpty) return 'Introduce un $label';
  return null;
}

//Email
String? validateEmail(value) {
  if (value.isEmpty) return 'Introduce un email';
  RegExp rex = RegExp(r'\S+@\S+\.\S+');
  if (!rex.hasMatch(value)) return 'Introduce un email válido';
  return null;
}

//Integer
String? validateInteger(value, label) {
  if (value.isEmpty) return 'Introduce un $label';
  if (int.tryParse(value) == null) return 'Introduce un $label válido';
  return null;
}

//Double
String? validateDouble(value, label) {
  if (value.isEmpty) return 'Introduce un $label';
  if (double.tryParse(value) == null) return 'Introduce un $label válido';
  return null;
}

//Date
String? validateDate(value, label){
  if(value.isEmpty) return 'Introduce un $label';
  if(DateTime.tryParse(value) is DateTime) return null;
  return 'Introduce un $label válido';
}

//Dropdown no lelection
String? validateDropdown(value) {
  if (value == null) return 'Selecciona un valor';
  return null;
}
