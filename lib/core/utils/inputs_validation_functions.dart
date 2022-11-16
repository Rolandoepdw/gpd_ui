//Name
String? validateName(value, label) {
  if (value.isEmpty) return 'Enter some $label';
  RegExp rex = RegExp(r"^[\p{L} ,.'-]*$",
      caseSensitive: false, unicode: true, dotAll: true);
  if (!rex.hasMatch(value)) return 'Please enter a valid $label';
  return null;
}

//Password
String? validatePassword(value) {
  if (value.isEmpty) return 'Introduzca una contraseña';
  return null;
}

//Password & Confirm
String? validatePasswordYConfirm(password, confirm){
  if(password.isEmpty) return 'Introdusca una contraseña.';
  if(confirm.isEmpty) return 'Confirme su contrseña.';
  if(password != confirm) return 'Las contraseñas deben de ser iguales.';
}

//Label
String? validateText(value, label) {
  if (value.isEmpty) return 'Enter some $label';
  return null;
}

//Email
String? validateEmail(value) {
  if (value.isEmpty) return 'Enter an email';
  RegExp rex = RegExp(r'\S+@\S+\.\S+');
  if (!rex.hasMatch(value)) return 'Please enter a valid email';
  return null;
}

//Integer
String? validateInteger(value, label) {
  if (value.isEmpty) return 'Enter some $label';
  if (int.tryParse(value) == null) return 'Please enter a valid $label';
  return null;
}

//Double
String? validateDouble(value, label) {
  if (value.isEmpty) return 'Enter some $label';
  if (double.tryParse(value) == null) return 'Please enter a valid $label';
  return null;
}

//Date
String? validateDate(value, label){
  if(value.isEmpty) return 'Enter some $label';
  if(DateTime.tryParse(value) is DateTime) return null;
  return 'Please enter a valid $label';
}

//Dropdown no lelection
String? validateDropdown(value) {
  if (value == null) return 'Please select a value';
  return null;
}
